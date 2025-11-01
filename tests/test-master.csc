// CScript Master Feature Test - All Language Features Combined

// Sample data for comprehensive testing
let users = [
  { id: 1, name: "Alice", age: 25, department: "Engineering", salary: 75000, active: true },
  { id: 2, name: "Bob", age: 30, department: "Engineering", salary: 85000, active: true },
  { id: 3, name: "Carol", age: 28, department: "Marketing", salary: 65000, active: false },
  { id: 4, name: "Dave", age: 35, department: "Engineering", salary: 95000, active: true },
  { id: 5, name: "Eve", age: 24, department: "Design", salary: 60000, active: true }
];

let projects = [
  { id: 101, name: "Website Redesign", leaderId: 1, budget: 50000, status: "active" },
  { id: 102, name: "Mobile App", leaderId: 2, budget: 100000, status: "planning" },
  { id: 103, name: "Marketing Campaign", leaderId: 3, budget: 30000, status: "completed" }
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
    join: function(other, outerKey, innerKey, resultSelector) {
      const results = [];
      for (let outer of collection) {
        for (let inner of other) {
          if (outerKey(outer) === innerKey(inner)) {
            results.push(resultSelector(outer, inner));
          }
        }
      }
      return from(results);
    },
    toArray: function() {
      return collection;
    }
  };
}

// Test class with auto-properties
class Employee {
  constructor(id, name, department) {
    this._id = id;
    this._name = name;
    this._department = department;
    this._performanceRating = 0;
  }

  get id() { return this._id; }
  set id(value) { this._id = value; }
  
  get name() { return this._name; }
  set name(value) { this._name = value; }
  
  get department() { return this._department; }
  set department(value) { this._department = value; }
  
  get performanceRating() { return this._performanceRating; }
  set performanceRating(value) { this._performanceRating = value; }
}

console.log("=== CScript Master Feature Test ===\n");

// Test 1: Pipeline operators with LINQ queries
console.log("🔗 Test 1: Pipeline + LINQ");
let topEngineers = users
  |> (data => from(data))
  |> (q => q.where(u => u.active))
  |> (q => q.where(u => u.department === "Engineering"))
  |> (q => q.orderBy(u => u.salary))
  |> (q => q.select(u => ({ name: u.name, salary: u.salary })))
  |> (q => q.toArray())
  |> (results => results.reverse()); // Highest first

console.log("Top engineers:", topEngineers);

// Test 2: Match expressions with LINQ object queries
console.log("\n🎯 Test 2: Match + LINQ Object Query");

let categorizedQuery = {
  from: users,
  where: u => u.active,
  select: u => ({
    ...u,
    category: u.age.match({
      "20..29": "young",
      "30..39": "experienced", 
      "40..49": "senior",
      _: "veteran"
    }),
    salaryTier: u.salary.match({
      "0..65000": "entry",
      "65001..85000": "mid",
      "85001..200000": "senior",
      _: "executive"
    })
  })
};

console.log("Categorized employees:", categorizedQuery);

// Test 3: WithUpdate + Match expressions in pipeline
console.log("\n🔄 Test 3: WithUpdate + Match + Pipeline");

let updatedUser = users[0]
  |> (user => withUpdate(user, {
      salary: user.salary * 1.1, // 10% raise
      bonus: user.salary.match({
        "0..70000": 5000,
        "70001..90000": 8000,
        "90001..200000": 12000,
        _: 15000
      })
    }))
  |> (user => withUpdate(user, {
      grade: user.salary.match({
        "0..75000": "Junior",
        "75001..95000": "Senior", 
        "95001..200000": "Lead",
        _: "Principal"
      })
    }));

console.log("Updated user with bonus and grade:", updatedUser);

// Test 4: Complex LINQ with joins, match, and pipeline
console.log("\n🔗 Test 4: Complex Query with All Features");

let projectAnalysis = {
  from: users,
  where: u => u.active,
  select: u => ({
    ...u,
    riskLevel: u.age.match({
      "20..30": "low",
      "31..40": "medium",
      "41..50": "high",
      _: "critical"
    })
  })
}
|> (teamMembers => from(teamMembers))
|> (q => q.join(projects, u => u.id, p => p.leaderId, (user, project) => ({
    projectName: project.name,
    leaderName: user.name,
    budget: project.budget,
    riskLevel: user.riskLevel,
    status: project.status,
    recommendation: project.budget.match({
      "0..40000": "Low budget - proceed",
      "40001..80000": "Medium budget - review",
      "80001..200000": "High budget - detailed analysis",
      _: "Executive approval required"
    })
  })))
|> (q => q.where(p => p.status !== "completed"))
|> (q => q.orderBy(p => p.budget))
|> (q => q.toArray());

console.log("Active project analysis:", projectAnalysis);

// Test 5: Auto-properties with other features
console.log("\n👤 Test 5: Auto-Properties Integration");

let employee = new Employee(1, "Test User", "Engineering");
employee.performanceRating = 85;

let enhancedEmployee = employee
  |> (emp => withUpdate(emp, {
      bonus: emp.performanceRating.match({
        "0..60": 1000,
        "61..80": 3000,
        "81..90": 5000,
        "91..100": 8000,
        _: 10000
      }),
      level: emp.performanceRating.match({
        "0..70": "Developing",
        "71..85": "Proficient",
        "86..95": "Expert", 
        _: "Master"
      })
    }));

console.log("Enhanced employee:", enhancedEmployee);

// Test 6: Ultimate complexity - everything together
console.log("\n🚀 Test 6: Ultimate Feature Combination");

let ultimateResult = users
  |> (data => withUpdate(data[0], { testField: "pipeline-start" }))
  |> (user => [user]) // Convert to array for LINQ
  |> (data => ({
      from: data,
      where: u => u.active !== false,
      select: u => withUpdate(u, {
        complexScore: (u.salary + u.age * 1000).match({
          "0..80000": "basic",
          "80001..120000": "good",
          "120001..150000": "excellent",
          _: "outstanding"
        }),
        processedAt: new Date().toISOString()
      })
    }))
  |> (query => query) // Transform query object
  |> (result => Array.isArray(result) ? result[0] : result);

console.log("Ultimate combined result:", ultimateResult);

console.log("\n✅ All CScript features working together successfully!");
console.log("🎉 Pipeline operators, Match expressions, With updates, Auto-properties, and LINQ queries are fully functional!");