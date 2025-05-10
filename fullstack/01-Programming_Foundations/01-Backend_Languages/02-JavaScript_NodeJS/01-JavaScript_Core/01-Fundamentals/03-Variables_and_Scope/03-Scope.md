# Scope in JavaScript

Scope determines the accessibility and visibility of variables, functions, and objects in your code. Understanding scope is crucial for writing maintainable JavaScript code and avoiding unexpected bugs.

## What is Scope?

Scope defines the region of your code where a variable can be accessed. In JavaScript, there are several types of scope:

1. **Global Scope**
2. **Function Scope**
3. **Block Scope** (introduced with `let` and `const` in ES6)
4. **Module Scope** (in ES6 modules)

## Global Scope

Variables declared outside any function or block have global scope and can be accessed from anywhere in your code.

```javascript
// Variables in global scope
const globalVariable = "I am global";
var anotherGlobal = "Also global";

function someFunction() {
  console.log(globalVariable); // Accessible here
}

if (true) {
  console.log(globalVariable); // Also accessible here
}
```

### Implicit Global Variables

Variables assigned without declaration (without `var`, `let`, or `const`) become global variables implicitly:

```javascript
function createGlobal() {
  implicitGlobal = "I am accidentally global"; // No declaration keyword!
}

createGlobal();
console.log(implicitGlobal); // "I am accidentally global"
```

> ⚠️ **Warning:** Implicit globals are considered a bad practice and should be avoided. Always declare your variables with `var`, `let`, or `const`.

### Global Object

In browsers, global variables become properties of the `window` object:

```javascript
var globalVar = "I'm global";
console.log(window.globalVar); // "I'm global"

// But let and const don't get added to window
let globalLet = "I'm global too";
console.log(window.globalLet); // undefined
```

In Node.js, the global object is called `global` instead of `window`.

## Function Scope

Variables declared within a function are only accessible within that function and any nested functions:

```javascript
function outerFunction() {
  const functionScopedVar = "I am function-scoped";

  console.log(functionScopedVar); // Accessible

  function innerFunction() {
    console.log(functionScopedVar); // Also accessible in nested function
  }

  innerFunction();
}

outerFunction();
// console.log(functionScopedVar); // Error: functionScopedVar is not defined
```

### var and Function Scope

The `var` keyword creates function-scoped variables - they are accessible throughout the entire function, regardless of block nesting:

```javascript
function varScoping() {
  var x = 1;

  if (true) {
    var x = 2; // Same variable as above!
    console.log(x); // 2
  }

  console.log(x); // 2 - the value was changed
}

varScoping();
```

## Block Scope

Block scope was introduced with `let` and `const` in ES6. Variables declared with these keywords are only accessible within the block (`{}`) in which they are defined:

```javascript
function blockScoping() {
  let x = 1;
  const y = 1;

  if (true) {
    let x = 2; // Different variable from outer x
    const y = 2; // Different variable from outer y
    console.log(x, y); // 2 2
  }

  console.log(x, y); // 1 1 - values remain unchanged
}

blockScoping();
```

### Loops and Block Scope

Block scope is particularly useful in loops:

```javascript
// With var
for (var i = 0; i < 3; i++) {
  setTimeout(() => console.log("var loop: " + i), 100);
}
// Outputs: "var loop: 3" three times

// With let
for (let j = 0; j < 3; j++) {
  setTimeout(() => console.log("let loop: " + j), 100);
}
// Outputs: "let loop: 0", "let loop: 1", "let loop: 2"
```

With `var`, the same variable is used across all iterations, and by the time the callback executes, the loop has completed. With `let`, a new binding is created for each iteration.

## Module Scope

With ES6 modules, each module has its own scope. Variables defined in a module are scoped to that module unless explicitly exported:

```javascript
// math.js
export const PI = 3.14159;
const secret = "This stays in the module";

// app.js
import { PI } from "./math.js";
console.log(PI); // 3.14159
// console.log(secret); // Error: secret is not defined
```

## Lexical Scope

JavaScript uses lexical (or static) scoping, meaning that the scope of a variable is determined by its location within the source code, and nested functions have access to variables in their outer scope:

```javascript
function outerFunction() {
  const outerVar = "I'm from the outer function";

  function innerFunction() {
    const innerVar = "I'm from the inner function";
    console.log(outerVar); // Can access outer function's variables
  }

  innerFunction();
  // console.log(innerVar); // Error: innerVar is not defined
}
```

## The Scope Chain

When JavaScript tries to resolve a variable, it searches up the scope chain:

1. It first looks in the current scope
2. If not found, it looks in the outer enclosing scope
3. It continues outward until it reaches the global scope
4. If still not found, it throws a `ReferenceError`

```javascript
const global = "I am global";

function outer() {
  const outer = "I am outer";

  function inner() {
    const inner = "I am inner";

    function innermost() {
      console.log(inner); // Found in inner scope
      console.log(outer); // Found in outer scope
      console.log(global); // Found in global scope
      // console.log(nonexistent); // ReferenceError: not in any accessible scope
    }

    innermost();
  }

  inner();
}

outer();
```

## Closures

Closures are a powerful feature in JavaScript that allows functions to "remember" their lexical scope even when executed outside that scope:

