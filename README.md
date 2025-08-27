# Archonit Crypto App

Cryptocurrency listing application with pagination and dynamic color generation.

## Features

- 📱 Cryptocurrency listing with real-time prices
- 🔄 Pagination (15 items per page, scroll to load more)
- 🎨 Dynamic RGB color generation (16M+ colors)
- 📊 Professional price formatting
- 🔄 Pull-to-refresh functionality
- ⚡ Loading states and error handling

## Architecture - ValueNotifier Pattern

```
UI Layer
  ↓
ValueNotifier (State Management)
  ↓
Repository (Business Logic + Safe Call)
  ↓
API Client (Dio + Retrofit)
  ↓
Interceptor (API Key Injection)
  ↓
CoinCap API
```

### State Management Flow
- **UI Widgets** → Listen to `ValueNotifier` changes
- **ValueNotifier** → Manages state with sealed classes (`CryptoListState`)
- **Repository** → Handles business logic with `Result<T>` pattern
- **Safe Call** → Wraps API calls with try-catch error handling
- **API Client** → Type-safe Retrofit client with Dio
- **Interceptor** → Automatically injects API key to requests

## Tech Stack

- **Flutter**: 3.32.2+
- **State Management**: ValueNotifier
- **HTTP Client**: Dio + Retrofit
- **Data Models**: Freezed (immutable classes)
- **API**: CoinCap REST API
- **Architecture**: Clean Architecture with Repository Pattern
- **Code Generation**: Custom `api_gen` tool (coming soon to [pub.dev](https://pub.dev))

## 🛠️ Custom Tooling

### **api_gen** - REST API Client Generator

This project uses a **custom-built code generation tool** developed by [@krysnkem](https://github.com/krysnkem):

- **🎯 Purpose**: Generates type-safe Retrofit API clients from OpenAPI/REST documentation
- **🔧 Used For**: CoinCap API client generation (`lib/data/api/coincap_api_client.dart`)
- **📦 Status**: Coming soon to [pub.dev](https://pub.dev) 
- **🏗️ Benefits**: 
  - Automated API client generation
  - Type-safe HTTP calls
  - Reduced boilerplate code
  - Consistent API integration patterns

*The generated API client demonstrates production-ready patterns for REST API integration in Flutter.*

## Quick Start

```bash
# Install dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build

# Run the app
flutter run

# Run tests
flutter test
```

## 🌿 State Management Implementations

This project showcases **three different state management approaches** for the same cryptocurrency app:

### 📋 Branch Overview

| Branch | State Management | Description | Status |
|--------|------------------|-------------|--------|
| [`main/vanilla`](https://github.com/krysnkem/crypto_app/tree/main/vanilla) | **ValueNotifier** | Baseline Flutter implementation | ✅ **Current** |
| [`alt/riverpod`](https://github.com/krysnkem/crypto_app/tree/alt/riverpod) | **Riverpod** | Modern reactive state management | ✅ Complete |
| [`alt/bloc-cubit`](https://github.com/krysnkem/crypto_app/tree/alt/bloc-cubit) | **BLoC Cubit** | Enterprise state management | ✅ Complete |

### 🎯 **Why Multiple Implementations?**

- **📚 Learning**: Compare different architectural approaches
- **🔍 Portfolio**: Demonstrate mastery of multiple patterns  
- **⚖️ Decision Making**: Understand trade-offs between approaches
- **🏢 Enterprise Ready**: Show adaptability to different project requirements

### 🏗️ **Consistent Architecture**

All branches maintain the **same clean architecture**:
- ✅ **Requirements Compliance**: Figma design, pagination, color generation
- ✅ **Repository Pattern**: Clean separation of business logic
- ✅ **API Integration**: Professional Dio + Retrofit implementation
- ✅ **Testing Strategy**: Comprehensive test coverage
- ✅ **Code Quality**: Flutter best practices across all implementations

*Switch between branches to explore different state management patterns while maintaining identical functionality.*
