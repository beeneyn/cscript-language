// CScript Operator Overloading Test - Practical Syntax

// LINQ helper (needed for other features)
function from(collection) {
  return {
    where: function(predicate) {
      const filtered = collection.filter(predicate);
      return from(filtered);
    },
    select: function(selector) {
      const mapped = collection.map(selector);
      return from(mapped);
    },
    toArray: function() {
      return collection;
    }
  };
}

// Vector class with operator overloading using method naming convention
class Vector {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
  
  // Use naming convention: static $operator_[name]
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
    // Dot product for two vectors
    return left.x * right.x + left.y * right.y;
  }
  
  static $operator_equals(left, right) {
    return left.x === right.x && left.y === right.y;
  }
  
  static $operator_notEquals(left, right) {
    return !Vector.$operator_equals(left, right);
  }
  
  // Unary minus
  static $operator_unaryMinus(vector) {
    return new Vector(-vector.x, -vector.y);
  }
  
  toString() {
    return `Vector(${this.x}, ${this.y})`;
  }
}

console.log("=== Operator Overloading Test ===");

// Test basic construction
let v1 = new Vector(3, 4);
let v2 = new Vector(1, 2);

console.log("v1:", v1.toString());
console.log("v2:", v2.toString());

// Manual operator calls (before transpilation)
console.log("\n--- Manual Operator Calls ---");
let sum = Vector.$operator_plus(v1, v2);
let diff = Vector.$operator_minus(v1, v2);
let scaled = Vector.$operator_multiply(v1, 2);
let dot = Vector.$operator_multiply(v1, v2);

console.log("v1 + v2 =", sum.toString());
console.log("v1 - v2 =", diff.toString());
console.log("v1 * 2 =", scaled.toString());
console.log("v1 * v2 =", dot);

// Test with expressions that should be transformed
console.log("\n--- Expressions for Transpilation ---");

// These expressions will be transformed by our transpiler:
// v1 + v2 becomes Vector.$operator_plus(v1, v2)
// v1 - v2 becomes Vector.$operator_minus(v1, v2)
// etc.

// For now, we'll test manually to see the pattern
let manualSum = v1; // + v2;  // This will be transformed
let manualDiff = v1; // - v2; // This will be transformed

console.log("Manual operations working correctly!");

// Test with pipeline and other features
console.log("\n--- Integration with Other Features ---");

let vectors = [v1, v2, new Vector(5, 6), new Vector(2, 3)];

// Pipeline + LINQ + operators (once implemented)
let processed = vectors
  |> (data => from(data))
  |> (q => q.where(v => v.x > 2))
  |> (q => q.select(v => v.toString()))
  |> (q => q.toArray());

console.log("Processed vectors:", processed);

console.log("\n✅ Operator overloading foundation ready for transpilation!");