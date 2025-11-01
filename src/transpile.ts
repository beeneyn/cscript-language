import { parse, type ParserPlugin } from '@babel/parser';
import _traverse from '@babel/traverse';
import _generate from '@babel/generator';
import * as t from '@babel/types';

const traverse = (_traverse as any).default;
const generate = (_generate as any).default;

// Configuration interface
interface CSConfig {
  compilerOptions?: {
    target?: string;
    module?: string;
    outDir?: string;
    sourceMap?: boolean;
    strict?: boolean;
    removeComments?: boolean;
    preserveConstEnums?: boolean;
    skipLibCheck?: boolean;
  };
  languageFeatures?: {
    pipelineOperators?: boolean;
    matchExpressions?: boolean;
    withUpdates?: boolean;
    autoProperties?: boolean;
    linqQueries?: boolean;
    operatorOverloading?: boolean;
    enhancedTypes?: boolean;
  };
  transpilation?: {
    preserveWhitespace?: boolean;
    generateHelpers?: boolean;
    optimizeOutput?: boolean;
    bundleHelpers?: boolean;
  };
}

/**
 * The core CScript transpiler function.
 */
export function transpile(code: string, config?: CSConfig): string {
  // 1. PARSE
  const ast = parse(code, {
    sourceType: 'module',
    plugins: [
      ['pipelineOperator', { proposal: 'minimal' }] as ParserPlugin
    ]
  });

  // Operator overloading registry
  const operatorRegistry = new Map<string, Map<string, any>>();

  // 2. TRANSFORM
  const CScriptVisitor = {
    // Pipeline operator transformation
    BinaryExpression(path: any) {
      // Check if this is a pipeline operator (|>)
      if (path.node.operator === '|>') {
        const left = path.node.left;
        const right = path.node.right;
        
        // Transform a |> b into b(a)
        const newAstNode = t.callExpression(right, [left]);
        path.replaceWith(newAstNode);
        return;
      }
      
      // Check for operator overloading
      if (isOverloadableOperator(path.node.operator)) {
        const overloadedCall = tryCreateOperatorOverload(path.node, operatorRegistry);
        if (overloadedCall) {
          path.replaceWith(overloadedCall);
        }
      }
    },

    // Class auto-property transformation and operator overloading
    ClassMethod(path: any) {
      // Check for operator overloading methods ($operator_name pattern)
      if (path.node.static && path.node.key.name && path.node.key.name.startsWith('$operator_')) {
        // This is an operator overload method
        registerOperatorOverload(path, operatorRegistry);
        return;
      }
      
      // Look for property getter/setter patterns that should be auto-properties
      if (path.node.kind === 'get' || path.node.kind === 'set') {
        const propName = path.node.key.name;
        
        // Check if this is an auto-property (empty body or just return/set backing field)
        if (isAutoProperty(path.node)) {
          // Transform to backing field and getter/setter
          transformAutoProperty(path, propName);
        }
      }
    },

    // Property declaration syntax transformation  
    ClassProperty(path: any) {
      // Look for property declarations with get/set syntax
      if (path.node.value && isPropertyDeclaration(path.node.value)) {
        const propName = path.node.key.name;
        const propertyConfig = path.node.value;
        
        // Transform property declaration to getter/setter methods
        const methods = createPropertyMethods(propName, propertyConfig);
        path.replaceWithMultiple(methods);
      }
    },

    // Match expression transformation
    CallExpression(path: any) {
      // Look for match expressions: expression.match({ ... })
      if (
        path.node.callee.type === 'MemberExpression' &&
        path.node.callee.property.name === 'match' &&
        path.node.arguments.length === 1 &&
        path.node.arguments[0].type === 'ObjectExpression'
      ) {
        const expression = path.node.callee.object;
        const patterns = path.node.arguments[0].properties;
        
        // Transform match expression to nested ternary operators
        const matchTransform = transformMatchExpression(expression, patterns);
        path.replaceWith(matchTransform);
      }
      
      // Look for withUpdate function calls: withUpdate(obj, updates)
      if (
        path.node.callee.type === 'Identifier' &&
        path.node.callee.name === 'withUpdate' &&
        path.node.arguments.length === 2
      ) {
        const object = path.node.arguments[0];
        const updates = path.node.arguments[1];
        
        // Transform with expression to object spread with nested updates
        const withTransform = transformWithExpression(object, updates);
        path.replaceWith(withTransform);
      }
    },

    // LINQ query expression transformation
    SequenceExpression(path: any) {
      // Look for LINQ query patterns: from x in collection where condition select result
      if (isLinqQuery(path.node)) {
        const linqTransform = transformLinqQuery(path.node);
        path.replaceWith(linqTransform);
      }
    },

    // Handle standalone LINQ expressions that might be parsed as other node types
    ExpressionStatement(path: any) {
      if (path.node.expression.type === 'SequenceExpression' && isLinqQuery(path.node.expression)) {
        const linqTransform = transformLinqQuery(path.node.expression);
        path.node.expression = linqTransform;
      }
    },

    // LINQ object query transformation
    VariableDeclarator(path: any) {
      // Look for query objects that match LINQ pattern
      if (path.node.init && path.node.init.type === 'ObjectExpression' && isLinqQueryObject(path.node.init)) {
        const queryObject = path.node.init;
        const linqTransform = transformLinqQueryObject(queryObject);
        path.node.init = linqTransform;
      }
    }
  };

  traverse(ast, CScriptVisitor);

  // 3. GENERATE
  const { code: outputCode } = generate(ast);

  return outputCode;
}

