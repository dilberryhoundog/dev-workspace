# Car Index

<!--
## Decision matrix
Unless the user has provided context, **Use `<AskUserQuestion>` tool** to determine which reference to use.

Only use the AUQ tool or display confidently the correct option. DO NOT reply in conversation.
-->

## Decision Matrix

**If user has NOT specified which car:** Use `<AskUserQuestion>` tool to ask which car they want to view.

**If user HAS specified a car:** Display that car's details only.

**IMPORTANT:** Do NOT reply conversationally. Only use AUQ tool OR confidently display the specified option.

<!--
## Decision Matrix

1. Check if user specified a car (e.g., "show me the Camry")
    - YES → Display that car's details
    - NO → Use `<AskUserQuestion>` to ask which car
2. Do NOT add conversational text or ask "what would you like to do?"

## Decision Matrix

**Without context:**
- User: "show me a car" → Use AUQ to ask which car
- User: (arrives from parent skill) → Use AUQ to ask which car

**With context:**
- User: "show me the Camry" → Display Camry only

**NEVER:** Display all cars then ask conversationally what to do next
-->

## Cars

### Toyota - Camry
- Make: Toyota
- Model: Camry
- Year: 2024
- Engine Type: 2.5L 4-cylinder

### Honda - Civic
- Make: Honda
- Model: Civic
- Year: 2024
- Engine Type: 2.0L 4-cylinder

### Ford - Mustang
- Make: Ford
- Model: Mustang
- Year: 2024
- Engine Type: 5.0L V8

### Tesla - Model 3
- Make: Tesla
- Model: Model 3
- Year: 2024
- Engine Type: Electric

### Chevrolet - Silverado
- Make: Chevrolet
- Model: Silverado
- Year: 2024
- Engine Type: 5.3L V8
