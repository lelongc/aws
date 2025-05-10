# var, let, and const in JavaScript

JavaScript offers three ways to declare variables: `var`, `let`, and `const`. Understanding the differences between these declarations is crucial for writing clean, bug-free code.

## Variable Declarations at a Glance

| Feature                     | `var`                                   | `let`                            | `const`                           |
| --------------------------- | --------------------------------------- | -------------------------------- | --------------------------------- |
| Scope                       | Function-scoped                         | Block-scoped                     | Block-scoped                      |
| Hoisting                    | Yes, with initialization as `undefined` | Yes, but in "temporal dead zone" | Yes, but in "temporal dead zone"  |
| Reassignment                | Yes                                     | Yes                              | No                                |
| Redeclaration in same scope | Yes                                     | No                               | No                                |
| When to use                 | Legacy code                             | For variables that change        | For values that should not change |
| Introduction                | Original JavaScript                     | ES6 (ES2015)                     | ES6 (ES2015)                      |

## var - The Original Variable Declaration

The `var` keyword was the original way to declare variables in JavaScript.

### Scope of var

`var` declarations are function-scoped, meaning they are only limited to the function they are declared in:

```javascript
function example() {
  var x = 1;
  if (true) {
    var x = 2; // Same variable, redefined
    console.log(x); // 2
  }
  console.log(x); // 2 - value changed
}

example();
// console.log(x); // ReferenceError: x is not defined (outside function)
```

### Hoisting with var

Variables declared with `var` are "hoisted" to the top of their scope and initialized with `undefined`:

```javascript
console.log(hoistedVar); // undefined (not an error)
var hoistedVar = 5;
console.log(hoistedVar); // 5

// What's happening behind the scenes:
// var hoistedVar;
// console.log(hoistedVar);
// hoistedVar = 5;
// console.log(hoistedVar);
```

### Problems with var

1. **Lack of block scope** can lead to unexpected behavior:

```javascript
for (var i = 0; i < 3; i++) {
  setTimeout(function () {
    console.log(i); // Logs "3" three times
  }, 1000);
}
```

2. **Global object pollution** when declared outside a function:

```javascript
var globalVar = "I'm global";
console.log(window.globalVar); // "I'm global" (in browsers)
```

3. **Accidental redeclaration** doesn't cause errors:

```javascript
var user = "John";
// ... hundreds of lines of code ...
var user = "Jane"; // Original value silently overwritten
```

## let - Block-Scoped Variable Declaration

Introduced in ES6, `let` addresses many issues with `var` by providing block-level scoping.

### Block Scope with let

Variables declared with `let` are limited to the block (enclosed by `{}`) in which they are defined:

```javascript
function example() {
  let x = 1;
  if (true) {
    let x = 2; // Different variable than outer x
    console.log(x); // 2
  }
  console.log(x); // 1 - value unchanged
}

example();
```

### Hoisting and the Temporal Dead Zone

While `let` declarations are hoisted, they are not initialized with a value and accessing them before declaration results in a `ReferenceError`:

```javascript
// console.log(blockVar); // ReferenceError: Cannot access 'blockVar' before initialization
let blockVar = 5;
console.log(blockVar); // 5
```

The period between the start of a scope and the declaration is known as the "temporal dead zone" (TDZ).

### Loop Iterations with let

`let` creates a new binding for each loop iteration:

```javascript
for (let i = 0; i < 3; i++) {
  setTimeout(function () {
    console.log(i); // Logs "0", "1", "2" as expected
  }, 1000);
}
```

### No Redeclaration

`let` prevents accidental variable redeclaration in the same scope:

```javascript
let user = "John";
// let user = "Jane"; // SyntaxError: Identifier 'user' has already been declared
```

## const - Block-Scoped Constants

`const` also appeared in ES6 and is similar to `let` but creates variables with values that cannot be reassigned.

### Immutable Binding with const

`const` creates a "read-only" reference to a value:

```javascript
const PI = 3.14159;
// PI = 3.14; // TypeError: Assignment to constant variable
```

