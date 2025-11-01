// CScript With Expression Tests

// Test data
let user = {
    name: "John",
    age: 30,
    preferences: {
        theme: "light",
        language: "en"
    },
    settings: {
        notifications: {
            email: false,
            push: true
        }
    }
};

// Simple with expression test function (for now, we'll simulate with a helper)
function withUpdate(obj, updates) {
    // This will be replaced by the transpiler
    return { ...obj, ...updates };
}

// Test 1: Simple property update
let updatedUser1 = withUpdate(user, { age: 31 });
console.log("Simple update:", updatedUser1.age);

// Test 2: Nested property update (we'll implement this step by step)
let updatedUser2 = withUpdate(user, { 
    preferences: { ...user.preferences, theme: "dark" }
});
console.log("Nested update:", updatedUser2.preferences.theme);

// Test 3: Multiple updates
let updatedUser3 = withUpdate(user, {
    age: 32,
    name: "John Doe"
});
console.log("Multiple updates:", updatedUser3.name, updatedUser3.age);

console.log("With expression tests completed (basic version)!");