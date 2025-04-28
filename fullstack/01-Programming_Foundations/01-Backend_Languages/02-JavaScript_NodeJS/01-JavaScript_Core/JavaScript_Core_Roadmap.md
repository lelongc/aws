# JavaScript Core Learning Roadmap

> **Note:** This roadmap is organized into corresponding folders in the same directory structure. Each topic has its own markdown file with detailed explanations and examples.

## Level 1: JavaScript Fundamentals

### 1.1. Getting Started

- Introduction to JavaScript
- Setting up development environment
- Browser developer tools
- Running JavaScript (browser console, Node.js)
- Basic syntax and structure

### 1.2. Basic Data Types

- Numbers
- Strings and template literals
- Booleans
- null and undefined
- Type conversion and coercion
- Symbol (basic introduction)
- BigInt (basic introduction)

### 1.3. Variables and Scope

- var, let and const
- Variable naming rules
- Global and local scope
- Block scope vs function scope
- Variable hoisting
- Temporal Dead Zone (TDZ)

### 1.4. Operators

- Arithmetic operators
- Assignment operators
- Comparison operators
- Logical operators
- Bitwise operators
- String operators
- Conditional (ternary) operator
- Operator precedence

### 1.5. Control Flow

- Conditional statements (if, else, else if)
- Switch statements
- Loops (for, while, do-while)
- break and continue
- Labeled statements

### 1.6. Functions Basics

- Function declarations
- Function expressions
- Arrow functions (basic)
- Parameters and arguments
- Default parameters
- Return values
- Function hoisting

### 1.7. Basic Data Structures

- Arrays (creation, access, modification)
- Array methods (push, pop, shift, unshift)
- Basic looping through arrays
- Objects (creation, properties, methods)
- Object property access (dot notation, bracket notation)
- JSON basics

## Level 2: Intermediate JavaScript

### 2.1. Advanced Functions

- First-class functions
- Higher-order functions
- Callback functions
- Immediately Invoked Function Expressions (IIFE)
- Closures
- The arguments object
- Rest parameters
- Spread syntax
- Function borrowing

### 2.2. More on Objects

- Object methods and this keyword
- Constructor functions
- Prototypes and inheritance
- Object.create()
- Property descriptors
- Getters and setters
- Object.assign() and spread operator for objects

### 2.3. Advanced Arrays

- Array methods for iteration (forEach, map, filter, reduce)
- Array methods for searching (find, findIndex, includes)
- Array methods for transformation (sort, reverse, flat)
- Array destructuring
- Multidimensional arrays

### 2.4. Exception Handling

- try...catch...finally
- throw statement
- Error objects (Error, SyntaxError, TypeError, etc.)
- Custom error types
- Error propagation
- Best practices for error handling

### 2.5. Modules and Organization

- Script loading strategies
- Script modules (import/export)
- Module patterns
- CommonJS modules (basic introduction)
- ES modules vs CommonJS

### 2.6. Regular Expressions

- Creating regular expressions
- RegExp methods (test, exec)
- String methods with RegExp (match, search, replace)
- Regex patterns and flags
- Character classes
- Quantifiers and groups

## Level 3: Advanced JavaScript

### 3.1. Deep Dive into 'this'

- Understanding 'this' in different contexts
- 'this' in global context
- 'this' in function context
- 'this' in object methods
- 'this' in classes and constructor functions
- Explicit binding (call, apply, bind)
- Arrow functions and lexical 'this'

### 3.2. Prototypal Inheritance in Depth

- Prototype chain
- Constructor functions
- The **proto** property
- Object.getPrototypeOf()
- Object.setPrototypeOf()
- Inheritance patterns
- Composition vs inheritance

### 3.3. Classes

- Class syntax
- Constructor method
- Instance methods
- Static methods
- Inheritance with extends
- Super keyword
- Private and public fields
- Private methods
- Mixins

### 3.4. Asynchronous JavaScript

- Event loop
- Callbacks
- Promises
  - Creation and consumption
  - Chaining
  - Error handling
  - Promise.all, Promise.race, Promise.allSettled
  - Promise.any, Promise.resolve, Promise.reject
- Async/await
  - Async functions
  - await expression
  - Error handling with try/catch
  - Parallel execution
- Generators and Iterators
  - Generator functions
  - yield keyword
  - Iterators and Iterables
  - Async generators and for-await-of

### 3.5. Memory Management

- JavaScript memory model
- Stack and heap
- Garbage collection
- Memory leaks
- Common causes of memory leaks
- Reference vs value
- Debugging memory issues

### 3.6. Functional Programming Concepts

- Pure functions
- Immutability
- Function composition
- Currying
- Partial application
- Point-free style
- Functors and monads (conceptual understanding)
- Recursion
- Memoization

### 3.7. Metaprogramming

- Property descriptors in depth
- Object.defineProperty()
- Object.defineProperties()
- Object.getOwnPropertyDescriptor()
- Proxy objects
- Reflect API
- Symbols in depth
- Well-known symbols

## Level 4: JavaScript Mastery

### 4.1. Performance Optimization

- Measurement and benchmarking
- Critical rendering path
- JavaScript optimization techniques
- Memory optimization
- DOM performance
- Algorithm efficiency
- Lazy loading and code splitting

### 4.2. Design Patterns in JavaScript

- Creational patterns (Constructor, Factory, Singleton)
- Structural patterns (Module, Decorator, Facade, Proxy)
- Behavioral patterns (Observer, Mediator, Command, Iterator)
- MV\* patterns (MVC, MVP, MVVM)
- Flux/Redux pattern

### 4.3. Advanced Asynchronous Patterns

- Reactive programming concepts
- Observables
- Event-driven architectures
- Web Workers
- Service Workers
- Shared Workers
- Message channels and ports
- Asynchronous iterators and generators

### 4.4. JavaScript Engines

- How JavaScript engines work
- V8 architecture
- Just-in-time compilation
- Hidden classes and inline caching
- Optimization and deoptimization
- Memory management internals
- Browser vs Node.js environments

### 4.5. Modern JavaScript Features

- Latest ECMAScript features
- Optional chaining
- Nullish coalescing
- Logical assignment operators
- Private class features
- Top-level await
- Dynamic imports
- Numeric separators
- Intl API for internationalization
- Temporal API (Date/Time)
- Pipeline operator (proposal)
- Pattern matching (proposal)

### 4.6. Testing and Debugging

- Unit testing
- Integration testing
- Test-driven development
- Mocking and stubbing
- Advanced debugging techniques
- Chrome DevTools in depth
- Memory profiling
- Performance profiling
- Source maps

### 4.7. Security Best Practices

- Common vulnerabilities (XSS, CSRF)
- Content Security Policy
- Secure coding practices
- Input validation
- Sandboxing
- Same-origin policy
- Cross-Origin Resource Sharing (CORS)
- Subresource Integrity

## Resources

### Books

- "Eloquent JavaScript" by Marijn Haverbeke
- "You Don't Know JS" series by Kyle Simpson
- "JavaScript: The Good Parts" by Douglas Crockford
- "JavaScript Patterns" by Stoyan Stefanov
- "Deep JavaScript" by Dr. Axel Rauschmayer

### Online Courses

- freeCodeCamp JavaScript Curriculum
- MDN JavaScript Guide
- JavaScript30 by Wes Bos
- JavaScript.info

### Practice Platforms

- LeetCode
- HackerRank
- Codewars
- JavaScript Koans
- Exercism

### Tools

- ESLint
- Prettier
- TypeScript (for type checking)
- Babel
- Webpack
- Chrome DevTools
- Jest (testing framework)
