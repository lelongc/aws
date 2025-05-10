# JavaScript Numbers

In JavaScript, all numbers are stored as 64-bit floating-point values (double precision), following the IEEE 754 standard. This means that, unlike many other programming languages, JavaScript doesn't distinguish between integers and floating-point numbers.

## Number Basics

### Creating Number Values

```javascript
// Direct assignment
let count = 42; // Integer
let price = 19.99; // Decimal number
let negative = -7; // Negative number
let million = 1000000; // Large number
let million2 = 1_000_000; // Numeric separators (ES2021)

// Scientific notation
let largeNumber = 5e6; // 5,000,000
let smallNumber = 5e-6; // 0.000005

// Number constructor
let x = Number(42); // Creates a number value
let y = new Number(42); // Creates a Number object (not recommended)
```

### Number Literals

JavaScript supports different number bases:

```javascript
// Decimal (base 10) - default
let decimal = 42;

// Binary (base 2) - prefix 0b
let binary = 0b101010; // 42 in decimal

// Octal (base 8) - prefix 0o
let octal = 0o52; // 42 in decimal

// Hexadecimal (base 16) - prefix 0x
let hex = 0x2a; // 42 in decimal
```

## Number Range and Precision

JavaScript numbers have limitations due to the 64-bit IEEE 754 format:

```javascript
// Min and Max safe integers
Number.MAX_SAFE_INTEGER; // 9,007,199,254,740,991 (2^53 - 1)
Number.MIN_SAFE_INTEGER; // -9,007,199,254,740,991 -(2^53 - 1)

// Checking if a number is safe
Number.isSafeInteger(9007199254740991); // true
Number.isSafeInteger(9007199254740992); // false

// Max and Min values
Number.MAX_VALUE; // ~1.79E+308
Number.MIN_VALUE; // ~5e-324 (smallest positive value)

// Precision issues
0.1 + 0.2; // 0.30000000000000004, not exactly 0.3
```

## Special Number Values

JavaScript has several special numeric values:

```javascript
// Infinity
Infinity; // Positive infinity
-Infinity; // Negative infinity
1 / 0; // Infinity
-1 / 0; // -Infinity
Number.POSITIVE_INFINITY; // Infinity
Number.NEGATIVE_INFINITY; // -Infinity

// NaN (Not a Number)
NaN; // Represents a computational error
0 / 0; // NaN
parseInt("hello"); // NaN
Number.NaN; // NaN

// Checking for NaN
isNaN(NaN); // true
isNaN("string"); // true (converts to NaN first)
Number.isNaN("string"); // false (checks if actually NaN)
Number.isNaN(NaN); // true

// Checking for finite values
isFinite(42); // true
isFinite(Infinity); // false
Number.isFinite(42); // true
Number.isFinite("42"); // false (stricter than global isFinite)
```

## Numeric Operations

### Basic Arithmetic

```javascript
let a = 10;
let b = 3;

// Basic operations
let sum = a + b; // Addition: 13
let difference = a - b; // Subtraction: 7
let product = a * b; // Multiplication: 30
let quotient = a / b; // Division: 3.3333333333333335
let remainder = a % b; // Remainder/modulus: 1
let power = a ** b; // Exponentiation: 1000 (10^3)

// Increment and decrement
let x = 5;
x++; // Post-increment: x becomes 6
++x; // Pre-increment: x becomes 7
x--; // Post-decrement: x becomes 6
--x; // Pre-decrement: x becomes 5

// Unary plus/minus
let str = "42";
let num = +str; // Unary plus: converts to number 42
let negNum = -num; // Unary minus: negates to -42
```

### Advanced Operations with the Math Object

The `Math` object provides advanced mathematical functions:

```javascript
// Constants
Math.PI; // π (approximately 3.14159)
Math.E; // Euler's number (approximately 2.71828)

// Rounding
Math.round(4.7); // 5 (nearest integer)
Math.round(4.4); // 4
Math.ceil(4.1); // 5 (rounded up)
Math.floor(4.9); // 4 (rounded down)
Math.trunc(4.9); // 4 (integer part, no rounding)

// Min and max
Math.min(2, 5, 1, 8); // 1
Math.max(2, 5, 1, 8); // 8

// Powers and roots
Math.pow(2, 3); // 8 (same as 2 ** 3)
Math.sqrt(16); // 4 (square root)
Math.cbrt(8); // 2 (cube root)

// Absolute value
Math.abs(-5); // 5

// Trigonometry
Math.sin(Math.PI / 2); // 1 (sine)
Math.cos(0); // 1 (cosine)
Math.tan(Math.PI / 4); // 1 (tangent)

// Random numbers
Math.random(); // Random number between 0 (inclusive) and 1 (exclusive)

// Random integer between min and max (inclusive)
function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

getRandomInt(1, 10); // Random integer from 1 to 10
```

## Number Methods

JavaScript numbers have useful built-in methods:

```javascript
// toString(base) - convert to string in specified base
let num = 42;
num.toString(); // "42" (decimal)
num.toString(2); // "101010" (binary)
num.toString(8); // "52" (octal)
num.toString(16); // "2a" (hexadecimal)

// toFixed(n) - format with n digits after decimal point
let pi = 3.14159;
pi.toFixed(2); // "3.14" (returns string)
pi.toFixed(4); // "3.1416" (rounds)

// toPrecision(n) - format with n significant digits
pi.toPrecision(3); // "3.14"
pi.toPrecision(6); // "3.14159"

// toExponential(n) - format in exponential notation with n digits
let bigNum = 1234.56;
bigNum.toExponential(2); // "1.23e+3"

// valueOf() - returns primitive value
let numObj = new Number(42);
numObj.valueOf(); // 42 (number primitive)
```

