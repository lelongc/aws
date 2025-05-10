# Assignment Operators in JavaScript

Assignment operators in JavaScript assign values to variables. They range from the basic assignment operator (`=`) to compound assignment operators that combine an operation with assignment, to the newer logical assignment operators introduced in recent JavaScript versions.

## Basic Assignment Operator (=)

The basic assignment operator assigns the value of the right operand to the left operand:

```javascript
let x = 10; // Assigns the value 10 to variable x
let y = x; // Assigns the value of x to variable y
let z = x + y; // Assigns the result of x + y to variable z

// Multiple assignments in a single statement
let a, b, c;
a = b = c = 5; // All variables are assigned the value 5
```

### Assignment with Variables Declaration

Assignment can be combined with variable declaration:

```javascript
// With var
var firstName = "John";

// With let
let lastName = "Doe";

// With const (must be initialized at declaration)
const age = 30;
```

### Assignment Return Value

The assignment operator returns the assigned value, which allows for chaining:

```javascript
let x;
let y = (x = 10); // x is assigned 10, then y is assigned the result (10)

console.log(x); // 10
console.log(y); // 10
```

## Compound Assignment Operators

Compound assignment operators combine an arithmetic, bitwise, or logical operation with assignment.

### Arithmetic Compound Assignments

```javascript
let x = 10;

x += 5; // Same as: x = x + 5     (x is now 15)
x -= 3; // Same as: x = x - 3     (x is now 12)
x *= 2; // Same as: x = x * 2     (x is now 24)
x /= 4; // Same as: x = x / 4     (x is now 6)
x %= 4; // Same as: x = x % 4     (x is now 2)
x **= 3; // Same as: x = x ** 3    (x is now 8) (ES2016)
```

### Bitwise Compound Assignments

```javascript
let x = 5; // 101 in binary

x &= 3; // Same as: x = x & 3     (x is now 1) (101 & 011 = 001)
x |= 6; // Same as: x = x | 6     (x is now 7) (001 | 110 = 111)
x ^= 3; // Same as: x = x ^ 3     (x is now 4) (111 ^ 011 = 100)
x <<= 2; // Same as: x = x << 2    (x is now 16) (100 << 2 = 10000)
x >>= 1; // Same as: x = x >> 1    (x is now 8) (10000 >> 1 = 1000)
x >>>= 1; // Same as: x = x >>> 1   (x is now 4) (1000 >>> 1 = 100)
```

### Logical Assignment Operators (ES2021)

Logical assignment operators were introduced in ES2021 and combine logical operations with assignment:

```javascript
// Logical AND assignment (&&=)
// Assigns RHS only if LHS is truthy
let x = 10;
x &&= 5; // Same as: x = x && 5    (x is now 5)

let y = 0;
y &&= 5; // y remains 0 because 0 is falsy

// Logical OR assignment (||=)
// Assigns RHS only if LHS is falsy
let a = 0;
a ||= 5; // Same as: a = a || 5    (a is now 5)

let b = 10;
b ||= 5; // b remains 10 because 10 is truthy

// Nullish coalescing assignment (??=)
// Assigns RHS only if LHS is null or undefined
let p = null;
p ??= 10; // Same as: p = p ?? 10   (p is now 10)

let q = 0;
q ??= 10; // q remains 0 because 0 is not null or undefined
```

## Destructuring Assignment

Destructuring assignment is a powerful feature that allows you to extract values from arrays or properties from objects and assign them to variables in a concise way.

### Array Destructuring

```javascript
// Basic array destructuring
const numbers = [1, 2, 3];
const [a, b, c] = numbers;

console.log(a); // 1
console.log(b); // 2
console.log(c); // 3

// Skip elements
const [x, , z] = numbers;
console.log(x); // 1
console.log(z); // 3

// Rest pattern
const [first, ...rest] = numbers;
console.log(first); // 1
console.log(rest); // [2, 3]

// Default values
const [p = 10, q = 20, r = 30, s = 40] = [1, 2];
console.log(p); // 1
console.log(q); // 2
console.log(r); // 30 (default)
console.log(s); // 40 (default)

// Swapping variables
let m = 5,
  n = 10;
[m, n] = [n, m];
console.log(m); // 10
console.log(n); // 5
```

### Object Destructuring

```javascript
// Basic object destructuring
const person = { name: "John", age: 30, city: "New York" };
const { name, age, city } = person;

console.log(name); // "John"
console.log(age); // 30
console.log(city); // "New York"

// Assign to different variable names
const { name: personName, age: personAge } = person;
console.log(personName); // "John"
console.log(personAge); // 30

// Default values
const { name: fullName, country = "USA" } = person;
console.log(fullName); // "John"
console.log(country); // "USA" (default)

// Nested destructuring
const user = {
  id: 1,
  details: {
    firstName: "Jane",
    lastName: "Doe",
  },
  roles: ["admin", "user"],
};

const {
  details: { firstName, lastName },
  roles: [primaryRole],
} = user;

console.log(firstName); // "Jane"
console.log(lastName); // "Doe"
console.log(primaryRole); // "admin"

// Rest in object destructuring
const { name: userName, ...userDetails } = person;
console.log(userName); // "John"
console.log(userDetails); // { age: 30, city: "New York" }
```

### Function Parameter Destructuring

