// 🚀 CScript Ultimate Language Demonstration
// Showcasing ALL features working in perfect harmony

// ===============================================
// 🎯 ENHANCED TYPE SYSTEM
// ===============================================

function isType(value, typeName) {
  switch (typeName) {
    case 'string': return typeof value === 'string';
    case 'number': return typeof value === 'number';
    case 'boolean': return typeof value === 'boolean';
    case 'array': return Array.isArray(value);
    default: return typeof typeName === 'function' ? value instanceof typeName : false;
  }
}

function assertType(value, expectedType, name = 'value') {
  if (!isType(value, expectedType)) {
    throw new TypeError(`Expected ${name} to be ${expectedType}, got ${typeof value}`);
  }
  return value;
}

// ===============================================
// 🔍 LINQ QUERY SYSTEM
// ===============================================

function from(collection) {
  return {
    where: function(predicate) {
      return from(collection.filter(predicate));
    },
    select: function(selector) {
      return from(collection.map(selector));
    },
    orderBy: function(keySelector) {
      const sorted = [...collection].sort((a, b) => {
        const aKey = keySelector(a);
        const bKey = keySelector(b);
        return aKey < bKey ? -1 : aKey > bKey ? 1 : 0;
      });
      return from(sorted);
    },
    groupBy: function(keySelector) {
      const groups = {};
      for (let item of collection) {
        const key = keySelector(item);
        if (!groups[key]) groups[key] = [];
        groups[key].push(item);
      }
      return Object.keys(groups).map(key => ({
        key: key,
        items: groups[key],
        count: () => groups[key].length,
        sum: selector => groups[key].reduce((acc, item) => acc + selector(item), 0),
        average: selector => groups[key].reduce((acc, item) => acc + selector(item), 0) / groups[key].length
      }));
    },
    toArray: function() {
      return collection;
    }
  };
}

// ===============================================
// 🧮 MATHEMATICAL TYPES WITH OPERATOR OVERLOADING
// ===============================================

class Vector3D {
  constructor(x, y, z) {
    this.x = assertType(x, "number", "x coordinate");
    this.y = assertType(y, "number", "y coordinate"); 
    this.z = assertType(z, "number", "z coordinate");
  }
  
  // ➕ Vector Addition
  static $operator_plus(left, right) {
    return new Vector3D(left.x + right.x, left.y + right.y, left.z + right.z);
  }
  
  // ➖ Vector Subtraction
  static $operator_minus(left, right) {
    return new Vector3D(left.x - right.x, left.y - right.y, left.z - right.z);
  }
  
  // ✖️ Scalar Multiplication or Dot Product
  static $operator_multiply(left, right) {
    if (typeof right === 'number') {
      return new Vector3D(left.x * right, left.y * right, left.z * right);
    }
    // Dot product
    return left.x * right.x + left.y * right.y + left.z * right.z;
  }
  
  // 🟰 Vector Equality
  static $operator_equals(left, right) {
    return Math.abs(left.x - right.x) < 0.001 && 
           Math.abs(left.y - right.y) < 0.001 && 
           Math.abs(left.z - right.z) < 0.001;
  }
  
  magnitude() {
    return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
  }
  
  toString() {
    return `Vector3D(${this.x.toFixed(2)}, ${this.y.toFixed(2)}, ${this.z.toFixed(2)})`;
  }
}

class Particle {
  constructor(position, velocity, mass) {
    this.position = assertType(position, Vector3D, "position");
    this.velocity = assertType(velocity, Vector3D, "velocity");
    this.mass = assertType(mass, "number", "mass");
    this.forces = [];
  }
  
  get energy() {
    return 0.5 * this.mass * (this.velocity * this.velocity);
  }
  
  set energy(value) {
    // This would be a complex calculation in real physics
    console.log(`Setting energy to ${value} (auto-property demo)`);
  }
  
  addForce(force) {
    this.forces.push(assertType(force, Vector3D, "force"));
    return this;
  }
  
  toString() {
    return `Particle(pos: ${this.position.toString()}, vel: ${this.velocity.toString()}, mass: ${this.mass})`;
  }
}

console.log("🚀 === CScript Ultimate Language Demonstration ===");
console.log("Showcasing ALL features in perfect harmony!\n");

// ===============================================
// 🎬 DEMO 1: Complex Physics Simulation
// ===============================================

console.log("⚛️  DEMO 1: Physics Simulation with All Features");

// Create particles with type safety
let particles = [
  new Particle(new Vector3D(0, 0, 0), new Vector3D(1, 0, 0), 1.0),
  new Particle(new Vector3D(1, 1, 0), new Vector3D(-0.5, 0.5, 0), 2.0),
  new Particle(new Vector3D(2, 0, 1), new Vector3D(0, 1, -0.5), 1.5)
];