## Number Conversions

Converting between numbers and other types:

```javascript
// String to Number
Number("42"); // 42
parseInt("42"); // 42
parseInt("42px"); // 42 (ignores non-numeric parts)
parseInt("42.5"); // 42 (integer part only)
parseFloat("42.5"); // 42.5
+"42"; // 42 (unary plus)

// Specifying base for parseInt
parseInt("101010", 2); // 42 (binary)
parseInt("2A", 16); // 42 (hexadecimal)

// Number to String
String(42); // "42"
(42).toString(); // "42" (note the double dot)
(42).toString(); // "42"
42 + ""; // "42" (implicit conversion)

// Boolean to Number
Number(true); // 1
Number(false); // 0

// Invalid conversions
Number("hello"); // NaN
parseInt("hello"); // NaN
```

## Precision Issues and Solutions

JavaScript numbers can have precision issues with decimal calculations:

```javascript
// Precision problems
0.1 + 0.2; // 0.30000000000000004, not exactly 0.3
0.1 + 0.2 === 0.3; // false

// Solutions for precise decimal calculations
// 1. Using rounding
Math.round((0.1 + 0.2) * 10) / 10; // 0.3

// 2. Using toFixed and parseFloat
parseFloat((0.1 + 0.2).toFixed(1)); // 0.3

// 3. Using epsilon for comparisons
Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON; // true
```

## BigInt for Large Numbers

For integers larger than `Number.MAX_SAFE_INTEGER`, use BigInt (ES2020):

```javascript
// Creating BigInt values
let bigInt = 9007199254740992n; // Literal notation with 'n' suffix
let anotherBigInt = BigInt(9007199254740992); // Constructor

// Operations with BigInts
let result = bigInt + 1n; // 9007199254740993n
let division = bigInt / 2n; // 4503599627370496n (truncated division)

// Limitations
// Cannot mix BigInt with regular numbers
// bigInt + 1;  // TypeError

// Comparison works across types
bigInt > Number.MAX_SAFE_INTEGER; // true

// Cannot use Math object with BigInt
// Math.sqrt(bigInt);  // TypeError
```

## Common Numeric Patterns

### Checking if a Value is a Number

```javascript
// Check if value is a number type (excludes NaN)
function isNumber(value) {
  return typeof value === "number" && !isNaN(value);
}

isNumber(42); // true
isNumber(NaN); // false
isNumber("42"); // false

// Check if value can be treated as a number
function isNumeric(value) {
  return !isNaN(parseFloat(value)) && isFinite(value);
}

isNumeric("42"); // true
isNumeric("42px"); // false
isNumeric(Infinity); // false
```

### Generating Random Numbers

```javascript
// Random decimal between min and max
function getRandomDecimal(min, max) {
  return Math.random() * (max - min) + min;
}

// Random integer between min and max (inclusive)
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// Random item from array
function getRandomItem(array) {
  return array[Math.floor(Math.random() * array.length)];
}
```

### Formatting Numbers

```javascript
// Format number with thousands separator
function formatNumber(num) {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

formatNumber(1234567); // "1,234,567"

// Format as currency
function formatCurrency(num) {
  return "$" + num.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

formatCurrency(1234.56); // "$1,234.56"

// Using Intl.NumberFormat (modern approach)
new Intl.NumberFormat("en-US").format(1234567); // "1,234,567"
new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" }).format(
  1234.56
); // "$1,234.56"
```

## Best Practices

1. **Avoid direct comparisons with floating-point numbers**

   ```javascript
   // Bad
   if (0.1 + 0.2 === 0.3) {
     /* ... */
   }

   // Good
   if (Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON) {
     /* ... */
   }
   ```

2. **Use parseInt with a radix parameter**

   ```javascript
   // Bad
   parseInt("08"); // Could be interpreted as octal in older browsers

   // Good
   parseInt("08", 10); // Always decimal
   ```

3. **Prefer Number() over new Number()**

   ```javascript
   // Bad - creates a Number object
   let x = new Number(42);

   // Good - creates a primitive number
   let x = Number(42);
   // Or simpler
   let x = 42;
   ```

4. **Use BigInt for large integers**

   ```javascript
   // When working with large integers beyond Number.MAX_SAFE_INTEGER
   const largeNumber = 9007199254740992n;
   ```

5. **Handle NaN appropriately**
   ```javascript
   // Check for NaN with Number.isNaN, not isNaN
   if (Number.isNaN(result)) {
     // Handle the error case
   }
   ```

## Exercises

1. Write a function that rounds a number to a specified number of decimal places.
2. Create a function to check if a number is prime.
3. Implement a function to generate a random hexadecimal color code.
4. Convert a decimal number to binary, octal, and hexadecimal representations.
5. Write a function to calculate the factorial of a number.

## Resources

- [MDN Web Docs: Number](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number)
- [MDN Web Docs: Math](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math)
- [MDN Web Docs: BigInt](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt)
- [What Every JavaScript Developer Should Know About Floating Point Numbers](https://floating-point-gui.de/)
