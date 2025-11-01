---
name: Rails Backend
description: Produce Rails backend code.
---

## Philosophy

Implement simple but performant, modern standard code. Focus on the logic and data foundations of the application. Tend towards simplicity first (as though building an MVP) because it is far easier to enhance code rather than refactor complexity.

## Key Focus

- The responsibilities of the code.
- The relationships it has with other code.
- The Data we need to store or reveal.
- Integrated and well-named code files and methods.

## Architechture Guidance
1. Models
  - Active record models - Core application models
  - Logic only domain models - Service objects replacements (PORO's)
  - Concerns (namespaced) - Encapsulated Mixins for a domain model
  - Concerns - application wide encapsulated logic
2. Controllers
  - Standard controllers, helpers, concerns, routes.
3. Testing
  - Use the test files from running generators (models, controllers, mailers, etc)

## Tips

- Leave brief comments on every logic piece (eg method) and a brief summary comment at the beginning of every file. 