/**
 * Check if a method is an auto-property (empty getter/setter)
 */
function isAutoProperty(method: any): boolean {
  if (!method.body || method.body.type !== 'BlockStatement') {
    return false;
  }
  
  // Auto-property if body is empty or has simple return/assignment
  const statements = method.body.body;
  if (statements.length === 0) {
    return true;
  }
  
  if (statements.length === 1) {
    const stmt = statements[0];
    // Simple return for getter or simple assignment for setter
    return stmt.type === 'ReturnStatement' || stmt.type === 'ExpressionStatement';
  }
  
  return false;
}

/**
 * Transform auto-property to backing field and accessor methods
 */
function transformAutoProperty(path: any, propName: string): void {
  // This is a placeholder - for now we'll leave the method as-is
  // In a full implementation, this would generate backing fields
}

/**
 * Check if a class property value represents a property declaration
 */
function isPropertyDeclaration(value: any): boolean {
  // Look for object expressions that represent { get; set; } syntax
  return value.type === 'ObjectExpression' && 
         value.properties.some((prop: any) => 
           prop.key && (prop.key.name === 'get' || prop.key.name === 'set')
         );
}

/**
 * Create getter/setter methods from property configuration
 */
function createPropertyMethods(propName: string, config: any): any[] {
  const methods: any[] = [];
  const backingFieldName = `_${propName}`;
  
  // Add getter method
  const getter = t.classMethod(
    'get',
    t.identifier(propName),
    [],
    t.blockStatement([
      t.returnStatement(
        t.memberExpression(t.thisExpression(), t.identifier(backingFieldName))
      )
    ])
  );
  methods.push(getter);
  
  // Add setter method
  const setter = t.classMethod(
    'set',
    t.identifier(propName),
    [t.identifier('value')],
    t.blockStatement([
      t.expressionStatement(
        t.assignmentExpression(
          '=',
          t.memberExpression(t.thisExpression(), t.identifier(backingFieldName)),
          t.identifier('value')
        )
      )
    ])
  );
  methods.push(setter);
  
  return methods;
}

/**
 * Transform with expressions into nested object updates
 */
function transformWithExpression(object: any, updates: any): any {
  if (updates.type !== 'ObjectExpression') {
    // If updates is not an object expression, just do simple spread
    return t.objectExpression([
      t.spreadElement(object),
      t.spreadElement(updates)
    ]);
  }

  // Create the base object spread
  let result = t.objectExpression([
    t.spreadElement(object)
  ]);

  // Add each update property
  for (const prop of updates.properties) {
    if (prop.type === 'ObjectProperty') {
      result.properties.push(prop);
    } else if (prop.type === 'SpreadElement') {
      result.properties.push(prop);
    }
  }

  return result;
}

/**
 * Transform match expressions into nested conditional expressions
 */
