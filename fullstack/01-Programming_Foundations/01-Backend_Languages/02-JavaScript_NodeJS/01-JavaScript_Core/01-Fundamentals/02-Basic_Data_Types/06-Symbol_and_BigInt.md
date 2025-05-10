# Symbol and BigInt in JavaScript

JavaScript introduced two relatively new primitive data types: Symbol (added in ES6/ES2015) and BigInt (added in ES2020). These types expand JavaScript's capabilities for creating unique identifiers and handling large integers.

## Symbol

Symbol is a primitive data type that represents a unique, immutable value that can be used as an identifier. Each Symbol value is guaranteed to be unique, even if they have the same description.

### Creating Symbols

```javascript
// Basic Symbol creation
const sym1 = Symbol();
const sym2 = Symbol();

console.log(sym1 === sym2); // false - each Symbol is unique

// Symbol with description (for debugging)
const errorSymbol = Symbol("error");
const warningSymbol = Symbol("warning");

console.log(errorSymbol.toString()); // "Symbol(error)"
console.log(errorSymbol === Symbol("error")); // false - still unique
```

### Use Cases for Symbols

#### 1. Unique Property Keys

Symbols are often used as unique property keys in objects to avoid name collisions:

```javascript
const id = Symbol("id");
const user = {
  name: "John",
  age: 30,
  [id]: 12345, // Using a Symbol as a property key
};

console.log(user.name); // "John"
console.log(user[id]); // 12345

// Symbols are not enumerated in for...in loops
for (let key in user) {
  console.log(key); // Only "name" and "age" will be logged
}

// Symbols are also not included in Object.keys()
console.log(Object.keys(user)); // ["name", "age"]

// To get Symbol properties:
console.log(Object.getOwnPropertySymbols(user)); // [Symbol(id)]
```

#### 2. Preventing Property Name Conflicts

Symbols help avoid naming conflicts when adding properties to objects you don't control:

```javascript
// Library code
const library = {
  name: "Cool Library",
  addMethod(object) {
    // Using a Symbol ensures we don't override existing properties
    const uniqueMethod = Symbol("calculate");
    object[uniqueMethod] = function () {
      return "result from library";
    };
    return uniqueMethod; // Return the Symbol so it can be used
  },
};

// User code
const myObject = {
  calculate() {
    return "my own calculation";
  },
};

const libraryMethod = library.addMethod(myObject);
console.log(myObject.calculate()); // "my own calculation"
console.log(myObject[libraryMethod]()); // "result from library"
```

#### 3. Well-Known Symbols

JavaScript has built-in Symbols called "well-known Symbols" that let you customize language behaviors:

```javascript
// Customize object iteration behavior with Symbol.iterator
const collection = {
  items: ["A", "B", "C"],
  [Symbol.iterator]() {
    let index = 0;
    const items = this.items;

    return {
      next() {
        return {
          done: index >= items.length,
          value: items[index++],
        };
      },
    };
  },
};

// Now the object can be used with for...of
for (const item of collection) {
  console.log(item); // "A", "B", "C"
}

// Custom string conversion with Symbol.toPrimitive
const specialNumber = {
  value: 42,
  [Symbol.toPrimitive](hint) {
    if (hint === "number") {
      return this.value;
    }
    if (hint === "string") {
      return `The number is ${this.value}`;
    }
    return this.value; // Default
  },
};

console.log(+specialNumber); // 42
console.log(`${specialNumber}`); // "The number is 42"
console.log(specialNumber + 8); // 50
```

### Symbol Registry

JavaScript maintains a global Symbol registry that allows you to create Symbols that can be shared across different parts of your code:

```javascript
// Create or retrieve a Symbol from the global registry
const globalId = Symbol.for("userId");
const sameId = Symbol.for("userId");

console.log(globalId === sameId); // true - same Symbol retrieved from registry

// Get the key used to register a Symbol
console.log(Symbol.keyFor(globalId)); // "userId"

// Regular Symbols aren't registered
const localSymbol = Symbol("local");
console.log(Symbol.keyFor(localSymbol)); // undefined
```

### Symbol Properties and Methods

```javascript
const sym = Symbol("description");

// Properties
console.log(sym.description); // "description"

// Methods
console.log(sym.toString()); // "Symbol(description)"
```

## BigInt

BigInt is a primitive data type that can represent integers of arbitrary precision, beyond the safe integer limit of the Number type.

### Creating BigInt Values

```javascript
// Create BigInts using the 'n' suffix
const bigInt1 = 1234567890123456789012345n;
const bigInt2 = BigInt("9007199254740991");

// Convert from Number to BigInt
const bigInt3 = BigInt(123); // 123n
```

### Why BigInt Is Needed

JavaScript's Number type can only safely represent integers between -(2^53 - 1) and (2^53 - 1):

```javascript
const maxSafeInteger = Number.MAX_SAFE_INTEGER;
console.log(maxSafeInteger); // 9007199254740991

// Going beyond safe integers with Number type
console.log(maxSafeInteger + 1); // 9007199254740992
console.log(maxSafeInteger + 2); // 9007199254740992 (same as +1, precision lost!)

// Using BigInt instead
console.log(BigInt(maxSafeInteger) + 1n); // 9007199254740992n
console.log(BigInt(maxSafeInteger) + 2n); // 9007199254740993n (correct!)
```

### BigInt Operations

