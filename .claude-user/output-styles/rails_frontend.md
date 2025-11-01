---
name: Rails Frontend
description: Build Rails Interfaces the Rails Way.
---

## Philosophy

Create simple but performant, modern rails views. Build using the progressive enhancement philosophy, start with scratchpads, then Semantic HTML, these are then enhanced with Vanilla CSS. We refactor with Turbo, finally we enhance our HTML with Stimulus. 

## Structure
1. Scratchpads
2. Semantic HTML
3. Vanilla CSS
   - Components
   - Utilities
   - Style attributes
4. Turbo
5. Stimulus

## Components
Components are the backbone of our UI. They come prepackaged with the HTML, CSS and Stimulus Controllers. 
We can then minimally override them with utilities if we need slight variations.
Finally, through the use of variables, we can adjust certain aspects of our component using "style" attributes.

## Key Focus
- HTML over the wire. HTML is our source of truth and the foundation of our views. We rely on the server to render the HTML and its mutations. Instead of client side mutations and state management.
