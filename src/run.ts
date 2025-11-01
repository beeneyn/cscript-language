import { promises as fs } from 'fs';
import * as path from 'path';
import { transpile } from './transpile.js';

async function main() {
  try {
    const filePath = path.resolve(process.cwd(), 'test.csc');
    const cscriptCode = await fs.readFile(filePath, 'utf-8');

    console.log('--- CScript Input ---');
    console.log(cscriptCode);

    // Run the transpiler
    const jsCode = transpile(cscriptCode);

    console.log('\n--- Transpiled JS Output ---');
    console.log(jsCode);
    
    console.log('\n--- Running JS Output ---');
    // We can even use 'eval' to run the code and prove it works!
    // (Use eval carefully in real projects)
    eval(jsCode);

  } catch (error) {
    console.error('Error during transpilation:', error);
  }
}

main();