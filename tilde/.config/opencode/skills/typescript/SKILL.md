---
name: typescript
description: Use when implementing any feature or bugfix in Typescript, before writing any code
---

# TypeScript Best Practices

Production-grade TypeScript development with strict type safety, and immutable patterns.

## Core Principles

1. **Type Safety at All Boundaries** - Runtime validation (schemas) + compile-time safety (TypeScript)
2. **Immutability** - No data mutation, always create new values
3. **Explicit Types** - No implicit any, strict mode enabled
4. **Behavior over implementation** - Focus on contracts and outcomes

## Quick Reference

| Topic                                                                  | Guide                                                 |
| ---------------------------------------------------------------------- | ----------------------------------------------------- |
| Type vs interface, any vs unknown, assertions, strict mode             | [types-interfaces.md](references/types-interfaces.md) |
| Immutability patterns, readonly, forbidden methods, error handling     | [immutability.md](references/immutability.md)         |
| Branded types, utility types, code smells reference                    | [utilities.md](references/utilities.md)               |
| Common TypeScript patterns with examples                               | [patterns.md](references/patterns.md)                 |

## When to Use Each Guide

### Types and Interfaces

Use [types-interfaces.md](references/types-interfaces.md) when you need:

- Type vs interface guidance
- The any vs unknown decision
- Type assertion best practices
- Strict mode configuration
- tsconfig.json settings

### Immutability

Use [immutability.md](references/immutability.md) when you need:

- Immutability patterns (spread operators)
- Readonly modifiers
- Forbidden array methods reference
- Options objects vs positional parameters
- Boolean parameter anti-patterns
- Result types for error handling
- Early return patterns

### Utilities

Use [utilities.md](references/utilities.md) when you need:

- Branded types for domain concepts
- Built-in utility types (Pick, Omit, Partial, etc.)
- Custom utility types
- Code smell reference tables

### Patterns

Use [patterns.md](references/patterns.md) when you need:

- Schema with test factory patterns
- Result type for error handling
- Branded types for domain safety
- Immutable array operations
- Options object pattern

## Quick Reference: Decision Trees

### Should I use `type` or `interface`?

```
Am I defining a behavior contract for dependency injection?
├── Yes → interface
└── No → type
```

### Should I use `any` or `unknown`?

```
Never use any.
Always use unknown for truly unknown types.
```

### Options object or positional parameters?

```
How many parameters?
├── 1-2 → Positional is fine
└── 3+ → Use options object
```

## Summary Checklist

Before committing TypeScript code, verify:

- [ ] Strict mode enabled in tsconfig.json
- [ ] No `any` types (use `unknown` instead)
- [ ] No `as` typecast unless you have a strong reason to use it, document with a "WHY" comment.
- [ ] No `!` non-null assertion
- [ ] Using `type` for data, `interface` only for behavior contracts
- [ ] All data structures use `readonly` where appropriate
- [ ] No array mutations (push, pop, splice, etc.)
- [ ] Functions with 3+ params use options objects
- [ ] No boolean positional parameters
- [ ] Result types for operations that can fail
- [ ] Early returns instead of nested conditionals
- [ ] Test factories validate with schemas
- [ ] Branded types for domain concepts that shouldn't mix
- [ ] Explicit return types on functions
