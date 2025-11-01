// CScript Native LINQ Syntax Test

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
    toArray: function() {
      return collection;
    }
  };
}

// Test 1: Basic LINQ query with native syntax
console.log("=== Test 1: Native LINQ Syntax ===");

// This should transform: from user in users where user.active where user.salary > 70000 select user.name
let result1 = from, user, in, users, where, user.active, where, user.salary > 70000, select, user.name;

console.log("Active high earners:", result1);

console.log("\n✅ Native LINQ syntax test completed!");