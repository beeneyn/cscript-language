# CScript Language 🚀# CScript Language 🚀# CScript - Hybrid Programming Language



CScript is a modern hybrid programming language that combines the best features from JavaScript, TypeScript, C, C++, and C#. It provides powerful syntactic sugar and advanced features while transpiling to clean, readable JavaScript.



## 🌟 Key FeaturesCScript is a modern hybrid programming language that combines the best features from JavaScript, TypeScript, C, C++, and C#. It provides powerful syntactic sugar and advanced features while transpiling to clean, readable JavaScript.A modern programming language that combines the best syntax features from JavaScript, TypeScript, C, C++, and C# into a unified, expressive language with powerful pipeline operators and advanced language constructs.



### ✅ Fully Implemented



#### Pipeline Operators## 🌟 Key Features## 🎯 Language Vision

Transform data with elegant pipeline syntax:

```cscript

const result = data |> filter(x => x > 5) |> map(x => x * 2) |> sum;

```### ✅ Fully ImplementedCScript aims to provide developers with familiar syntax patterns from multiple popular languages, allowing for:



#### Match Expressions- **JavaScript/TypeScript**: Dynamic typing, modern ES6+ features, and flexibility

Pattern matching with comprehensive support:

```cscript#### Pipeline Operators- **C/C++**: Performance-oriented constructs, operator overloading, and low-level control

const result = value match {

  1..10 => "Small number",Transform data with elegant pipeline syntax:- **C#**: Modern OOP features, LINQ-style queries, and clean syntax patterns

  string s when s.startsWith("test") => "Test string",

  { type: "user", active: true } => "Active user",```cscript- **Pipeline Operators**: Functional programming with clean data transformation chains

  _ => "Default case"

};const result = data |> filter(x => x > 5) |> map(x => x * 2) |> sum;

```

```## ✨ Planned Features

#### LINQ Queries

SQL-like query syntax for JavaScript:

```cscript

const result = from users#### Match Expressions### ✅ Currently Implemented

               where user => user.age > 18

               select user => ({ name: user.name, email: user.email })Pattern matching with comprehensive support:1. **Pipeline Operator (`|>`)**: Clean, left-to-right function chaining

               orderBy user => user.name;

``````cscript   ```cscript



#### With Updatesconst result = value match {   data |> filter |> map |> reduce

Immutable object updates made simple:

```cscript  1..10 => "Small number",   ```

const updated = user withUpdate {

  profile.name = "New Name",  string s when s.startsWith("test") => "Test string",

  settings.theme = "dark"

};  { type: "user", active: true } => "Active user",### 🚧 In Development

```

  _ => "Default case"2. **Match Expressions**: Powerful pattern matching alternative to switch statements

#### Auto-Properties

Automatic getter/setter generation:};   ```cscript

```cscript

class User {```   result = value match {

  name: string { get; set; }

  age: number { get; private set; }       0 => "zero",

}

```#### LINQ Queries       1..10 => "small", 



#### Operator OverloadingSQL-like query syntax for JavaScript:       _ => "large"

Custom operators for user-defined types:

```cscript```cscript   }

class Vector {

  $operator_+(other) { return new Vector(this.x + other.x, this.y + other.y); }const result = from users   ```

  $operator_==(other) { return this.x === other.x && this.y === other.y; }

}               where user => user.age > 18

```

               select user => ({ name: user.name, email: user.email })3. **Simplified Immutable Updates**: Clean nested object updates with `with` keyword

#### Enhanced Type System

Runtime type validation and smart coercion:               orderBy user => user.name;   ```cscript

```cscript

function process(value: number | string) : number {```   newState = state with { user.settings.theme = "dark" }

  // Automatic type coercion and validation

  return value;   ```

}

```#### With Updates



## 📦 InstallationImmutable object updates made simple:### 📋 Planned Features



```bash```cscript4. **LINQ (Language-Integrated Query)**: C#-inspired syntax for querying data

npm install -g cscript-language

```const updated = user withUpdate {   ```cscript



## 🚀 Quick Start  profile.name = "New Name",   result = from p in people where p.age > 65 select p.name



1. **Create a CScript file:**  settings.theme = "dark"   ```

```cscript

// hello.csc};

const numbers = [1, 2, 3, 4, 5];

const result = numbers |> filter(x => x % 2 === 0) |> map(x => x * x);```5. **C# Auto-Properties**: Shorthand for defining class properties

console.log(result);

```   ```cscript



2. **Transpile and run:**#### Auto-Properties   public Name { get; private set; }

```bash

cscript hello.cscAutomatic getter/setter generation:   ```

```

