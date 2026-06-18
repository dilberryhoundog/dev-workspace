# Tasks: health command — review fixes (issue #8)

**Branch:** `feature/health-command` · Findings from the medium-effort `/code-review` of the uncommitted health-command work. Ranked most-severe first. Each item: the problem, the verdict, the location, and a concrete proposed fix.

Legend: `[C]` correctness · `[R]` regression vs old behaviour · `[A]` altitude/maintainability · `[L]` latent (no live failure today)

---

## 1. `[C]` `10-plugin-scope` checks give contradictory verdicts across plugins

**Status: ✅ Fixed (alignment pass).** Both checks now share one corrected `enabled_in` (jq: object⇒value `true`, array⇒presence; grep fallback). Files differ only by the standalone `PLUGIN_NAME` default.
**Verdict:** CONFIRMED.
**Files:** `plugins/dev-workspace/hooks/health/10-plugin-scope`, `plugins/dev-deploy/hooks/health/10-plugin-scope`

**Problem.** The two checks parse `enabledPlugins` differently:
- dev-workspace uses a grep regex requiring object form with a literal `true`: `"<name>@…"[[:space:]]*:[[:space:]]*true`.
- dev-deploy uses `jq`, handling both object **and** array shapes, matching by `<name>@` prefix, with a grep fallback.

For the same `~/.claude/settings.json` they disagree. With an array form `{"enabledPlugins":["dev-workspace@m","dev-deploy@m"]}`, dev-deploy reports `✓ enabled` while dev-workspace reports `⚠ not found`. Same with a quoted value `{"dev-workspace@m":"true"}`.

