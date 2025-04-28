#!/bin/bash

# Base directory for JavaScript Core content
base_dir="$(pwd)"

# Level 1: JavaScript Fundamentals
mkdir -p "$base_dir/01-Fundamentals/01-Getting_Started"
touch "$base_dir/01-Fundamentals/01-Getting_Started/01-Introduction_to_JavaScript.md"
touch "$base_dir/01-Fundamentals/01-Getting_Started/02-Setting_Up_Environment.md"
touch "$base_dir/01-Fundamentals/01-Getting_Started/03-Browser_Developer_Tools.md"
touch "$base_dir/01-Fundamentals/01-Getting_Started/04-Running_JavaScript.md"
touch "$base_dir/01-Fundamentals/01-Getting_Started/05-Basic_Syntax.md"

mkdir -p "$base_dir/01-Fundamentals/02-Basic_Data_Types"
touch "$base_dir/01-Fundamentals/02-Basic_Data_Types/01-Numbers.md"
touch "$base_dir/01-Fundamentals/02-Basic_Data_Types/02-Strings.md"
touch "$base_dir/01-Fundamentals/02-Basic_Data_Types/03-Booleans.md"
touch "$base_dir/01-Fundamentals/02-Basic_Data_Types/04-Null_and_Undefined.md"
touch "$base_dir/01-Fundamentals/02-Basic_Data_Types/05-Type_Conversion.md"
touch "$base_dir/01-Fundamentals/02-Basic_Data_Types/06-Symbol_and_BigInt.md"

mkdir -p "$base_dir/01-Fundamentals/03-Variables_and_Scope"
touch "$base_dir/01-Fundamentals/03-Variables_and_Scope/01-Var_Let_Const.md"
touch "$base_dir/01-Fundamentals/03-Variables_and_Scope/02-Variable_Naming.md"
touch "$base_dir/01-Fundamentals/03-Variables_and_Scope/03-Scope.md"
touch "$base_dir/01-Fundamentals/03-Variables_and_Scope/04-Hoisting.md"
touch "$base_dir/01-Fundamentals/03-Variables_and_Scope/05-Temporal_Dead_Zone.md"

mkdir -p "$base_dir/01-Fundamentals/04-Operators"
touch "$base_dir/01-Fundamentals/04-Operators/01-Arithmetic_Operators.md"
touch "$base_dir/01-Fundamentals/04-Operators/02-Assignment_Operators.md"
touch "$base_dir/01-Fundamentals/04-Operators/03-Comparison_Operators.md"
touch "$base_dir/01-Fundamentals/04-Operators/04-Logical_Operators.md"
touch "$base_dir/01-Fundamentals/04-Operators/05-Bitwise_Operators.md"
touch "$base_dir/01-Fundamentals/04-Operators/06-Other_Operators.md"

mkdir -p "$base_dir/01-Fundamentals/05-Control_Flow"
touch "$base_dir/01-Fundamentals/05-Control_Flow/01-Conditional_Statements.md"
touch "$base_dir/01-Fundamentals/05-Control_Flow/02-Switch_Statements.md"
touch "$base_dir/01-Fundamentals/05-Control_Flow/03-Loops.md"
touch "$base_dir/01-Fundamentals/05-Control_Flow/04-Break_and_Continue.md"
touch "$base_dir/01-Fundamentals/05-Control_Flow/05-Labeled_Statements.md"

mkdir -p "$base_dir/01-Fundamentals/06-Functions_Basics"
touch "$base_dir/01-Fundamentals/06-Functions_Basics/01-Function_Declarations.md"
touch "$base_dir/01-Fundamentals/06-Functions_Basics/02-Function_Expressions.md"
touch "$base_dir/01-Fundamentals/06-Functions_Basics/03-Arrow_Functions.md"
touch "$base_dir/01-Fundamentals/06-Functions_Basics/04-Parameters_and_Arguments.md"
touch "$base_dir/01-Fundamentals/06-Functions_Basics/05-Return_Values.md"
touch "$base_dir/01-Fundamentals/06-Functions_Basics/06-Function_Hoisting.md"

