# Comparison Operators in JavaScript

Comparison operators are used to compare values and return a Boolean result (`true` or `false`). JavaScript provides various comparison operators for different types of value comparisons, including equality checks, inequality checks, and relative comparisons.

## Equality Operators

JavaScript has two sets of equality operators: loose equality and strict equality.

### Loose Equality (== and !=)

Loose equality operators compare values after attempting to convert them to a common type, which can lead to unexpected results:

```javascript
// Equal to (==)
console.log(5 == 5); // true
console.log(5 == "5"); // true (string "5" is converted to number 5)
console.log(true == 1); // true (boolean true is converted to number 1)
console.log(null == undefined); // true (special case in JavaScript)
console.log(0 == false); // true (boolean false is converted to number 0)
console.log(0 == ""); // true (empty string is converted to number 0)

// Not equal to (!=)
console.log(5 != 10); // true
console.log("5" != 5); // false (after conversion they're equal)
console.log(true != 0); // true
```

### Strict Equality (=== and !==)

Strict equality operators compare both value and type without conversion, providing more predictable results:

```javascript
// Strictly equal to (===)
console.log(5 === 5); // true
console.log(5 === "5"); // false (different types: number vs string)
console.log(true === 1); // false (different types: boolean vs number)
console.log(null === undefined); // false (different types)
console.log(0 === false); // false (different types: number vs boolean)

// Strictly not equal to (!==)
console.log(5 !== 10); // true
console.log("5" !== 5); // true (different types)
console.log(true !== 1); // true
```

## Relational Operators

Relational operators compare the relationship between two values:

```javascript
// Greater than (>)
console.log(10 > 5); // true
console.log(10 > 10); // false
console.log(10 > "5"); // true (string "5" is converted to number 5)

// Less than (<)
console.log(5 < 10); // true
console.log(10 < 10); // false
console.log("5" < 10); // true (string "5" is converted to number 5)

// Greater than or equal to (>=)
console.log(10 >= 10); // true
console.log(10 >= 5); // true
console.log(5 >= 10); // false

// Less than or equal to (<=)
console.log(5 <= 10); // true
console.log(10 <= 10); // true
console.log(10 <= 5); // false
```

## Type Conversion in Comparisons

When comparing values of different types, JavaScript often converts them to numbers first:

```javascript
// String to number conversion
console.log("10" > 5); // true (string "10" becomes number 10)
console.log("10" < 20); // true
console.log("10" == 10); // true

// Boolean to number conversion
console.log(true > 0); // true (true becomes 1)
console.log(false < 1); // true (false becomes 0)

// Null and undefined
console.log(null == 0); // false (special case)
console.log(null >= 0); // true (null becomes 0)
console.log(undefined == 0); // false
console.log(undefined >= 0); // false (undefined becomes NaN)
```

### Special Comparisons

```javascript
// NaN comparisons
console.log(NaN == NaN); // false (NaN is not equal to anything, including itself)
console.log(NaN === NaN); // false
console.log(NaN != NaN); // true
console.log(NaN !== NaN); // true

// Proper way to check for NaN
console.log(isNaN(NaN)); // true
console.log(Number.isNaN(NaN)); // true

// Infinity comparisons
console.log(Infinity > 1000000); // true
console.log(-Infinity < -1000000); // true
console.log(Infinity > Infinity); // false
console.log(Infinity >= Infinity); // true
```

## String Comparisons

String comparison is based on lexicographical (dictionary) order, comparing character by character:

```javascript
console.log("apple" < "banana"); // true (a comes before b)
console.log("apple" < "Apple"); // false (uppercase letters come before lowercase in ASCII)
console.log("app" < "apple"); // true (shorter string that matches is "less than")
console.log("2" > "12"); // true (first character '2' is greater than '1')

// For case-insensitive comparison
console.log("Apple".toLowerCase() === "apple".toLowerCase()); // true
```

## Object Comparisons

When comparing objects, equality operators check for reference equality, not structural equality:

```javascript
const obj1 = { name: "John" };
const obj2 = { name: "John" };
const obj3 = obj1;

console.log(obj1 == obj2); // false (different objects in memory)
console.log(obj1 === obj2); // false (different objects in memory)
console.log(obj1 == obj3); // true (same reference)
console.log(obj1 === obj3); // true (same reference)
```

### Array Comparisons

Arrays, being objects, follow the same reference comparison rules:

```javascript
const arr1 = [1, 2, 3];
const arr2 = [1, 2, 3];
const arr3 = arr1;

console.log(arr1 == arr2); // false (different arrays in memory)
console.log(arr1 === arr2); // false (different arrays in memory)
console.log(arr1 == arr3); // true (same reference)
console.log(arr1 === arr3); // true (same reference)

// To compare array contents
console.log(JSON.stringify(arr1) === JSON.stringify(arr2)); // true
// Or
console.log(arr1.toString() === arr2.toString()); // true for simple arrays
```

## Deep Comparison of Objects

For structural equality of objects, you need custom comparison or helper libraries:

```javascript
// Simple deep equality function (limited)
function deepEqual(obj1, obj2) {
  if (obj1 === obj2) return true;

  if (
    typeof obj1 !== "object" ||
    obj1 === null ||
    typeof obj2 !== "object" ||
    obj2 === null
  ) {
    return false;
  }

  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);

  if (keys1.length !== keys2.length) return false;

  return keys1.every(
    (key) => keys2.includes(key) && deepEqual(obj1[key], obj2[key])
  );
}

const objA = { a: 1, b: { c: 2 } };
const objB = { a: 1, b: { c: 2 } };
const objC = { a: 1, b: { c: 3 } };

console.log(deepEqual(objA, objB)); // true
console.log(deepEqual(objA, objC)); // false
```

