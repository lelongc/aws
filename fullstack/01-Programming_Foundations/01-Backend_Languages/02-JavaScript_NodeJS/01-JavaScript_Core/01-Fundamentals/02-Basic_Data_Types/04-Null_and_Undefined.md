# Null and Undefined in JavaScript

JavaScript has two special values that represent the absence of a meaningful value: `null` and `undefined`. While they might seem similar at first, they have distinct meanings and uses in JavaScript code.

## Understanding Undefined

`undefined` is a primitive value automatically assigned in specific situations when no value is assigned.

### When Values are Undefined

A value becomes `undefined` in these scenarios:

1. **Variables that are declared but not initialized**:

   ```javascript
   let username;
   console.log(username); // undefined
   ```

2. **Accessing non-existent object properties**:

   ```javascript
   const user = { name: "John" };
   console.log(user.age); // undefined
   ```

3. **Function parameters that aren't provided**:

   ```javascript
   function greet(name) {
     console.log(name); // undefined if not provided
   }
   greet(); // logs undefined
   ```

4. **Function without a return statement**:

   ```javascript
   function doSomething() {
     // no return statement
   }
   const result = doSomething();
   console.log(result); // undefined
   ```

5. **Accessing array elements beyond array bounds**:
   ```javascript
   const arr = [1, 2, 3];
   console.log(arr[5]); // undefined
   ```

### The undefined Type

`undefined` is also a type in JavaScript:

```javascript
let x;
console.log(typeof x); // "undefined"

// The global undefined value
console.log(typeof undefined); // "undefined"
```

## Understanding Null

`null` is a primitive value that represents the intentional absence of any object value. Unlike `undefined`, `null` must be explicitly assigned.

```javascript
let user = null;
console.log(user); // null

// Reset an object reference
let customer = { name: "Alice" };
customer = null; // No longer references the object
```

### The null Type

Interestingly, `null` has a type of `object` (this is considered a historical bug in JavaScript):

```javascript
console.log(typeof null); // "object"
```

The correct way to check for null:

```javascript
console.log(myVar === null); // true if myVar is null
```

## Key Differences Between null and undefined

1. **Assignment**:

   - `undefined` is automatically assigned by JavaScript
   - `null` is explicitly assigned by developers

2. **Type**:

   - `typeof undefined` is `"undefined"`
   - `typeof null` is `"object"` (a known JavaScript quirk)

3. **Equality comparisons**:

   ```javascript
   console.log(null == undefined); // true (loose equality)
   console.log(null === undefined); // false (strict equality)
   ```

4. **Use cases**:

   - `undefined` typically represents values that haven't been set
   - `null` typically represents intentionally missing object references

5. **Mathematical operations**:
   ```javascript
   console.log(undefined + 1); // NaN
   console.log(null + 1); // 1 (null converts to 0)
   ```

## Checking for null and undefined

### Single Value Check

```javascript
// Check for undefined
if (variable === undefined) {
  // Variable is undefined
}

// Check for null
if (variable === null) {
  // Variable is null
}

// Check for either null or undefined
if (variable == null) {
  // Variable is null or undefined (loose equality)
}
```

### Nullish Coalescing Operator (??)

The nullish coalescing operator (introduced in ES2020) provides a concise way to handle null and undefined:

```javascript
// Returns the right-hand operand when the left is null or undefined
const username = inputValue ?? "Guest";

// Different from logical OR
const count = 0;
const score = count || 10; // score = 10 (0 is falsy)
const points = count ?? 10; // points = 0 (0 is not null/undefined)
```

### Optional Chaining (?.)

Optional chaining (ES2020) provides a safe way to access nested properties:

```javascript
const user = {
  profile: null,
};

// Without optional chaining (can cause error):
// const bio = user.profile.bio; // TypeError: Cannot read property 'bio' of null

// With optional chaining (safe):
const bio = user.profile?.bio; // undefined
```

## Void Operator

The `void` operator evaluates an expression and returns `undefined`:

```javascript
console.log(void 0); // undefined
console.log(void (2 + 3)); // undefined

// Useful for immediately-invoked functions:
void (function () {
  console.log("This function executes immediately");
})();

// Sometimes used in hyperlinks:
<a href="javascript:void(0)">Click me (no action)</a>;
```

## Common Patterns with null and undefined

### Default Parameters

