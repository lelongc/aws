# Type Conversion in JavaScript

JavaScript is a dynamically typed language, which means variables can change types. Type conversion (also called type casting) is the process of converting a value from one type to another. Understanding type conversion is crucial for writing predictable JavaScript code.

## Implicit vs Explicit Type Conversion

JavaScript has two types of conversion:

1. **Implicit Conversion** (Coercion): Happens automatically when JavaScript expects a certain type
2. **Explicit Conversion**: When you deliberately convert from one type to another

## Explicit Type Conversion

### Converting to String

There are several ways to explicitly convert values to strings:

```javascript
// Using the String() function
String(123); // "123"
String(true); // "true"
String(null); // "null"
String(undefined); // "undefined"
String([1, 2, 3]); // "1,2,3"
String({}); // "[object Object]"

// Using the toString() method
(123).toString(); // "123"
true.toString(); // "true"
[1, 2, 3].toString(); // "1,2,3"
// null.toString();   // TypeError: Cannot read property 'toString' of null
// undefined.toString(); // TypeError

// String concatenation with empty string
"" + 123; // "123"
"" + true; // "true"
"" + null; // "null"
"" + undefined; // "undefined"
```

### Converting to Number

To convert values to numbers:

```javascript
// Using the Number() function
Number("123"); // 123
Number("12.3"); // 12.3
Number(""); // 0
Number("  "); // 0
Number("123abc"); // NaN
Number(true); // 1
Number(false); // 0
Number(null); // 0
Number(undefined); // NaN
Number([]); // 0
Number([1]); // 1
Number([1, 2]); // NaN
Number({}); // NaN

// Using parseInt() and parseFloat()
parseInt("123"); // 123
parseInt("123.45"); // 123 (integer part only)
parseInt("123abc"); // 123 (stops at non-digit)
parseInt("abc123"); // NaN (must start with digit)
parseFloat("123.45"); // 123.45
parseFloat("123"); // 123

// Specifying base with parseInt
parseInt("1010", 2); // 10 (base 2 - binary)
parseInt("FF", 16); // 255 (base 16 - hexadecimal)

// Using the unary plus operator
+"123"; // 123
+"123.45"; // 123.45
+""; // 0
+"123abc"; // NaN
+true; // 1
+false; // 0
+null; // 0
+undefined; // NaN
```

### Converting to Boolean

To convert values to booleans:

```javascript
// Using the Boolean() function
Boolean(1); // true
Boolean(0); // false
Boolean(-1); // true
Boolean(""); // false
Boolean(" "); // true
Boolean("hello"); // true
Boolean(null); // false
Boolean(undefined); // false
Boolean({}); // true
Boolean([]); // true
Boolean(NaN); // false

// Using double negation (!!)
!!1; // true
!!0; // false
!!"hello"; // true
!!null; // false

// Falsy values in JavaScript:
// false, 0, -0, 0n (BigInt zero), "", null, undefined, NaN
// Everything else is truthy
```

### Converting to Object

```javascript
// Using the Object() constructor
Object(1); // Number {1}
Object("hello"); // String {"hello"}
Object(true); // Boolean {true}
Object(null); // {}
Object(undefined); // {}

// Using wrapper constructors (not recommended)
new Number(1); // Number {1}
new String("hello"); // String {"hello"}
new Boolean(true); // Boolean {true}
```

## Implicit Type Conversion (Coercion)

JavaScript automatically converts types in many contexts:

### Operators Causing Type Conversion

```javascript
// Addition (+)
"5" + 3; // "53" (number converted to string)
3 + "5"; // "35" (number converted to string)
3 + true; // 4 (true converted to 1)
3 + false; // 3 (false converted to 0)
3 + null; // 3 (null converted to 0)
3 + undefined; // NaN (undefined converted to NaN)

// Subtraction, Multiplication, Division, etc.
"5" - 3; // 2 (string converted to number)
"5" * 3; // 15 (string converted to number)
"5" / 3; // 1.6666... (string converted to number)
"5" - true; // 4 (true converted to 1)
5 * false; // 0 (false converted to 0)
5 * null; // 0 (null converted to 0)
5 * undefined; // NaN (undefined converted to NaN)
```