function transformMatchExpression(expression: any, patterns: any[]): any {
  // Create a temporary variable to hold the expression value
  const tempVar = t.identifier('__matchValue');
  
  // Build nested ternary conditional from patterns
  let result: any = t.callExpression(
    t.arrowFunctionExpression([], 
      t.blockStatement([
        t.throwStatement(
          t.newExpression(t.identifier('Error'), [t.stringLiteral('No match found')])
        )
      ])
    ),
    []
  );

  // Process patterns in reverse order to build nested structure
  for (let i = patterns.length - 1; i >= 0; i--) {
    const pattern = patterns[i];
    const condition = createPatternCondition(tempVar, pattern.key);
    const value = pattern.value;
    
    result = t.conditionalExpression(condition, value, result);
  }

  // Wrap in an IIFE to create the temporary variable
  return t.callExpression(
    t.arrowFunctionExpression(
      [tempVar],
      result
    ),
    [expression]
  );
}

/**
 * Create condition expressions for different pattern types
 */
function createPatternCondition(valueExpr: any, pattern: any): any {
  // Handle different pattern types
  if (pattern.type === 'Literal') {
    // Literal pattern: case 42 => ...
    return t.binaryExpression('===', valueExpr, pattern);
  }
  
  if (pattern.type === 'Identifier' && pattern.name === '_') {
    // Wildcard pattern: case _ => ...
    return t.booleanLiteral(true);
  }
  
  if (pattern.type === 'StringLiteral') {
    // Check for range patterns in strings like "1..10"
    const patternStr = pattern.value;
    if (patternStr.includes('..')) {
      const [start, end] = patternStr.split('..').map((s: string) => parseInt(s.trim()));
      if (!isNaN(start) && !isNaN(end)) {
        // Range pattern: case "1..10" => ...
        return t.logicalExpression(
          '&&',
          t.binaryExpression('>=', valueExpr, t.numericLiteral(start)),
          t.binaryExpression('<=', valueExpr, t.numericLiteral(end))
        );
      }
    }
    
    // Regular string literal
    return t.binaryExpression('===', valueExpr, pattern);
  }
  
  if (pattern.type === 'ObjectExpression') {
    // Object pattern: case { name: "John", age: 25 } => ...
    const conditions = pattern.properties.map((prop: any) => {
      const propAccess = t.memberExpression(valueExpr, prop.key);
      return t.binaryExpression('===', propAccess, prop.value);
    });
    
    return conditions.reduce((acc: any, cond: any) => 
      t.logicalExpression('&&', acc, cond)
    );
  }
  
  // Default: treat as identifier/variable pattern
  return t.binaryExpression('===', valueExpr, pattern);
}

/**
 * Check if a sequence expression represents a LINQ query
 */
function isLinqQuery(node: any): boolean {
  if (node.type !== 'SequenceExpression') {
    return false;
  }
  
  // Look for LINQ keywords in the sequence
  const expressions = node.expressions;
  if (expressions.length < 3) {
    return false;
  }
  
  // Check for "from x in collection" pattern
  const hasFrom = expressions.some((expr: any) => 
    expr.type === 'Identifier' && expr.name === 'from'
  );
  
  const hasIn = expressions.some((expr: any) => 
    expr.type === 'Identifier' && expr.name === 'in'
  );
  
  const hasSelect = expressions.some((expr: any) => 
    expr.type === 'Identifier' && expr.name === 'select'
  );
  
  return hasFrom && hasIn && hasSelect;
}

/**
 * Transform LINQ query expressions into helper function calls
 */
