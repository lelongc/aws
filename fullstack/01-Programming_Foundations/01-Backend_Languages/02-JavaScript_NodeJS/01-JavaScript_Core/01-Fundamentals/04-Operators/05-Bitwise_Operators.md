# Bitwise Operators in JavaScript

Bitwise operators in JavaScript perform operations on binary representations of numbers. While not as commonly used as other operators, they're powerful for certain types of operations like flags, permissions, and low-level manipulations.

## Understanding Binary Numbers

Before diving into bitwise operators, it's important to understand how numbers are represented in binary:

- Each position in a binary number represents a power of 2
- JavaScript stores numbers as 64-bit floating-point values
- Bitwise operations are performed on 32-bit integers

```javascript
// Decimal to binary conversion
console.log((10).toString(2)); // "1010" (binary representation of 10)
console.log((25).toString(2)); // "11001" (binary representation of 25)

// Binary to decimal conversion
console.log(parseInt("1010", 2)); // 10
console.log(parseInt("11001", 2)); // 25
```

## JavaScript Bitwise Operators

### Bitwise AND (&)

The bitwise AND operator compares each bit of the first operand with the corresponding bit of the second operand. It returns a 1 for each position where both bits are 1; otherwise, it returns 0.

```javascript
const a = 5; // Binary: 0101
const b = 3; // Binary: 0011
const result = a & b; // Binary: 0001 (Decimal: 1)

console.log(result); // 1

// Truth table for AND
// 0 & 0 = 0
// 0 & 1 = 0
// 1 & 0 = 0
// 1 & 1 = 1
```

### Bitwise OR (|)

The bitwise OR operator compares each bit of the first operand with the corresponding bit of the second operand. It returns a 1 for each position where at least one of the bits is 1; otherwise, it returns 0.

```javascript
const a = 5; // Binary: 0101
const b = 3; // Binary: 0011
const result = a | b; // Binary: 0111 (Decimal: 7)

console.log(result); // 7

// Truth table for OR
// 0 | 0 = 0
// 0 | 1 = 1
// 1 | 0 = 1
// 1 | 1 = 1
```

### Bitwise XOR (^)

The bitwise XOR (exclusive OR) operator compares each bit of the first operand with the corresponding bit of the second operand. It returns a 1 for each position where the bits are different; otherwise, it returns 0.

```javascript
const a = 5; // Binary: 0101
const b = 3; // Binary: 0011
const result = a ^ b; // Binary: 0110 (Decimal: 6)

console.log(result); // 6

// Truth table for XOR
// 0 ^ 0 = 0
// 0 ^ 1 = 1
// 1 ^ 0 = 1
// 1 ^ 1 = 0
```

### Bitwise NOT (~)

The bitwise NOT operator inverts all the bits of its operand. In JavaScript, this is equivalent to taking the two's complement of a number.

```javascript
const a = 5; // Binary: 0000 0000 0000 0000 0000 0000 0000 0101
const result = ~a; // Binary: 1111 1111 1111 1111 1111 1111 1111 1010 (Decimal: -6)

console.log(result); // -6

// The formula for ~ is: ~n = -(n+1)
```

### Left Shift (<<)

The left shift operator shifts the bits of the first operand to the left by the number of bits specified by the second operand. New bits on the right are filled with zeros.

```javascript
const a = 5; // Binary: 0101
const result = a << 2; // Binary: 010100 (Decimal: 20)

console.log(result); // 20

// Left shifting is equivalent to multiplying by 2^n
// 5 << 2 = 5 * (2^2) = 5 * 4 = 20
```

### Right Shift (>>)

The right shift operator shifts the bits of the first operand to the right by the number of bits specified by the second operand. New bits on the left are filled based on the sign (sign-propagating).

```javascript
const a = 5; // Binary: 0101
const result = a >> 1; // Binary: 010 (Decimal: 2)

console.log(result); // 2

// For positive numbers, right shifting is equivalent to dividing by 2^n
// 5 >> 1 = 5 / (2^1) = 5 / 2 = 2 (integer division)

const negative = -10; // Binary representation is complex due to two's complement
const negResult = negative >> 1; // -5

console.log(negResult); // -5
```

### Zero-fill Right Shift (>>>)

The zero-fill right shift operator shifts the bits of the first operand to the right by the number of bits specified by the second operand. New bits on the left are always filled with zeros (regardless of sign).

```javascript
const a = 5; // Binary: 0101
const result = a >>> 1; // Binary: 010 (Decimal: 2)

console.log(result); // 2 (same as >> for positive numbers)

const negative = -10; // Binary: 11...1010 (32 bits)
const negResult = negative >>> 1; // Binary: 01...1101 (32 bits)

console.log(negResult); // 2147483643 (large positive number)
```

## Bitwise Assignment Operators

JavaScript also provides bitwise assignment operators that combine bitwise operations with assignment:

```javascript
let a = 5;

a &= 3; // Same as: a = a & 3;  (a becomes 1)
a |= 6; // Same as: a = a | 6;  (a becomes 7)
a ^= 2; // Same as: a = a ^ 2;  (a becomes 5)
a <<= 2; // Same as: a = a << 2; (a becomes 20)
a >>= 1; // Same as: a = a >> 1; (a becomes 10)
a >>>= 1; // Same as: a = a >>> 1; (a becomes 5)
```

## Common Use Cases for Bitwise Operators

### 1. Flag Management (Bitmasks)

Bitwise operators are excellent for managing multiple boolean flags efficiently:

