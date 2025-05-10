# Arithmetic Operators in JavaScript

Arithmetic operators perform mathematical operations on numeric values. JavaScript provides a standard set of arithmetic operators similar to other programming languages, along with some additional features specific to JavaScript.

## Basic Arithmetic Operators

JavaScript includes the following basic arithmetic operators:

### Addition (+)

The addition operator adds two values:

```javascript
let sum = 5 + 3; // 8
let x = 10;
let y = 20;
let total = x + y; // 30
```

### Subtraction (-)

The subtraction operator subtracts the right operand from the left operand:

```javascript
let difference = 10 - 5; // 5
let result = 20 - 30; // -10 (negative number)
```

### Multiplication (\*)

The multiplication operator multiplies two values:

```javascript
let product = 6 * 7; // 42
let area = width * height; // Calculate area
```

### Division (/)

The division operator divides the left operand by the right operand:

```javascript
let quotient = 20 / 5; // 4
let result = 10 / 3; // 3.3333333333333335 (not exactly 3.33)
let divideByZero = 5 / 0; // Infinity
```

### Remainder (%)

The remainder operator (also called modulo) returns the remainder of a division:

```javascript
let remainder = 10 % 3; // 1 (10 divided by 3 gives 3 with remainder 1)
let evenCheck = 24 % 2; // 0 (24 is divisible by 2, so remainder is 0)

// Common use case: checking if a number is odd or even
let isEven = number % 2 === 0;
```

### Exponentiation (\*\*)

The exponentiation operator (introduced in ES2016) raises the left operand to the power of the right operand:

```javascript
let power = 2 ** 3; // 8 (2³ = 2×2×2 = 8)
let squared = 5 ** 2; // 25 (5² = 5×5 = 25)
let cubed = 3 ** 3; // 27 (3³ = 3×3×3 = 27)

// Equivalent to:
let powerUsingMath = Math.pow(2, 3); // 8
```

## Unary Arithmetic Operators

### Unary Plus (+)

The unary plus operator attempts to convert its operand to a number:

```javascript
let strNumber = "5";
let num = +strNumber; // 5 (converted to number)
let bool = +true; // 1
let notANumber = +"hello"; // NaN (Not a Number)
```

### Unary Minus (-)

The unary minus operator negates its operand and attempts to convert it to a number:

```javascript
let negation = -5; // -5
let strNegation = -"5"; // -5 (converted to number then negated)
let negBool = -true; // -1
```

### Increment (++)

The increment operator adds one to its operand:

```javascript
// Prefix increment (++x)
let a = 5;
let b = ++a; // a is incremented to 6, then assigned to b
console.log(a); // 6
console.log(b); // 6

// Postfix increment (x++)
let c = 5;
let d = c++; // c's value (5) is assigned to d, then c is incremented
console.log(c); // 6
console.log(d); // 5
```

### Decrement (--)

The decrement operator subtracts one from its operand:

```javascript
// Prefix decrement (--x)
let a = 5;
let b = --a; // a is decremented to 4, then assigned to b
console.log(a); // 4
console.log(b); // 4

// Postfix decrement (x--)
let c = 5;
let d = c--; // c's value (5) is assigned to d, then c is decremented
console.log(c); // 4
console.log(d); // 5
```

## Arithmetic Assignment Operators

These operators combine arithmetic operations with assignment:

```javascript
let x = 10;

x += 5; // x = x + 5 (x is now 15)
x -= 3; // x = x - 3 (x is now 12)
x *= 2; // x = x * 2 (x is now 24)
x /= 4; // x = x / 4 (x is now 6)
x %= 4; // x = x % 4 (x is now 2)
x **= 3; // x = x ** 3 (x is now 8)
```

## Order of Operations (Operator Precedence)

JavaScript follows the standard mathematical order of operations:

1. Parentheses `()`
2. Exponentiation `**`
3. Unary operators `+`, `-`, `++`, `--`
4. Multiplication, division, remainder `*`, `/`, `%`
5. Addition, subtraction `+`, `-`

```javascript
let result = 2 + 3 * 4; // 14 (not 20, * has higher precedence than +)
let withParens = (2 + 3) * 4; // 20 (parentheses change the order)
let complex = 2 ** 3 + 4 * 5 - 6 / 2; // 8 + 20 - 3 = 25
```

## Special Cases and Edge Behaviors

### Division by Zero

Unlike some languages that throw errors for division by zero, JavaScript returns special values:

```javascript
let divideByZero = 5 / 0; // Infinity
let negDivideByZero = -5 / 0; // -Infinity
let zeroDivideByZero = 0 / 0; // NaN
```

### NaN (Not a Number)

NaN results from operations that cannot produce a meaningful numeric result:

```javascript
let invalid = "hello" / 5; // NaN
let notANumber = Math.sqrt(-1); // NaN

// NaN has unique properties
console.log(NaN === NaN); // false
console.log(isNaN(NaN)); // true

// Better checking with Number.isNaN()
console.log(Number.isNaN(NaN)); // true
console.log(Number.isNaN("test")); // false (unlike global isNaN)
```

### Infinity

JavaScript can represent positive and negative infinity:

```javascript
let posInfinity = Infinity;
let negInfinity = -Infinity;

// Operations with Infinity
console.log(Infinity + 1); // Infinity
console.log(Infinity - 100); // Infinity
console.log(Infinity * 0); // NaN
console.log(Infinity / Infinity); // NaN
console.log(5 / Infinity); // 0
```

