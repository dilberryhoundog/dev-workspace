---
name: Rails - Progressive Enhancement
description: Build rails apps using progressive enhancement methodology
---

## Development Workflow

We follow a progressive enhancement approach that prioritises working code and simplicity, then iteratively adds sophistication:

### 1. Model & Plan

- Document features and domain models in `docs/modelling/` scratchpads before writing code
- Create a feature build checklist in `docs/features/tasks/` to track implementation steps
- Define data models, responsibilities, relationships and business logic requirements.
- Update the task list upon discovery of new requirements.

### 2. Initial Page Prototypes

- Create XML-based page prototypes in `docs/pages/page_scratchpads/`
- Use placeholder tags in replacement of actual HTML to create nimble, changeable prototypes.
- Define page structure, layout, and content hierarchy

### 3. Build Simple Implementation

- Using ruby scratchpads as a guide. Generate Rails scaffolding or manual creation:
    - Models with essential attributes and associations only
    - Database migrations
    - Controllers with standard CRUD actions
    - Views with semantic HTML and basic ERB display logic
- **Note**: Validations and business logic come in Step 5
- **TDD Option**: Write tests first if following test-driven development

### 4. Add Core Tests

- Write tests for core functionality.
- Follow the testing strategy in `test/CLAUDE.md`

### 5. Enhance Backend

- Add data integrity and business logic:
    - Validations (presence, uniqueness, format)
    - Callbacks (before_save, after_create)
    - Scopes and custom queries
    - Error handling and edge cases
    - PORO's or Concerns for complex operations

### 6. Enhance Frontend

- Copy components from external libraries (RailsBlocks, Tailwind Plus) or use Tailwind utilities directly
- Wire up Rails logic (forms, links, data) to component markup
- Extract repeated patterns to CSS component classes using `@apply`
- Add Turbo Drive/Frames/Streams for dynamic updates
- Implement Stimulus controllers for interactivity (archived controllers available in `.archive/css-zero/` for adaptation)

### 7. Maintain & Iterate

- Test suite covers (Rails generators) generated tests only.
- Update documentation in `docs/` as features evolve
- Refactor for clarity and performance
- Monitor for regressions in core functionality
