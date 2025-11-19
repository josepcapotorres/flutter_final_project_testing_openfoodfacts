# 🧾 OpenFoodFacts Flutter — Testing, Clean Architecture & CI/CD

A Flutter project built around **Clean Architecture**, **TDD**, **Dependency Injection**, and solid **testing practices**, with a complete **CI/CD pipeline** powered by GitHub Actions.

This project emphasizes maintainable, testable code — and automates its delivery:
- 🔄 Automatic builds and distribution to **Firebase App Distribution** for testing.
- 🚀 Automated release to **Google Play (Closed Testing)** when pushing semantic version tags.

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

## ⚙️ CI/CD — Automated Android Distribution

This project includes a full GitHub Actions workflow for continuous integration and continuous delivery:

### 🔹 Testing Environment — Firebase App Distribution
- Triggered automatically **on every push to the `testing` branch**.
- Builds and signs the app.
- Distributes the build to **Firebase App Distribution** for internal testers.

### 🔹 Production Environment — Google Play (Closed Testing)
- Triggered **when pushing a Git tag** that matches:  
  **`v.*.*.*`**
- Generates the release AAB.
- Uploads it to the **Closed Testing** track in Google Play Console.

The pipeline handles:
- Secure authentication (GitHub Secrets)
- Build and signing
- Automated distribution to the correct environment

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
