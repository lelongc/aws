# Promise Basics

## What are Promises?

A Promise in JavaScript is an object representing the eventual completion or failure of an asynchronous operation. Essentially, it's a placeholder for a value that may not be available yet.

Promises provide a cleaner alternative to callback-based asynchronous programming, helping to avoid "callback hell" and making asynchronous code more readable and maintainable.

## Promise States

A Promise can be in one of three states:

1. **Pending**: Initial state, neither fulfilled nor rejected
2. **Fulfilled**: Operation completed successfully
3. **Rejected**: Operation failed
   
Once a promise is fulfilled or rejected, it is settled and cannot change state again.

## Creating a Promise

You create a Promise using the `Promise` constructor which takes an executor function with two parameters: `resolve` and `reject`.

```javascript
const myPromise = new Promise((resolve, reject) => {
  // Asynchronous operation
  const success = true;
  
  if (success) {
    resolve('Operation completed successfully');  // Fulfilled with a value
  } else {
    reject(new Error('Operation failed'));  // Rejected with a reason
  }
});
```

## Consuming a Promise

Promises can be consumed using the `.then()`, `.catch()`, and `.finally()` methods:

```javascript
myPromise
  .then((result) => {
    // Handle successful result
    console.log(result);
  })
  .catch((error) => {
    // Handle error
    console.error(error);
  })
  .finally(() => {
    // This will run regardless of success or failure
    console.log('Promise settled');
  });
```

## Promise.resolve() and Promise.reject()

You can create already resolved or rejected promises:

```javascript
// Creates a promise that is already resolved with value 42
const resolvedPromise = Promise.resolve(42);

// Creates a promise that is already rejected with an error
const rejectedPromise = Promise.reject(new Error('Something went wrong'));
```

## Common Use Cases

Promises are commonly used for:

1. **Fetching data from an API**:

```javascript
fetch('https://api.example.com/data')
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error fetching data:', error));
```

2. **Reading files in Node.js**:

```javascript
const fs = require('fs').promises;

fs.readFile('file.txt', 'utf8')
  .then(data => console.log(data))
  .catch(error => console.error('Error reading file:', error));
```

3. **Setting timeouts**:

```javascript
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

delay(2000).then(() => console.log('2 seconds have passed'));
```

## Best Practices

1. Always return values in promise chains to enable proper chaining
2. Always include error handling with `.catch()`
3. Keep promise chains flat rather than nesting them
4. Consider using async/await for even more readable code (covered in a later section)

## Next Steps

In the next section, we'll explore Promise chaining which allows you to perform sequential asynchronous operations in a clean, readable way.