mkdir -p "$base_dir/01-Fundamentals/07-Basic_Data_Structures"
touch "$base_dir/01-Fundamentals/07-Basic_Data_Structures/01-Arrays_Basics.md"
touch "$base_dir/01-Fundamentals/07-Basic_Data_Structures/02-Array_Methods.md"
touch "$base_dir/01-Fundamentals/07-Basic_Data_Structures/03-Array_Looping.md"
touch "$base_dir/01-Fundamentals/07-Basic_Data_Structures/04-Objects_Basics.md"
touch "$base_dir/01-Fundamentals/07-Basic_Data_Structures/05-Object_Properties.md"
touch "$base_dir/01-Fundamentals/07-Basic_Data_Structures/06-JSON_Basics.md"

# Level 2: Intermediate JavaScript
mkdir -p "$base_dir/02-Intermediate/01-Advanced_Functions"
touch "$base_dir/02-Intermediate/01-Advanced_Functions/01-First_Class_Functions.md"
touch "$base_dir/02-Intermediate/01-Advanced_Functions/02-Higher_Order_Functions.md"
touch "$base_dir/02-Intermediate/01-Advanced_Functions/03-Callbacks.md"
touch "$base_dir/02-Intermediate/01-Advanced_Functions/04-IIFE.md"
touch "$base_dir/02-Intermediate/01-Advanced_Functions/05-Closures.md"
touch "$base_dir/02-Intermediate/01-Advanced_Functions/06-Arguments_Object.md"
touch "$base_dir/02-Intermediate/01-Advanced_Functions/07-Rest_and_Spread.md"
touch "$base_dir/02-Intermediate/01-Advanced_Functions/08-Function_Borrowing.md"

mkdir -p "$base_dir/02-Intermediate/02-More_on_Objects"
touch "$base_dir/02-Intermediate/02-More_on_Objects/01-Object_Methods.md"
touch "$base_dir/02-Intermediate/02-More_on_Objects/02-Constructor_Functions.md"
touch "$base_dir/02-Intermediate/02-More_on_Objects/03-Prototypes.md"
touch "$base_dir/02-Intermediate/02-More_on_Objects/04-Object_Create.md"
touch "$base_dir/02-Intermediate/02-More_on_Objects/05-Property_Descriptors.md"
touch "$base_dir/02-Intermediate/02-More_on_Objects/06-Getters_and_Setters.md"
touch "$base_dir/02-Intermediate/02-More_on_Objects/07-Object_Methods.md"

mkdir -p "$base_dir/02-Intermediate/03-Advanced_Arrays"
touch "$base_dir/02-Intermediate/03-Advanced_Arrays/01-Iteration_Methods.md"
touch "$base_dir/02-Intermediate/03-Advanced_Arrays/02-Search_Methods.md"
touch "$base_dir/02-Intermediate/03-Advanced_Arrays/03-Transformation_Methods.md"
touch "$base_dir/02-Intermediate/03-Advanced_Arrays/04-Array_Destructuring.md"
touch "$base_dir/02-Intermediate/03-Advanced_Arrays/05-Multidimensional_Arrays.md"

mkdir -p "$base_dir/02-Intermediate/04-Exception_Handling"
touch "$base_dir/02-Intermediate/04-Exception_Handling/01-Try_Catch.md"
touch "$base_dir/02-Intermediate/04-Exception_Handling/02-Throw_Statement.md"
touch "$base_dir/02-Intermediate/04-Exception_Handling/03-Error_Objects.md"
touch "$base_dir/02-Intermediate/04-Exception_Handling/04-Custom_Errors.md"
touch "$base_dir/02-Intermediate/04-Exception_Handling/05-Error_Propagation.md"
touch "$base_dir/02-Intermediate/04-Exception_Handling/06-Best_Practices.md"

mkdir -p "$base_dir/02-Intermediate/05-Modules_and_Organization"
touch "$base_dir/02-Intermediate/05-Modules_and_Organization/01-Script_Loading.md"
touch "$base_dir/02-Intermediate/05-Modules_and_Organization/02-ES_Modules.md"
touch "$base_dir/02-Intermediate/05-Modules_and_Organization/03-Module_Patterns.md"
touch "$base_dir/02-Intermediate/05-Modules_and_Organization/04-CommonJS.md"
touch "$base_dir/02-Intermediate/05-Modules_and_Organization/05-ES_vs_CommonJS.md"