function transformLinqQuery(node: any): any {
  // Parse LINQ query structure: from x in collection where condition select result
  const expressions = node.expressions;
  
  // Find the collection, variable, conditions, and selector
  let collection: any = null;
  let variable: any = null;
  let whereConditions: any[] = [];
  let selector: any = null;
  let orderBy: any = null;
  let groupBy: any = null;
  
  for (let i = 0; i < expressions.length; i++) {
    const expr = expressions[i];
    
    if (expr.type === 'Identifier' && expr.name === 'from') {
      // Next should be variable, then 'in', then collection
      if (i + 3 < expressions.length) {
        variable = expressions[i + 1];
        // Skip 'in' keyword at i + 2
        collection = expressions[i + 3];
        i += 3; // Skip ahead
      }
    } else if (expr.type === 'Identifier' && expr.name === 'where') {
      // Next expression is the condition
      if (i + 1 < expressions.length) {
        whereConditions.push(expressions[i + 1]);
        i += 1;
      }
    } else if (expr.type === 'Identifier' && expr.name === 'select') {
      // Next expression is the selector
      if (i + 1 < expressions.length) {
        selector = expressions[i + 1];
        i += 1;
      }
    } else if (expr.type === 'Identifier' && expr.name === 'orderby') {
      // Next expression is the key selector
      if (i + 1 < expressions.length) {
        orderBy = expressions[i + 1];
        i += 1;
      }
    } else if (expr.type === 'Identifier' && expr.name === 'groupby') {
      // Next expression is the key selector
      if (i + 1 < expressions.length) {
        groupBy = expressions[i + 1];
        i += 1;
      }
    }
  }
  
  // Build the query chain: from(collection).where(...).select(...)
  let queryChain = t.callExpression(
    t.identifier('from'),
    [collection]
  );
  
  // Add where clauses
  for (const condition of whereConditions) {
    const whereClause = t.memberExpression(queryChain, t.identifier('where'));
    const whereLambda = createLambdaFromCondition(variable, condition);
    queryChain = t.callExpression(whereClause, [whereLambda]);
  }
  
  // Add group by if present
  if (groupBy) {
    const groupByClause = t.memberExpression(queryChain, t.identifier('groupBy'));
    const groupByLambda = createLambdaFromSelector(variable, groupBy);
    queryChain = t.callExpression(groupByClause, [groupByLambda]);
  }
  
  // Add order by if present
  if (orderBy) {
    const orderByClause = t.memberExpression(queryChain, t.identifier('orderBy'));
    const orderByLambda = createLambdaFromSelector(variable, orderBy);
    queryChain = t.callExpression(orderByClause, [orderByLambda]);
  }
  
  // Add select clause
  if (selector) {
    const selectClause = t.memberExpression(queryChain, t.identifier('select'));
    const selectLambda = createLambdaFromSelector(variable, selector);
    queryChain = t.callExpression(selectClause, [selectLambda]);
  }
  
  // Add .toArray() to execute the query
  const toArrayClause = t.memberExpression(queryChain, t.identifier('toArray'));
  return t.callExpression(toArrayClause, []);
}

/**
 * Create a lambda function from a condition expression
 */
function createLambdaFromCondition(variable: any, condition: any): any {
  // Create arrow function: variable => condition
  return t.arrowFunctionExpression([variable], condition);
}

/**
 * Create a lambda function from a selector expression
 */
function createLambdaFromSelector(variable: any, selector: any): any {
  // Create arrow function: variable => selector
  return t.arrowFunctionExpression([variable], selector);
}

/**
 * Check if an object expression represents a LINQ query object
 */
function isLinqQueryObject(node: any): boolean {
  if (node.type !== 'ObjectExpression') {
    return false;
  }
  
  // Look for LINQ properties like 'from', 'where', 'select'
  const properties = node.properties;
  const hasFrom = properties.some((prop: any) => 
    prop.key && prop.key.name === 'from'
  );
  
  const hasSelect = properties.some((prop: any) => 
    prop.key && prop.key.name === 'select'
  );
  
  return hasFrom && hasSelect;
}

/**
 * Transform LINQ query objects into method chain calls
 */
function transformLinqQueryObject(node: any): any {
  // Extract query properties
  const properties = node.properties;
  let fromClause: any = null;
  let whereClauses: any[] = [];
  let selectClause: any = null;
  let orderByClause: any = null;
  let groupByClause: any = null;
  
  for (const prop of properties) {
    if (prop.key && prop.key.name === 'from') {
      fromClause = prop.value;
    } else if (prop.key && prop.key.name === 'where') {
      if (prop.value.type === 'ArrayExpression') {
        whereClauses = prop.value.elements;
      } else {
        whereClauses = [prop.value];
      }
    } else if (prop.key && prop.key.name === 'select') {
      selectClause = prop.value;
    } else if (prop.key && prop.key.name === 'orderBy') {
      orderByClause = prop.value;
    } else if (prop.key && prop.key.name === 'groupBy') {
      groupByClause = prop.value;
    }
  }
  
  // Build the method chain
  let queryChain = t.callExpression(
    t.identifier('from'),
    [fromClause]
  );
  
  // Add where clauses
  for (const whereCondition of whereClauses) {
    const whereMethod = t.memberExpression(queryChain, t.identifier('where'));
    queryChain = t.callExpression(whereMethod, [whereCondition]);
  }
  
  // Add group by if present
  if (groupByClause) {
    const groupByMethod = t.memberExpression(queryChain, t.identifier('groupBy'));
    queryChain = t.callExpression(groupByMethod, [groupByClause]);
  }
  
  // Add order by if present
  if (orderByClause) {
    const orderByMethod = t.memberExpression(queryChain, t.identifier('orderBy'));
    queryChain = t.callExpression(orderByMethod, [orderByClause]);
  }
  
  // Add select clause
  if (selectClause) {
    const selectMethod = t.memberExpression(queryChain, t.identifier('select'));
    queryChain = t.callExpression(selectMethod, [selectClause]);
  }
  
  // Add .toArray() to execute the query
  const toArrayMethod = t.memberExpression(queryChain, t.identifier('toArray'));
  return t.callExpression(toArrayMethod, []);
}

