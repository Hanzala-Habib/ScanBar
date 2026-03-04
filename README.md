# ScanBar

Flutter barcode cart application using:
- **GetX** for state management + dependency injection.
- **sqflite** for real-time local persistence.
- **MVVM feature-based architecture** (`features/cart/...`).

## Features
- Scan a barcode and instantly add/update item in cart.
- Animated product list updates with quantity controls.
- Real-time running total.
- Product model includes name, quantity, and price.

## Architecture
- `core/`: shared database, models, services.
- `features/cart/data/domain`: repository (database operations).
- `features/cart/presentation/controllers`: GetX ViewModel/controller.
- `features/cart/presentation/pages|widgets`: UI.

## Run
1. Install Flutter SDK.
2. `flutter pub get`
3. `flutter run`

> This environment did not include Flutter tooling, so generation/checks were done by file creation.
