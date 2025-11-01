// CScript Operator Overloading - Expression Transformation Test

// Vector class with operator overloading
class Vector {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
  
  // Operator overload methods
  static $operator_plus(left, right) {
    return new Vector(left.x + right.x, left.y + right.y);
  }
  
  static $operator_minus(left, right) {
    return new Vector(left.x - right.x, left.y - right.y);
  }
  
  static $operator_multiply(left, right) {
    if (typeof right === 'number') {
      return new Vector(left.x * right, left.y * right);
    }
    return left.x * right.x + left.y * right.y; // dot product
  }
  
  static $operator_equals(left, right) {
    return left.x === right.x && left.y === right.y;
  }
  
  toString() {
    return `Vector(${this.x}, ${this.y})`;
  }
}

console.log("=== Operator Expression Transformation Test ===");

// Create test vectors
let v1 = new Vector(3, 4);
let v2 = new Vector(1, 2);

console.log("v1:", v1.toString());
console.log("v2:", v2.toString());

// These expressions should be transformed by the transpiler:
console.log("\n--- Testing Operator Transformations ---");

// Basic arithmetic (should become Vector.$operator_plus(v1, v2))
let sum = v1 + v2;
console.log("v1 + v2 =", sum.toString());

// Subtraction (should become Vector.$operator_minus(v1, v2))
let diff = v1 - v2;
console.log("v1 - v2 =", diff.toString());

// Scalar multiplication (should become Vector.$operator_multiply(v1, 2))
let scaled = v1 * 2;
console.log("v1 * 2 =", scaled.toString());

// Vector dot product (should become Vector.$operator_multiply(v1, v2))
let dot = v1 * v2;
console.log("v1 * v2 =", dot);

// Comparison (should become Vector.$operator_equals(v1, v2))
let isEqual = v1 == v2;
console.log("v1 == v2 =", isEqual);

// Complex expressions
console.log("\n--- Complex Expressions ---");

// Should transform both operators
let complex1 = v1 + v2 - v1;
console.log("(v1 + v2) - v1 =", complex1.toString());

// Should work with parentheses and precedence
let complex2 = (v1 + v2) * 3;
console.log("(v1 + v2) * 3 =", complex2.toString());

console.log("\n✅ Operator overloading expressions ready for transpilation!");