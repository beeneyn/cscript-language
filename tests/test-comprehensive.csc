// CScript Comprehensive Feature Test
// Combining Pipeline Operators, Match Expressions, and With Updates

// Test data
let users = [
    { id: 1, name: "Alice", age: 25, status: "active", role: "admin" },
    { id: 2, name: "Bob", age: 17, status: "active", role: "user" },
    { id: 3, name: "Charlie", age: 35, status: "inactive", role: "user" },
    { id: 4, name: "Diana", age: 70, status: "active", role: "moderator" }
];

let config = {
    app: {
        theme: "light",
        language: "en"
    },
    features: {
        darkMode: false,
        notifications: true
    }
};

// Helper functions
function isAdult(age) { return age >= 18; }
function isActive(status) { return status === "active"; }
function categorizeAge(age) {
    return age.match({
        "0..17": "minor",
        "18..64": "adult", 
        "65..120": "senior",
        _: "unknown"
    });
}

function getUserPermissions(role) {
    return role.match({
        "admin": "full",
        "moderator": "limited",
        "user": "basic",
        _: "none"
    });
}

// Test 1: Pipeline + Match combination
console.log("=== Test 1: Pipeline + Match ===");

let processedUsers = users
    |> (list => list.filter(isActive))
    |> (list => list.map(user => withUpdate(user, {
        category: categorizeAge(user.age),
        permissions: getUserPermissions(user.role),
        canVote: isAdult(user.age)
    })))
    |> (list => list.sort((a, b) => a.age - b.age));

processedUsers.forEach(user => {
    console.log(`${user.name} (${user.age}): ${user.category}, ${user.permissions} permissions, can vote: ${user.canVote}`);
});

// Test 2: Complex match with ranges and pipeline
console.log("\n=== Test 2: Complex Age Processing ===");

let ageStats = users
    |> (list => list.map(user => user.age))
    |> (ages => ages.map(age => age.match({
        "0..12": { category: "child", group: "young" },
        "13..17": { category: "teen", group: "young" },
        "18..64": { category: "adult", group: "working" },
        "65..120": { category: "senior", group: "retired" },
        _: { category: "unknown", group: "other" }
    })))
    |> (categories => {
        let counts = {};
        categories.forEach(cat => {
            counts[cat.category] = (counts[cat.category] || 0) + 1;
        });
        return counts;
    });

console.log("Age distribution:", ageStats);

// Test 3: Configuration updates with with expressions
console.log("\n=== Test 3: Configuration Updates ===");

let themes = ["light", "dark", "auto"];
let languages = ["en", "es", "fr"];

let updatedConfigs = themes
    |> (themeList => themeList.map(theme => 
        withUpdate(config, {
            app: withUpdate(config.app, { theme: theme }),
            features: withUpdate(config.features, { 
                darkMode: theme === "dark",
                lastUpdated: Date.now()
            })
        })
    ));

updatedConfigs.forEach((conf, i) => {
    console.log(`Config ${i + 1}: Theme: ${conf.app.theme}, Dark Mode: ${conf.features.darkMode}`);
});

// Test 4: User status classification with complex logic
console.log("\n=== Test 4: User Classification ===");

let classifyUser = (user) => {
    let baseClassification = user.status.match({
        "active": "operational",
        "inactive": "dormant", 
        "banned": "restricted",
        _: "unknown"
    });
    
    let roleWeight = user.role.match({
        "admin": 3,
        "moderator": 2, 
        "user": 1,
        _: 0
    });
    
    let ageCategory = categorizeAge(user.age);
    
    return withUpdate(user, {
        classification: baseClassification,
        priority: roleWeight,
        ageGroup: ageCategory,
        score: roleWeight * (isActive(user.status) ? 10 : 1)
    });
};

let classifiedUsers = users
    |> (list => list.map(classifyUser))
    |> (list => list.sort((a, b) => b.score - a.score));

console.log("User classifications (by score):");
classifiedUsers.forEach(user => {
    console.log(`${user.name}: ${user.classification}, Priority: ${user.priority}, Score: ${user.score}, Age Group: ${user.ageGroup}`);
});

// Test 5: Chained operations with all features
console.log("\n=== Test 5: Chained Operations ===");

let summary = users
    |> (list => list.filter(user => user.age >= 18))
    |> (adults => adults.map(user => withUpdate(user, {
        accessLevel: user.role.match({
            "admin": "level-3",
            "moderator": "level-2",
            "user": "level-1", 
            _: "level-0"
        }),
        statusDescription: user.status.match({
            "active": "Currently active user",
            "inactive": "User needs reactivation",
            _: "Status unknown"
        })
    })))
    |> (processed => {
        let summary = {
            total: processed.length,
            active: processed.filter(u => u.status === "active").length,
            byRole: {}
        };
        
        processed.forEach(user => {
            summary.byRole[user.role] = (summary.byRole[user.role] || 0) + 1;
        });
        
        return summary;
    });

console.log("Adult user summary:", summary);

console.log("\n✅ All CScript features working together successfully!");