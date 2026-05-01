# Contributing to OyaShip Mobile

Thank you for your interest in contributing!

## Prerequisites

- **Xcode 15+** (Swift 5.9, iOS 17.5 SDK)
- **macOS Sonoma** or later

## Setup

```bash
git clone https://github.com/OyaShip/mobile.git
cd mobile
open OyaShip.xcodeproj
```

No external dependencies — pure SwiftUI + Apple frameworks.

## Running the App

1. Select an iPhone 15 simulator (iOS 17.5+)
2. Press `Cmd+R` or click the Run button
3. On first launch a Stellar testnet wallet is created automatically

## Project Structure

- `OyaShip/Services/` — API and auth logic
- `OyaShip/Views/` — SwiftUI screens
- `OyaShip/Components/` — reusable UI components
- `OyaShip/Models/` — data models
- `OyaShip/Theme/` — design system tokens

## Pull Request Process

1. Branch off `main`: `git checkout -b feat/your-feature`
2. Make your changes with descriptive commits
3. Ensure the project builds without warnings (`Cmd+B`)
4. Open a PR against `main` and fill in the template

## Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add offer card to ChatView
fix: handle nil publicKey in ProfileView
chore: update Xcode project settings
test: add unit tests for AuthManager
docs: update README setup steps
```

## Code Style

- Use `@MainActor` on all `ObservableObject` classes that update UI
- Prefer `async/await` over closures for network calls
- Follow the existing theme tokens (`C.`, `S.`, `R.`) — no hardcoded values
- No force-unwraps (`!`) in production code
