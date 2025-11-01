# CScript Enhanced Type System Design

## Union Types
```cscript
// Type definition syntax
type NumberOrString = number | string;
type Status = "pending" | "approved" | "rejected";

// Usage
function process(value: NumberOrString): string {
  return value.toString();
}

let status: Status = "pending";
```

## Intersection Types
```cscript
// Combining object types
type Named = { name: string };
type Aged = { age: number };
type Person = Named & Aged;

// Usage
let person: Person = { name: "Alice", age: 30 };
```

## Type Guards and Narrowing
```cscript
function isString(value: unknown): value is string {
  return typeof value === "string";
}

function example(value: NumberOrString) {
  if (isString(value)) {
    // value is narrowed to string here
    console.log(value.toUpperCase());
  } else {
    // value is narrowed to number here
    console.log(value.toFixed(2));
  }
}
```

## Generic Types
```cscript
// Generic function
function identity<T>(arg: T): T {
  return arg;
}

// Generic class
class Container<T> {
  private value: T;
  
  constructor(val: T) {
    this.value = val;
  }
  
  getValue(): T {
    return this.value;
  }
}
```

## Advanced Type Inference
```cscript
// Automatic type inference
let numbers = [1, 2, 3]; // inferred as number[]
let mixed = [1, "hello", true]; // inferred as (number | string | boolean)[]

// Function return type inference
function createUser(name: string, age: number) {
  return { name, age, isActive: true }; // inferred as { name: string, age: number, isActive: boolean }
}
```

## Implementation Strategy

1. **Type Declaration Parser**: Recognize `type` keyword and union/intersection syntax
2. **Type Registry**: Track user-defined types and their definitions
3. **Type Checker**: Validate assignments and function calls
4. **Type Inference Engine**: Deduce types from context and usage
5. **Generic Support**: Handle parameterized types with constraints

## Transpilation Approach

Since we're transpiling to JavaScript, the type system will be:
1. **Compile-time only**: Types removed in output JavaScript
2. **Runtime validation**: Optional runtime type checks for debugging
3. **Documentation**: Types preserved in comments for tooling
4. **Integration**: Work seamlessly with existing CScript features