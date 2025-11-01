// CScript LINQ Query Object Test

// Sample data
let users = [
  { id: 1, name: "Alice", age: 25, department: "Engineering", salary: 75000, active: true },
  { id: 2, name: "Bob", age: 30, department: "Engineering", salary: 85000, active: true },
  { id: 3, name: "Carol", age: 28, department: "Marketing", salary: 65000, active: false },
  { id: 4, name: "Dave", age: 35, department: "Engineering", salary: 95000, active: true }
];

// LINQ helper functions
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

console.log("=== LINQ Query Object Test ===");

// Test: Query object that should be transformed
let query1 = {
  from: users,
  where: [
    user => user.active,
    user => user.salary > 70000
  ],
  select: user => user.name
};

console.log("Should be transformed to method chain:", query1);

// Test: Simple query object
let query2 = {
  from: users,
  where: user => user.department === "Engineering",
  orderBy: user => user.salary,
  select: user => ({ name: user.name, salary: user.salary })
};

console.log("Engineering sorted by salary:", query2);

console.log("\n✅ Query object test completed!");