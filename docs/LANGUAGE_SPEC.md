# CScript Language Specification

## Overview

CScript is a hybrid programming language that combines syntax elements from JavaScript, TypeScript, C, C++, and C# to create a modern, expressive language suitable for both systems programming and application development.

## Language Features

### 1. Pipeline Operator (`|>`) ✅ Implemented

**Syntax**: `expression |> function`

**Description**: Allows clean left-to-right data transformation chains.

**Examples**:
```cscript
// Simple pipeline
let result = 5 |> square |> double;

// Complex data processing
let processed = data 
    |> (arr => arr.filter(x => x > 0))
    |> (arr => arr.map(x => x * 2))
    |> (arr => arr.reduce((a, b) => a + b));

// Function composition
let transform = compose(
    x => x |> validate |> sanitize |> process
);
```

**Transpiles to**: Function call with reversed argument order
```javascript
// result = double(square(5))
// processed = arr.reduce((a, b) => a + b)(arr.map(x => x * 2)(arr.filter(x => x > 0)(data)))
```

### 2. Match Expressions 🚧 Planned

**Syntax**: `expression match { pattern => result, ... }`

**Description**: Pattern matching alternative to switch statements with destructuring.

**Examples**:
```cscript
// Basic matching
let result = value match {
    0 => "zero",
    1 => "one", 
    2..10 => "small number",
    _ => "large number"
};

// Object destructuring
let response = user match {
    { age: 0..17, status: "student" } => "minor student",
    { age: 18..64, employed: true } => "working adult",
    { age: 65.._, retired: true } => "retiree",
    _ => "unknown category"
};

// Array patterns
let result = list match {
    [] => "empty",
    [x] => `single: ${x}`,
    [x, y] => `pair: ${x}, ${y}`,
    [head, ...tail] => `head: ${head}, tail length: ${tail.length}`
};
```

### 3. Immutable Updates with `with` 🚧 Planned

**Syntax**: `object with { path = value }`

**Description**: Clean syntax for updating nested immutable objects.

**Examples**:
```cscript
// Nested property updates
let newState = state with { 
    user.profile.name = "John",
    user.settings.theme = "dark",
    lastUpdated = Date.now()
};

// Array updates
let newArray = items with { 
    [0] = newFirstItem,
    [length - 1] = newLastItem
};

// Conditional updates
let updated = config with {
    feature.enabled = isProduction ? true : false,
    logging.level = debugMode ? "debug" : "info"
};
```

### 4. LINQ (Language-Integrated Query) 🚧 Planned

**Syntax**: `from variable in collection where condition select projection`

**Description**: C#-inspired syntax for querying collections.

**Examples**:
```cscript
// Basic query
let adults = from person in people 
             where person.age >= 18 
             select person;

// Complex query with joins
let results = from user in users
              join order in orders on user.id equals order.userId
              where order.total > 100
              select { 
                  name: user.name, 
                  total: order.total,
                  date: order.date
              };

// Grouping
let grouped = from sale in sales
              group sale by sale.category into g
              select { 
                  category: g.key, 
                  total: g.sum(s => s.amount),
                  count: g.count()
              };
```

### 5. Auto-Properties 🚧 Planned

**Syntax**: `[access] PropertyName { get; [access] set; }`

**Description**: C#-style automatic property generation.

**Examples**:
```cscript
class User {
    // Auto-implemented properties
    public Name { get; private set; }
    public Email { get; set; }
    public Age { get; private set; }
    
    // Custom getter/setter
    public DisplayName { 
        get => `${this.Name} <${this.Email}>`;
        set => this.Name = value.split('<')[0].trim();
    }
    
    constructor(name: string, email: string, age: number) {
        this.Name = name;
        this.Email = email;
        this.Age = age;
    }
}
```

### 6. Operator Overloading 🚧 Planned

**Syntax**: `operator [op](parameters) { ... }`

**Description**: Define custom behavior for operators on user-defined types.

**Examples**:
```cscript
struct Vector {
    x: number;
    y: number;
    
    // Addition operator
    operator +(other: Vector): Vector {
        return { x: this.x + other.x, y: this.y + other.y };
    }
    
    // Scalar multiplication
    operator *(scalar: number): Vector {
        return { x: this.x * scalar, y: this.y * scalar };
    }
    
    // Equality operator
    operator ==(other: Vector): boolean {
        return this.x === other.x && this.y === other.y;
    }
    
    // String conversion
    operator string(): string {
        return `(${this.x}, ${this.y})`;
    }
}

// Usage
let v1 = Vector { x: 1, y: 2 };
let v2 = Vector { x: 3, y: 4 };
let result = v1 + v2 * 2;  // Vector { x: 7, y: 10 }
```

### 7. Value Types (Structs) 🚧 Planned

**Syntax**: `struct Name { fields... }`

**Description**: C#-style value types for efficient, immutable data structures.

**Examples**:
```cscript
// Basic struct
struct Point {
    x: number;
    y: number;
    
    // Methods
    distanceFrom(other: Point): number {
        return Math.sqrt((this.x - other.x) ** 2 + (this.y - other.y) ** 2);
    }
}

// Generic struct
struct Result<T, E> {
    value?: T;
    error?: E;
    isSuccess: boolean;
    
    static Ok<T>(value: T): Result<T, never> {
        return { value, isSuccess: true };
    }
    
    static Error<E>(error: E): Result<never, E> {
        return { error, isSuccess: false };
    }
}

// Usage
let point1 = Point { x: 0, y: 0 };
let point2 = Point { x: 3, y: 4 };
let distance = point1.distanceFrom(point2);  // 5
```

## Type System

CScript uses a gradual type system similar to TypeScript:

```cscript
// Type annotations (optional)
let name: string = "John";
let age: number = 30;
let isActive: boolean = true;

// Type inference
let inferredString = "Hello";  // string
let inferredNumber = 42;       // number

// Generic types
function identity<T>(arg: T): T {
    return arg;
}

// Union types
let id: string | number = "abc123";

// Interface definitions
interface User {
    name: string;
    email: string;
    age?: number;
}
```

## Compilation Targets

CScript can compile to multiple targets:

1. **JavaScript** (ES5, ES6+, Node.js)
2. **WebAssembly** (for performance-critical applications)
3. **Native Code** (via LLVM backend - future)

## Standard Library

CScript includes a rich standard library with:

- **Collections**: Arrays, Maps, Sets with pipeline-friendly methods
- **Async**: Modern async/await with pipeline support
- **IO**: File system, networking, streams
- **Math**: Extended mathematical functions and operators
- **String**: Enhanced string manipulation with pattern matching

## Interoperability

- **JavaScript**: Full bidirectional compatibility
- **TypeScript**: Import existing TypeScript definitions
- **C/C++**: FFI for native library integration
- **WebAssembly**: Seamless WASM module integration