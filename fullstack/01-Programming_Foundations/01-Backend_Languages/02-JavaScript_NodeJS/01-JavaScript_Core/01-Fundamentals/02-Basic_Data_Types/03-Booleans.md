# JavaScript Booleans

Booleans represent one of the simplest data types in JavaScript, with only two possible values: `true` or `false`. Despite their simplicity, booleans are fundamental to programming logic and control flow.

## Boolean Basics

### Creating Boolean Values

The boolean data type has only two literal values:

```javascript
let isActive = true;
let isComplete = false;
```

### Boolean Operators

JavaScript includes standard logical operators for working with boolean values:

```javascript
// Logical AND (&&)
console.log(true && true); // true
console.log(true && false); // false
console.log(false && true); // false
console.log(false && false); // false

// Logical OR (||)
console.log(true || true); // true
console.log(true || false); // true
console.log(false || true); // true
console.log(false || false); // false

// Logical NOT (!)
console.log(!true); // false
console.log(!false); // true
console.log(!!true); // true (double negation)
```

### Comparison Operators

Comparison operators evaluate expressions and return boolean values:

```javascript
// Equality
console.log(5 == 5); // true
console.log(5 == "5"); // true (type coercion happens)
console.log(5 === 5); // true
console.log(5 === "5"); // false (strict equality, no type coercion)

// Inequality
console.log(5 != 8); // true
console.log(5 != "5"); // false (type coercion happens)
console.log(5 !== "5"); // true (strict inequality)

// Greater than / Less than
console.log(10 > 5); // true
console.log(10 < 5); // false
console.log(10 >= 10); // true
console.log(5 <= 10); // true
```

## Boolean Objects vs Boolean Primitives

Like other primitives in JavaScript, booleans can be created as primitives or as objects:

```javascript
// Boolean primitive (recommended)
let isPrimitive = true;

// Boolean object (NOT recommended for general use)
let isObject = new Boolean(true);

typeof isPrimitive; // "boolean"
typeof isObject; // "object"

// Converting Boolean object to primitive
let primitiveValue = isObject.valueOf(); // true
```

### Important Differences

Boolean objects and primitives behave differently in conditional expressions:

```javascript
let truePrimitive = true;
let falseObject = new Boolean(false);

if (truePrimitive) {
  console.log("This will execute"); // This executes because true is truthy
}

if (falseObject) {
  console.log("This will also execute!"); // This executes because ALL objects are truthy!
}

// The correct way to use a Boolean object in conditions:
if (falseObject.valueOf()) {
  console.log("This won't execute"); // This doesn't execute
}
```

## Truthy and Falsy Values

JavaScript has a concept of "truthiness" and "falsiness" where non-boolean values are converted to boolean when used in boolean contexts (like `if` statements).

### Falsy Values

The following values are considered falsy in JavaScript:

```javascript
// All of these are falsy:
false
0
-0
0n (BigInt zero)
""  (empty string)
null
undefined
NaN
```

### Truthy Values

Everything else is considered truthy, including:

```javascript
// All of these are truthy:
true
"false" (a string containing the text "false")
"0" (a string containing a zero)
[] (empty array)
{} (empty object)
function(){} (empty function)
```

### Examples in Conditionals

```javascript
// Falsy examples
if (false) {
  /* never executes */
}
if (0) {
  /* never executes */
}
if ("") {
  /* never executes */
}
if (null) {
  /* never executes */
}
if (undefined) {
  /* never executes */
}
if (NaN) {
  /* never executes */
}

// Truthy examples
if (true) {
  /* executes */
}
if (1) {
  /* executes */
}
if ("hello") {
  /* executes */
}
if ([]) {
  /* executes */
}
if ({}) {
  /* executes */
}
if (new Date()) {
  /* executes */
}
```

## Boolean Type Conversion

### Converting to Boolean

There are several ways to convert values to boolean:

```javascript
// Using the Boolean function (preferred for explicit conversion)
Boolean(1); // true
Boolean(0); // false
Boolean("hello"); // true
Boolean(""); // false
Boolean([]); // true
Boolean({}); // true

// Using double negation (common in code)
!!1; // true
!!0; // false
!!"hello"; // true
!!""; // false

// Using ternary operator
1 ? true : false; // true
0 ? true : false; // false

// Implicit conversion in logical operations
console.log(1 && "visible"); // "visible" (returns last truthy value)
console.log(0 || "default"); // "default" (returns first truthy value)
```

### The toString() Method

Converting booleans to strings:

```javascript
true.toString(); // "true"
false.toString(); // "false"

// Using String function
String(true); // "true"
String(false); // "false"

// Concatenation with empty string
"" + true; // "true"
"" + false; // "false"
```

## Short-Circuit Evaluation

JavaScript's logical operators use short-circuit evaluation, which can be used for conditional assignments and function execution:

### Logical AND (&&)

Evaluates the right operand only if the left operand is truthy:

