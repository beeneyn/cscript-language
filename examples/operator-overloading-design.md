# CScript Operator Overloading Design

## Syntax Design (C#-inspired)

```cscript
class Vector {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
  
  // Binary operators
  static operator +(left, right) {
    return new Vector(left.x + right.x, left.y + right.y);
  }
  
  static operator -(left, right) {
    return new Vector(left.x - right.x, left.y - right.y);
  }
  
  static operator *(left, scalar) {
    if (typeof scalar === 'number') {
      return new Vector(left.x * scalar, left.y * scalar);
    }
    // Dot product if both vectors
    return left.x * scalar.x + left.y * scalar.y;
  }
  
  // Comparison operators
  static operator ==(left, right) {
    return left.x === right.x && left.y === right.y;
  }
  
  static operator !=(left, right) {
    return !(left == right);
  }
  
  // Unary operators
  static operator -(vector) {
    return new Vector(-vector.x, -vector.y);
  }
  
  // String conversion
  toString() {
    return `(${this.x}, ${this.y})`;
  }
}
```

## Usage Examples

```cscript
let v1 = new Vector(3, 4);
let v2 = new Vector(1, 2);

// Binary operations
let sum = v1 + v2;        // Vector(4, 6)
let diff = v1 - v2;       // Vector(2, 2)
let scaled = v1 * 2;      // Vector(6, 8)
let dot = v1 * v2;        // 11 (dot product)

// Comparisons
let equal = v1 == v2;     // false
let notEqual = v1 != v2;  // true

// Unary operations
let negated = -v1;        // Vector(-3, -4)

// Complex expressions
let result = (v1 + v2) * 2 - v1;
```

## Transpilation Strategy

1. **Parse operator methods**: Detect `static operator +` syntax
2. **Track overloaded types**: Build registry of which types have which operators
3. **Transform expressions**: Replace `a + b` with `TypeA.__operator_plus(a, b)` when appropriate
4. **Fallback to native**: Use native operators for primitive types

## Implementation Plan

1. Add operator method detection to AST visitor
2. Build operator registry during transpilation
3. Transform binary/unary expressions based on operand types
4. Generate static operator methods in transpiled classes