```cscript

3. **Create configuration (optional):**

```bashclass User {6. **C++ Operator Overloading**: Custom behavior for operators on classes

cscript --init  # Creates csconfig.json

```  name: string { get; set; }   ```cscript



## 🛠 Usage  age: number { get; private set; }   Vector + Vector  // Custom addition for Vector class



### Command Line Interface}   ```

```bash

# Transpile a CScript file```

cscript input.csc

7. **Value Types (`struct`)**: C#-style structs for efficient data structures

# Transpile and save output

cscript input.csc -o output.js#### Operator Overloading   ```cscript



# Create default configurationCustom operators for user-defined types:   struct Point { x: number; y: number; }

cscript --init

```cscript   ```

# View help and all features

cscript --helpclass Vector {

```

  $operator_+(other) { return new Vector(this.x + other.x, this.y + other.y); }## 📝 Example

### Configuration File

Create `csconfig.json` to customize CScript behavior:  $operator_==(other) { return this.x === other.x && this.y === other.y; }

```json

{}**Current CScript (Pipeline Operators):**

  "languageFeatures": {

    "pipelineOperators": true,``````cscript

    "matchExpressions": true,

    "linqQueries": true,// Helper functions

    "operatorOverloading": true

  },#### Enhanced Type Systemfunction square(n) { return n * n; }

  "compilerOptions": {

    "target": "ES2020",Runtime type validation and smart coercion:function add(a, b) { return a + b; }

    "sourceMap": true

  }```cscript

}

```function process(value: number | string) : number {// Clean pipeline syntax



### Programmatic API  // Automatic type coercion and validationlet result = 5 |> square |> (n => add(n, 10));  // 35

```javascript

import { transpile } from 'cscript-language';  return value;



const cscriptCode = `}// Complex data processing  

  const data = [1, 2, 3] |> map(x => x * 2);

`;```let processed = users



const jsCode = transpile(cscriptCode);    |> (list => list.filter(u => u.active))

console.log(jsCode);

```## 📦 Installation    |> (list => list.map(u => ({ ...u, displayName: `${u.first} ${u.last}` })))



## 📁 Project Structure    |> (list => list.sort((a, b) => a.last.localeCompare(b.last)));



``````bash```

cscript/

├── src/           # TypeScript source filesnpm install -g cscript-language

├── dist/          # Compiled JavaScript output

├── tests/         # CScript test files```**Future CScript (Full Language):**

├── examples/      # Example CScript programs

├── docs/          # Documentation```cscript

├── outputs/       # Test outputs

└── vscode-extension/  # VS Code extension## 🚀 Quick Start// Match expressions for pattern matching

```

let categorize = (user) => user.age match {

## 🧪 Testing

1. **Create a CScript file:**    0..17 => "minor",

Run the test suite:

```bash```cscript    18..64 when user.employed => "working adult",

npm test

```// hello.csc    65.._ => "senior"



Run specific examples:const numbers = [1, 2, 3, 4, 5];};

```bash

npm run cli tests/test-phase4-complete.cscconst result = numbers |> filter(x => x % 2 === 0) |> map(x => x * x);

```

console.log(result);// LINQ for data queries  

## 🔧 Development

```let expensiveOrders = 

1. **Clone the repository:**

```bash    from order in orders

git clone https://github.com/beeneyn/cscript-language.git

cd cscript-language2. **Transpile and run:**    join user in users on order.userId equals user.id

```

```bash    where order.total > 500

2. **Install dependencies:**

```bashcscript hello.csc    select { userName: user.name, total: order.total };

npm install

``````



3. **Build the project:**// Immutable updates with 'with'

```bash

npm run build## 🛠 Usagelet updated = user with { 

```

    preferences.theme = "dark",

4. **Run in development mode:**

```bash### Command Line Interface    lastLogin = Date.now() 

npm run dev

``````bash};



## 📖 Documentation# Transpile a CScript file



- [Language Specification](docs/LANGUAGE_SPEC.md)cscript input.csc// Operator overloading on structs

- [Configuration Guide](docs/CONFIGURATION.md)

- [Roadmap](docs/ROADMAP.md)struct Vector { x: number; y: number; }

- [Contributing Guide](docs/CONTRIBUTING.md)

# Transpile and save outputoperator +(a: Vector, b: Vector) => Vector { x: a.x + b.x, y: a.y + b.y };

## 🎨 VS Code Extension

cscript input.csc -o output.js

CScript includes a VS Code extension with:

- Syntax highlightinglet result = Vector{1,2} + Vector{3,4};  // Vector{4,6}

