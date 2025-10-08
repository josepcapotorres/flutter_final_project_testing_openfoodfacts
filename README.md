# 🧾 OpenFoodFacts Flutter — Testing & Clean Architecture

A Flutter project built around **Clean Architecture**, **TDD**, **Dependency injection** and solid **testing practices**.  
It focuses on writing maintainable code and testing every layer of the app.

---

## 🚀 Features
- 📷 Barcode scanner
- 🧃 Product details page
- 🕓 History of previous product scans

---

## 🧱 Architecture
Follows **Clean Architecture** principles:
- **Domain**: Entities and use cases
- **Data**: Repositories and data sources (local with Hive, remote with HTTP)
- **Presentation**: Cubits and UI

All dependencies are managed with **GetIt**.

---

## 🧪 Testing
Includes complete testing coverage:
- **Unit tests** → Business logic and repositories
- **Bloc tests** → State transitions
- **Widget tests** → UI and navigation flow

---

## 🧰 Tech Stack
| Purpose | Package |
|----------|----------|
| State management | flutter_bloc |
| Local storage | hive |
| Networking | http |
| Testing | flutter_test, bloc_test, mocktail |
| Dependency injection | get_it |
| Barcode scanning | flutter_barcode_scanner |