```javascript
// Define flags using powers of 2
const READ = 1; // 0001
const WRITE = 2; // 0010
const EXECUTE = 4; // 0100
const DELETE = 8; // 1000

// Combining permissions
let userPermissions = READ | WRITE; // 0011 (3)

// Checking permissions
function hasPermission(permissions, flag) {
  return (permissions & flag) !== 0;
}

console.log(hasPermission(userPermissions, READ)); // true
console.log(hasPermission(userPermissions, EXECUTE)); // false

// Adding a permission
userPermissions |= EXECUTE; // Add EXECUTE permission (now 7)
console.log(hasPermission(userPermissions, EXECUTE)); // true

// Removing a permission
userPermissions &= ~WRITE; // Remove WRITE permission (now 5)
console.log(hasPermission(userPermissions, WRITE)); // false

// Toggling a permission
userPermissions ^= READ; // Toggle READ permission (now 4)
console.log(hasPermission(userPermissions, READ)); // false
```

### 2. Color Manipulation

Bitwise operations can manipulate RGB colors efficiently:

```javascript
// Extract RGB components from a color number
function getRGB(color) {
  const r = (color >> 16) & 0xff;
  const g = (color >> 8) & 0xff;
  const b = color & 0xff;
  return { r, g, b };
}

// Create color from RGB components
function createRGB(r, g, b) {
  return (r << 16) | (g << 8) | b;
}

const purple = 0x800080; // RGB: (128, 0, 128)
const components = getRGB(purple);
console.log(components); // { r: 128, g: 0, b: 128 }

const recreated = createRGB(128, 0, 128);
console.log(recreated.toString(16)); // "800080"
```

### 3. Fast Integer Math Operations

Bitwise operators can perform certain mathematical operations faster:

```javascript
// Fast multiplication by powers of 2
const num = 10;
const times2 = num << 1; // 20
const times4 = num << 2; // 40
const times8 = num << 3; // 80

// Fast division by powers of 2
const divide2 = num >> 1; // 5
const divide4 = num >> 2; // 2
const divide8 = num >> 3; // 1

// Fast modulo for powers of 2
function fastModulo(n, d) {
  return n & (d - 1); // Works when d is a power of 2
}

console.log(fastModulo(27, 8)); // 3 (27 % 8)
console.log(27 % 8); // 3 (same result)
```

### 4. Checking Even/Odd Numbers

A quick way to check if a number is even or odd:

```javascript
function isEven(num) {
  return (num & 1) === 0;
}

function isOdd(num) {
  return (num & 1) === 1;
}

console.log(isEven(4)); // true
console.log(isEven(7)); // false
console.log(isOdd(9)); // true
```

### 5. Swapping Values Without a Temporary Variable

Using XOR to swap two values:

```javascript
let x = 10;
let y = 20;

// Swap values using XOR
x = x ^ y;
y = x ^ y;
x = x ^ y;

console.log(x, y); // 20, 10

// How it works:
// 1. x = x ^ y   (x now holds x ^ y)
// 2. y = x ^ y   (y now holds (x ^ y) ^ y = x)
// 3. x = x ^ y   (x now holds (x ^ y) ^ x = y)
```

## Performance Considerations

While bitwise operators can be elegant solutions for certain problems, there are some considerations:

1. **Readability**: Bitwise operations can be harder to understand and maintain.
2. **Numbers are converted to 32-bit integers**: JavaScript stores numbers as 64-bit float, but bitwise operations work on 32-bit integers.
3. **Modern JavaScript engines**: The performance advantage of bitwise tricks may be less significant with optimized JavaScript engines.

```javascript
// Numbers are truncated to 32 bits for bitwise operations
const bigNum = 2147483648; // 2^31
console.log((bigNum << 1).toString(2)); // "0" (overflow)

// Decimal parts are truncated
console.log(10.5 << 1); // 20 (not 21)
```

## Best Practices

1. **Use bitwise operators when appropriate**: Flags, permissions, and low-level operations.
2. **Comment your bitwise operations**: Explain the logic for better maintainability.
3. **Use binary literals for clarity**:

```javascript
// Using binary literals (ES6)
const READ = 0b0001;
const WRITE = 0b0010;
const permissions = 0b1010; // More readable than 10
```

4. **Consider using named constants**: Improve readability by naming your bit flags.
5. **Be cautious with negative numbers**: They use two's complement representation, which can be confusing.

## Binary Bitwise Operations Visualization

Here's a visualization of how bitwise operations work with 8-bit numbers:

```
  Bitwise AND (&)        Bitwise OR (|)         Bitwise XOR (^)

  10101010              10101010               10101010
& 11001100            | 11001100             ^ 11001100
  --------              --------               --------
  10001000              11101110               01100110


  Bitwise NOT (~)       Left Shift (<<)        Right Shift (>>)

  10101010              10101010               10101010
  --------              << 2                   >> 2
  01010101              10101000               00101010
```

## Exercises

1. Write a function that uses bitwise operators to determine if a number is a power of 2.
2. Create a color mixer function that takes two colors and creates a new color by averaging their RGB components.
3. Implement a bit field to store information about a game character's abilities using flags.
4. Write a function to count the number of set (1) bits in a number.
5. Use bitwise operators to convert between uppercase and lowercase letters.

## Resources

- [MDN Web Docs: Bitwise Operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators)
- [JavaScript.info: Bitwise Operators](https://javascript.info/operators#bitwise-operators)
- [Computer Hope: Binary Tutorial](https://www.computerhope.com/jargon/b/binary.htm)