- Auto-transpilation on save

- Integrated build commands# Watch mode (requires additional setup)```

- IntelliSense support

cscript input.csc --watch

Install from the VS Code marketplace or build locally from the `vscode-extension/` directory.

```**Transpiled JavaScript Output:**

## 🤝 Contributing

```javascript

We welcome contributions! Please see our [Contributing Guide](docs/CONTRIBUTING.md) for details.

### Programmatic API// Current: Clean function call chains

## 📄 License

```javascriptlet result = add(square(5), 10);

MIT License - see [LICENSE](LICENSE) file for details.

import { transpile } from 'cscript-language';let processed = list.sort((a, b) => a.last.localeCompare(b.last))(

## 🏗 Architecture

    list.map(u => ({ ...u, displayName: `${u.first} ${u.last}` }))(

CScript uses Babel for AST parsing and transformation:

- **Parser**: Babel parser with custom pluginsconst cscriptCode = `        list.filter(u => u.active)(users)

- **Transformer**: Custom AST visitors for each language feature

- **Generator**: Babel generator for clean JavaScript output  const data = [1, 2, 3] |> map(x => x * 2);    )

- **Type System**: Runtime validation with compile-time inference

`;);

## 🌐 Examples

```

Check out the `examples/` directory for comprehensive usage examples:

- Basic syntax and featuresconst jsCode = transpile(cscriptCode);

- Advanced pattern matching

- LINQ query examplesconsole.log(jsCode);## 🛠️ Installation

- Operator overloading demos

- Real-world applications```



## 🚧 Status```bash



CScript is ready for production use! All major features are implemented and tested:## 📁 Project Structure# Clone the repository



- ✅ Pipeline Operatorsgit clone https://github.com/beeneyn/cscript-language.git

- ✅ Match Expressions  

- ✅ LINQ Queries```cd cscript-language

- ✅ With Updates

- ✅ Auto-Propertiescscript/

- ✅ Operator Overloading

- ✅ Enhanced Type System├── src/           # TypeScript source files# Install dependencies

- ✅ VS Code Extension

- ✅ NPM Package├── dist/          # Compiled JavaScript outputnpm install

- ✅ Configuration System

├── tests/         # CScript test files```

## 📬 Support

├── examples/      # Example CScript programs

