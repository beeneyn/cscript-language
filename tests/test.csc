// CScript Language Feature Showcase

// Helper functions (just standard JS)
function square(n) {
  return n * n;
}

function add(a, b) {
  return a + b;
}

function multiply(a, b) {
  return a * b;
}

// ===== PIPELINE OPERATORS =====
console.log("=== Pipeline Operators ===");

// Test 1: Simple pipeline
let result1 = 5 |> square;
console.log('Test 1 (5 |> square):', result1);

// Test 2: Chained pipeline
let result2 = 5 |> square |> (n => add(n, 10));
console.log('Test 2 (5 |> square |> add 10):', result2);

// Test 3: Complex pipeline with multiple operations
let result3 = 3 |> square |> (n => multiply(n, 2)) |> (n => add(n, 1));
console.log('Test 3 (3 |> square |> *2 |> +1):', result3);

// Test 4: Pipeline with array operations
let arr = [1, 2, 3];
let result4 = arr |> (a => a.map(square)) |> (a => a.reduce((x, y) => x + y));
console.log('Test 4 (array pipeline):', result4);

// ===== MATCH EXPRESSIONS =====
console.log("\n=== Match Expressions ===");

// Age categorization
let categorizeAge = (age) => age.match({
    "0..12": "child",
    "13..17": "teenager", 
    "18..64": "adult",
    "65..120": "senior",
    _: "unknown"
});

console.log('Age 8:', categorizeAge(8));
console.log('Age 16:', categorizeAge(16));
console.log('Age 30:', categorizeAge(30));
console.log('Age 70:', categorizeAge(70));

// Status processing
let processStatus = (status) => status.match({
    "active": "User is currently active",
    "inactive": "User needs reactivation",
    "banned": "Access denied",
    _: "Unknown status"
});

console.log('Status active:', processStatus("active"));
console.log('Status banned:', processStatus("banned"));

// ===== WITH EXPRESSIONS =====
console.log("\n=== With Expressions (Immutable Updates) ===");

let user = {
    name: "Alice",
    age: 28,
    preferences: {
        theme: "light",
        language: "en"
    }
};

// Simple update
let updatedUser1 = withUpdate(user, { age: 29 });
console.log('Updated age:', updatedUser1.age, '(original:', user.age, ')');

// Nested update
let updatedUser2 = withUpdate(user, {
    preferences: withUpdate(user.preferences, { theme: "dark" })
});
console.log('Updated theme:', updatedUser2.preferences.theme);

// Multiple updates
let updatedUser3 = withUpdate(user, {
    name: "Alice Smith",
    age: 30
});
console.log('Multiple updates:', updatedUser3.name, updatedUser3.age);

// ===== COMBINING ALL FEATURES =====
console.log("\n=== Combined Features ===");

let users = [
    { name: "Bob", age: 17, status: "active" },
    { name: "Carol", age: 25, status: "inactive" },
    { name: "Dave", age: 35, status: "active" },
    { name: "Eve", age: 70, status: "active" }
];

// Complex data processing combining all features
let processedUsers = users
    |> (list => list.filter(u => u.status === "active"))
    |> (list => list.map(u => withUpdate(u, {
        category: categorizeAge(u.age),
        description: u.status.match({
            "active": "Active user",
            "inactive": "Needs activation",
            _: "Unknown"
        }),
        canVote: u.age >= 18
    })))
    |> (list => list.sort((a, b) => a.age - b.age));

console.log("Processed users:");
processedUsers.forEach(u => {
    console.log(`- ${u.name} (${u.age}): ${u.category}, ${u.description}, Can vote: ${u.canVote}`);
});

console.log("\n✅ CScript language features demonstration completed!");