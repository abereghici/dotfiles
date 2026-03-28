---
name: react
description: Use when implementing any feature or bugfix in React, before writing any code 
---

# React Best Practices

Production-grade React development with feature-based architecture, type-safe state management, and performance optimization.

## Core Principles

1. **Easy to get started with** - Clear patterns that new team members can follow
2. **Simple to understand and maintain** - Readable code with obvious intent
3. **Clean boundaries** - Clear separation between features and layers
4. **Early issue detection** - Catch problems at build time, not runtime
5. **Consistency** - Same patterns throughout the codebase

## When to Use Each Guide

### useEffect

Use [useeffect.md](./references/useeffect.md) when you need:

- When NOT to use useEffect (most cases)
- When useEffect IS appropriate (external systems)
- Dependency array rules
- Alternatives to useEffect

## Quick Reference: Decision Trees

### Do I need useEffect?

```
Why does this code need to run?

"Because the component was displayed"
├── Is it synchronizing with an external system?
│   ├── Yes → useEffect is appropriate
│   └── No → Probably don't need useEffect
│
"Because the user did something"
└── Put it in the event handler, not useEffect

"Because I need to compute a value"
└── Calculate during render (or useMemo if expensive)

See useeffect.md for detailed guidance.
```
