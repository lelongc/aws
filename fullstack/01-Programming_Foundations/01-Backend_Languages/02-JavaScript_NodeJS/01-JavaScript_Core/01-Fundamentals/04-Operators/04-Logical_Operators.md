# Logical Operators in JavaScript

Logical operators are used to determine the logic between variables or values and return a Boolean result. However, in JavaScript, logical operators have some unique behaviors beyond simple Boolean logic, making them powerful tools for control flow and value assignment.

## Basic Logical Operators

### Logical AND (&&)

The logical AND operator (`&&`) returns `true` if both operands are `true`, otherwise it returns `false`:

```javascript
console.log(true && true); // true
console.log(true && false); // false
console.log(false && true); // false
console.log(false && false); // false
```

### Logical OR (||)

The logical OR operator (`||`) returns `true` if at least one operand is `true`, otherwise it returns `false`:

```javascript
console.log(true || true); // true
console.log(true || false); // true
console.log(false || true); // true
console.log(false || false); // false
```

### Logical NOT (!)

The logical NOT operator (`!`) returns `true` if the operand is `false`, and `false` if the operand is `true`:

```javascript
console.log(!true); // false
console.log(!false); // true
console.log(!!true); // true (double negation)
console.log(!!false); // false (double negation)
```

## Advanced Logical Operators

### Nullish Coalescing Operator (??)

The nullish coalescing operator (`??`) returns the right-hand operand when the left-hand operand is `null` or `undefined`, otherwise it returns the left-hand operand:

```javascript
let name = null;
console.log(name ?? "Guest"); // "Guest" (name is null)

let username = undefined;
console.log(username ?? "Anonymous"); // "Anonymous" (username is undefined)

let count = 0;
console.log(count ?? 42); // 0 (count is 0, which is not null or undefined)

let empty = "";
console.log(empty ?? "Not empty"); // "" (empty is "", which is not null or undefined)
```

### Logical Assignment Operators (ES2021)

JavaScript introduced logical assignment operators that combine logical operations with assignment:

#### Logical AND Assignment (&&=)

Assigns the right operand to the left operand only if the left operand is truthy:

```javascript
let x = 10;
x &&= 5; // Same as: if (x) x = 5;
console.log(x); // 5 (x was truthy, so assignment happened)

let y = 0;
y &&= 5; // No assignment happens because y is falsy
console.log(y); // 0 (unchanged)
```

#### Logical OR Assignment (||=)

Assigns the right operand to the left operand only if the left operand is falsy:

```javascript
let x = 0;
x ||= 5; // Same as: if (!x) x = 5;
console.log(x); // 5 (x was falsy, so assignment happened)

let y = 10;
y ||= 5; // No assignment happens because y is truthy
console.log(y); // 10 (unchanged)
```

#### Nullish Coalescing Assignment (??=)

Assigns the right operand to the left operand only if the left operand is `null` or `undefined`:

```javascript
let x = null;
x ??= 5; // Same as: if (x === null || x === undefined) x = 5;
console.log(x); // 5 (x was null, so assignment happened)

let y = 0;
y ??= 5; // No assignment happens because y is 0, not null/undefined
console.log(y); // 0 (unchanged)
```

## Short-Circuit Evaluation

A key feature of JavaScript's logical operators is that they "short-circuit" - they stop evaluating as soon as the result is determined.

### Short-Circuit with &&

The `&&` operator stops evaluating if the first operand is falsy, because the result must be false:

```javascript
console.log(false && expensiveOperation()); // false, expensiveOperation() not called

function expensiveOperation() {
  console.log("This is an expensive operation");
  return true;
}
```

### Short-Circuit with ||

The `||` operator stops evaluating if the first operand is truthy, because the result must be true:

```javascript
console.log(true || expensiveOperation()); // true, expensiveOperation() not called
```

### Short-Circuit with ??

The `??` operator short-circuits if the left operand is not `null` or `undefined`:

```javascript
console.log(0 ?? expensiveOperation()); // 0, expensiveOperation() not called
console.log(null ?? expensiveOperation()); // expensiveOperation() is called
```

## Truthy and Falsy Values

When non-Boolean values are used with logical operators, JavaScript coerces them to Boolean values:

### Falsy Values

The following values are considered falsy:

- `false`
- `0` (zero)
- `-0` (negative zero)
- `0n` (BigInt zero)
- `''` or `""` (empty string)
- `null`
- `undefined`
- `NaN` (Not a Number)

### Truthy Values

Everything else is considered truthy, including:

- `true`
- Any non-zero number
- Non-empty strings
- All objects and arrays (even empty ones)
- Functions

```javascript
if (true && 1 && "hello" && [] && {}) {
  console.log("All these values are truthy");
}

if (false || 0 || "" || null || undefined) {
  // This won't execute because all values are falsy
} else {
  console.log("All these values are falsy");
}
```

## Return Values of Logical Operators

In JavaScript, logical operators don't just return Boolean values - they return the actual value of one of their operands:

### && Return Value

The `&&` operator returns the first falsy operand, or the last operand if all operands are truthy:

```javascript
console.log("hello" && "world"); // "world" (both are truthy, returns last operand)
console.log("hello" && ""); // "" (second operand is falsy, returns it)
console.log(0 && "world"); // 0 (first operand is falsy, returns it)
console.log({} && []); // [] (both are truthy, returns last operand)
```

### || Return Value

The `||` operator returns the first truthy operand, or the last operand if all operands are falsy:

