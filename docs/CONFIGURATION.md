# CScript Configuration (csconfig.json)

The `csconfig.json` file allows you to customize CScript's transpilation behavior and control which language features are enabled.

## Quick Start

Create a default configuration file:
```bash
cscript --init
```

This creates a `csconfig.json` with all features enabled.

## Configuration Options

### Compiler Options
Controls TypeScript-like compilation settings:
```json
{
  "compilerOptions": {
    "target": "ES2020",           // Target JavaScript version
    "module": "ESNext",           // Module system
    "outDir": "./dist",           // Output directory
    "sourceMap": true,            // Generate source maps
    "strict": true,               // Strict type checking
    "removeComments": false,      // Preserve comments
    "preserveConstEnums": true,   // Keep const enums
    "skipLibCheck": true          // Skip library type checking
  }
}
```

### Language Features
Enable/disable specific CScript features:
```json
{
  "languageFeatures": {
    "pipelineOperators": true,    // |> operator
    "matchExpressions": true,     // pattern matching
    "withUpdates": true,          // immutable updates
    "autoProperties": true,       // { get; set; } syntax
    "linqQueries": true,          // from...where...select
    "operatorOverloading": true,  // $operator_ methods
    "enhancedTypes": true         // union types & coercion
  }
}
```

### Transpilation Settings
Control code generation:
```json
{
  "transpilation": {
    "preserveWhitespace": true,   // Keep original formatting
    "generateHelpers": true,      // Include helper functions
    "optimizeOutput": false,      // Optimize generated code
    "bundleHelpers": false        // Bundle vs inline helpers
  }
}
```

### File Patterns
Specify which files to process:
```json
{
  "include": [
    "src/**/*.csc",
    "*.csc"
  ],
  "exclude": [
    "node_modules/**/*",
    "dist/**/*",
    "**/*.d.ts"
  ],
  "files": []                     // Explicit file list (optional)
}
```

### Watch Mode
Configure file watching:
```json
{
  "watch": {
    "enabled": false,
    "extensions": [".csc"],
    "ignore": ["node_modules", "dist"]
  }
}
```

### Output Settings
Control generated file format:
```json
{
  "output": {
    "format": "module",           // "module" or "commonjs"
    "extension": ".js",           // Output file extension
    "preserveStructure": true     // Keep directory structure
  }
}
```

## Example Configurations

### Minimal CScript (Only Pipelines)
```json
{
  "languageFeatures": {
    "pipelineOperators": true,
    "matchExpressions": false,
    "withUpdates": false,
    "autoProperties": false,
    "linqQueries": false,
    "operatorOverloading": false,
    "enhancedTypes": false
  }
}
```

### Development Mode
```json
{
  "compilerOptions": {
    "sourceMap": true,
    "removeComments": false
  },
  "transpilation": {
    "preserveWhitespace": true,
    "optimizeOutput": false
  }
}
```

### Production Build
```json
{
  "compilerOptions": {
    "sourceMap": false,
    "removeComments": true
  },
  "transpilation": {
    "preserveWhitespace": false,
    "optimizeOutput": true,
    "bundleHelpers": true
  }
}
```

## Usage

The CLI automatically loads `csconfig.json` from the current directory:

```bash
# Uses csconfig.json automatically
cscript input.csc

# Create default config
cscript --init

# View all options
cscript --help
```

## Feature Integration

When features are disabled in config, the transpiler skips their transformation:

```cscript
// With operatorOverloading: false
class Vector {
  $operator_+(other) { return this; }  // Transpiled as regular method
}

// With matchExpressions: false  
const result = value match { 1 => "one" };  // Syntax error - feature disabled
```

This allows gradual adoption of CScript features in existing JavaScript projects.