# 📱 CoinWatch

## 📝 Task

Build an iPhone app that fetches the **current exchange rate of Bitcoin (BTC) in EUR**, with two screens:

- ✅ **List Screen**: Displays the historical Bitcoin price for the past **2 weeks**, including **today**.
  - The price for **today** is fetched in **real-time** and updates **every 60 seconds**.
  - Tapping a specific date navigates to the detail screen.

- ✅ **Detail Screen**: Shows the **Bitcoin price on the selected day** in **EUR, USD**, and **GBP**, with the option to return to the list screen.

---

## 🧰 Architecture & Tools

- iOS 16.0  
- iPhoneOS  
- Clean Architecture (Vertical Layering)  
- Swift & SwiftUI with Navigation  
- Unit Tested  

---

## 🧭 Approach

1. Utilized **SwiftUI** for faster and declarative UI development.
2. Introduced **ViewModels** to manage presentation state, keeping view logic minimal and testable.
3. Integrated **[Resolver](https://github.com/hmlongco/Resolver)** for dependency injection, simplifying testability and modularity.
4. Followed **Clean Architecture** with a **vertical layering** approach to enforce separation of concerns.
5. Wrote **unit tests** for key components, including **ViewModels** and **Use Cases**, to ensure stability and correctness.

---

## 📦 3rd-Party Decision: Resolver

The decision to use `Resolver` for **dependency management** was based on the need for:

- Minimal boilerplate  
- Test-friendly architecture  
- Avoidance of manual dependency drilling  
- Familiar API patterns used widely in iOS development  

While a custom container could work, `Resolver` offers a clean and lightweight solution without introducing unnecessary complexity.

---

## 🏗️ Architectural Decision

- Applied a **ViewModel layer** to separate UI logic from SwiftUI Views, improving **unit testability** and maintainability.
- Ensured **state management** is tightly integrated with the views, avoiding actions on invalid states and improving user experience.
- Adopted a **vertical layering structure**, clearly separating:
  - **Presentation Layer**  
  - **Domain Layer** (business logic)  
  - **Data Layer**  

For a deeper understanding of this approach, I recommend reading:  
👉 [Horizontal and Vertical Layers in Software Development](https://markusherkommer.medium.com/horizontal-and-vertical-layers-in-software-development-4af12e54c08a)

In *CoinWatch*, each architectural layer is represented within clearly named folders for simplicity. This keeps the project clean and navigable without adding unnecessary overhead like creating separate modules or packages.

> Note: For simplicity, network calls are currently handled directly in the `Repository`. In larger-scale apps, this would typically be abstracted further into a **dedicated networking layer**.

---

## ▶️ How to Run

1. Install the latest version of **Xcode**.
2. Clone the project and check out the `development` branch.
3. Open the project in Xcode.
4. Connect your **iPhone** to your Mac.  
   *(Due to a simulator issue on my machine, the app must be run on a real device.)*
5. Select your iPhone as the destination and press **Run** to install the app.

---