- GitHub Issues: [Report bugs or request features](https://github.com/beeneyn/cscript-language/issues)

- Discussions: [Community discussions](https://github.com/beeneyn/cscript-language/discussions)├── docs/          # Documentation## 🚀 Current Status



---├── outputs/       # Test outputs



Made with ❤️ by the CScript team└── vscode-extension/  # VS Code extension**✅ Implemented Features:**

```- **Pipeline operators (`|>`)** with full support for:

  - Simple function chaining: `5 |> square |> double`

## 🧪 Testing  - Complex expressions: `data |> filter |> map |> reduce` 

  - Arrow functions: `x |> (n => n * 2) |> display`

Run the test suite:- **Match expressions** with pattern matching:

```bash  - Literal patterns: `value.match({ 0: "zero", 1: "one" })`

npm test  - Range patterns: `age.match({ "0..17": "minor", "18..64": "adult" })`

```  - Wildcard patterns: `value.match({ "specific": "case", _: "default" })`

- **Immutable updates** with `withUpdate()` function:

Run specific examples:  - Simple updates: `withUpdate(user, { age: 31 })`

```bash  - Nested updates: `withUpdate(user, { preferences: { theme: "dark" } })`

npm run cli tests/test-phase4-complete.csc  - Multiple properties: `withUpdate(obj, { prop1: val1, prop2: val2 })`

```- Complete TypeScript-based transpiler infrastructure

- CLI tool for transpilation and testing

## 🔧 Development- Comprehensive test suite with real-world examples



1. **Clone the repository:****🚧 In Development:**

```bash- Enhanced type system with union and intersection types

git clone https://github.com/beeneyn/cscript-language.git- Better error handling and source maps

cd cscript-language- Performance optimizations

```

**📋 Planned (See [ROADMAP.md](ROADMAP.md)):**

2. **Install dependencies:**- Native `with` keyword syntax (currently using function)

```bash- LINQ query syntax

npm install- Auto-properties for classes  

```- Operator overloading

- Value types (structs)

3. **Build the project:**- WebAssembly compilation target

```bash

npm run build## 🎯 Usage

```

### Command Line Interface

4. **Run in development mode:**

```bash```bash

npm run dev# Transpile and display output

```npm run cli input.csc



## 📖 Documentation# Transpile and save to file

npm run cli input.csc output.js

- [Language Specification](docs/LANGUAGE_SPEC.md)

- [Roadmap](docs/ROADMAP.md)# Run the built-in test

- [Contributing Guide](docs/CONTRIBUTING.md)npm start



## 🎨 VS Code Extension# Show help

npm run cli --help

CScript includes a VS Code extension with:```

- Syntax highlighting

- Auto-transpilation on save### Programmatic API

- Integrated build commands

- IntelliSense support```typescript

import { transpile } from './transpile.ts';

Install from the VS Code marketplace or build locally from the `vscode-extension/` directory.

const cscriptCode = `

## 🤝 Contributing  let result = 5 |> square |> (n => add(n, 10));

`;

We welcome contributions! Please see our [Contributing Guide](docs/CONTRIBUTING.md) for details.

const jsCode = transpile(cscriptCode);

## 📄 Licenseconsole.log(jsCode);

```

MIT License - see [LICENSE](LICENSE) file for details.

### Examples

## 🏗 Architecture

**Input CScript:**

CScript uses Babel for AST parsing and transformation:```javascript

- **Parser**: Babel parser with custom plugins// Multiple pipeline operations

- **Transformer**: Custom AST visitors for each language featurelet result1 = 5 |> square;                                    // Simple

- **Generator**: Babel generator for clean JavaScript outputlet result2 = 5 |> square |> (n => add(n, 10));             // Chained  

- **Type System**: Runtime validation with compile-time inferencelet result3 = 3 |> square |> (n => multiply(n, 2)) |> (n => add(n, 1)); // Complex



## 🌐 Examples// Array operations

let arr = [1, 2, 3];

Check out the `examples/` directory for comprehensive usage examples:let sum = arr |> (a => a.map(square)) |> (a => a.reduce((x, y) => x + y));

- Basic syntax and features```

- Advanced pattern matching

- LINQ query examples**Output JavaScript:**

- Operator overloading demos```javascript

- Real-world applications// Transpiled function calls

let result1 = square(5);

## 🚧 Statuslet result2 = (n => add(n, 10))(square(5));

let result3 = (n => add(n, 1))((n => multiply(n, 2))(square(3)));

CScript is ready for production use! All major features are implemented and tested:

// Array operations

- ✅ Pipeline Operatorslet arr = [1, 2, 3];

- ✅ Match Expressions  let sum = (a => a.reduce((x, y) => x + y))((a => a.map(square))(arr));

- ✅ LINQ Queries```

- ✅ With Updates

- ✅ Auto-Properties## 📁 Project Structure

- ✅ Operator Overloading

- ✅ Enhanced Type System```

- ✅ VS Code Extensioncscript/

- ✅ NPM Package├── transpile.ts    # Core transpiler logic

├── run.ts          # Test runner with examples

## 📬 Support├── cli.ts          # Command-line interface

├── test.csc        # Example CScript file with test cases

- GitHub Issues: [Report bugs or request features](https://github.com/beeneyn/cscript-language/issues)├── package.json    # Project configuration

- Discussions: [Community discussions](https://github.com/beeneyn/cscript-language/discussions)└── tsconfig.json   # TypeScript configuration

```

---

## 🔧 How It Works

Made with ❤️ by the CScript team
1. **Parse**: Uses Babel parser to create an AST from CScript code
2. **Transform**: Traverses the AST and converts pipeline expressions to function calls
3. **Generate**: Uses Babel generator to output standard JavaScript

The transpiler specifically looks for `PipelineExpression` nodes and transforms them:
- `a |> b` becomes `b(a)`
- `a |> b |> c` becomes `c(b(a))`

## 🧪 Development

```bash
# Run the transpiler
npm start

# The project uses ts-node for TypeScript execution
# Modify test.csc to test different pipeline expressions
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Future Enhancements

- [ ] Support for more pipeline operators (`|>>`, `<|`)
- [ ] Better error handling and source maps
- [ ] CLI tool for batch processing
- [ ] Integration with build tools (Webpack, Rollup)
- [ ] VS Code extension for syntax highlighting

## 🏷️ Tags

`programming-language` `transpiler` `pipeline-operator` `match-expressions` `linq` `operator-overloading` `value-types` `functional-programming` `javascript` `typescript` `csharp` `cplusplus`

---

**Learn More:**
- [Language Specification](LANGUAGE_SPEC.md) - Detailed syntax and feature documentation
- [Development Roadmap](ROADMAP.md) - Implementation timeline and priorities  
- [Contributing Guide](CONTRIBUTING.md) - How to contribute to CScript
- [Examples](examples/) - Code samples showcasing CScript features
