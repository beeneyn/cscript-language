#!/usr/bin/env node

import { promises as fs } from 'fs';
import * as path from 'path';
import { transpile } from './transpile.js';

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
  include?: string[];
  exclude?: string[];
  files?: string[];
  watch?: {
    enabled?: boolean;
    extensions?: string[];
    ignore?: string[];
  };
  output?: {
    format?: string;
    extension?: string;
    preserveStructure?: boolean;
  };
}

async function loadConfig(): Promise<CSConfig> {
  const configPath = path.resolve(process.cwd(), 'csconfig.json');
  try {
    const configContent = await fs.readFile(configPath, 'utf-8');
    return JSON.parse(configContent);
  } catch (error) {
    // Return default config if file doesn't exist
    return {
      languageFeatures: {
        pipelineOperators: true,
        matchExpressions: true,
        withUpdates: true,
        autoProperties: true,
        linqQueries: true,
        operatorOverloading: true,
        enhancedTypes: true
      },
      transpilation: {
        preserveWhitespace: true,
        generateHelpers: true,
        optimizeOutput: false,
        bundleHelpers: false
      }
    };
  }
}

async function main() {
  const args = process.argv.slice(2);
  const config = await loadConfig();
  
  if (args.length === 0) {
    console.log(`
CScript Transpiler v1.0.0

Usage:
  cscript <input-file> [output-file]
  cscript --help
  cscript --init                       # Create default csconfig.json

Examples:
  cscript input.csc                    # Transpile and print to console
  cscript input.csc output.js          # Transpile and save to file
  cscript test.csc                     # Run the default test file

Options:
  --help, -h                           # Show this help message
  --init                               # Initialize csconfig.json
  --config <file>                      # Use custom config file
`);
    return;
  }

  if (args[0] === '--help' || args[0] === '-h') {
    console.log(`
CScript Transpiler - Hybrid Programming Language

CScript combines JavaScript, TypeScript, C, C++, and C# syntax features:

✅ Pipeline Operators:    value |> transform |> process
✅ Match Expressions:     value match { 1..10 => "range", _ => "default" }
✅ LINQ Queries:          from users where u => u.active select u => u.name
✅ With Updates:          obj withUpdate { prop.nested = "value" }
✅ Auto-Properties:       class { name: string { get; set; } }
✅ Operator Overloading:  class { $operator_+(other) { ... } }
✅ Enhanced Types:        function(value: number | string): number

Configuration:
  Create csconfig.json to customize transpilation options and language features.
`);
    return;
  }

  if (args[0] === '--init') {
    const defaultConfig: CSConfig = {
      compilerOptions: {
        target: "ES2020",
        module: "ESNext",
        outDir: "./dist",
        sourceMap: true,
        strict: true,
        removeComments: false,
        preserveConstEnums: true,
        skipLibCheck: true
      },
      languageFeatures: {
        pipelineOperators: true,
        matchExpressions: true,
        withUpdates: true,
        autoProperties: true,
        linqQueries: true,
        operatorOverloading: true,
        enhancedTypes: true
      },
      transpilation: {
        preserveWhitespace: true,
        generateHelpers: true,
        optimizeOutput: false,
        bundleHelpers: false
      },
      include: [
        "src/**/*.csc",
        "*.csc"
      ],
      exclude: [
        "node_modules/**/*",
        "dist/**/*",
        "**/*.d.ts"
      ],
      files: [],
      watch: {
        enabled: false,
        extensions: [".csc"],
        ignore: ["node_modules", "dist"]
      },
      output: {
        format: "module",
        extension: ".js",
        preserveStructure: true
      }
    };

    try {
      await fs.writeFile('csconfig.json', JSON.stringify(defaultConfig, null, 2), 'utf-8');
      console.log('✅ Created csconfig.json with default configuration');
      return;
    } catch (error) {
      console.error('❌ Error creating csconfig.json:', error);
      process.exit(1);
    }
  }

  try {
    const inputFile = args[0];
    const outputFile = args[1];
    
    const filePath = path.resolve(process.cwd(), inputFile);
    const cscriptCode = await fs.readFile(filePath, 'utf-8');

    console.log('🔄 Transpiling CScript...');
    
    // Pass config to transpiler (for future feature toggles)
    const jsCode = transpile(cscriptCode, config);

    if (outputFile) {
      const outputPath = path.resolve(process.cwd(), outputFile);
      await fs.writeFile(outputPath, jsCode, 'utf-8');
      console.log(`✅ Transpiled to: ${outputFile}`);
      
      if (config.compilerOptions?.sourceMap) {
        console.log('📍 Source maps: enabled');
      }
    } else {
      console.log('\n--- Transpiled JavaScript ---');
      console.log(jsCode);
    }

    // Show active language features
    if (config.languageFeatures) {
      const activeFeatures = Object.entries(config.languageFeatures)
        .filter(([_, enabled]) => enabled)
        .map(([feature, _]) => feature);
      
      if (activeFeatures.length > 0) {
        console.log(`\n🎯 Active features: ${activeFeatures.join(', ')}`);
      }
    }

  } catch (error) {
    console.error('❌ Error during transpilation:', error);
    process.exit(1);
  }
}

main();