# JavaScript Basic Syntax

JavaScript has a C-like syntax that is relatively easy to learn. This guide covers the fundamental syntax rules and structures of JavaScript that form the foundation for writing any JavaScript code.

## JavaScript Statements

JavaScript code is composed of statements that tell the browser what to do.

```javascript
// Each line is typically a statement
let message = "Hello!";
console.log(message);
```

Statements are usually separated by semicolons (`;`).

## Comments

Comments are used to explain code and are ignored by the JavaScript engine.

```javascript
// This is a single-line comment

/* This is
   a multi-line
   comment */
```

## Case Sensitivity

JavaScript is **case-sensitive**. Variables, function names, and all other identifiers must be typed with consistent capitalization.

```javascript
let name = "John";
let Name = "Jane"; // Different variable (capital N)

console.log(name); // "John"
console.log(Name); // "Jane"
```

## Variables and Constants

Variables are containers for storing data values. In modern JavaScript, there are three ways to declare variables:

```javascript
// Using 'let' (block-scoped, value can change)
let age = 25;
age = 26; // Value can be changed

// Using 'const' (block-scoped, value cannot change)
const PI = 3.14;
// PI = 3.15;  // Error: Assignment to constant variable

// Using 'var' (function-scoped, older way)
var count = 10;
count = 11; // Value can be changed
```

### Variable Naming Rules

- Names can contain letters, digits, underscores, and dollar signs
- Names must begin with a letter, $ or \_
- Names are case sensitive
- Reserved words (like JavaScript keywords) cannot be used as names

```javascript
// Valid variable names
let userName = "john_doe";
let $price = 19.99;
let _privateVar = "secret";
let camelCase = "This is standard convention";

// Invalid variable names
// let 123abc = "invalid";  // Cannot start with a number
// let user-name = "john";  // Cannot use hyphen
// let let = "reserved";    // Cannot use reserved keyword
```

## Data Types

JavaScript has dynamic typing - variables can hold different types of data:

```javascript
// String
let name = "John";

// Number
let age = 30;
let price = 19.99;

// Boolean
let isActive = true;

// Undefined
let undefinedVar;

// Null
let emptyValue = null;

// Object
let person = {
  firstName: "John",
  lastName: "Doe",
};

// Array (type of object)
let colors = ["red", "green", "blue"];

// Function
let greet = function () {
  console.log("Hello!");
};
```

## Basic Operators

### Arithmetic Operators

```javascript
let a = 10;
let b = 3;

let sum = a + b; // Addition: 13
let difference = a - b; // Subtraction: 7
let product = a * b; // Multiplication: 30
let quotient = a / b; // Division: 3.33...
let remainder = a % b; // Modulus (remainder): 1
let power = a ** b; // Exponentiation: 1000 (10^3)

// Increment and decrement
let count = 5;
count++; // Increment by 1 (count is now 6)
count--; // Decrement by 1 (count is now 5 again)

// Prefix vs. postfix
let x = 3;
let y = ++x; // Prefix increment: x becomes 4, y is 4
let z = x++; // Postfix increment: z is 4, then x becomes 5
```

### Assignment Operators

```javascript
let x = 10; // Simple assignment

x += 5; // Add and assign: x = x + 5 (x is now 15)
x -= 3; // Subtract and assign: x = x - 3 (x is now 12)
x *= 2; // Multiply and assign: x = x * 2 (x is now 24)
x /= 4; // Divide and assign: x = x / 4 (x is now 6)
x %= 4; // Modulus and assign: x = x % 4 (x is now 2)
x **= 3; // Exponentiation and assign: x = x ** 3 (x is now 8)
```

### Comparison Operators

```javascript
let a = 5;
let b = 10;
let c = "5";

a == b; // Equal to: false
a != b; // Not equal to: true
a < b; // Less than: true
a > b; // Greater than: false
a <= b; // Less than or equal to: true
a >= b; // Greater than or equal to: false

a == c; // Equal to (with type conversion): true
a === c; // Strict equal to (no type conversion): false
a !== c; // Strict not equal to: true
```

### Logical Operators

```javascript
let x = true;
let y = false;

x && y; // Logical AND: false
x || y; // Logical OR: true
!x; // Logical NOT: false
```

## Strings and Template Literals

### Basic String Operations

```javascript
let firstName = "John";
let lastName = "Doe";

// String concatenation
let fullName = firstName + " " + lastName; // "John Doe"

// String length
let length = firstName.length; // 4
```

### Template Literals (ES6+)

```javascript
let name = "John";
let age = 30;

// Using template literals with backticks (`)
let message = `Hello, my name is ${name} and I am ${age} years old.`;
console.log(message); // "Hello, my name is John and I am 30 years old."

