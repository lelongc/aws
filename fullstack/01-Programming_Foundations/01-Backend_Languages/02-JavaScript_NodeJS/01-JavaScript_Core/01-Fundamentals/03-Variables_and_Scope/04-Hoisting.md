# Hoisting in JavaScript

Hoisting is one of JavaScript's unique behaviors that often confuses developers. It refers to the process of moving declarations to the top of their containing scope during the compilation phase, before code execution. Understanding hoisting is crucial for writing predictable JavaScript code.

## What is Hoisting?

In JavaScript, variable and function declarations are "hoisted" to the top of their containing scope. However, only the declarations are hoisted, not the initializations or assignments.

It's as if JavaScript splits your declaration and assignment into two separate steps:

```javascript
// What you write
var x = 5;

// How JavaScript processes it
var x; // Declaration (hoisted)
x = 5; // Initialization (stays in place)
```

## Variable Hoisting

### Hoisting with var

Variables declared with `var` are hoisted to the top of their function scope or global scope and initialized with `undefined`:

```javascript
console.log(hoistedVar); // undefined (not an error)
var hoistedVar = "I'm hoisted";
console.log(hoistedVar); // "I'm hoisted"

// The above behaves like:
var hoistedVar;
console.log(hoistedVar); // undefined
hoistedVar = "I'm hoisted";
console.log(hoistedVar); // "I'm hoisted"
```

### Hoisting with let and const

Variables declared with `let` and `const` are also hoisted, but they are not initialized with any value. Instead, they enter what's called the "Temporal Dead Zone" (TDZ) until the actual declaration is reached:

```javascript
// console.log(hoistedLet); // ReferenceError: Cannot access 'hoistedLet' before initialization
let hoistedLet = "I am let";

// console.log(hoistedConst); // ReferenceError: Cannot access 'hoistedConst' before initialization
const hoistedConst = "I am const";
```