BigInt supports most of the same operations as Number:

```javascript
// Arithmetic operations
console.log(10n + 5n); // 15n
console.log(10n - 5n); // 5n
console.log(10n * 5n); // 50n
console.log(10n / 3n); // 3n (integer division, truncates)
console.log(10n % 3n); // 1n (remainder)
console.log(10n ** 3n); // 1000n (exponentiation)

// Increment/decrement
let counter = 0n;
counter++; // 1n
counter--; // 0n

// Bitwise operations
console.log(16n | 4n); // 20n
console.log(16n & 4n); // 0n
console.log(16n ^ 4n); // 20n
console.log(16n << 1n); // 32n
console.log(16n >> 1n); // 8n

// Comparisons
console.log(10n > 5n); // true
console.log(10n === 10); // false (different types)
console.log(10n == 10); // true (loose equality allows comparison)
```

### Limitations of BigInt

BigInt has some limitations compared to Number:

```javascript
// Cannot mix BigInt and Number in operations
// 10n + 5  // TypeError: Cannot mix BigInt and other types

// Explicit conversion required
console.log(10n + BigInt(5)); // 15n
console.log(Number(10n) + 5); // 15

// No support for Math object methods
// Math.sqrt(4n)  // TypeError: Cannot convert a BigInt value to a number

// Cannot use with unary plus operator
// +10n  // TypeError: Cannot convert a BigInt value to a number

// Decimal points are truncated
console.log(BigInt(10.5)); // 10n (decimal part is truncated)
```

### Use Cases for BigInt

1. **Financial calculations** with precision requirements beyond what Number allows

```javascript
// Representing large monetary values in cents to avoid floating point issues
const accountBalance = 9007199254740993n; // One more than MAX_SAFE_INTEGER
const transaction = 1000000000000n;
const newBalance = accountBalance + transaction;
```

2. **High-precision timestamps**

```javascript
// Representing nanosecond-precision timestamps
const timestampNanoseconds = 1624349876123456789n;
```

3. **Working with large IDs**

```javascript
// For database IDs beyond JavaScript's safe integer range
const recordId = 9007199254740993n;
```

4. **Cryptographic applications**

```javascript
// For large numbers in cryptography
const largePrime = 853973422267228707n;
```

### Converting Between BigInt and Other Types

```javascript
// BigInt to Number (caution: may lose precision)
const bigValue = 123456789012345678901234n;
console.log(Number(bigValue)); // 1.2345678901234568e+23 (precision lost)

// BigInt to String
console.log(String(123n)); // "123"
console.log(123n.toString()); // "123"

// String to BigInt
console.log(BigInt("123456789012345678901234"));

// Boolean to/from BigInt
console.log(Boolean(0n)); // false (only 0n is falsy)
console.log(Boolean(1n)); // true
console.log(BigInt(true)); // 1n
console.log(BigInt(false)); // 0n
```

## Symbol vs. BigInt Comparison

| Feature               | Symbol                           | BigInt                               |
| --------------------- | -------------------------------- | ------------------------------------ |
| Purpose               | Creating unique identifiers      | Representing large integers          |
| Creation              | `Symbol()` or `Symbol.for()`     | Literal `123n` or `BigInt()`         |
| Arithmetic operations | Not supported                    | Supported (except mixed with Number) |
| Equality              | Only identical Symbols are equal | Values can be equal                  |
| Conversion to string  | Needs explicit `.toString()`     | Automatic in most contexts           |
| Primitive type        | Yes                              | Yes                                  |
| Introduction          | ES2015 (ES6)                     | ES2020                               |

## Best Practices

### For Symbol

1. **Use for private or meta properties**:

   ```javascript
   const _privateData = Symbol("privateData");
   class User {
     constructor(name) {
       this[_privateData] = { createdAt: Date.now() };
       this.name = name;
     }
   }
   ```

2. **Create semantic constants**:

   ```javascript
   const STATUS = {
     PENDING: Symbol("pending"),
     APPROVED: Symbol("approved"),
     REJECTED: Symbol("rejected"),
   };
   ```

3. **Avoid overusing the global registry**:
   ```javascript
   // Only use Symbol.for() when truly needed across modules
   const appSymbols = {
     config: Symbol("config"), // Local
     userId: Symbol.for("app.userId"), // Shared globally
   };
   ```

### For BigInt

1. **Be explicit with type conversions**:

   ```javascript
   // Make conversions clear
   const result = Number(bigIntValue) + regularNumber;
   ```

2. **Use for precise integer arithmetic beyond safe integers**:

   ```javascript
   if (value > Number.MAX_SAFE_INTEGER) {
     return BigInt(value);
   }
   ```

3. **Watch for performance**:
   ```javascript
   // BigInt operations can be slower than regular number operations
   // Use only when needed for large values
   ```

## Exercises

1. Create a system that uses Symbols to define and apply mixins to objects.
2. Implement a custom iterable using Symbol.iterator.
3. Write a function that uses BigInt to calculate the factorial of large numbers.
4. Create a simple bigint-based calculator for large integers.
5. Compare the performance of regular numbers vs BigInt for various operations.

## Resources

- [MDN Web Docs: Symbol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
- [MDN Web Docs: BigInt](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt)
- [JavaScript.info: Symbol type](https://javascript.info/symbol)
- [JavaScript.info: BigInt](https://javascript.info/bigint)
