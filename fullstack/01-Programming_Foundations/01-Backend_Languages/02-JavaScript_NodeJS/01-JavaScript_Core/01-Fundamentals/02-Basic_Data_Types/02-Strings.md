# JavaScript Strings

Strings are sequences of characters used to represent text in JavaScript. They are one of the fundamental data types and are used extensively in nearly all JavaScript applications.

## Creating Strings

In JavaScript, you can create strings using three types of quotes:

```javascript
// Single quotes
let firstName = "John";

// Double quotes
let lastName = "Doe";

// Backticks (template literals - ES6)
let greeting = `Hello`;

// All these are valid strings
```

### String Literals vs String Objects

```javascript
// String literal (primitive) - Recommended
let str1 = "Hello";

// String object - Not recommended for general use
let str2 = new String("Hello");

typeof str1; // "string"
typeof str2; // "object"

// Converting String object to primitive
let str3 = new String("Hello").valueOf(); // "Hello"
```

## String Properties

### Length

The `length` property returns the number of characters in a string:

```javascript
let text = "Hello, World!";
console.log(text.length); // 13
```

## String Characters and Indices

Strings can be accessed by index (zero-based):

```javascript
let str = "JavaScript";
console.log(str[0]); // "J"
console.log(str[4]); // "S"

// Alternative method using charAt()
console.log(str.charAt(0)); // "J"

// Get the last character
console.log(str[str.length - 1]); // "t"

// Characters beyond the length
console.log(str[20]); // undefined
console.log(str.charAt(20)); // "" (empty string)
```

## String Immutability

Strings in JavaScript are immutable, meaning you cannot change individual characters:

```javascript
let str = "Hello";
str[0] = "J"; // This doesn't work
console.log(str); // Still "Hello"

// To change a string, you must create a new one
str = "Jello"; // This works
```

## String Concatenation

There are several ways to join strings:

```javascript
// Using the + operator
let firstName = "John";
let lastName = "Doe";
let fullName = firstName + " " + lastName; // "John Doe"

// Using the += operator
let greeting = "Hello";
greeting += ", World!"; // "Hello, World!"

// Using the concat() method
let text1 = "Hello";
let text2 = "World";
let result = text1.concat(", ", text2, "!"); // "Hello, World!"
```

## Template Literals (ES6)

Template literals provide more powerful string capabilities:

```javascript
// String interpolation
let name = "John";
let age = 30;
let message = `Hello, my name is ${name} and I am ${age} years old.`;

// Multi-line strings
let multiLine = `This is line 1
This is line 2
This is line 3`;

// Expressions in template literals
let a = 5;
let b = 10;
console.log(`The sum is ${a + b} and the product is ${a * b}`);

// Tagged templates
function highlight(strings, ...values) {
  let result = "";
  strings.forEach((string, i) => {
    result += string;
    if (i < values.length) {
      result += `<strong>${values[i]}</strong>`;
    }
  });
  return result;
}

const highlighted = highlight`The value is ${a + b} and another is ${a * b}`;
// "The value is <strong>15</strong> and another is <strong>50</strong>"
```

## Escape Sequences

Special characters in strings can be represented using escape sequences:

```javascript
// Special characters
let text1 = 'This is a "quote" inside a string'; // Use \" for quotes
let text2 = "It's a beautiful day"; // Use \' for apostrophe
let path = "C:\\Users\\John\\Documents"; // Use \\ for backslash

// Common escape sequences
let newLine = "Line 1\nLine 2"; // \n - New line
let tab = "Column1\tColumn2"; // \t - Tab
let carriageReturn = "Start\rOver"; // \r - Carriage return
let backspace = "Back\bspace"; // \b - Backspace
let formFeed = "Page1\fPage2"; // \f - Form feed
let unicodeChar = "\u00A9"; // \uXXXX - Unicode character (© symbol)
let unicodeEsc = "\u{1F600}"; // \u{X...} - Unicode code point (😀 emoji)
```

## String Methods for Basic Manipulation

### Case Conversion

```javascript
let text = "Hello, World!";

// Convert to uppercase/lowercase
console.log(text.toUpperCase()); // "HELLO, WORLD!"
console.log(text.toLowerCase()); // "hello, world!"

// For locale-specific conversions
console.log(text.toLocaleLowerCase()); // "hello, world!"
console.log(text.toLocaleUpperCase()); // "HELLO, WORLD!"
```

### Trimming

```javascript
let text = "   Hello, World!   ";

// Remove whitespace from both ends
console.log(text.trim()); // "Hello, World!"
console.log(text.trimStart()); // "Hello, World!   " (ES2019)
console.log(text.trimEnd()); // "   Hello, World!" (ES2019)

// Older alternatives
console.log(text.trimLeft()); // Same as trimStart()
console.log(text.trimRight()); // Same as trimEnd()
```