The key difference between `var` and `let`/`const` is that `var` variables can be accessed before declaration (with value `undefined`), while `let`/`const` variables cannot be accessed at all before declaration (they're in the TDZ).

## Function Hoisting

### Function Declarations

Function declarations are completely hoisted, meaning both the function's name and its body are moved to the top. This means you can call a function before its declaration:

```javascript
// This works thanks to hoisting
sayHello(); // "Hello, world!"

function sayHello() {
  console.log("Hello, world!");
}
```

### Function Expressions

Function expressions, on the other hand, are not hoisted in the same way. When using a function expression with `var`, only the variable declaration is hoisted, not the function assignment:

```javascript
// console.log(sayHi); // undefined
// sayHi(); // TypeError: sayHi is not a function

var sayHi = function () {
  console.log("Hi, world!");
};

// After this point, sayHi can be called
sayHi(); // "Hi, world!"
```

With `let` or `const`, the variable is hoisted but remains in the TDZ until declaration:

```javascript
// console.log(greet); // ReferenceError: Cannot access 'greet' before initialization

const greet = function () {
  console.log("Greetings!");
};
```

### Arrow Functions

Arrow functions behave like function expressions regarding hoisting:

```javascript
// console.log(arrowFunc); // undefined (if using var) or ReferenceError (if using let/const)

var arrowFunc = () => {
  console.log("I am an arrow function");
};
```

## Class Hoisting

Class declarations are hoisted but, like `let` and `const`, they remain uninitialized until evaluation:

```javascript
// const p = new Person(); // ReferenceError: Cannot access 'Person' before initialization

class Person {
  constructor(name) {
    this.name = name;
  }
}

// After the class declaration, it can be used
const p = new Person("John");
```

Class expressions follow the same hoisting rules as function expressions.

## The Temporal Dead Zone (TDZ)

The Temporal Dead Zone is the period between entering a scope where a variable is declared and the actual declaration:

```javascript
{
  // TDZ starts for x
  console.log(typeof y); // undefined (y is not declared anywhere)
  // console.log(typeof x); // ReferenceError: Cannot access 'x' before initialization

  // TDZ continues...

  let x = 10; // TDZ ends for x
  console.log(x); // 10
}
```

The TDZ exists to catch errors where you might accidentally use a variable before it's declared.

## Hoisting in Loops

Understanding hoisting in loops is important, especially with `var`:

```javascript
// With var
for (var i = 0; i < 3; i++) {
  // i is function-scoped
}
console.log(i); // 3 (i is accessible outside the loop)

// With let
for (let j = 0; j < 3; j++) {
  // j is block-scoped
}
// console.log(j); // ReferenceError: j is not defined
```

In the first loop, `var i` is hoisted to the function or global scope. In the second loop, `let j` is block-scoped to the loop.

## Practical Examples of Hoisting

### Example 1: Mixed Declarations

```javascript
console.log(a); // undefined (var is hoisted and initialized with undefined)
// console.log(b); // ReferenceError: Cannot access 'b' before initialization
var a = 1;
let b = 2;
```

### Example 2: Functions Inside Conditionals

```javascript
function example() {
  if (true) {
    function localFunc() {
      return "A";
    }
  } else {
    function localFunc() {
      return "B";
    }
  }

  return localFunc(); // Behavior is inconsistent across browsers due to hoisting
}

// More reliable approach:
function betterExample() {
  let localFunc;

  if (true) {
    localFunc = function () {
      return "A";
    };
  } else {
    localFunc = function () {
      return "B";
    };
  }

  return localFunc();
}
```

### Example 3: Nested Functions

```javascript
function outer() {
  var x = 10;

  function inner() {
    var y = 20;
    console.log(x + y); // 30
  }

  inner();
}

outer();
```

In this example, `inner` can access `x` because of both hoisting and scope chain.

## Best Practices to Avoid Hoisting Issues

1. **Declare variables at the top of their scope**

   ```javascript
   function example() {
     // Declare all variables at the top
     var a, b, c;

     // Rest of the function...
     a = fetchSomething();
     b = processSomething(a);
     c = a + b;
   }
   ```

2. **Always use `let` and `const` instead of `var`**

   ```javascript
   // Prefer:
   let counter = 0;
   const MAX_SIZE = 100;

   // Instead of:
   var counter = 0;
   var MAX_SIZE = 100;
   ```

3. **Use function expressions instead of function declarations inside blocks**

   ```javascript
   // Better:
   if (condition) {
     const myFunc = function () {
       console.log("Function defined in a block");
     };
     myFunc();
   }

   // Avoid:
   if (condition) {
     function myFunc() {
       // Hoisting behavior may vary between browsers
       console.log("Function defined in a block");
     }
     myFunc();
   }
   ```

4. **Declare functions before using them**

   Even though function declarations are hoisted, it's clearer to define them before using them:

   ```javascript
   // Preferred style:
   function processData(data) {
     // Implementation
   }

   processData(myData);
   ```

## Common Hoisting Pitfalls

### Pitfall 1: Confusing Hoisting with Initialization

```javascript
console.log(myVar); // undefined, not "Hello"
var myVar = "Hello";
```

### Pitfall 2: Relying on Function Hoisting Inside Blocks

```javascript
if (true) {
  function conditionalFunc() {
    return "Version A";
  }
} else {
  function conditionalFunc() {
    return "Version B";
  }
}

// The behavior of conditionalFunc() is not guaranteed across all environments
```

### Pitfall 3: Forgetting that let/const Are Hoisted But Not Initialized

```javascript
{
  // console.log(blockScoped); // Error, but not because it's not hoisted
  // It's because it's in the TDZ
  let blockScoped = "I am block-scoped";
}
```

### Pitfall 4: Redeclaring Variables

```javascript
var x = 1;
// ...
var x = 2; // No error, x is now 2

let y = 1;
// let y = 2; // SyntaxError: Identifier 'y' has already been declared
```

## Strict Mode Effects on Hoisting

When using JavaScript's strict mode (`"use strict";`), some hoisting behaviors change:

```javascript
"use strict";

// This causes an error in strict mode
function strictFunc() {
  // Error: y is not defined
  y = 10;
  var x = 5;
}
```

## Exercises

1. What will be logged in this code?
   ```javascript
   console.log(x);
   var x = 5;
   ```
2. Fix this code to ensure `result` is correctly calculated:

   ```javascript
   function calculate() {
     console.log(result); // undefined
     return result * 2; // NaN
     var result = 10;
   }
   ```

3. Explain the difference in output between these two loops:

   ```javascript
   // Loop A
   for (var i = 0; i < 3; i++) {
     setTimeout(() => console.log(i), 100);
   }

   // Loop B
   for (let j = 0; j < 3; j++) {
     setTimeout(() => console.log(j), 100);
   }
   ```

## Resources

- [MDN Web Docs: Hoisting](https://developer.mozilla.org/en-US/docs/Glossary/Hoisting)
- [JavaScript.info: Variable scope, closure](https://javascript.info/closure)
- [You Don't Know JS: Scope & Closures](https://github.com/getify/You-Dont-Know-JS/tree/2nd-ed/scope-closures)