mkdir -p "$base_dir/02-Intermediate/06-Regular_Expressions"
touch "$base_dir/02-Intermediate/06-Regular_Expressions/01-Creating_RegExp.md"
touch "$base_dir/02-Intermediate/06-Regular_Expressions/02-RegExp_Methods.md"
touch "$base_dir/02-Intermediate/06-Regular_Expressions/03-String_Methods_with_RegExp.md"
touch "$base_dir/02-Intermediate/06-Regular_Expressions/04-Patterns_and_Flags.md"
touch "$base_dir/02-Intermediate/06-Regular_Expressions/05-Character_Classes.md"
touch "$base_dir/02-Intermediate/06-Regular_Expressions/06-Quantifiers_and_Groups.md"

# Level 3: Advanced JavaScript
mkdir -p "$base_dir/03-Advanced/01-This_Keyword"
touch "$base_dir/03-Advanced/01-This_Keyword/01-This_Contexts.md"
touch "$base_dir/03-Advanced/01-This_Keyword/02-Global_Context.md"
touch "$base_dir/03-Advanced/01-This_Keyword/03-Function_Context.md"
touch "$base_dir/03-Advanced/01-This_Keyword/04-Object_Methods.md"
touch "$base_dir/03-Advanced/01-This_Keyword/05-Classes_and_Constructors.md"
touch "$base_dir/03-Advanced/01-This_Keyword/06-Explicit_Binding.md"
touch "$base_dir/03-Advanced/01-This_Keyword/07-Arrow_Functions.md"

mkdir -p "$base_dir/03-Advanced/02-Prototypal_Inheritance"
touch "$base_dir/03-Advanced/02-Prototypal_Inheritance/01-Prototype_Chain.md"
touch "$base_dir/03-Advanced/02-Prototypal_Inheritance/02-Constructor_Functions.md"
touch "$base_dir/03-Advanced/02-Prototypal_Inheritance/03-Proto_Property.md"
touch "$base_dir/03-Advanced/02-Prototypal_Inheritance/04-Prototype_Methods.md"
touch "$base_dir/03-Advanced/02-Prototypal_Inheritance/05-Inheritance_Patterns.md"
touch "$base_dir/03-Advanced/02-Prototypal_Inheritance/06-Composition_vs_Inheritance.md"

mkdir -p "$base_dir/03-Advanced/03-Classes"
touch "$base_dir/03-Advanced/03-Classes/01-Class_Syntax.md"
touch "$base_dir/03-Advanced/03-Classes/02-Constructor_Method.md"
touch "$base_dir/03-Advanced/03-Classes/03-Instance_Methods.md"
touch "$base_dir/03-Advanced/03-Classes/04-Static_Methods.md"
touch "$base_dir/03-Advanced/03-Classes/05-Inheritance.md"
touch "$base_dir/03-Advanced/03-Classes/06-Super_Keyword.md"
touch "$base_dir/03-Advanced/03-Classes/07-Fields_and_Methods.md"
touch "$base_dir/03-Advanced/03-Classes/08-Mixins.md"

mkdir -p "$base_dir/03-Advanced/04-Asynchronous_JavaScript"
mkdir -p "$base_dir/03-Advanced/04-Asynchronous_JavaScript/01-Callbacks_and_EventLoop"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/01-Callbacks_and_EventLoop/01-Event_Loop.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/01-Callbacks_and_EventLoop/02-Callbacks.md"

mkdir -p "$base_dir/03-Advanced/04-Asynchronous_JavaScript/02-Promises"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/02-Promises/01-Promise_Basics.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/02-Promises/02-Chaining.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/02-Promises/03-Error_Handling.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/02-Promises/04-Promise_Methods.md"