### Object Mutability with const

While the binding is immutable, the value itself might be mutable if it's an object or array:

```javascript
const user = { name: "John" };
user.name = "Jane"; // This works - we're modifying the object, not the binding
console.log(user.name); // "Jane"

// But we cannot reassign the variable:
// user = { name: "Bob" }; // TypeError: Assignment to constant variable

// Same applies to arrays:
const numbers = [1, 2, 3];
numbers.push(4); // Works
// numbers = [5, 6]; // TypeError: Assignment to constant variable
```

### Initialization Requirement

`const` declarations must be initialized when they are declared:

```javascript
// const favoriteFood; // SyntaxError: Missing initializer in const declaration
const favoriteFood = "Pizza";
```

### Block Scope and TDZ

Like `let`, `const` has block scope and is subject to the temporal dead zone:

```javascript
{
  // console.log(RATE); // ReferenceError: Cannot access 'RATE' before initialization
  const RATE = 0.1;
  console.log(RATE); // 0.1
}
// console.log(RATE); // ReferenceError: RATE is not defined
```

## When to Use Each Declaration

### Use var

- In legacy code that requires function-scoped variables
- When targeting old browsers without transpilation
- When you need a variable to be accessible throughout a function regardless of block nesting

```javascript
function legacyFunction() {
  if (true) {
    var result = "success";
  }
  return result; // Works with var
}
```

### Use let

- For variables that will be reassigned:

```javascript
function counter() {
  let count = 0;
  return function () {
    count += 1;
    return count;
  };
}
```

- In for loops:

```javascript
for (let i = 0; i < array.length; i++) {
  // Use let for loop counters
}
```

- When you want block scoping:

```javascript
if (condition) {
  let temporaryValue = getValue();
  // Use temporaryValue...
}
// temporaryValue not accessible here, avoiding pollution
```

### Use const

- For values that shouldn't change (as the default choice):

```javascript
const API_URL = "https://api.example.com";
const TAX_RATE = 0.07;
```

- For object and array references that won't be reassigned (but may be mutated):

```javascript
const user = { name: "John" };
const supportedLanguages = ["JavaScript", "Python", "Ruby"];
```

- For importing modules:

```javascript
const React = require("react");
const { useState } = React;
```

## Best Practices

1. **Default to `const`** unless you know the variable will need to be reassigned
2. **Use `let` when reassignment is needed**
3. **Avoid `var` in modern code** unless specifically needed
4. **Declare variables at the top of their scope** for clarity
5. **Use descriptive variable names** regardless of declaration type

```javascript
// Good practice example
function processUser(userData) {
  const MAX_AGE = 120;
  const user = { ...userData };

  let age = user.age || 0;
  if (age > MAX_AGE) {
    age = MAX_AGE;
  }

  for (let i = 0; i < user.permissions.length; i++) {
    const permission = user.permissions[i];
    // Process each permission...
  }

  return {
    ...user,
    age,
  };
}
```

## Browser Compatibility

- `var`: All browsers
- `let` and `const`:
  - IE11 and below: Not supported without transpilation
  - Edge 12+, Firefox 44+, Chrome 49+, Safari 10+: Full support

## Historical Context

Before ES6 (2015), JavaScript only had `var` for variable declarations. The introduction of `let` and `const` was one of the most significant improvements in modern JavaScript, addressing many longstanding issues with variable scope and mutability.

## Exercises

1. Predict and explain the output of code snippets using different variable declarations
2. Refactor a function that uses `var` to use `let` and `const` appropriately
3. Create examples of situations where `let` behaves differently from `var`
4. Write code that demonstrates the temporal dead zone
5. Practice with objects declared with `const` to understand mutability vs. reassignment

## Resources

- [MDN Web Docs: var](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/var)
- [MDN Web Docs: let](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let)
- [MDN Web Docs: const](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const)
- [JavaScript.info: Variables](https://javascript.info/variables)
- [ES6 In Depth: let and const](https://hacks.mozilla.org/2015/07/es6-in-depth-let-and-const/)
