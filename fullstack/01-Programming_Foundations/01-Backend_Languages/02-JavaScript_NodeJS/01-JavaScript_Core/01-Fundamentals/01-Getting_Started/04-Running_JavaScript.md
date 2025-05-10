# Running JavaScript

JavaScript is versatile and can run in different environments. This guide covers the main ways to execute JavaScript code, from browsers to server-side environments like Node.js.

## Running JavaScript in Web Browsers

Browsers have built-in JavaScript engines that can run your code. Here are different ways to use JavaScript in the browser environment:

### 1. Using the Browser Console

The browser console allows you to test JavaScript code immediately:

1. Open your browser's developer tools:

   - Chrome/Edge: Press F12 or Ctrl+Shift+I (Cmd+Option+I on Mac)
   - Firefox: Press F12 or Ctrl+Shift+I
   - Safari: Press Cmd+Option+C

2. Navigate to the Console tab and type your JavaScript:

```javascript
console.log("Hello, World!");
2 + 2;
let name = "JavaScript";
alert("Welcome to " + name);
```

3. Press Enter to execute each line

**Advantages:**

- Instant feedback
- Access to the current page's DOM
- Great for quick tests and debugging

**Limitations:**

- Code is not saved permanently
- Not suitable for multi-file projects

### 2. Using Script Tags in HTML

Embed JavaScript directly in HTML files using `<script>` tags:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>My JavaScript Page</title>
    <!-- Internal script in the head -->
    <script>
      function greet() {
        alert("Hello from the head!");
      }
    </script>
  </head>
  <body>
    <h1>JavaScript Example</h1>
    <button onclick="greet()">Click Me</button>

    <!-- Script at the end of body (recommended) -->
    <script>
      console.log("Page loaded!");
      document.querySelector("h1").style.color = "blue";
    </script>
  </body>
</html>
```

**Best Practices:**

- Place scripts at the end of the `<body>` for better page loading performance
- Use the `defer` or `async` attributes when placing scripts in the `<head>`

### 3. External JavaScript Files

Link external JavaScript files to your HTML:

1. Create a JavaScript file (e.g., `script.js`):

```javascript
// script.js
function showMessage() {
  alert("Hello from external file!");
}

document.addEventListener("DOMContentLoaded", function () {
  console.log("Page fully loaded");
  document.querySelector("h1").style.color = "green";
});
```

2. Link it in your HTML:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>External JS Example</title>
    <!-- Using defer attribute to load after HTML parsing -->
    <script src="script.js" defer></script>
  </head>
  <body>
    <h1>External JavaScript Example</h1>
    <button onclick="showMessage()">Show Message</button>
  </body>
</html>
```

**Script Loading Attributes:**

- `defer`: Downloads in parallel with HTML parsing and executes after parsing completes
- `async`: Downloads in parallel and executes as soon as it's available, potentially before HTML parsing completes

## Running JavaScript with Node.js

Node.js allows you to run JavaScript on the server-side or as a standalone application:

### 1. Running JavaScript Files

After [installing Node.js](./02-Setting_Up_Environment.md), you can run any JavaScript file:

1. Create a JavaScript file (e.g., `app.js`):

```javascript
// app.js
console.log("Hello from Node.js!");

function add(a, b) {
  return a + b;
}

const result = add(5, 7);
console.log(`5 + 7 = ${result}`);
```

2. Run it using Node.js:

```bash
node app.js
```

### 2. Node.js REPL (Read-Eval-Print Loop)

Node.js includes an interactive mode similar to the browser console:

1. Open your terminal or command prompt
2. Type `node` and press Enter
3. Start typing JavaScript commands:

```javascript
> console.log("Hello from Node.js REPL")
Hello from Node.js REPL
undefined
> 2 + 2
4
> let name = "Node.js"
undefined
> `I'm using ${name}`
'I'm using Node.js'
```

4. Exit by pressing Ctrl+C twice or typing `.exit`

### 3. Using Nodemon for Development

Nodemon automatically restarts your Node.js application when file changes are detected:

1. Install nodemon globally:

```bash
npm install -g nodemon
```

2. Run your application with nodemon:

```bash
nodemon app.js
```

## Online JavaScript Environments

Several online platforms let you run JavaScript without any local setup:

### 1. Code Playgrounds

- **CodePen** (https://codepen.io): Great for web projects with HTML, CSS, and JavaScript
- **JSFiddle** (https://jsfiddle.net): Similar to CodePen with a focus on JavaScript
- **CodeSandbox** (https://codesandbox.io): More advanced, supports npm packages and frameworks
- **Replit** (https://replit.com): Supports full projects across many languages, including Node.js apps

### 2. Browser Developer Tools Snippets

Chrome and Edge DevTools allow you to save and run code snippets:

1. Open DevTools (F12)
2. Go to Sources tab
3. Click on the Snippets sub-tab
4. Create a new snippet
5. Write your code and press Ctrl+Enter to run

## Running JavaScript with Build Tools

For more complex projects, build tools help manage dependencies and compilation:

### 1. Using npm Scripts

1. Create a `package.json` file with scripts:

```json
{
  "name": "my-js-app",
  "version": "1.0.0",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "build": "webpack --mode production"
  }
}
```

2. Run using npm:

```bash
npm run start
npm run dev
```

### 2. Using Build Tools and Bundlers

Tools like webpack, Parcel, or Vite can bundle JavaScript modules:

1. Install webpack:

```bash
npm install webpack webpack-cli --save-dev
```

2. Create a webpack configuration (webpack.config.js):

```javascript
const path = require("path");

module.exports = {
  entry: "./src/index.js",
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, "dist"),
  },
};
```

3. Build and run:

```bash
npx webpack
node dist/bundle.js
```

## JavaScript Execution Environments Comparison

| Feature            | Browser                    | Node.js   | Online Playground |
| ------------------ | -------------------------- | --------- | ----------------- |
| DOM API            | ✅                         | ❌        | ✅                |
| File System Access | ❌                         | ✅        | Limited           |
| Network Requests   | ✅ (with CORS)             | ✅        | Limited           |
| npm Packages       | With bundlers              | ✅        | Some platforms    |
| Persistence        | Limited (cookies, storage) | ✅        | Limited           |
| Performance        | Engine varies by browser   | V8 engine | Limited           |

## JavaScript Runtime Environments

JavaScript has different runtime environments, each with its own features and limitations:

1. **Browser JavaScript Engines**:

   - Chrome/Edge: V8 (fastest)
   - Firefox: SpiderMonkey
   - Safari: JavaScriptCore (Nitro)

2. **Server-side Environments**:

   - Node.js: Built on V8
   - Deno: Built on V8 with TypeScript support
   - Bun: Built on JavaScriptCore, very fast startup

3. **Mobile App Environments**:
   - React Native: Runs on JavaScriptCore (iOS) and V8 (Android)
   - NativeScript: Uses V8 on both iOS and Android
   - Capacitor/Ionic: Uses the device's WebView engine

## Running Tests

For testing JavaScript code, use testing frameworks:

```bash
# Install Jest
npm install --save-dev jest

# Run tests
npx jest
```

Example test file (`sum.test.js`):

```javascript
const sum = require("./sum");

test("adds 1 + 2 to equal 3", () => {
  expect(sum(1, 2)).toBe(3);
});
```

## Debugging JavaScript

### Browser Debugging

1. Add `debugger;` statement in your code
2. Open browser DevTools (F12)
3. Refresh the page
4. Code execution will pause at the debugger statement

### Node.js Debugging

1. Run with the inspector:

```bash
node --inspect app.js
```

2. Open Chrome and navigate to `chrome://inspect`
3. Click "Open dedicated DevTools for Node"

## Best Practices

1. **Development Environment**:

   - Use source maps in production for easier debugging
   - Set up proper error handling
   - Use modules to organize code

2. **Performance**:

   - Minify and compress for production
   - Use code splitting for large applications
   - Optimize critical rendering path for browser apps

3. **Security**:
   - Never run untrusted code with `eval()`
   - Sanitize input in both browser and Node.js
   - Use Content Security Policy in browsers

## Next Steps

After learning how to run JavaScript in various environments, proceed to learn:

- Basic JavaScript syntax
- Control flow structures
- Functions and scope
- Working with data types

## Resources

- [MDN: JavaScript First Steps](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps)
- [Node.js Documentation](https://nodejs.org/en/docs/)
- [V8 JavaScript Engine](https://v8.dev/)