## The Object.is() Method

ES6 introduced `Object.is()` which behaves similarly to `===` but with better handling of special cases:

```javascript
console.log(Object.is(5, 5)); // true
console.log(Object.is(5, "5")); // false

// Special cases better handled by Object.is
console.log(Object.is(0, -0)); // false (=== would return true)
console.log(Object.is(NaN, NaN)); // true (=== would return false)
```

## Comparison in Control Structures

Comparisons are commonly used in control structures to make decisions:

```javascript
// In if statements
const age = 20;
if (age >= 18) {
  console.log("Adult");
} else {
  console.log("Minor");
}

// In ternary operators
const status = age >= 18 ? "Adult" : "Minor";

// In switch statements (uses strict equality)
switch (age) {
  case 18:
    console.log("Just turned 18");
    break;
  case 21:
    console.log("Just turned 21");
    break;
  default:
    console.log("Other age");
}

// In loops
for (let i = 0; i < 5; i++) {
  console.log(i);
}
```

## Best Practices for Comparisons

1. **Use strict equality (=== and !==) by default**

   This avoids unexpected type conversions and makes your code more predictable:

   ```javascript
   // Good
   if (userId === 123) {
     /* ... */
   }

   // Potentially problematic
   if (userId == 123) {
     /* ... */
   } // Works with userId = "123" (string)
   ```

2. **Be careful when comparing floating point numbers**

   Due to IEEE 754 floating point representation, direct equality might not work as expected:

   ```javascript
   console.log(0.1 + 0.2 === 0.3); // false! (0.1 + 0.2 is actually 0.30000000000000004)

   // Better approach: use a small epsilon value
   function areNumbersEqual(a, b, epsilon = 0.0001) {
     return Math.abs(a - b) < epsilon;
   }

   console.log(areNumbersEqual(0.1 + 0.2, 0.3)); // true
   ```

3. **Use appropriate methods for special value checks**

   ```javascript
   // Checking for NaN
   if (Number.isNaN(value)) {
     /* ... */
   }

   // Checking for null or undefined
   if (value == null) {
     /* ... */
   } // Checks for both null and undefined

   // Or more explicitly
   if (value === null || value === undefined) {
     /* ... */
   }
   ```

4. **Be explicit about type conversions**

   ```javascript
   // Instead of relying on implicit conversion
   if (userId == 123) {
     /* ... */
   }

   // Be explicit
   if (Number(userId) === 123) {
     /* ... */
   }
   ```

5. **Use appropriate methods for structural comparisons**

   ```javascript
   // For arrays
   const arraysEqual = JSON.stringify(arr1) === JSON.stringify(arr2);

   // For simple objects
   const objectsEqual = JSON.stringify(obj1) === JSON.stringify(obj2);

   // Note: This approach has limitations for complex objects, functions, circular references
   ```

## Common Comparison Patterns

### Safe Null/Undefined Checks

```javascript
// Check if value exists (not null or undefined)
if (value != null) {
  // Safe to use value
}

// Modern approach with nullish coalescing
const safeValue = value ?? defaultValue;
```

### Type-Safe Equality Check

```javascript
function safeEqual(a, b) {
  // Return false if types are different
  if (typeof a !== typeof b) return false;

  // Handle NaN case
  if (Number.isNaN(a) && Number.isNaN(b)) return true;

  // Otherwise use strict equality
  return a === b;
}
```

### Range Check

```javascript
function isInRange(value, min, max) {
  return value >= min && value <= max;
}

console.log(isInRange(15, 10, 20)); // true
console.log(isInRange(5, 10, 20)); // false
```

### String Comparison Helper

```javascript
// Case-insensitive comparison
function equalsIgnoreCase(str1, str2) {
  return str1.toLowerCase() === str2.toLowerCase();
}

console.log(equalsIgnoreCase("Hello", "hello")); // true
```

## Common Pitfalls to Avoid

### 1. Confusion Between == and ===

```javascript
// Example where loose equality can cause bugs
function processValue(value) {
  // Bug: this condition is true when value is 0, "", false, etc.
  if (value == null) {
    return "No value provided";
  }

  // Fix: use strict equality to check specifically for null
  if (value === null || value === undefined) {
    return "No value provided";
  }
}
```

### 2. Using == null

One acceptable use of loose equality is checking for both `null` and `undefined`:

```javascript
// This is a common pattern and is actually okay
if (value == null) {
  // This runs if value is null or undefined
}

// Equivalent to
if (value === null || value === undefined) {
  // Same behavior, but more verbose
}
```

### 3. NaN Comparison Errors

```javascript
// Wrong way to check for NaN
if (value === NaN) {
  /* Never true */
}

// Correct ways to check for NaN
if (isNaN(value)) {
  /* Be careful, this has issues with strings */
}
if (Number.isNaN(value)) {
  /* Preferred method - true only for actual NaN */
}
```

### 4. Comparing Objects by Value

```javascript
// Incorrect: comparing objects by reference when value comparison is needed
if (userObj1 === userObj2) {
  /* Only true if same reference */
}

// Better for simple objects:
if (JSON.stringify(userObj1) === JSON.stringify(userObj2)) {
  /* Compares structure */
}
```

## Exercises

1. Write a function that compares two arrays for equality, accounting for nested arrays.
2. Create a function that safely compares two values regardless of their types.
3. Implement a version check function that determines if a given version is greater than, equal to, or less than another version.
4. Write a function that checks if an object is a subset of another object.

## Resources

- [MDN: Comparison Operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators)
- [JavaScript.info: Comparisons](https://javascript.info/comparison)
- [Equality Comparisons and Sameness](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Equality_comparisons_and_sameness)
