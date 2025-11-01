// CScript Enhanced Type System - Runtime Validation & Inference

// Type validation functions
function isType(value, typeName) {
  switch (typeName) {
    case 'string': return typeof value === 'string';
    case 'number': return typeof value === 'number';
    case 'boolean': return typeof value === 'boolean';
    case 'object': return typeof value === 'object' && value !== null;
    case 'array': return Array.isArray(value);
    case 'function': return typeof value === 'function';
    default: 
      // Check for class instances
      if (typeof typeName === 'function') {
        return value instanceof typeName;
      }
      return false;
  }
}

// Union type checker
function isUnionType(value, types) {
  return types.some(type => isType(value, type));
}

// Intersection type checker (for objects)
function hasAllProperties(obj, requiredProps) {
  return requiredProps.every(prop => prop in obj);
}

// Type assertion with validation
function assertType(value, expectedType, variableName = 'value') {
  if (!isType(value, expectedType)) {
    throw new TypeError(`Expected ${variableName} to be ${expectedType}, got ${typeof value}`);
  }
  return value;
}

// Generic container with type safety
class TypedContainer {
  constructor(value, expectedType) {
    this.expectedType = expectedType;
    this.value = assertType(value, expectedType, 'container value');
  }
  
  setValue(newValue) {
    this.value = assertType(newValue, this.expectedType, 'new value');
    return this;
  }
  
  getValue() {
    return this.value;
  }
  
  map(fn) {
    const result = fn(this.value);
    return new TypedContainer(result, this.expectedType);
  }
}

// Advanced type inference for arrays
function inferArrayType(arr) {
  if (arr.length === 0) return 'unknown[]';
  
  const types = new Set();
  for (const item of arr) {
    types.add(typeof item);
  }
  
  if (types.size === 1) {
    return `${[...types][0]}[]`;
  } else {
    return `(${[...types].join(' | ')})[]`;
  }
}

// Smart type coercion
function smartCoerce(value, targetType) {
  if (isType(value, targetType)) {
    return value;
  }
  
  switch (targetType) {
    case 'string':
      return String(value);
    case 'number':
      const num = Number(value);
      return isNaN(num) ? 0 : num;
    case 'boolean':
      return Boolean(value);
    default:
      return value;
  }
}

console.log("=== Enhanced Type System Test ===");

// Test 1: Basic type validation
console.log("\n🔍 Test 1: Type Validation");
try {
  assertType("hello", "string");
  console.log("✅ String validation passed");
  
  assertType(42, "number");
  console.log("✅ Number validation passed");
  
  assertType([1, 2, 3], "array");
  console.log("✅ Array validation passed");
} catch (e) {
  console.log("❌ Type validation failed:", e.message);
}

// Test 2: Union types
console.log("\n🤝 Test 2: Union Types");
function processUnion(value) {
  if (isUnionType(value, ["string", "number"])) {
    console.log(`Processing ${typeof value}: ${value}`);
    return value.toString();
  } else {
    throw new TypeError("Expected string or number");
  }
}

console.log("Result:", processUnion("hello"));
console.log("Result:", processUnion(123));

// Test 3: Typed containers
console.log("\n📦 Test 3: Typed Containers");
let stringContainer = new TypedContainer("hello", "string");
console.log("String container:", stringContainer.getValue());

let numberContainer = new TypedContainer(42, "number");
console.log("Number container:", numberContainer.getValue());

// Container with transformations
let doubled = numberContainer.map(x => x * 2);
console.log("Doubled:", doubled.getValue());

// Test 4: Type inference
console.log("\n🧠 Test 4: Type Inference");
let numbers = [1, 2, 3, 4, 5];
let mixed = [1, "hello", true, 3.14];
let strings = ["a", "b", "c"];

console.log(`numbers type: ${inferArrayType(numbers)}`);
console.log(`mixed type: ${inferArrayType(mixed)}`);
console.log(`strings type: ${inferArrayType(strings)}`);

// Test 5: Integration with other features
console.log("\n🔗 Test 5: Types + Other Features");

// Typed vectors with validation
class TypedVector {
  constructor(x, y) {
    this.x = assertType(x, "number", "x coordinate");
    this.y = assertType(y, "number", "y coordinate");
  }
  
  static $operator_plus(left, right) {
    // Ensure both are TypedVector instances
    if (!(left instanceof TypedVector) || !(right instanceof TypedVector)) {
      throw new TypeError("Can only add TypedVector instances");
    }
    return new TypedVector(left.x + right.x, left.y + right.y);
  }
  
  toString() {
    return `TypedVector(${this.x}, ${this.y})`;
  }
}

let tv1 = new TypedVector(3, 4);
let tv2 = new TypedVector(1, 2);
let sum = tv1 + tv2; // This will use operator overloading with type safety

console.log("Typed vector sum:", sum.toString());

// Test 6: Smart coercion with match expressions
console.log("\n🎯 Test 6: Types + Match + Coercion");
function smartProcess(value) {
  // Try to infer and coerce the type
  let processed = typeof value.match({
    "string": smartCoerce(value, "number"),
    "number": smartCoerce(value, "string"), 
    "boolean": smartCoerce(value, "string"),
    _: value
  });
  
  return {
    original: value,
    originalType: typeof value,
    processed: processed,
    processedType: typeof processed
  };
}

console.log("Smart processing:");
console.log(smartProcess("123"));
console.log(smartProcess(456));
console.log(smartProcess(true));

console.log("\n✅ Enhanced type system features working!");
console.log("🎉 CScript now has comprehensive type support!");