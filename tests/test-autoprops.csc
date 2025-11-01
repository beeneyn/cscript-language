// CScript Auto-Properties Test

// Helper function to simulate auto-property syntax
function createAutoProperty(name, options = {}) {
    return {
        get: options.get || function() { return this[`_${name}`]; },
        set: options.set || function(value) { this[`_${name}`] = value; },
        configurable: true,
        enumerable: true
    };
}

// Test 1: Basic class with manual property implementation (for now)
class User {
    constructor(name, email) {
        this._name = name;
        this._email = email;
        this._age = 0;
    }
    
    // Manually implemented getters/setters (will be auto-generated later)
    get name() {
        return this._name;
    }
    
    set name(value) {
        this._name = value;
    }
    
    get email() {
        return this._email;
    }
    
    set email(value) {
        this._email = value;
    }
    
    get age() {
        return this._age;
    }
    
    set age(value) {
        if (value >= 0) {
            this._age = value;
        } else {
            throw new Error("Age cannot be negative");
        }
    }
    
    // Computed property
    get displayName() {
        return `${this.name} <${this.email}>`;
    }
}

// Test usage
console.log("=== Auto-Properties Test (Manual Implementation) ===");

let user = new User("Alice", "alice@example.com");
console.log("Initial user:", user.displayName);

// Test property setting
user.age = 25;
console.log("After setting age:", user.age);

// Test property updating with pipeline and match
let updatedUser = withUpdate(user, { 
    name: "Alice Smith",
    age: user.age |> (age => age.match({
        "0..17": age,
        "18..64": age + 1, // Increment for adults
        "65..120": age,
        _: 25
    }))
});

console.log("Updated user:", updatedUser.name, "Age:", updatedUser.age);

// Test 2: Using pipeline with objects
let userInfo = { name: "Bob", age: 30, role: "admin" }
    |> (info => withUpdate(info, {
        description: info.role.match({
            "admin": "System Administrator",
            "user": "Regular User",
            "moderator": "Community Moderator",
            _: "Unknown Role"
        }),
        canManage: info.role === "admin" || info.role === "moderator"
    }))
    |> (info => withUpdate(info, {
        ageCategory: info.age.match({
            "0..17": "minor",
            "18..64": "adult",
            "65..120": "senior",
            _: "unknown"
        })
    }));

console.log("Processed user info:", userInfo);

// Test 3: Property validation simulation
class Product {
    constructor(name, price) {
        this._name = name;
        this._price = price;
    }
    
    get name() {
        return this._name;
    }
    
    set name(value) {
        if (value && value.length > 0) {
            this._name = value;
        } else {
            throw new Error("Product name cannot be empty");
        }
    }
    
    get price() {
        return this._price;
    }
    
    set price(value) {
        let validatedPrice = value.match({
            _: value < 0 ? 0 : value > 10000 ? 10000 : value
        });
        this._price = validatedPrice;
    }
    
    get formattedPrice() {
        return `$${this.price.toFixed(2)}`;
    }
}

let product = new Product("Laptop", 999.99);
console.log("Product:", product.name, product.formattedPrice);

// Test price validation
product.price = -50; // Should be clamped to 0
console.log("After negative price:", product.formattedPrice);

product.price = 15000; // Should be clamped to 10000
console.log("After excessive price:", product.formattedPrice);

console.log("\n✅ Auto-properties test completed (manual implementation)!");