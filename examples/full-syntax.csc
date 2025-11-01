// CScript Language Example - Full Feature Showcase
// This file demonstrates the planned syntax for CScript when complete

// 1. PIPELINE OPERATORS (✅ Currently Working)
import { users, orders, products } from './data';

// Simple pipeline operations
let result = 5 |> square |> double |> (x => x + 1);

// Complex data transformations
let processedUsers = users
    |> (list => list.filter(u => u.active))
    |> (list => list.map(u => ({ ...u, displayName: `${u.firstName} ${u.lastName}` })))
    |> (list => list.sort((a, b) => a.lastName.localeCompare(b.lastName)));

// 2. MATCH EXPRESSIONS (🚧 Planned)
let categorizeUser = (user) => user.age match {
    0..17 => "minor",
    18..64 when user.employed => "working adult", 
    18..64 when !user.employed => "unemployed adult",
    65.._ => "senior",
    _ => "unknown"
};

let processOrder = (order) => order match {
    { status: "pending", total: 0..100 } => processSmallOrder(order),
    { status: "pending", total: 100.._ } => processLargeOrder(order), 
    { status: "completed" } => archiveOrder(order),
    { status: "cancelled", reason } => handleCancellation(order, reason),
    _ => throw new Error("Unknown order status")
};

// 3. IMMUTABLE UPDATES WITH 'with' (🚧 Planned)
let updateUserPreferences = (user, theme, language) => {
    return user with {
        preferences.theme = theme,
        preferences.language = language,
        lastUpdated = Date.now(),
        settings.notifications.email = true
    };
};

let updateNestedConfig = (config) => config with {
    database.connection.timeout = 5000,
    api.rateLimit.requests = 1000,
    logging.level = "debug"
};

// 4. LINQ (Language-Integrated Query) (🚧 Planned)
let expensiveOrdersByUser = 
    from order in orders
    join user in users on order.userId equals user.id
    where order.total > 500
    select {
        userName: user.name,
        orderTotal: order.total,
        orderDate: order.date
    } into results
    group results by results.userName into userGroups
    select {
        user: userGroups.key,
        totalSpent: userGroups.sum(x => x.orderTotal),
        orderCount: userGroups.count()
    };

// Complex query with multiple joins
let productSalesReport =
    from order in orders
    join orderItem in orderItems on order.id equals orderItem.orderId
    join product in products on orderItem.productId equals product.id
    where order.date >= new Date('2025-01-01')
    group { order, orderItem, product } by product.category into categoryGroups
    select {
        category: categoryGroups.key,
        totalRevenue: categoryGroups.sum(x => x.orderItem.quantity * x.product.price),
        unitsSold: categoryGroups.sum(x => x.orderItem.quantity),
        topProduct: categoryGroups.maxBy(x => x.orderItem.quantity).product.name
    };

// 5. AUTO-PROPERTIES (🚧 Planned)
class User {
    // Auto-implemented properties
    public Id { get; private set; }
    public Email { get; set; }
    public FirstName { get; set; }
    public LastName { get; set; }
    
    // Computed property
    public FullName { 
        get => `${this.FirstName} ${this.LastName}`;
    }
    
    // Property with validation
    public Age { 
        get; 
        set => value >= 0 ? field = value : throw new Error("Age cannot be negative");
    }

    constructor(id: string, email: string, firstName: string, lastName: string) {
        this.Id = id;
        this.Email = email;
        this.FirstName = firstName;
        this.LastName = lastName;
    }
}

// 6. OPERATOR OVERLOADING (🚧 Planned)
struct Vector2D {
    x: number;
    y: number;
    
    // Addition operator
    operator +(other: Vector2D): Vector2D {
        return Vector2D { x: this.x + other.x, y: this.y + other.y };
    }
    
    // Scalar multiplication
    operator *(scalar: number): Vector2D {
        return Vector2D { x: this.x * scalar, y: this.y * scalar };
    }
    
    // Equality operator
    operator ==(other: Vector2D): boolean {
        return this.x === other.x && this.y === other.y;
    }
    
