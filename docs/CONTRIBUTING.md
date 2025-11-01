# Contributing to CScript Transpiler

Thank you for your interest in contributing to CScript! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn
- Basic knowledge of TypeScript and JavaScript ASTs

### Setup Development Environment

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/YOUR-USERNAME/cscript-transpiler.git
   cd cscript-transpiler
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Run the project**
   ```bash
   npm start
   ```

## 🔧 Development Workflow

### Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Edit the relevant files in the project
   - Test your changes by running `npm start`
   - Update test cases in `test.csc` if needed

3. **Test your changes**
   ```bash
   # Run the transpiler
   npm start
   
   # Check TypeScript compilation
   npx tsc --noEmit
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

### Commit Message Convention

We follow conventional commits:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `refactor:` for code refactoring
- `test:` for adding tests
- `chore:` for maintenance tasks

## 📝 Code Style

- Use TypeScript for all new code
- Follow existing code formatting
- Add comments for complex logic
- Keep functions small and focused

## 🧪 Testing

### Testing Your Changes

1. **Modify `test.csc`** with your test cases
2. **Run the transpiler**: `npm start`
3. **Verify output** is correct JavaScript
4. **Test edge cases** like nested pipelines

### Example Test Cases

Add test cases to `test.csc`:

```javascript
// Basic pipeline
let basic = 5 |> square;

// Chained pipeline
let chained = 10 |> square |> (n => n + 1);

// Complex expressions
let complex = [1, 2, 3] |> (arr => arr.map(square)) |> (arr => arr.reduce((a, b) => a + b));
```

## 🐛 Reporting Issues

### Bug Reports

When reporting bugs, please include:

1. **Description** of the issue
2. **Steps to reproduce** the bug
3. **Expected behavior**
4. **Actual behavior**
5. **CScript code** that causes the issue
6. **Environment** (Node.js version, OS)

### Feature Requests

For feature requests:

1. **Describe the feature** you'd like to see
2. **Explain the use case** and why it's valuable
3. **Provide examples** of how it would work
4. **Consider backwards compatibility**

## 🎯 Areas for Contribution

### High Priority
- Better error handling and error messages
- Source map generation
- Performance optimizations
- More comprehensive test cases

### Medium Priority
- CLI tool improvements
- Support for additional pipeline operators
- Integration with build tools
- Documentation improvements

### Low Priority
- VS Code extension for syntax highlighting
- Prettier plugin for formatting
- Benchmark suite

## 📋 Pull Request Process

1. **Create a pull request** from your feature branch
2. **Fill out the PR template** (describe your changes)
3. **Ensure CI passes** (GitHub Actions)
4. **Request review** from maintainers
5. **Address feedback** if any
6. **Merge** once approved

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Changes are tested with example code
- [ ] Documentation is updated if needed
- [ ] Commit messages follow convention
- [ ] No breaking changes (or clearly documented)

## 🤝 Code of Conduct

- Be respectful and inclusive
- Help others learn and grow
- Focus on constructive feedback
- Keep discussions technical and professional

## 🙋 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **Discussions**: For questions and general discussion
- **Email**: Contact maintainers for sensitive issues

## 📚 Resources

- [Babel AST Explorer](https://astexplorer.net/) - Visualize JavaScript ASTs
- [Babel Handbook](https://github.com/jamiebuilds/babel-handbook) - Learn about Babel transformations
- [Pipeline Operator Proposal](https://github.com/tc39/proposal-pipeline-operator) - TC39 proposal for pipeline operator

Thank you for contributing to CScript! 🎉