// Multi-line strings with template literals
let multiLine = `This is line 1
This is line 2
This is line 3`;
```

## Code Blocks

Code blocks are defined with curly braces `{}` and are used to group statements:

```javascript
// Code block example
{
  let x = 5;
  console.log(x); // 5
}

// Variable x is not accessible here
// console.log(x);  // ReferenceError

// Code blocks are often used with control statements
if (true) {
  let message = "This code will run";
  console.log(message);
}
```

## Whitespace and Formatting

JavaScript ignores extra whitespace in the code. Use it to make your code more readable:

```javascript
// These two statements are equivalent
let x = 10;
console.log(x);

// More readable with proper spacing and line breaks
let y = 20;
console.log(y);
```

## Semicolons

Semicolons are used to terminate statements in JavaScript:

```javascript
let name = "John"; // Semicolon here
console.log(name); // Semicolon here

// JavaScript has Automatic Semicolon Insertion (ASI)
// But it's best practice to include semicolons explicitly
let age = 30;
console.log(age); // Works, but not recommended
```

## Output and Debugging

The most basic way to output data in JavaScript is through the console:

```javascript
// Basic console output
console.log("Hello, world!");
console.log(42);
console.log(true);

// Multiple values
console.log("Name:", "John", "Age:", 30);

// Formatted console output
console.log("%s is %d years old", "John", 30);

// Other console methods
console.info("Informational message");
console.warn("Warning message");
console.error("Error message");
```

## JavaScript Expressions

An expression is any valid unit of code that resolves to a value:

```javascript
// Arithmetic expressions
let sum = 5 + 3; // 8

// String expressions
let greeting = "Hello" + " " + "world"; // "Hello world"

// Logical expressions
let isAdult = age >= 18; // true or false depending on age

// Assignment expressions
let x = (y = 10); // Assigns 10 to y, then assigns y to x

// Function call expressions
let result = Math.max(10, 20); // 20

// Object and array expressions
let user = { name: "John" };
let numbers = [1, 2, 3];
```

## Common Syntax Patterns

### Conditional (Ternary) Operator

```javascript
// condition ? expression1 : expression2
let status = age >= 18 ? "Adult" : "Minor";
```

### Object and Array Literal Notation

```javascript
// Object literal
let person = {
  name: "John",
  age: 30,
  isEmployed: true,
};

// Array literal
let fruits = ["Apple", "Banana", "Cherry"];
```

### Function Declaration and Expression

```javascript
// Function declaration
function greet(name) {
  return "Hello, " + name + "!";
}

// Function expression
let sayHello = function (name) {
  return "Hello, " + name + "!";
};

// Arrow function (ES6+)
let welcome = (name) => {
  return "Welcome, " + name + "!";
};

// Simplified arrow function (single expression)
let add = (a, b) => a + b;
```

## Best Practices

1. **Use meaningful variable names** that describe what the variable contains
2. **Follow consistent coding style** (indentation, spacing, etc.)
3. **Comment your code** to explain complex logic
4. **Use semicolons** at the end of statements
5. **Use strict equality (`===`)** instead of loose equality (`==`) where possible
6. **Use camelCase** for variable and function names
7. **Avoid global variables** to prevent namespace pollution

## Common Beginner Mistakes

1. **Missing closing brackets or parentheses**
2. **Case sensitivity issues** in variable or function names
3. **Using assignment (`=`) instead of comparison (`===` or `==`)**
4. **Forgetting to declare variables** with `let`, `const`, or `var`
5. **Confusion between `=` (assignment) and `==` or `===` (comparison)**

## Example: Putting It All Together

```javascript
// A simple program demonstrating basic JavaScript syntax
const TAX_RATE = 0.2; // 20% tax rate

function calculateTotalPrice(price, quantity) {
  if (price <= 0 || quantity <= 0) {
    console.error("Price and quantity must be positive numbers");
    return 0;
  }

  let subtotal = price * quantity;
  let tax = subtotal * TAX_RATE;
  let total = subtotal + tax;

  return total;
}

// Calculate price for 5 items at $10 each
let itemPrice = 10;
let itemCount = 5;
let finalPrice = calculateTotalPrice(itemPrice, itemCount);

console.log(`Buying ${itemCount} items at $${itemPrice} each:`);
console.log(`Total price including tax: $${finalPrice.toFixed(2)}`);

// Output using an if statement and ternary operator
if (finalPrice > 50) {
  let shippingMethod = finalPrice > 100 ? "Express" : "Standard";
  console.log(`Eligible for ${shippingMethod} shipping`);
} else {
  console.log("Not eligible for free shipping");
}
```

## Next Steps

Now that you understand the basic syntax of JavaScript, you're ready to explore more advanced topics like:

- Control flow statements (if, else, switch, loops)
- Functions in depth
- Objects and arrays
- DOM manipulation
- Events and event handling

Remember that programming is a skill best learned through practice, so experiment with the syntax you've learned to build your understanding.