mkdir -p "$base_dir/03-Advanced/04-Asynchronous_JavaScript/03-Async_Await"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/03-Async_Await/01-Async_Functions.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/03-Async_Await/02-Await_Expression.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/03-Async_Await/03-Error_Handling.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/03-Async_Await/04-Parallel_Execution.md"

mkdir -p "$base_dir/03-Advanced/04-Asynchronous_JavaScript/04-Generators_Iterators"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/04-Generators_Iterators/01-Generator_Functions.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/04-Generators_Iterators/02-Yield_Keyword.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/04-Generators_Iterators/03-Iterators_and_Iterables.md"
touch "$base_dir/03-Advanced/04-Asynchronous_JavaScript/04-Generators_Iterators/04-Async_Generators.md"

mkdir -p "$base_dir/03-Advanced/05-Memory_Management"
touch "$base_dir/03-Advanced/05-Memory_Management/01-Memory_Model.md"
touch "$base_dir/03-Advanced/05-Memory_Management/02-Stack_and_Heap.md"
touch "$base_dir/03-Advanced/05-Memory_Management/03-Garbage_Collection.md"
touch "$base_dir/03-Advanced/05-Memory_Management/04-Memory_Leaks.md"
touch "$base_dir/03-Advanced/05-Memory_Management/05-Reference_vs_Value.md"
touch "$base_dir/03-Advanced/05-Memory_Management/06-Debugging_Memory_Issues.md"

mkdir -p "$base_dir/03-Advanced/06-Functional_Programming"
touch "$base_dir/03-Advanced/06-Functional_Programming/01-Pure_Functions.md"
touch "$base_dir/03-Advanced/06-Functional_Programming/02-Immutability.md"
touch "$base_dir/03-Advanced/06-Functional_Programming/03-Function_Composition.md"
touch "$base_dir/03-Advanced/06-Functional_Programming/04-Currying.md"
touch "$base_dir/03-Advanced/06-Functional_Programming/05-Partial_Application.md"
touch "$base_dir/03-Advanced/06-Functional_Programming/06-Point_Free_Style.md"
touch "$base_dir/03-Advanced/06-Functional_Programming/07-Functors_and_Monads.md"
touch "$base_dir/03-Advanced/06-Functional_Programming/08-Recursion_and_Memoization.md"

mkdir -p "$base_dir/03-Advanced/07-Metaprogramming"
touch "$base_dir/03-Advanced/07-Metaprogramming/01-Property_Descriptors.md"
touch "$base_dir/03-Advanced/07-Metaprogramming/02-Define_Properties.md"
touch "$base_dir/03-Advanced/07-Metaprogramming/03-Property_Descriptor_Methods.md"
touch "$base_dir/03-Advanced/07-Metaprogramming/04-Proxy_Objects.md"
touch "$base_dir/03-Advanced/07-Metaprogramming/05-Reflect_API.md"
touch "$base_dir/03-Advanced/07-Metaprogramming/06-Symbols.md"

# Level 4: JavaScript Mastery
mkdir -p "$base_dir/04-Mastery/01-Performance_Optimization"
touch "$base_dir/04-Mastery/01-Performance_Optimization/01-Measurement_and_Benchmarking.md"
touch "$base_dir/04-Mastery/01-Performance_Optimization/02-Critical_Rendering_Path.md"
touch "$base_dir/04-Mastery/01-Performance_Optimization/03-JS_Optimization_Techniques.md"
touch "$base_dir/04-Mastery/01-Performance_Optimization/04-Memory_Optimization.md"
touch "$base_dir/04-Mastery/01-Performance_Optimization/05-DOM_Performance.md"
touch "$base_dir/04-Mastery/01-Performance_Optimization/06-Algorithm_Efficiency.md"
touch "$base_dir/04-Mastery/01-Performance_Optimization/07-Lazy_Loading.md"

mkdir -p "$base_dir/04-Mastery/02-Design_Patterns"
touch "$base_dir/04-Mastery/02-Design_Patterns/01-Creational_Patterns.md"
touch "$base_dir/04-Mastery/02-Design_Patterns/02-Structural_Patterns.md"
touch "$base_dir/04-Mastery/02-Design_Patterns/03-Behavioral_Patterns.md"
touch "$base_dir/04-Mastery/02-Design_Patterns/04-MV_Patterns.md"
touch "$base_dir/04-Mastery/02-Design_Patterns/05-Flux_Redux_Pattern.md"