```javascript
console.log("hello" || "world"); // "hello" (first operand is truthy, returns it)
console.log("" || "world"); // "world" (first operand is falsy, tries next)
console.log(0 || false); // false (both are falsy, returns last operand)
console.log(null || undefined || 0 || ""); // "" (all falsy, returns last)
```

### ?? Return Value

The `??` operator returns the first operand if it's not `null` or `undefined`, otherwise it returns the second operand:

```javascript
console.log("hello" ?? "world"); // "hello" (not null or undefined)
console.log(0 ?? 42); // 0 (not null or undefined)
console.log("" ?? "default"); // "" (not null or undefined)
console.log(null ?? "default"); // "default" (first operand is null)
console.log(undefined ?? {}); // {} (first operand is undefined)
```

## Common Use Patterns

### Default Values

#### Using || for Default Values (When Falsy Values Are Invalid)

```javascript
function greet(name) {
  name = name || "Guest"; // If name is falsy, use "Guest"
  return `Hello, ${name}!`;
}

console.log(greet("John")); // "Hello, John!"
console.log(greet("")); // "Hello, Guest!" (Empty string is falsy)
console.log(greet(0)); // "Hello, Guest!" (0 is falsy)
```

#### Using ?? for Default Values (Only When null/undefined)

```javascript
function greet(name) {
  name = name ?? "Guest"; // If name is null or undefined, use "Guest"
  return `Hello, ${name}!`;
}

console.log(greet("John")); // "Hello, John!"
console.log(greet("")); // "Hello, !" (Empty string is valid)
console.log(greet(0)); // "Hello, 0!" (0 is valid)
console.log(greet(null)); // "Hello, Guest!" (null triggers default)
```

### Conditional Execution

```javascript
// Only call a method if the object exists
user && user.save();

// Same as:
if (user) {
  user.save();
}
```

### Assigning Default Values

```javascript
// Using the OR operator
function createConfiguration(config) {
  config.timeout = config.timeout || 1000;
  config.retries = config.retries || 3;
  return config;
}

// Modern approach with nullish coalescing
function createConfiguration(config) {
  config.timeout = config.timeout ?? 1000;
  config.retries = config.retries ?? 3;
  return config;
}

// Even better with logical assignment operators
function createConfiguration(config) {
  config.timeout ??= 1000;
  config.retries ??= 3;
  return config;
}
```

### Early Returns

```javascript
function processData(data) {
  // Return early if data is invalid
  if (!data || !data.items || data.items.length === 0) {
    return { error: "Invalid data" };
  }

  // Process the data
  return { result: data.items.map((item) => item.value) };
}
```

### Chaining Logical Operations

```javascript
// Check multiple conditions
const isValid = hasName && hasEmail && !isBlocked;

// Check validation with early termination
const isValidUser =
  user && user.profile && user.profile.isActive && !user.isBanned;
```

## Logical Operators vs Control Flow

While logical operators can replace some control flow statements, they're not always the most readable solution:

```javascript
// Using logical operators for control flow
isAdmin && deleteAllRecords();

// More readable alternative
if (isAdmin) {
  deleteAllRecords();
}
```

## Operator Precedence

Logical operators have different precedence (order of evaluation):

1. `!` (Logical NOT)
2. `&&` (Logical AND)
3. `||` (Logical OR)
4. `??` (Nullish Coalescing)

```javascript
console.log(!true && false);         // false (evaluates to false && false)
console.log(true || false && false);  // true (&& is evaluated before ||)
console.log(null ?? false || true);   // false (|| is evaluated before ??)

// Use parentheses for clarity
console.log(null ?? (false || true)); // false (more explicit)
```

> **Note:** The nullish coalescing operator (`??`) cannot be directly combined with AND (`&&`) or OR (`||`) operators without parentheses due to syntax restrictions.

## Best Practices

1. **Use ?? Instead of || for Default Values When Appropriate**:

   ```javascript
   // Better for numerical values
   const count = userCount ?? 0;

   // Could be problematic if 0 is valid
   const count = userCount || 0;
   ```

2. **Add Parentheses for Clarity**:

   ```javascript
   // Less clear
   const result = (a && b) || (c && d);

   // More clear
   const result = (a && b) || (c && d);
   ```

3. **Avoid Overusing Logical Operators for Control Flow**:

   ```javascript
   // Harder to maintain
   isAdmin && hasPermission && !isReadOnly && editDocument();

   // Clearer, especially when debugging
   if (isAdmin && hasPermission && !isReadOnly) {
     editDocument();
   }
   ```

4. **Beware of Side Effects**:

   ```javascript
   // Problematic - counter is not incremented when result is truthy
   result || counter++;

   // Better - explicit if statement
   if (!result) {
     counter++;
   }
   ```

5. **Use Optional Chaining with Nullish Coalescing for Deep Property Access**:
   ```javascript
   // Safer nested property access with default
   const userCity = user?.address?.city ?? "Unknown";
   ```

## Exercises

1. Create a user validation function that performs multiple checks using logical operators.
2. Write a function that sets default configuration values using the nullish coalescing operator.
3. Convert a series of if-else statements to use logical operators for conciseness.
4. Implement a safe property access function that uses logical operators to prevent errors.
5. Use logical operators to filter out invalid elements from an array.

## Resources

- [MDN Web Docs: Logical Operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_Operators)
- [MDN Web Docs: Nullish Coalescing Operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing_operator)
- [MDN Web Docs: Logical Assignment Operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_AND_assignment)
- [JavaScript.info: Logical operators](https://javascript.info/logical-operators)
