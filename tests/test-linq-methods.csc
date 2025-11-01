// CScript LINQ Syntax Test - Method Chain Approach

// Sample data
let users = [
  { id: 1, name: "Alice", age: 25, department: "Engineering", salary: 75000, active: true },
  { id: 2, name: "Bob", age: 30, department: "Engineering", salary: 85000, active: true },
  { id: 3, name: "Carol", age: 28, department: "Marketing", salary: 65000, active: false },
  { id: 4, name: "Dave", age: 35, department: "Engineering", salary: 95000, active: true }
];

// LINQ helper functions (needed for transpiled output)
function from(collection) {
  return {
    where: function(predicate) {
      const filtered = collection.filter(predicate);
      return from(filtered);
    },
    select: function(selector) {
      return collection.map(selector);
    },
    orderBy: function(keySelector) {
      const sorted = [...collection].sort((a, b) => {
        const aKey = keySelector(a);
        const bKey = keySelector(b);
        return aKey < bKey ? -1 : aKey > bKey ? 1 : 0;
      });
      return from(sorted);
    },
    toArray: function() {
      return collection;
    }
  };
}

// Test 1: Method chaining LINQ (this already works)
console.log("=== Test 1: Method Chain LINQ (Current) ===");
let result1 = from(users)
  .where(user => user.active)
  .where(user => user.salary > 70000)
  .select(user => user.name)
  .toArray();

console.log("Active high earners:", result1);

// Test 2: Alternative query syntax using object notation
console.log("\n=== Test 2: Alternative Query Syntax ===");

// Let's define a more JavaScript-friendly LINQ syntax
let query2 = {
  from: users,
  where: [
    user => user.active,
    user => user.salary > 70000
  ],
  select: user => user.name
};

// This could be transformed by our transpiler
let result2 = executeQuery(query2);
console.log("Query object result:", result2);

// Test 3: Pipeline-style LINQ
console.log("\n=== Test 3: Pipeline LINQ ===");

// Use pipeline operator with LINQ
let result3 = users 
  |> (data => from(data))
  |> (q => q.where(user => user.active))
  |> (q => q.where(user => user.department === "Engineering"))
  |> (q => q.select(user => ({ name: user.name, salary: user.salary })))
  |> (q => q.orderBy(user => user.salary))
  |> (q => q.toArray());

console.log("Pipeline LINQ result:", result3);

// Helper function for query objects
function executeQuery(query) {
  let result = from(query.from);
  
  if (query.where) {
    if (Array.isArray(query.where)) {
      for (let condition of query.where) {
        result = result.where(condition);
      }
    } else {
      result = result.where(query.where);
    }
  }
  
  if (query.orderBy) {
    result = result.orderBy(query.orderBy);
  }
  
  if (query.select) {
    result = result.select(query.select);
  }
  
  return result.toArray();
}

console.log("\n✅ LINQ syntax variations test completed!");