### Comparison Operators

```javascript
// Equality (==) causes type conversion
5 == "5"; // true (string converted to number)
5 === "5"; // false (strict equality, no conversion)
true == 1; // true (boolean converted to number)
true === 1; // false
null == undefined; // true
null === undefined; // false
0 == false; // true
0 === false; // false
"0" == false; // true (complex conversion)
"0" === false; // false
[] == false; // true (complex conversion)
[] === false; // false
```

### Logical Operators

```javascript
// The && and || operators return one of their operands
// and don't always return a boolean
"hello" && "world"; // "world" (last truthy value)
"" && "world"; // "" (first falsy value)

"hello" || "world"; // "hello" (first truthy value)
"" || "world"; // "world" (first truthy value)

// Nullish coalescing operator (??) checks for null/undefined
const value = null ?? "default"; // "default"
const count = 0 ?? 42; // 0 (not null or undefined)
```

### Conditional Contexts

In conditional contexts, values are implicitly converted to boolean:

```javascript
if ("hello") {
  // "hello" becomes true
}

if (0) {
  // This block won't run, 0 becomes false
}

while ("") {
  // This loop won't run, "" becomes false
}

// Ternary operator
const result = 123 ? "truthy" : "falsy"; // "truthy"
```

## Type Conversion Rules

### To String Conversion Rules

1. Primitives convert to their literal representation:

   ```javascript
   String(123); // "123"
   String(true); // "true"
   String(false); // "false"
   String(null); // "null"
   String(undefined); // "undefined"
   String(Symbol("id")); // "Symbol(id)"
   String(1234n); // "1234"
   ```

2. Objects use a more complex process:
   - Call `toString()` method if available and it returns a primitive
   - If not, call `valueOf()` method if available and it returns a primitive
   - Otherwise, throw a TypeError

### To Number Conversion Rules

1. Primitives follow these rules:

   ```javascript
   Number(undefined); // NaN
   Number(null); // 0
   Number(true); // 1
   Number(false); // 0
   Number(" 12 "); // 12 (whitespace is trimmed)
   Number("-12.34"); // -12.34
   Number("123abc"); // NaN (invalid number format)
   Number("0xFF"); // 255 (recognizes hex format)
   Number(Symbol()); // TypeError
   Number(1234n); // 1234
   ```

2. Objects follow a similar process as string conversion, but in reverse order:
   - Call `valueOf()` method if available and it returns a primitive
   - If not, call `toString()` method if available and it returns a primitive
   - Otherwise, throw a TypeError

### To Boolean Conversion Rules

All JavaScript values are either "truthy" or "falsy":

Falsy values (convert to `false`):

```javascript
Boolean(false); // false
Boolean(0); // false
Boolean(-0); // false
Boolean(0n); // false (BigInt zero)
Boolean(""); // false
Boolean(null); // false
Boolean(undefined); // false
Boolean(NaN); // false
```

Everything else is truthy (converts to `true`):

```javascript
Boolean("0"); // true (non-empty string)
Boolean(" "); // true (space)
Boolean([]); // true (empty array)
Boolean({}); // true (empty object)
Boolean(function () {}); // true (function)
```

## Common Pitfalls and Solutions

### Addition vs. Concatenation

```javascript
// Problem:
var total = "10" + 5; // "105" (string concatenation)

// Solution: Convert string to number first
var total = Number("10") + 5; // 15
// or
var total = +"10" + 5; // 15
```

### Loose Equality Comparisons

```javascript
// Problem:
if (1 == true) {  // true, unexpected comparison

// Solution: Use strict equality
if (1 === true) {  // false
```

### Empty Arrays and Objects

