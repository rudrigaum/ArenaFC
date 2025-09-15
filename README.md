# ⚽️ ArenaFC

ArenaFC is a mobile application for iOS designed for passionate football (soccer) fans. It provides a personalized experience, allowing users to follow their favorite team closely with quick access to the latest match results, upcoming fixtures, and current league standings.

This project is being built as a portfolio piece to demonstrate a deep understanding of modern iOS development principles and best practices.

## ✨ Key Features

* **Favorite Team Selection:** A simple onboarding process to select and save a favorite team.
* **Team Dashboard:** A central hub displaying the most relevant information: next match, last result, and current league position.
* **Match Details:** In-depth view for each match, including scores, statistics, and lineups.
* **League Standings:** A full and up-to-date league table, with the user's favorite team highlighted.
* **Player Roster:** View the current squad of the selected team.

## 🛠️ Tech Stack & Architecture

The project is built using the latest Apple technologies and follows industry best practices to ensure scalability, maintainability, and code quality.

* **UI:** 100% **SwiftUI** for a modern, declarative user interface.
* **Architecture:** **MVVM-C (Model-View-ViewModel-Coordinator)** to ensure a clean separation of concerns and decoupled navigation logic.
* **Data Persistence:** **SwiftData** for robust and efficient on-device storage of user preferences.
* **Concurrency:** Modern concurrency with **`async/await`** for clean and safe asynchronous network operations.
* **Networking:** A reusable networking layer built on top of native **`URLSession`**.
* **Code Quality:** **SwiftLint** is integrated to enforce a consistent code style and best practices.
* **Dependency Management:** **Swift Package Manager (SPM)**.
* **API:** All football data is provided by the [API-Football](https://www.api-football.com/).