### Padding (ES2017)

```javascript
let num = "42";

// Pad the start until length is 5
console.log(num.padStart(5, "0")); // "00042"

// Pad the end until length is 4
console.log(num.padEnd(4, "*")); // "42**"

// If no pad string is specified, space is used
console.log(num.padStart(4)); // "  42"
```

## String Methods for Searching

### indexOf and lastIndexOf

```javascript
let text = "Hello, Hello, World!";

// Find first occurrence
console.log(text.indexOf("Hello")); // 0
console.log(text.indexOf("Hello", 1)); // 7 (start from index 1)
console.log(text.indexOf("Goodbye")); // -1 (not found)

// Find last occurrence
console.log(text.lastIndexOf("Hello")); // 7
console.log(text.lastIndexOf("o")); // 14
```

### includes, startsWith, and endsWith (ES6)

```javascript
let text = "Hello, World!";

// Check if string contains substring
console.log(text.includes("World")); // true
console.log(text.includes("world")); // false (case sensitive)
console.log(text.includes("World", 8)); // false (start from index 8)

// Check if string starts with substring
console.log(text.startsWith("Hello")); // true
console.log(text.startsWith("ello", 1)); // true (start from index 1)

// Check if string ends with substring
console.log(text.endsWith("World!")); // true
console.log(text.endsWith("World", 12)); // true (check up to position 12)
```

### search with RegExp

```javascript
let text = "Hello, World! The world is beautiful.";

// Search with regular expression
console.log(text.search(/World/)); // 7
console.log(text.search(/world/i)); // 7 (case insensitive)
console.log(text.search(/\w+$/)); // 33 (last word)
```

## String Methods for Extraction

### Substrings

```javascript
let text = "Hello, World!";

// slice(start, end) - end not included
console.log(text.slice(0, 5)); // "Hello"
console.log(text.slice(7)); // "World!"
console.log(text.slice(-6)); // "World!" (from end)
console.log(text.slice(-6, -1)); // "World" (from end)

// substring(start, end) - similar to slice but can't use negative indices
console.log(text.substring(0, 5)); // "Hello"
console.log(text.substring(7)); // "World!"

// substr(start, length) - deprecated but still works
console.log(text.substr(0, 5)); // "Hello"
console.log(text.substr(7, 5)); // "World"
console.log(text.substr(-6, 5)); // "World" (from end)
```

### Character Extraction

```javascript
let text = "Hello";

// Get a specific character (newer method)
console.log(text[0]); // "H"
console.log(text.at(0)); // "H" (ES2022)
console.log(text.at(-1)); // "o" (supports negative indices)

// Get character code
console.log(text.charCodeAt(0)); // 72 (UTF-16 code unit)
console.log(text.codePointAt(0)); // 72 (Unicode code point)
```

## String Methods for Replacement

```javascript
let text = "Hello, World!";

// Replace first occurrence
console.log(text.replace("Hello", "Hi")); // "Hi, World!"

// Replace all occurrences
let repeatedText = "apple apple apple";
console.log(repeatedText.replace(/apple/g, "orange")); // "orange orange orange"
console.log(repeatedText.replaceAll("apple", "orange")); // "orange orange orange" (ES2021)

// Case-insensitive replacement
console.log(text.replace(/world/i, "Universe")); // "Hello, Universe!"

// Using functions in replace
function capitalize(match) {
  return match.toUpperCase();
}
console.log(text.replace(/\w+/g, capitalize)); // "HELLO, WORLD!"
```

## String Methods for Splitting and Joining

```javascript
let text = "apple,banana,orange";

// Split string into array
console.log(text.split(",")); // ["apple", "banana", "orange"]
console.log(text.split("")); // ["a", "p", "p", "l", "e", ...]
console.log(text.split(",", 2)); // ["apple", "banana"] (limit to 2)

// Join array into string
let fruits = ["apple", "banana", "orange"];
console.log(fruits.join()); // "apple,banana,orange"
console.log(fruits.join(" and ")); // "apple and banana and orange"
console.log(fruits.join("")); // "applebananaorange"
```

## Regular Expressions with Strings

Regular expressions provide powerful pattern matching with strings:

```javascript
let text = "The quick brown fox jumps over the lazy dog.";

// test if pattern exists
console.log(/fox/.test(text)); // true
console.log(/cat/.test(text)); // false

// match - find all matches
console.log(text.match(/[a-z]+/g)); // Array of all lowercase words
console.log(text.match(/(\w+)\s(\w+)/)); // ["quick brown", "quick", "brown"]

// matchAll - returns an iterator (ES2020)
let iterator = text.matchAll(/\b(\w)(\w+)\b/g);
for (const match of iterator) {
  console.log(
    `Word: ${match[0]}, First letter: ${match[1]}, Rest: ${match[2]}`
  );
}
```

