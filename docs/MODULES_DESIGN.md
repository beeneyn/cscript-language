# CScript Module System Design

## Overview
CScript will implement a module system using `.csm` (CScript Module) files to provide organized, reusable code components.

## File Extensions
- `.csc` - Regular CScript source files
- `.csm` - CScript module files

## Planned Module Types

### Built-in Modules
- **web** - Browser/DOM utilities, fetch API, event handling
- **server** - HTTP server, file system, database connections
- **math** - Advanced mathematical operations
- **crypto** - Cryptographic functions
- **util** - General utility functions

### Module Syntax (Planned)
```cscript
// Importing modules
import web from "web";
import { server, fs } from "server";
import MyModule from "./mymodule.csm";

// Exporting from modules
export function myFunction() { ... }
export const myConstant = 42;
export default class MyClass { ... }
```

### Module Resolution
1. Built-in modules (web, server, etc.)
2. Relative paths (./module.csm, ../utils.csm)
3. Absolute paths from project root
4. Node.js packages (future consideration)

## Implementation Status
- **Status**: Planned for future release
- **Priority**: High (after core language stabilization)
- **Dependencies**: Core transpiler completion

## Related Files
- Will modify `src/transpile.ts` for module handling
- Will add `src/modules/` directory for built-in modules
- Will update grammar for import/export syntax

---
*Note: This is a design document. Implementation pending.*