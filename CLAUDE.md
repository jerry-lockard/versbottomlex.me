# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

### Frontend (Flutter)
- Build: `cd frontend && flutter build <platform>` (web/apk/ios)
- Run: `cd frontend && flutter run`
- Analyze: `cd frontend && flutter analyze`
- Test all: `cd frontend && flutter test`
- Test single: `cd frontend && flutter test test/widget_test.dart`
- Format: `cd frontend && dart format lib/`

### Backend (Node.js)
- Start: `cd backend && npm start`
- Test: `cd backend && npm test`
- Install: `cd backend && npm install`

## Code Style Guidelines

### Flutter/Dart
- Use `const` constructors when possible
- Prefer named parameters for widgets
- Follow standard Flutter widgets naming (MyWidget, _MyWidgetState)
- Type all variables and parameters
- Use `required` for mandatory parameters
- Import organization: dart:core, package:flutter, project imports
- Error handling: use try/catch blocks with specific exceptions

### Backend
- Use camelCase for variables and functions
- Use meaningful variable names
- Group related functionality in modules
- Document API endpoints with JSDoc