**Proposed fix.** Make both checks use ONE shared implementation (see also #6). Adopt a single `enabled_in()` that is correct for both shapes AND respects the value:
- **Object form**: enabled only when the matching `"<name>@…"` key's value is boolean `true` (a key set to `false` means *disabled* — note the current jq `keys` approach would wrongly count `false` as enabled, and the grep approach is object-only; the unified version must handle both).
- **Array form**: enabled when any element starts with `"<name>@"`.
- Implement with `jq` when available, falling back to a documented grep heuristic when not. Suggested jq:
  ```
  jq -e --arg p "<name>@" '
    .enabledPlugins
    | if type=="object" then (to_entries | map(select(.key|startswith($p)) and .value==true) | any)
      elif type=="array" then (map(startswith($p)) | any)
      else false end' "$file" >/dev/null
  ```
- Ship the identical file in both plugins (or one shared file per #6).

---

## 2. `[C][R]` `50-server` bypasses `run_hook`, breaking documented custom health hooks

**Status: ✅ Fixed.** `50-server` now checks the hook exists, `chmod +x`'s it, exports the `DEPLOY_*` env (`DEPLOY_SERVER_HOST`/`PORT`, empty `ENV`/`BRANCH`/`URL`), and wraps it in `timeout 30` (gtimeout fallback). The documented `$DEPLOY_SERVER_HOST` example works again.
**Verdict:** CONFIRMED.
**File:** `plugins/dev-deploy/hooks/health/50-server`

**Problem.** The old `cmd_health` ran the custom hook via `run_hook "health" "$HOOK_HEALTH" ""`, which (a) exported `DEPLOY_ENV` / `DEPLOY_SERVER_HOST` / `DEPLOY_SERVER_PORT` / `DEPLOY_BRANCH` / `DEPLOY_URL`, (b) checked the hook file exists (else "Hook not found … Skipping"), and (c) `chmod +x`'d it if the exec bit was missing. The new `50-server` execs `"$PROJECT_ROOT/$HOOK_HEALTH"` directly with none of that:
- The canonical example hook in `references/health.md` uses `$DEPLOY_SERVER_HOST` → now empty → `ssh ""` fails → misleading `⚠ health hook reported a problem`.
- A missing hook path or a hook checked out without the exec bit (common on fresh clone) errors instead of being skipped/chmod'd.

**Proposed fix.** Restore the `run_hook` contract inside the check (since check scripts can't call the in-script `run_hook` function):
1. Guard existence: `[[ -f "$PROJECT_ROOT/$HOOK_HEALTH" ]]` else print `✓ skipped — health hook not found` (or `⚠`, decide) and exit 0/1.
2. `chmod +x` the hook if it lacks the exec bit (matching old behaviour).
3. Export the `DEPLOY_*` env vars before exec: `DEPLOY_ENV=""`, `DEPLOY_SERVER_HOST="$SERVER_HOST"`, `DEPLOY_SERVER_PORT="$SERVER_PORT"`, `DEPLOY_BRANCH=""`, `DEPLOY_URL=""` (the old health call passed `deploy_env=""`, so branch/url were empty — preserve that).
4. Wrap in `timeout` (see #4) so a stalling hook can't hang health.
   - Requires the runner to export `SERVER_HOST` / `SERVER_PORT` to checks (it already does for dev-deploy).
- *Altitude note:* the cleanest version would route through the real `run_hook` (single source of hook semantics). Consider having the runner — which lives in the main script and CAN call `run_hook` — handle `HOOK_HEALTH` and pass the result to the check, OR factor `run_hook`'s env/existence/chmod logic into a small sourced helper both the script and checks use.

---

## 3. `[C]` `30-kamal-apps` reports a healthy app as "down"

**Status: ✅ Fixed.** Status now detected by the word `Up` (`grep -qw Up`, portable), with the friendly duration parsed tolerantly (`Up \([^,)]*\)` — handles "About a minute"). Empty duration just reports "up".
**Verdict:** CONFIRMED (logic carried over from the original `cmd_health`, now re-exposed).
**File:** `plugins/dev-deploy/hooks/health/30-kamal-apps`

**Problem.** Uptime is parsed with `sed -n 's/.*Up \([0-9]* [a-z]*\).*/\1/p'`, which requires a digit immediately after `Up `. Docker/Kamal status strings like `Up About a minute`, `Up About an hour`, `Up Less than a second` have no leading digit → capture is empty → the check prints `⚠ Production: down` (advisory) for a container that is actually up.

**Proposed fix.** Decouple up/down detection from the friendly-duration parse:
- Determine status by presence of the word `Up` in the details output: `if grep -q '\bUp\b' <<<"$details"; then up; else down`.
- Optionally still extract a human duration tolerant of non-numeric text: `sed -n 's/.*Up \([^,)]*\).*/\1/p'` (anything up to the next `,`/`)`), e.g. yields `About a minute`.
- Apply the same change to the staging branch of the check.

---

## 4. `[C]` `30-kamal-apps` can hang indefinitely (no timeout)

**Status: ✅ Fixed.** kamal calls wrapped in `timeout 10` (`gtimeout` fallback, no wrapper if neither). A timed-out/errored call now reports `⚠ unreachable` (distinct from `down`).
**Verdict:** CONFIRMED.
**File:** `plugins/dev-deploy/hooks/health/30-kamal-apps`

**Problem.** Both `kamal app details` invocations (production + staging) open SSH connections to the deploy host with no `timeout` and no SSH `ConnectTimeout` — unlike `50-server`'s ssh which uses `ConnectTimeout=5`. An unreachable host blocks `dev-deploy health` indefinitely (twice, serially, when both envs are configured).

**Proposed fix.** Bound each kamal call with `timeout`, e.g. `timeout 10 kamal app details -q … 2>/dev/null`. Guard for `timeout` not being installed (macOS lacks it by default; coreutils provides `gtimeout`): resolve a `TIMEOUT` helper at the top of the check (`command -v timeout || command -v gtimeout`) and skip the wrapper if neither exists. A timed-out call should be treated as `⚠ … unreachable` (advisory), not `down`.

---

## 5. `[C]` Health discovery silently skips ALL checks when the install path contains a space

**Status: ✅ Fixed (alignment pass).** Both runners now use `while IFS= read -r -d '' … done < <(find … -print0 | sort -z)`.
**Verdict:** CONFIRMED (deterministic; low real-world incidence).
**Files:** both runners — `plugins/dev-workspace/skills/dev-workspace/scripts/dev-workspace`, `plugins/dev-deploy/skills/dev-deploy/scripts/dev-deploy` (the `run_health_checks` loop)

**Problem.** `for check in $(find "$health_dir" -maxdepth 1 -type f | sort)` uses an unquoted command substitution, so default-IFS word-splitting breaks any path containing a space. Every fragment fails `[[ -x "$check" ]]`, `total` stays 0, and the runner prints `no executable checks` and exits 0 — health appears clean while running nothing. Triggers only if `PLUGIN_ROOT` (under `~/.claude/plugins/…`) sits beneath a home/install path with a space (uncommon on macOS but possible).

**Proposed fix.** Use a NUL-delimited, quoted iteration in both runners:
```bash
while IFS= read -r -d '' check; do
    [[ -x "$check" ]] || continue
    …
done < <(find "$health_dir" -maxdepth 1 -type f -print0 | sort -z)
```
(Keep this identical in both copies — see #6.)

---

## 6. `[A]` Duplicated runner / generic checks drifted because two agents authored them separately

**Status: ✅ Fixed (alignment pass).** `run_health_checks` bodies aligned (identical except dev-deploy's deploy-var exports); help-arg set matched (`help|--help|-h`); `10`/`20` generic checks byte-identical except the standalone `PLUGIN_NAME` default. Optional drift-guard deferred.
**Verdict:** Structural finding (root cause of #1).
**Files:** both plugin scripts + `10-plugin-scope` / `20-stub-location` in both plugins

**Problem.** The runner and the generic checks were built independently by two agents and diverged (the `10-plugin-scope` logic in #1, the runner's help-arg set `help|--help` vs `help|--help|-h`). This is an *alignment* problem, not an architecture problem — the pieces are small (~40 lines) and live in one repo, almost always edited together.

**Decision: align, do not extract.** A cross-plugin symlink would dangle after marketplace install (each plugin is a separate `git-subdir`, extracted to its own cache dir). A shared-source + sync-copy mechanism (or runtime sourcing via the #7 dependency) is over-engineering for this size. Instead:
- Author ONE canonical version of each shared piece and drop it **byte-identical** into both plugins:
  - `run_health_checks` — identical body in both; the ONLY legitimate per-plugin difference is dev-deploy's extra deploy-var exports in the per-check env block.
  - `10-plugin-scope` — one corrected version (see #1).
  - `20-stub-location` — already byte-identical (synced during the stub-bug fix).
- Fold the cross-cutting fixes (#5 find-loop, #8 `${VAR:-}` hardening) into the canonical runner so both copies get them at once.
- *Optional, later (not required):* a tiny drift guard — a repo dev-check that diffs the shared pieces between plugins and warns. Skip for now; rely on co-editing discipline + code review.

---

## 7. `[C]` `40-branch-sync` prints nonsense "? ahead / ? behind"

**Status: ✅ Fixed.** Staging block now guards `[[ "$ahead" == "?" || "$behind" == "?" ]]` → `⚠ cannot determine (origin/<staging> not available)` before the in-sync/ahead-behind logic.
**Verdict:** symptom CONFIRMED (the original candidate's "arithmetic `-eq`" mechanism was wrong — the code uses string compares — but the bad output is real and unguarded).
**File:** `plugins/dev-deploy/hooks/health/40-branch-sync`

**Problem.** `ahead=$(git rev-list origin/$STAGING_BRANCH..$STAGING_BRANCH --count 2>/dev/null || echo "?")`. When `origin/<staging>` isn't fetched / has no tracking ref, `ahead`/`behind` become `"?"`. The staging block has no "cannot determine" guard (only the source→staging block does), so it falls through and emits `⚠ <staging>: ? ahead, ? behind`.

**Proposed fix.** Add a guard before the in-sync/ahead-behind logic mirroring the source block:
```bash
if [[ "$ahead" == "?" || "$behind" == "?" ]]; then
    echo "⚠ $STAGING_BRANCH: cannot determine (origin/$STAGING_BRANCH not available)"
    severity=1
elif [[ "$ahead" == "0" && "$behind" == "0" ]]; then
    echo "✓ $STAGING_BRANCH: in sync with origin"
else
    …existing ahead/behind output…
fi
```

---

## 8. `[L]` Latent `set -u` landmine in the dev-deploy runner

**Status: ✅ Fixed (alignment pass).** Runner export block now uses `${VAR:-}` defaults for all deploy vars (and PROJECT_ROOT/CONFIG), safe outside a project and under a future `set -u`.
**Verdict:** PLAUSIBLE / latent — no live failure today.
**File:** `plugins/dev-deploy/skills/dev-deploy/scripts/dev-deploy` (`cmd_health` / `run_health_checks`)

**Problem.** When not in a deploy project, `cmd_health`'s else branch clears only `PROJECT_ROOT`/`CONFIG` and never initialises `SOURCE_BRANCH`/`STAGING_BRANCH`/`PROD_BRANCH`/`PROD_KAMAL_DEST`/`STAGING_KAMAL_DEST`/`SERVER_HOST`/`SERVER_PORT`/`HOOK_HEALTH`, yet the runner references them in the per-check export line. It works only because the parent script uses `set -e` but **not** `set -u`. The shipped check scripts *do* use `set -u`, so a maintainer adding it to the parent for consistency would make `dev-deploy health` abort with "unbound variable" outside a deploy project — exactly where the install checks (10/20) are most useful. (The dev-workspace runner avoids this by exporting only the 4 common vars.)

**Proposed fix.** Make the export site robust regardless of `set -u` / whether `load_config` ran — use default expansions in the runner's export block: `SOURCE_BRANCH="${SOURCE_BRANCH:-}" STAGING_BRANCH="${STAGING_BRANCH:-}" …`. (Equivalently, initialise all deploy vars to `""` in `cmd_health`'s no-project branch.)

---

## Suggested order

1. Fixes **1, 5** touch both plugins / the shared runner — do alongside the **#6** de-duplication so the canonical runner + generic checks land once.
2. Then dev-deploy check fixes **2, 3, 4, 7** (all in `30`/`40`/`50`).
3. **8** is a one-line hardening — fold into the #6 runner work.

## Verification after fixes
- Re-run `dev-workspace health` and `dev-deploy health` from the repo (project + a non-deploy dir).
- Add/confirm a blocker-path test (a check exiting 2 → runner exits 2) since no shipped check exercises it.
- Simulate array-form `enabledPlugins` and confirm both plugins agree (#1).
- Drop a check under a path with a space to confirm discovery survives (#5).