```javascript
function createCounter() {
  let count = 0; // This variable is "enclosed" in the closure

  return function () {
    count++; // Accessing the variable from the outer scope
    return count;
  };
}

const counter = createCounter();
console.log(counter()); // 1
console.log(counter()); // 2
console.log(counter()); // 3
```

The inner function maintains access to `count` even after `createCounter` has finished execution. This is because the inner function forms a closure that preserves the scope chain.

### Practical Uses of Closures

1. **Data Privacy:**

   ```javascript
   function createPerson(name) {
     let age = 0; // Private variable

     return {
       getName: () => name,
       getAge: () => age,
       setAge: (newAge) => {
         age = newAge;
       },
       birthday: () => {
         age++;
       },
     };
   }

   const person = createPerson("John");
   person.birthday();
   console.log(person.getAge()); // 1
   // console.log(person.age); // undefined - can't access directly
   ```

2. **Function Factories:**

   ```javascript
   function multiply(factor) {
     return function (number) {
       return number * factor;
     };
   }

   const double = multiply(2);
   const triple = multiply(3);

   console.log(double(5)); // 10
   console.log(triple(5)); // 15
   ```

## Variable Shadowing

When a variable in an inner scope has the same name as a variable in an outer scope, the inner variable "shadows" the outer one:

```javascript
const value = "global";

function outer() {
  const value = "outer";

  function inner() {
    const value = "inner";
    console.log("inner:", value); // "inner"
  }

  inner();
  console.log("outer:", value); // "outer"
}

outer();
console.log("global:", value); // "global"
```

## Hoisting

Variable and function declarations are "hoisted" to the top of their containing scope:

```javascript
console.log(hoistedVar); // undefined (not an error)
var hoistedVar = "I'm hoisted";

// The above behaves like:
// var hoistedVar;
// console.log(hoistedVar);
// hoistedVar = "I'm hoisted";

// Function declarations are fully hoisted
hoistedFunction(); // "I work!"
function hoistedFunction() {
  console.log("I work!");
}

// But let and const are hoisted without initialization
// console.log(hoistedLet); // ReferenceError: Cannot access 'hoistedLet' before initialization
let hoistedLet = "I'm blocked by the temporal dead zone";
```

## Common Scope Issues and Best Practices

### 1. Unintended Global Variables

```javascript
// Bad - creates global variable
function badFunction() {
  badVariable = "I'm accidentally global";
}

// Good - properly scoped variable
function goodFunction() {
  const goodVariable = "I'm properly scoped";
}
```

### 2. Loop Variables with var

```javascript
// Problematic - single shared variable
for (var i = 0; i < 3; i++) {
  setTimeout(function () {
    console.log(i); // Will log "3" three times
  }, 100);
}

// Better - use let for block scoping
for (let i = 0; i < 3; i++) {
  setTimeout(function () {
    console.log(i); // Will log 0, 1, 2
  }, 100);
}
```

### 3. Self-Executing Functions for Isolation

```javascript
// IIFE - Immediately Invoked Function Expression
(function () {
  const private = "Not accessible outside";
  console.log(private); // "Not accessible outside"
})();

// console.log(private); // Error: private is not defined
```

### 4. Minimize the Use of Global Variables

```javascript
// Bad - polluting global scope
const userId = 42;
const userName = "John";

// Better - namespace your globals
const userModule = {
  id: 42,
  name: "John",
};

// Best - use modules or closures
const userService = (function () {
  const id = 42;
  const name = "John";

  return {
    getId: () => id,
    getName: () => name,
  };
})();
```

### 5. Avoid Variable Shadowing When Possible

```javascript
const value = "global";

// Risky - shadows outer 'value'
function setValue() {
  const value = "local";
  // This might be confusing or lead to bugs
}

// Better - different name avoids confusion
function updateValue() {
  const localValue = "local";
  // Clearer distinction between global and local
}
```

### 6. Use Block Scope to Limit Exposure

```javascript
// Limit variable scope as much as possible
function processData(data) {
  // Only exists for the if block
  if (data.isValid) {
    const processedData = transform(data.value);
    return processedData;
  }

  // processedData is not accessible here - good!
  return null;
}
```

## Understanding Scope in Modern JavaScript

Modern JavaScript development often uses module systems and build tools that affect scope:

### 1. ES Modules

```javascript
// Each file has its own scope
// moduleA.js
export const valueA = "Module A";

// moduleB.js
import { valueA } from "./moduleA.js";
export const valueB = valueA + " extended";
```

### 2. Webpack and Other Bundlers

These tools wrap your code in functions to prevent global scope pollution, implementing a form of module scope even for non-module code.

## Exercises

1. Predict the output of nested functions accessing variables at different scope levels
2. Create a function that demonstrates closure by maintaining private state
3. Fix a scope-related bug in a loop that uses callbacks
4. Implement a module pattern that exposes a public API while keeping some functions private

## Resources

- [MDN Web Docs: Scope](https://developer.mozilla.org/en-US/docs/Glossary/Scope)
- [MDN Web Docs: Closures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)
- [JavaScript.info: Variable scope, closure](https://javascript.info/closure)
- [You Don't Know JS: Scope & Closures](https://github.com/getify/You-Dont-Know-JS/tree/2nd-ed/scope-closures)