## Type Coercion in Arithmetic Operations

JavaScript automatically converts (coerces) values when performing arithmetic operations:

```javascript
// String and number addition
let result1 = "5" + 3; // "53" (number is converted to string)
let result2 = 5 + "3"; // "53" (number is converted to string)

// Other operations convert strings to numbers
let result3 = "5" - 3; // 2 (string is converted to number)
let result4 = "5" * 3; // 15 (string is converted to number)
let result5 = "5" / 2; // 2.5 (string is converted to number)

// Boolean conversion
let result6 = true + 1; // 2 (true is converted to 1)
let result7 = false * 5; // 0 (false is converted to 0)

// Array conversion
let result8 = [1, 2, 3] + 4; // "1,2,34" (array converts to string "1,2,3")
let result9 = [1] - 1; // 0 (single-element array can convert to number)

// Object conversion
let result10 = {} + 5; // "[object Object]5" (object converts to string)
let result11 = {} - 5; // NaN (cannot convert for subtraction)
```

## Numeric Precision Issues

JavaScript uses IEEE 754 floating-point representation, which can lead to precision issues:

```javascript
let calculation = 0.1 + 0.2;
console.log(calculation); // 0.30000000000000004, not exactly 0.3
console.log(calculation === 0.3); // false

// Solutions:
// 1. Use toFixed() for display
console.log(calculation.toFixed(2)); // "0.30"

// 2. Use a small epsilon for comparison
const epsilon = 0.0001;
console.log(Math.abs(calculation - 0.3) < epsilon); // true

// 3. Multiply by a power of 10, perform integer arithmetic, then divide
let precise = (0.1 * 10 + 0.2 * 10) / 10;
console.log(precise); // 0.3
```

## Bitwise Operators

JavaScript also includes bitwise operators for low-level bit manipulation:

```javascript
// Bitwise AND (&)
let bitAnd = 5 & 3; // 1 (0101 & 0011 = 0001)

// Bitwise OR (|)
let bitOr = 5 | 3; // 7 (0101 | 0011 = 0111)

// Bitwise XOR (^)
let bitXor = 5 ^ 3; // 6 (0101 ^ 0011 = 0110)

// Bitwise NOT (~)
let bitNot = ~5; // -6 (inverts bits and adds 1 to the negative value)

// Left shift (<<)
let leftShift = 5 << 1; // 10 (shifts bits left by 1 position)

// Right shift (>>)
let rightShift = 5 >> 1; // 2 (shifts bits right by 1 position)

// Zero-fill right shift (>>>)
let zeroFill = -5 >>> 1; // Large positive number (shifts and fills with zeros)
```

## Common Use Cases and Patterns

### Checking Odd/Even Numbers

```javascript
// Check if a number is even
function isEven(num) {
  return num % 2 === 0;
}

// Check if a number is odd
function isOdd(num) {
  return num % 2 !== 0;
}
```

### Converting String to Number

```javascript
// Using unary plus
let age = +"25"; // 25

// Safer parsing with fallback
function safeParseInt(value, defaultValue = 0) {
  const parsed = parseInt(value, 10);
  return isNaN(parsed) ? defaultValue : parsed;
}
```

### Truncating Decimal Numbers

```javascript
// Using Math.floor() (rounds down)
Math.floor(3.7); // 3

// Using Math.ceil() (rounds up)
Math.ceil(3.2); // 4

// Using Math.round() (rounds to nearest integer)
Math.round(3.5); // 4

// Using Math.trunc() (removes decimal part)
Math.trunc(3.7); // 3
```

### Calculating Percentages

```javascript
function calculatePercentage(value, total) {
  return (value / total) * 100;
}

calculatePercentage(75, 200); // 37.5
```

## Best Practices

1. **Use Parentheses for Clarity**:

   ```javascript
   let result = (2 + 3) * 4; // Clearer than relying on operator precedence
   ```

2. **Avoid Implicit Type Conversions**:

   ```javascript
   // Bad
   let sum = "5" + 3;

   // Good
   let sum = Number("5") + 3;
   // or
   let sum = parseInt("5", 10) + 3;
   ```

3. **Handle Division Carefully**:

   ```javascript
   // Check for division by zero
   function safeDivide(a, b) {
     if (b === 0) {
       return "Cannot divide by zero";
     }
     return a / b;
   }
   ```

4. **Use Utility Functions for Floating-Point Comparison**:

   ```javascript
   function areFloatsEqual(a, b, epsilon = 0.00001) {
     return Math.abs(a - b) < epsilon;
   }
   ```

5. **Use BigInt for Large Numbers**:
   ```javascript
   // For integers larger than Number.MAX_SAFE_INTEGER
   const largeNumber = 9007199254740992n + 1n; // Use 'n' suffix for BigInt
   ```

## Exercises

1. Write a function to calculate the area of a circle given its radius.
2. Create a temperature converter between Celsius and Fahrenheit.
3. Implement a function that returns the factorial of a given number.
4. Write a function that checks if a given number is a prime number.
5. Create a simple interest calculator for a loan.

## Resources

- [MDN Web Docs: Arithmetic Operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators)
- [MDN Web Docs: Expressions and Operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Expressions_and_Operators)
- [JavaScript.info: Operators](https://javascript.info/operators)