// Physics simulation using ALL CScript features
let simulationStep = particles
  |> (data => from(data))  // 🔍 Convert to LINQ
  |> (q => q.where(p => p.mass > 1.0))  // Filter heavy particles
  |> (q => q.select(p => {  // Transform each particle
      // 🎯 Match expression for force calculation
      let environmentalForce = p.position.y.match({
        "0..0.5": new Vector3D(0, -0.1, 0),     // Weak gravity
        "0.5..1.5": new Vector3D(0, -0.2, 0),   // Medium gravity
        "1.5..10": new Vector3D(0, -0.5, 0),    // Strong gravity
        _: new Vector3D(0, 0, 0)                // No gravity
      });
      
      // 🔄 Immutable update with physics calculations
      return withUpdate(p, {
        // ➕ Vector addition with operator overloading
        velocity: p.velocity + environmentalForce * 0.1,
        position: p.position + p.velocity * 0.1,
        energy: p.energy,  // 👤 Auto-property access
        step: "simulated"
      });
    }))
  |> (q => q.orderBy(p => p.energy))  // Sort by energy
  |> (q => q.toArray());  // Execute query

console.log("Simulation results:");
simulationStep.forEach((p, i) => {
  console.log(`  ${i + 1}. ${p.toString()}`);
  console.log(`     Energy: ${p.energy.toFixed(4)}`);
});

// ===============================================
// 🎬 DEMO 2: Data Analysis Pipeline
// ===============================================

console.log("\n📊 DEMO 2: Advanced Data Analysis");

let dataset = [
  { id: 1, name: "Alpha", value: 23.5, category: "A", active: true },
  { id: 2, name: "Beta", value: 45.2, category: "B", active: false },
  { id: 3, name: "Gamma", value: 12.8, category: "A", active: true },
  { id: 4, name: "Delta", value: 67.1, category: "C", active: true },
  { id: 5, name: "Epsilon", value: 34.9, category: "B", active: true }
];

// Complex analysis using query object syntax (LINQ feature)
let analysis = {
  from: dataset,
  where: [
    item => item.active,
    item => item.value > 20
  ],
  select: item => ({
    ...item,
    // 🎯 Match expression for classification
    classification: item.value.match({
      "0..25": "low",
      "25..50": "medium", 
      "50..100": "high",
      _: "extreme"
    }),
    // Complex calculation using spread and pipeline concepts
    normalizedValue: item.value / 100,
    category_enhanced: item.category + "_processed"
  }),
  orderBy: item => item.value
};

console.log("Data analysis results:", analysis);

// ===============================================
// 🎬 DEMO 3: Advanced Vector Mathematics
// ===============================================

console.log("\n🧮 DEMO 3: Vector Mathematics Showcase");

let v1 = new Vector3D(1, 2, 3);
let v2 = new Vector3D(4, 5, 6);
let v3 = new Vector3D(1, 0, 0);

// Complex vector operations using operator overloading
console.log("Vector operations:");
console.log(`v1 = ${v1.toString()}`);
console.log(`v2 = ${v2.toString()}`);
console.log(`v3 = ${v3.toString()}`);

// ➕➖✖️ Chain of operations
let result1 = (v1 + v2) * 2 - v3;
console.log(`(v1 + v2) * 2 - v3 = ${result1.toString()}`);

// Dot products and comparisons
let dotProduct = v1 * v2;
let isEqual = v1 == v2;
console.log(`v1 • v2 = ${dotProduct.toFixed(2)}`);
console.log(`v1 == v2 = ${isEqual}`);

// ===============================================
// 🎬 DEMO 4: Ultimate Feature Combination
// ===============================================

console.log("\n🌟 DEMO 4: Ultimate Feature Combination");

// Create a complex scenario that uses EVERY feature
let complexScenario = particles
  |> (data => withUpdate(data[0], {  // 🔄 Immutable update
      metadata: {
        processed: true,
        algorithm: "CScript-Ultimate"
      }
    }))
  |> (updated => [updated, ...particles.slice(1)])  // Reconstruct array
  |> (allParticles => ({  // 🔍 LINQ object query
      from: allParticles,
      where: p => p.mass.match({  // 🎯 Match in LINQ condition
        "0..1": false,
        "1..3": true,
        _: false
      }),
      select: p => ({
        particle: p,
        // ➕ Operator overloading in query
        futurePosition: p.position + p.velocity * 5,
        energyClass: p.energy.match({
          "0..0.5": "low-energy",
          "0.5..2": "medium-energy", 
          "2..10": "high-energy",
          _: "extreme-energy"
        })
      })
    }))
  |> (queryResult => queryResult);  // 🔗 Pipeline completion

console.log("Ultimate scenario result:", complexScenario);

// ===============================================
// 🏆 FINALE
// ===============================================

console.log("\n🏆 === CScript Language Features Complete! ===");
console.log("✅ Pipeline Operators (|>) - Functional composition");
console.log("✅ Match Expressions - Pattern matching with ranges/wildcards");
console.log("✅ Immutable Updates - withUpdate() for clean state changes");
console.log("✅ Auto-Properties - Automatic getter/setter generation");
console.log("✅ LINQ Queries - Multiple syntax styles for data querying");
console.log("✅ Operator Overloading - Custom operators for user types");
console.log("✅ Enhanced Type System - Runtime validation and inference");
console.log("\n🎉 CScript: The ultimate hybrid programming language!");
console.log("🌈 Combining the best of JavaScript, TypeScript, C, C++, and C#!");
console.log("🚀 Ready for real-world development!");