mkdir -p "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns"
touch "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns/01-Reactive_Programming.md"
touch "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns/02-Observables.md"
touch "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns/03-Event_Driven_Architecture.md"
touch "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns/04-Web_Workers.md"
touch "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns/05-Service_Workers.md"
touch "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns/06-Shared_Workers.md"
touch "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns/07-Message_Channels.md"
touch "$base_dir/04-Mastery/03-Advanced_Asynchronous_Patterns/08-Async_Iterators.md"

mkdir -p "$base_dir/04-Mastery/04-JavaScript_Engines"
touch "$base_dir/04-Mastery/04-JavaScript_Engines/01-JS_Engine_Internals.md"
touch "$base_dir/04-Mastery/04-JavaScript_Engines/02-V8_Architecture.md"
touch "$base_dir/04-Mastery/04-JavaScript_Engines/03-JIT_Compilation.md"
touch "$base_dir/04-Mastery/04-JavaScript_Engines/04-Hidden_Classes.md"
touch "$base_dir/04-Mastery/04-JavaScript_Engines/05-Optimization.md"
touch "$base_dir/04-Mastery/04-JavaScript_Engines/06-Memory_Management.md"
touch "$base_dir/04-Mastery/04-JavaScript_Engines/07-Browser_vs_NodeJS.md"

mkdir -p "$base_dir/04-Mastery/05-Modern_JavaScript_Features"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/01-Latest_ECMAScript.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/02-Optional_Chaining.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/03-Nullish_Coalescing.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/04-Logical_Assignment.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/05-Private_Features.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/06-Top_Level_Await.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/07-Dynamic_Imports.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/08-Numeric_Separators.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/09-Intl_API.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/10-Temporal_API.md"
touch "$base_dir/04-Mastery/05-Modern_JavaScript_Features/11-Proposals.md"

mkdir -p "$base_dir/04-Mastery/06-Testing_and_Debugging"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/01-Unit_Testing.md"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/02-Integration_Testing.md"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/03-TDD.md"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/04-Mocking_and_Stubbing.md"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/05-Advanced_Debugging.md"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/06-Chrome_DevTools.md"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/07-Memory_Profiling.md"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/08-Performance_Profiling.md"
touch "$base_dir/04-Mastery/06-Testing_and_Debugging/09-Source_Maps.md"

mkdir -p "$base_dir/04-Mastery/07-Security_Best_Practices"
touch "$base_dir/04-Mastery/07-Security_Best_Practices/01-Common_Vulnerabilities.md"
touch "$base_dir/04-Mastery/07-Security_Best_Practices/02-Content_Security_Policy.md"
touch "$base_dir/04-Mastery/07-Security_Best_Practices/03-Secure_Coding.md"
touch "$base_dir/04-Mastery/07-Security_Best_Practices/04-Input_Validation.md"
touch "$base_dir/04-Mastery/07-Security_Best_Practices/05-Sandboxing.md"
touch "$base_dir/04-Mastery/07-Security_Best_Practices/06-Same_Origin.md"
touch "$base_dir/04-Mastery/07-Security_Best_Practices/07-CORS.md"
touch "$base_dir/04-Mastery/07-Security_Best_Practices/08-Subresource_Integrity.md"

echo "✅ JavaScript Core learning path folder structure has been created successfully!"

# Create a sample template for one of the files to demonstrate structure
cat > "$base_dir/01-Fundamentals/01-Getting_Started/01-Introduction_to_JavaScript.md" << 'EOL'
# Introduction to JavaScript

## What is JavaScript?

JavaScript is a high-level, interpreted programming language that conforms to the ECMAScript specification. It is a language that is also characterized as dynamic, weakly typed, prototype-based and multi-paradigm.

## Brief History

