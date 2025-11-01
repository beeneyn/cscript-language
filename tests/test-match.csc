// CScript Match Expression Tests

// Helper function to test our match expressions
function testMatch(value, description) {
    console.log(`${description}: ${value}`);
}

// Test 1: Simple literal matching
let simpleMatch = (value) => {
    return value.match({
        0: "zero",
        1: "one", 
        2: "two",
        _: "other"
    });
};

testMatch(simpleMatch(0), "Simple match (0)");
testMatch(simpleMatch(1), "Simple match (1)");
testMatch(simpleMatch(5), "Simple match (5)");

// Test 2: Range matching (using custom syntax)
let rangeMatch = (age) => {
    return age.match({
        "0..17": "minor",
        "18..64": "adult", 
        "65..120": "senior",
        _: "invalid age"
    });
};

testMatch(rangeMatch(15), "Range match (15)");
testMatch(rangeMatch(30), "Range match (30)");
testMatch(rangeMatch(70), "Range match (70)");

// Test 3: Object property matching (simplified)
let statusMatch = (user) => {
    return user.match({
        "active": "User is active",
        "inactive": "User is inactive", 
        "banned": "User is banned",
        _: "Unknown status"
    });
};

let user1 = { status: "active", name: "John" };
let user2 = { status: "banned", name: "Jane" };

testMatch(statusMatch(user1.status), "Status match (active)");
testMatch(statusMatch(user2.status), "Status match (banned)");

// Test 4: Combining with pipeline operators
let processValue = (input) => {
    return input 
        |> (x => x * 2)
        |> (x => x.match({
            0: "zero result",
            "1..10": "small result",
            "11..50": "medium result", 
            _: "large result"
        }));
};

testMatch(processValue(2), "Pipeline + match (2)");
testMatch(processValue(15), "Pipeline + match (15)");
testMatch(processValue(50), "Pipeline + match (50)");

console.log("\nMatch expression tests completed!");