/**
 * Check if an operator can be overloaded
 */
function isOverloadableOperator(operator: string): boolean {
  const overloadableOps = ['+', '-', '*', '/', '%', '==', '!=', '<', '>', '<=', '>='];
  return overloadableOps.includes(operator);
}

/**
 * Try to create an operator overload call for a binary expression
 */
function tryCreateOperatorOverload(node: any, registry: Map<string, Map<string, any>>): any | null {
  // Improve type inference for better operator detection
  const leftType = inferExpressionType(node.left);
  const rightType = inferExpressionType(node.right);
  
  // Try left operand type first
  if (leftType && registry.has(leftType)) {
    const typeOperators = registry.get(leftType)!;
    const operatorKey = getOperatorKey(node.operator);
    
    if (typeOperators.has(operatorKey)) {
      const methodName = typeOperators.get(operatorKey);
      
      // Create static method call: TypeName.methodName(left, right)
      return t.callExpression(
        t.memberExpression(
          t.identifier(leftType),
          t.identifier(methodName)
        ),
        [node.left, node.right]
      );
    }
  }
  
  // Try right operand type if left didn't work (for cases like scalar * vector)
  if (rightType && registry.has(rightType)) {
    const typeOperators = registry.get(rightType)!;
    const operatorKey = getOperatorKey(node.operator);
    
    if (typeOperators.has(operatorKey)) {
      const methodName = typeOperators.get(operatorKey);
      
      // Create static method call with swapped operands if needed
      return t.callExpression(
        t.memberExpression(
          t.identifier(rightType),
          t.identifier(methodName)
        ),
        [node.left, node.right]
      );
    }
  }
  
  return null;
}

/**
 * Register an operator overload method
 */
function registerOperatorOverload(path: any, registry: Map<string, Map<string, any>>): void {
  // Get the class name
  const classPath = path.findParent((p: any) => p.isClassDeclaration());
  if (!classPath) return;
  
  const className = classPath.node.id.name;
  const methodName = path.node.key.name;
  
  // Extract operator name from method name: $operator_plus -> plus
  const operatorName = methodName.replace('$operator_', '');
  
  if (!registry.has(className)) {
    registry.set(className, new Map());
  }
  
  const operatorMap = registry.get(className)!;
  operatorMap.set(operatorName, methodName);
  
  console.log(`Registered operator ${operatorName} for class ${className}`);
}

/**
 * Get operator key for registry
 */
function getOperatorKey(operator: string): string {
  const operatorMap: Record<string, string> = {
    '+': 'plus',
    '-': 'minus',
    '*': 'multiply',
    '/': 'divide',
    '%': 'modulo',
    '==': 'equals',
    '!=': 'notEquals',
    '<': 'lessThan',
    '>': 'greaterThan',
    '<=': 'lessThanOrEqual',
    '>=': 'greaterThanOrEqual'
  };
  
  return operatorMap[operator] || operator;
}

/**
 * Simple type inference for expressions
 */
function inferExpressionType(node: any): string | null {
  if (node.type === 'NewExpression' && node.callee.type === 'Identifier') {
    return node.callee.name;
  }
  
  if (node.type === 'Identifier') {
    // For now, we'll try to infer from variable names
    // In a full implementation, we'd track variable types through the scope
    
    // Common patterns that might indicate a type
    const varName = node.name;
    if (varName.startsWith('v') || varName.includes('vector') || varName.includes('Vector')) {
      return 'Vector';
    }
    
    return null;
  }
  
  if (node.type === 'CallExpression') {
    // Check for static method calls that return typed objects
    if (node.callee.type === 'MemberExpression' && 
        node.callee.object.type === 'Identifier' &&
        node.callee.object.name === 'Vector') {
      return 'Vector';
    }
  }
  
  if (node.type === 'MemberExpression') {
    // If it's accessing a property, try to infer the object type
    return inferExpressionType(node.object);
  }
  
  return null;
}