    // Magnitude calculation
    get magnitude(): number {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    }
}

// Usage of operator overloading
let v1 = Vector2D { x: 1, y: 2 };
let v2 = Vector2D { x: 3, y: 4 };
let result = v1 + v2 * 2;  // Vector2D { x: 7, y: 10 }
let isEqual = v1 == Vector2D { x: 1, y: 2 };  // true

// 7. VALUE TYPES (STRUCTS) (🚧 Planned)
struct Money {
    amount: number;
    currency: string;
    
    operator +(other: Money): Money {
        if (this.currency !== other.currency) {
            throw new Error("Cannot add different currencies");
        }
        return Money { amount: this.amount + other.amount, currency: this.currency };
    }
    
    operator >(other: Money): boolean {
        if (this.currency !== other.currency) {
            throw new Error("Cannot compare different currencies");
        }
        return this.amount > other.amount;
    }
    
    toString(): string {
        return `${this.amount} ${this.currency}`;
    }
}

struct Result<T, E> {
    value?: T;
    error?: E;
    isSuccess: boolean;
    
    static Ok<T>(value: T): Result<T, never> {
        return Result { value, isSuccess: true };
    }
    
    static Error<E>(error: E): Result<never, E> {
        return Result { error, isSuccess: false };
    }
    
    map<U>(fn: (value: T) => U): Result<U, E> {
        return this.isSuccess ? 
            Result.Ok(fn(this.value!)) : 
            Result.Error(this.error!);
    }
    
    flatMap<U>(fn: (value: T) => Result<U, E>): Result<U, E> {
        return this.isSuccess ? fn(this.value!) : Result.Error(this.error!);
    }
}

// COMBINING ALL FEATURES - Real-world example
class OrderProcessor {
    public ProcessingFee { get; private set; } = Money { amount: 2.50, currency: "USD" };
    
    processOrder(order: Order): Result<ProcessedOrder, string> {
        return order
            |> validateOrder
            |> (result => result.flatMap(applyDiscounts))
            |> (result => result.flatMap(calculateTaxes))
            |> (result => result.map(addProcessingFee));
    }
    
    private validateOrder(order: Order): Result<Order, string> {
        return order match {
            { items: [] } => Result.Error("Order cannot be empty"),
            { customer: null } => Result.Error("Customer is required"), 
            { total when total <= Money { amount: 0, currency: "USD" } } => 
                Result.Error("Order total must be positive"),
            _ => Result.Ok(order)
        };
    }
    
    private applyDiscounts(order: Order): Result<Order, string> {
        let discountedItems = order.items
            |> (items => items.map(item => item with { 
                price = calculateItemDiscount(item) 
            }));
            
        return Result.Ok(order with { 
            items = discountedItems,
            total = discountedItems |> (items => items.reduce((sum, item) => sum + item.price))
        });
    }
    
    private calculateTaxes(order: Order): Result<Order, string> {
        let taxableAmount = from item in order.items 
                           where item.taxable 
                           select item.price
                           |> (prices => prices.reduce((a, b) => a + b));
                           
        let tax = taxableAmount * 0.08;  // 8% tax rate
        
        return Result.Ok(order with { 
            tax = Money { amount: tax, currency: order.total.currency },
            total = order.total + Money { amount: tax, currency: order.total.currency }
        });
    }
}

// Example usage combining pipeline operators, match expressions, and LINQ
let orderSummary = orders
    |> (list => from order in list
                where order.date >= startDate && order.date <= endDate
                select order)
    |> (filtered => filtered.map(order => order match {
        { status: "completed", total } when total > Money { amount: 100, currency: "USD" } => 
            { ...order, category: "high-value" },
        { status: "completed" } => 
            { ...order, category: "standard" },
        _ => 
            { ...order, category: "other" }
    }))
    |> (categorized => from order in categorized
                      group order by order.category into groups
                      select {
                          category: groups.key,
                          count: groups.count(),
                          totalRevenue: groups.sum(o => o.total.amount)
                      });

console.log("Order summary:", orderSummary);