```javascript
// Only calls function if user exists
user && user.logout();

// Equivalent to:
if (user) {
  user.logout();
}
```

### Logical OR (||)

Evaluates the right operand only if the left operand is falsy:

```javascript
// Default values (pre-ES6)
function greet(name) {
  name = name || "Guest";
  return "Hello, " + name;
}

console.log(greet()); // "Hello, Guest"
console.log(greet("John")); // "Hello, John"
```

### Nullish Coalescing Operator (??) - ES2020

Returns the right operand when the left is `null` or `undefined` (but not other falsy values):

```javascript
let count = 0;
let score = count || 10; // score = 10 (because 0 is falsy)
let points = count ?? 10; // points = 0 (because 0 is not null or undefined)

let userName = null;
let displayName = userName ?? "Guest"; // displayName = "Guest"
```

## Logical Assignment Operators - ES2021

JavaScript added logical assignment operators that combine logical operations with assignment:

```javascript
// Logical OR assignment
let a = null;
a ||= 10; // a = 10 (assigns right side if a is falsy)

// Logical AND assignment
let b = 5;
b &&= 20; // b = 20 (assigns right side if b is truthy)

// Logical nullish assignment
let c = 0;
c ??= 42; // c = 0 (assigns right side only if c is null or undefined)
```

## Boolean Methods

The `Boolean` object only has the methods inherited from the `Object` prototype, plus the following:

```javascript
// valueOf() - Returns the primitive value
let boolObject = new Boolean(true);
console.log(boolObject.valueOf()); // true

// toString() - Returns "true" or "false"
console.log(true.toString()); // "true"
console.log(false.toString()); // "false"
```

## Common Patterns and Idioms

### Guard Pattern

```javascript
// Function only runs if condition is true
function processUser(user) {
  // Check if the user exists before proceeding
  if (!user) return;

  // Process user...
  console.log("Processing user:", user.name);
}
```

### Default Parameters (Modern)

```javascript
// Using ES6 default parameters instead of || operator
function greet(name = "Guest") {
  return "Hello, " + name;
}

console.log(greet()); // "Hello, Guest"
console.log(greet("John")); // "Hello, John"
```

### Boolean Conversion for Arrays

A common pattern to check if array contains elements:

```javascript
const arr = [1, 2, 3];
if (arr.length) {
  console.log("Array has items");
}

// Converting to boolean
const hasItems = Boolean(arr.length); // true if array has items
// Or
const hasItems2 = !!arr.length; // Same result, more concise
```

### Toggle Pattern

```javascript
// Toggle a boolean value
let isVisible = true;
isVisible = !isVisible; // Now false
isVisible = !isVisible; // Back to true
```

### Function Return Value Checks

```javascript
// Check if function returned a "success" boolean
function processData() {
  // Some processing that returns true if successful
  return true;
}

if (processData()) {
  console.log("Data processed successfully");
} else {
  console.log("Error processing data");
}
```

## Best Practices

1. **Use Primitive Booleans Instead of Objects**

   ```javascript
   // Good
   const isActive = true;

   // Bad - avoid Boolean objects unless specifically needed
   const isActive = new Boolean(true);
   ```

2. **Use Strict Equality (`===`) Instead of Loose Equality (`==`)**

   ```javascript
   // Good
   if (value === true) {
     /* ... */
   }

   // Bad - might have unexpected results due to type coercion
   if (value == true) {
     /* ... */
   }
   ```

3. **Be Careful with Truthy/Falsy Values**

   ```javascript
   // Bad - relies on implicit conversion
   if (someArray) {
     // Array exists, but it could be empty
   }

   // Good - explicit check for what you want
   if (someArray && someArray.length > 0) {
     // Array exists and has elements
   }
   ```

4. **Use Explicit Boolean Conversion When Needed**

   ```javascript
   // Convert to boolean explicitly when the intent is clear
   const hasPermission = Boolean(user.permission);

   // For variables that should only be true/false
   let isLoading = false;
   ```

5. **Take Advantage of Short-Circuit Evaluation**

   ```javascript
   // Good for conditional execution
   userIsLoggedIn && showDashboard();

   // Good for default values
   const username = inputValue || "Guest";
   ```

## Exercises

1. Write a function that checks if a given year is a leap year (returns boolean).
2. Create a validation function that returns true if a password meets specific criteria.
3. Implement a toggle function that switches a boolean value and returns the new state.
4. Convert various values to booleans and explain their truthiness/falsiness.
5. Refactor code that uses if-statements to use short-circuit evaluation.

## Resources

- [MDN Web Docs: Boolean](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Boolean)
- [MDN Web Docs: Truthy](https://developer.mozilla.org/en-US/docs/Glossary/Truthy)
- [MDN Web Docs: Falsy](https://developer.mozilla.org/en-US/docs/Glossary/Falsy)
- [JavaScript.info: Logical Operators](https://javascript.info/logical-operators)