```javascript
// Object parameter destructuring
function printUserInfo({ name, age, country = "Unknown" }) {
  console.log(`${name} is ${age} years old and from ${country}`);
}

printUserInfo({ name: "Alice", age: 25 });
// "Alice is 25 years old and from Unknown"

// Array parameter destructuring
function printCoordinates([x, y, z = 0]) {
  console.log(`Coordinates: ${x}, ${y}, ${z}`);
}

printCoordinates([10, 20]);
// "Coordinates: 10, 20, 0"
```

## Common Patterns and Use Cases

### Conditional Assignment

```javascript
// Assign a default value if variable is undefined
let username;
username = username || "Guest"; // Old way, has issues with falsy values

// Better approach with nullish coalescing
let displayName = username ?? "Guest"; // Only assigns 'Guest' if username is null/undefined
```

### Object Property Shorthand

```javascript
const name = "John";
const age = 30;

// Instead of
const person1 = { name: name, age: age };

// You can use shorthand
const person2 = { name, age };
```

### Copy and Update Objects (Immutable Update Pattern)

```javascript
const user = { id: 1, name: "John", age: 30 };

// Create a new object with all properties from user but update age
const updatedUser = { ...user, age: 31 };

console.log(user.age); // 30 (original unchanged)
console.log(updatedUser.age); // 31
```

### Dynamic Property Assignment

```javascript
const propertyName = "color";
const propertyValue = "blue";

// Create an object with a dynamic property name
const item = {
  [propertyName]: propertyValue, // Creates property "color": "blue"
};

console.log(item.color); // "blue"
```

### Multiple Updates in a Single Statement

```javascript
// Using compound assignment operators
function adjustPosition(element, dx, dy) {
  element.x += dx;
  element.y += dy;
  return element;
}

// Using destructuring assignment
function moveShape(shape) {
  [shape.x, shape.y] = [shape.x + 10, shape.y + 20];
  return shape;
}
```

## Best Practices

### 1. Use const by Default

```javascript
// Use const for values that shouldn't be reassigned
const API_URL = "https://api.example.com";
const ITEMS_PER_PAGE = 20;

// Use let only when you need to reassign a variable
let currentPage = 1;
```

### 2. Avoid Global Assignments

```javascript
// Bad: Global variable
userName = "John"; // Implicit global (without var, let, const)

// Good: Properly scoped variables
const userName = "John";

// Better: Encapsulate in modules or functions
function getUserInfo() {
  const userName = "John";
  return { userName };
}
```

### 3. Prefer Destructuring for Multiple Assignments

```javascript
// Instead of
const name = user.name;
const email = user.email;
const role = user.role;

// Use destructuring
const { name, email, role } = user;
```

### 4. Use Logical Assignment Operators For Defaults

```javascript
// Set defaults with logical assignment operators
function updateOptions(options) {
  // Only assign if current value is nullish
  options.timeout ??= 2000;
  options.retries ??= 3;

  // Only assign if current value is falsy
  options.enabled ||= true;

  // Only update if current value exists and is truthy
  options.callback &&= wrapCallback(options.callback);

  return options;
}
```

### 5. Be Careful with Chained Assignments

```javascript
// This can be harder to read and maintain
a = b = c = d = 5;

// Consider separate assignments for clarity
a = 5;
b = 5;
c = 5;
d = 5;
```

### 6. Avoid Assignment in Conditional Statements

```javascript
// Problematic: Assignment in condition
if ((x = getValueFromSomewhere())) {
  // This always evaluates to the value of the assignment
  // which might not be what you expect
}

// Better: Separate assignment and condition
x = getValueFromSomewhere();
if (x) {
  // Now the condition is clearer
}
```

## Common Mistakes and Pitfalls

### 1. Assignment vs. Equality Comparison

```javascript
// Common mistake: Using = instead of === in conditions
if ((x = 10)) {
  // Assigns 10 to x, then evaluates to 10 (truthy)
  console.log("This always runs");
}

// Correct usage: Equality check
if (x === 10) {
  console.log("This runs only if x is 10");
}
```

### 2. Object Assignment is by Reference

```javascript
const original = { a: 1, b: 2 };
const copy = original; // Not a real copy, just a reference

copy.a = 5;
console.log(original.a); // 5 (original is modified too)

// To create a real copy:
const realCopy = { ...original };
// or
const deepCopy = JSON.parse(JSON.stringify(original));
```

### 3. Destructuring Undefined Objects

```javascript
// This will throw an error if user is undefined
const { name, age } = user;

// Safer approach
const { name, age } = user || {};
```

### 4. Confusion with Compound Assignment Operators

```javascript
let x = "5";
x += 5; // Results in "55" (string concatenation, not addition)

// To ensure numeric addition:
x = Number(x) + 5; // 10
```

## Exercises

1. Create a function that uses compound assignment operators to manipulate a counter.
2. Write code that uses object destructuring to extract user information from an API response.
3. Use array destructuring to swap the values of two variables.
4. Implement a function that uses logical assignment operators to set default configuration options.
5. Use dynamic property assignment to create a key-value store.

## Resources

- [MDN Web Docs: Assignment Operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Assignment_Operators)
- [MDN Web Docs: Destructuring Assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
- [JavaScript.info: Assignment](https://javascript.info/assignment)
- [Logical Assignment Operators](https://v8.dev/features/logical-assignment)