```javascript
// ES6 default parameters
function greet(name = "Guest") {
  console.log(`Hello, ${name}!`);
}

greet(); // "Hello, Guest!"
greet(undefined); // "Hello, Guest!"
greet(null); // "Hello, null!" (null doesn't trigger default)
```

### Default Values with Logical OR

```javascript
// Legacy approach before nullish coalescing
function displayName(name) {
  const displayedName = name || "Guest";
  console.log(displayedName);
}

displayName(); // "Guest"
displayName(undefined); // "Guest"
displayName(null); // "Guest"
displayName(""); // "Guest" (empty string is falsy)
displayName("John"); // "John"
```

### Default Values with Nullish Coalescing

```javascript
// Modern approach with nullish coalescing
function displayName(name) {
  const displayedName = name ?? "Guest";
  console.log(displayedName);
}

displayName(); // "Guest"
displayName(undefined); // "Guest"
displayName(null); // "Guest"
displayName(""); // "" (empty string is a valid value)
displayName("John"); // "John"
```

### Short-Circuit Evaluation

```javascript
// Only execute if object exists
user && user.save();

// Set default if value is null/undefined
const greeting = message ?? "Hello world";
```

### Destructuring with Default Values

```javascript
const settings = { theme: "dark" };

// With defaults for missing properties
const { theme, fontSize = 16, animation = true } = settings;

console.log(theme); // 'dark'
console.log(fontSize); // 16
console.log(animation); // true
```

## Common Pitfalls

### Implicit Type Conversion

```javascript
// Equality (==) with type coercion
console.log(undefined == null); // true
console.log(undefined == false); // false
console.log(null == false); // false
console.log(0 == null); // false
console.log("" == null); // false

// Always use === for more predictable results
```

### JSON Serialization

```javascript
// undefined values in objects are omitted during JSON serialization
const user = {
  name: "John",
  email: undefined,
};

console.log(JSON.stringify(user)); // {"name":"John"}

// null values are preserved
const profile = {
  name: "Jane",
  email: null,
};

console.log(JSON.stringify(profile)); // {"name":"Jane","email":null}
```

### Deletion Behavior

```javascript
// Setting to undefined doesn't remove the property
let user = { name: "John", age: 30 };
user.age = undefined;
console.log("age" in user); // true
console.log(user); // {name: "John", age: undefined}

// Setting to null keeps the property with null value
user.name = null;
console.log("name" in user); // true
console.log(user); // {name: null, age: undefined}

// delete actually removes the property
delete user.age;
console.log("age" in user); // false
console.log(user); // {name: null}
```

## Best Practices

1. **Use `undefined` for:**

   - Variables not yet assigned
   - Missing function parameters
   - Non-existent properties
   - Functions that don't explicitly return

2. **Use `null` for:**

   - Intentionally missing object references
   - Reset an existing variable
   - When you want to indicate "no value" but more intentionally than undefined

3. **Checking for both:**

   ```javascript
   // Check for both null and undefined without type coercion
   function isNullOrUndefined(value) {
     return value === null || value === undefined;
   }

   // Modern approach with nullish coalescing
   const effectiveValue = potentiallyNullOrUndefined ?? defaultValue;
   ```

4. **Use strict equality (`===`) when checking for `null` or `undefined`**

5. **Provide default values for function parameters:**

   ```javascript
   function processData(data = []) {
     // Now we can safely use data as an array
     return data.length;
   }
   ```

6. **Use optional chaining for nested properties:**
   ```javascript
   const streetName = user?.address?.street;
   ```

## Historical Context

In early JavaScript, there was only `undefined`. `null` was added later to represent an intentionally empty value, aligned with how other languages like Java handled the concept of "no value".

Brendan Eich, creator of JavaScript, has stated that having both `null` and `undefined` was a design mistake, but both remain in the language for backward compatibility.

## Exercises

1. Write a function that safely accesses deeply nested object properties.
2. Create a function that correctly handles both null and undefined inputs.
3. Refactor code that uses old-style null checking to use modern features like optional chaining and nullish coalescing.
4. Create a function that processes an API response that might contain null values.
5. Implement a function that normalizes different "empty" values (null, undefined, empty string, etc.).

## Resources

- [MDN Web Docs: null](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/null)
- [MDN Web Docs: undefined](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/undefined)
- [JavaScript.info: Nullish coalescing operator '??'](https://javascript.info/nullish-coalescing-operator)
- [JavaScript.info: Optional chaining '?.'](https://javascript.info/optional-chaining)