- Created in 1995 by Brendan Eich while at Netscape
- Originally called Mocha, then LiveScript, and finally JavaScript
- Standardized as ECMAScript in 1997
- Major versions:
  - ES5 (2009): Added strict mode, JSON methods, array methods
  - ES6/ES2015: Major update with classes, modules, promises, arrow functions, etc.
  - Yearly releases since then (ES2016, ES2017, etc.)

## Why JavaScript is Important

1. **Universal Language**: Runs on virtually every device with a web browser
2. **Full Stack Development**: Can be used for frontend (browser) and backend (Node.js)
3. **Versatility**: From web apps to mobile apps, desktop apps, games, and more
4. **Rich Ecosystem**: Vast library of frameworks and tools
5. **Community Support**: One of the largest developer communities

## What JavaScript Can Do

- Dynamic HTML content manipulation
- Form validation
- User interface interactivity
- Data fetching from servers (AJAX, Fetch API)
- Animations and visual effects
- Single Page Applications (SPAs)
- Server-side applications (with Node.js)
- Mobile applications (React Native, Ionic)
- Desktop applications (Electron)
- Internet of Things (IoT) programming

## JavaScript vs. Java

Despite the name similarity, JavaScript and Java are completely different languages:

| JavaScript | Java |
|------------|------|
| Interpreted | Compiled |
| Dynamically typed | Statically typed |
| Prototype-based inheritance | Class-based inheritance |
| First-class functions | No first-class functions |
| Single-threaded | Multi-threaded |

## JavaScript Versions

JavaScript follows the ECMAScript (ES) standard. Some key versions include:

- **ES5** (2009): The "old" JavaScript
- **ES6/ES2015**: Major update with lots of new features
- **ES2016, ES2017, etc.**: Yearly incremental updates

## Next Steps

After understanding what JavaScript is, you'll want to start writing your first JavaScript code. Continue to the next section to learn about setting up your development environment.
EOL

cat > "$base_dir/03-Advanced/04-Asynchronous_JavaScript/02-Promises/01-Promise_Basics.md" << 'EOL'
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
EOL

# Create a Windows batch file version as well for Windows users
cat > "$base_dir/create_js_structure.bat" << 'EOL'
@echo off
REM Windows batch script to create JavaScript Core folder structure
REM Run this script from the JavaScript_Core directory

echo Creating JavaScript Core folder structure...

REM Base directory is current directory
set base_dir=%CD%

REM Level 1: JavaScript Fundamentals
mkdir "%base_dir%\01-Fundamentals\01-Getting_Started"
type nul > "%base_dir%\01-Fundamentals\01-Getting_Started\01-Introduction_to_JavaScript.md"
type nul > "%base_dir%\01-Fundamentals\01-Getting_Started\02-Setting_Up_Environment.md"
type nul > "%base_dir%\01-Fundamentals\01-Getting_Started\03-Browser_Developer_Tools.md"
type nul > "%base_dir%\01-Fundamentals\01-Getting_Started\04-Running_JavaScript.md"
type nul > "%base_dir%\01-Fundamentals\01-Getting_Started\05-Basic_Syntax.md"

mkdir "%base_dir%\01-Fundamentals\02-Basic_Data_Types"
type nul > "%base_dir%\01-Fundamentals\02-Basic_Data_Types\01-Numbers.md"
type nul > "%base_dir%\01-Fundamentals\02-Basic_Data_Types\02-Strings.md"
type nul > "%base_dir%\01-Fundamentals\02-Basic_Data_Types\03-Booleans.md"
type nul > "%base_dir%\01-Fundamentals\02-Basic_Data_Types\04-Null_and_Undefined.md"
type nul > "%base_dir%\01-Fundamentals\02-Basic_Data_Types\05-Type_Conversion.md"
type nul > "%base_dir%\01-Fundamentals\02-Basic_Data_Types\06-Symbol_and_BigInt.md"

REM Continue with the rest of the structure...
REM For brevity, I'm not including the entire structure in this batch file
REM The full structure would mirror what's in the bash script

echo ✓ Basic structure created. See create_js_structure.sh for the complete structure.
echo ✓ JavaScript Core learning path folder structure has been initiated! 
EOL

echo "Created both bash and batch scripts for generating the JavaScript learning path structure."