## String Normalization

Unicode normalization is important for string comparison:

```javascript
// Different Unicode representations can look the same
let cafe1 = "café"; // with é as single character
let cafe2 = "cafe\u0301"; // with e followed by combining accent

// They look the same but are different
console.log(cafe1 === cafe2); // false
console.log(cafe1.length, cafe2.length); // 4, 5

// Normalize for comparison
console.log(cafe1.normalize() === cafe2.normalize()); // true

// Different normalization forms
console.log(cafe2.normalize("NFC").length); // 4 (composed)
console.log(cafe2.normalize("NFD").length); // 5 (decomposed)
```

## String Localization

For proper internationalization support:

```javascript
// localeCompare for string comparison based on locale
let a = "café";
let b = "cafe";
console.log(a.localeCompare(b)); // 1 (in English locale)
console.log(a.localeCompare(b, "fr")); // Different in French locale

// Case conversion considering locale
console.log("Istanbul".toLocaleLowerCase("tr")); // "istanbul" (Turkish)
console.log("İstanbul".toLocaleLowerCase("en")); // "i̇stanbul" (English)
```

## Raw Strings

Access the raw template string content:

```javascript
// Using String.raw
console.log(String.raw`Hello\nWorld`); // "Hello\nWorld" (escape sequences not processed)

// As tag function
function tag(strings) {
  return strings.raw[0];
}
console.log(tag`Hello\nWorld`); // "Hello\nWorld"
```

## Performance Considerations

```javascript
// Avoid excessive concatenation in loops
let bad = "";
for (let i = 0; i < 1000; i++) {
  bad += "x"; // Creates new string each time
}

// Better approach
let good = [];
for (let i = 0; i < 1000; i++) {
  good.push("x");
}
good = good.join(""); // Single join operation at the end
```

## Common String Patterns

### Check if string contains only letters

```javascript
function isAlpha(str) {
  return /^[A-Za-z]+$/.test(str);
}
console.log(isAlpha("Hello")); // true
console.log(isAlpha("Hello123")); // false
```

### Format numbers with commas

```javascript
function formatNumber(num) {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
console.log(formatNumber(1234567)); // "1,234,567"
```

### Capitalize first letter

```javascript
function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}
console.log(capitalize("hello")); // "Hello"
```

### Check if string is a palindrome

```javascript
function isPalindrome(str) {
  const cleaned = str.toLowerCase().replace(/[^a-z0-9]/g, "");
  const reversed = cleaned.split("").reverse().join("");
  return cleaned === reversed;
}
console.log(isPalindrome("A man, a plan, a canal: Panama")); // true
```

### Truncate string with ellipsis

```javascript
function truncate(str, maxLength) {
  if (str.length > maxLength) {
    return str.slice(0, maxLength - 3) + "...";
  }
  return str;
}
console.log(truncate("The quick brown fox jumps over the lazy dog", 15)); // "The quick bro..."
```

## Best Practices

1. **Use string literals over string objects**

   ```javascript
   // Good
   const str = "Hello";

   // Avoid
   const str = new String("Hello");
   ```

2. **Use template literals for string interpolation**

   ```javascript
   // Good
   const name = "John";
   const greeting = `Hello, ${name}!`;

   // Avoid
   const greeting = "Hello, " + name + "!";
   ```

3. **Be aware of encoding issues**

   ```javascript
   // Always normalize strings before comparing
   const input1 = "café";
   const input2 = "cafe\u0301";

   // Good
   if (input1.normalize() === input2.normalize()) {
     // Strings match
   }
   ```

4. **Avoid excessive concatenation**

   ```javascript
   // Good - for many concatenations
   const parts = ["Hello", "World", "Welcome", "To", "JavaScript"];
   const message = parts.join(" ");

   // Good - for template composition
   const template = `Hello ${name}, welcome to ${site}`;
   ```

5. **Handle empty and null strings properly**
   ```javascript
   function processInput(input) {
     // Check for null, undefined, or empty string
     if (input == null || input === "") {
       return "Default value";
     }
     return input.trim();
   }
   ```

## Exercises

1. Write a function to count the occurrences of a substring in a string.
2. Create a function that converts a string to camelCase.
3. Implement a simple string templating engine.
4. Write a function that validates an email address using regular expressions.
5. Create a function that masks all but the last four characters of a string (like a credit card number).

## Resources

- [MDN Web Docs: String](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String)
- [JavaScript.info: Strings](https://javascript.info/string)
- [Regular Expressions 101](https://regex101.com/) - For testing regular expressions
- [Unicode Standard](https://unicode.org/standard/standard.html)