```javascript
// Problem:
Boolean([]); // true, but...
[] == false; // true (confusing!)

// Objects to boolean conversion:
if ([]) {
  // This is true
  console.log("[] is truthy");
}

// But with loose equality:
if ([] == false) {
  // This is also true!
  console.log("[] equals false");
}

// Solution: Always use strict equality and explicit type conversion
if (Array.isArray(value) && value.length === 0) {
  // Empty array check
}
```

### parseInt Pitfalls

```javascript
// Problem:
parseInt("08"); // Was 0 in older browsers (interpreted as octal)
parseInt("09"); // Was 0 in older browsers

// Solution: Always provide the radix parameter
parseInt("08", 10); // 8
parseInt("09", 10); // 9
```

## Best Practices for Type Conversion

1. **Use strict equality (`===` and `!==`)** unless you specifically want type coercion

   ```javascript
   if (x === 5) {
     /* ... */
   }
   ```

2. **Use explicit conversion functions** to make code more readable

   ```javascript
   // Better:
   const value = Number(inputString);

   // Less clear:
   const value = +inputString;
   ```

3. **Be careful with loose operations like `+` and `==`**

   ```javascript
   // Safeguard numeric operations
   let sum = Number(a) + Number(b);
   ```

4. **Use explicit Boolean conversion for conditionals**

   ```javascript
   if (Boolean(value)) {
     /* ... */
   }
   // or
   if (!!value) {
     /* ... */
   }
   ```

5. **Take advantage of optional chaining and nullish coalescing**

   ```javascript
   // Instead of:
   const name = user && user.name ? user.name : "Guest";

   // Modern JavaScript:
   const name = user?.name ?? "Guest";
   ```

6. **Use TypeScript** for larger projects to catch type-related bugs early

## The typeof Operator

The `typeof` operator returns a string indicating the type of an operand:

```javascript
typeof 42; // "number"
typeof "abc"; // "string"
typeof true; // "boolean"
typeof undefined; // "undefined"
typeof null; // "object" (historical bug)
typeof Symbol("id"); // "symbol"
typeof 42n; // "bigint"
typeof {}; // "object"
typeof []; // "object" (arrays are objects)
typeof function () {}; // "function"
```

## Checking Types More Precisely

Because `typeof` has some limitations, use these patterns for more precise checks:

```javascript
// Check for array
Array.isArray([]); // true
Array.isArray({}); // false

// Check for null
value === null; // true for null only

// Check for NaN
Number.isNaN(NaN); // true
Number.isNaN("string"); // false (unlike global isNaN)

// Check for finite number
Number.isFinite(42); // true
Number.isFinite(Infinity); // false

// Check for integer
Number.isInteger(42); // true
Number.isInteger(42.5); // false
```

## Type Conversion with Modern JavaScript

### Template Literals

```javascript
const price = 19.99;
const message = `The price is $${price}`; // "The price is $19.99"
```

### Object.toString() Customization

```javascript
const user = {
  name: "John",
  age: 30,
  toString() {
    return `${this.name}, ${this.age} years old`;
  },
};

alert(user); // "John, 30 years old"
```

### Symbol.toPrimitive

```javascript
const obj = {
  [Symbol.toPrimitive](hint) {
    if (hint === "number") {
      return 42;
    }
    if (hint === "string") {
      return "hello";
    }
    return true; // default
  },
};

alert(obj); // "hello"
+obj; // 42
if (obj) {
} // true
```

## Exercises

1. Predict the output of various type conversions and explain the results
2. Create a robust type detection function that correctly identifies arrays, null, etc.
3. Write a function that safely compares two values of potentially different types
4. Create a function that converts an object to a query string for URL parameters

## Resources

- [MDN Web Docs: Type conversion](https://developer.mozilla.org/en-US/docs/Glossary/Type_conversion)
- [JavaScript.info: Type Conversions](https://javascript.info/type-conversions)
- [ECMAScript Specification: Abstract Operations](https://tc39.es/ecma262/#sec-abstract-operations)
