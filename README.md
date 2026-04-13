<div align="center">

# OyaShip Mobile

**Native iOS app for cross-border social commerce with Stellar escrow.**

[![Swift](https://img.shields.io/badge/Swift-5.9-F05138?logo=swift)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5-0071E3?logo=apple)](https://developer.apple.com/swiftui/)
[![Stellar](https://img.shields.io/badge/Stellar-Testnet-7C68EE)](https://stellar.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

---

## Overview

This is the iOS client for **OyaShip** — a social commerce platform where importers discover products from global suppliers, negotiate in real-time chat, and pay safely through smart contract escrow on Stellar.

The app creates a Stellar wallet automatically on sign-in (no seed phrases), lets users browse a social feed, discover products, chat with sellers, and lock funds in onchain escrow until goods arrive.

**Related repos:**
- [OyaShip/backend](https://github.com/OyaShip/backend) — Node.js API
- [OyaShip/smartcontract](https://github.com/OyaShip/smartcontract) — Soroban escrow contract

---

## Features

- **Zero-friction Stellar wallet** — Ed25519 keypair via Apple CryptoKit, stored in iOS Keychain, funded via Friendbot
- **Social feed** — post photos, tag products, like and comment
- **Marketplace** — browse listings, filter by category, view seller reputation
- **Real-time chat** — message sellers, send offer cards, negotiate price
- **Escrow deals** — lock XLM in Soroban contract, track deal status (Created → Shipped → Confirmed)
- **Role-based UX** — buyers see Discover, sellers see My Shop
- **Onchain reputation** — completed deals count stored on Stellar

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Language** | Swift 5.9 |
| **UI** | SwiftUI 5 (iOS 17.5+) |
| **Crypto** | Apple CryptoKit (Ed25519) |
| **Key storage** | iOS Keychain Services |
| **Blockchain** | Stellar Testnet (Horizon API + Friendbot) |
| **Backend** | OyaShip API (Node.js + Supabase) |
| **Design** | Custom design system — pure black theme, 8pt grid, SF Rounded |

---

## Project Structure

```
OyaShip/
├── OyaShipApp.swift              App entry point
├── RootView.swift                Auth gate + navigation
│
├── Models/
│   └── Models.swift              User, Post, Listing, Conversation, Message, Deal
│
├── Services/
│   ├── AuthManager.swift         Stellar keypair gen, Keychain, Friendbot, balance
│   └── APIService.swift          Backend REST client
│
├── Theme/
│   └── Theme.swift               Colors (C), spacing (S), radius (R), typography, haptics
│
├── Components/
│   └── OyaButton.swift           Multi-variant button (primary, secondary, ghost, danger)
│
└── Views/
    ├── MainTabView.swift         Tab navigator (role-aware)
    ├── Auth/
    │   ├── LandingView.swift     Onboarding + sign-in
    │   └── RoleSelectionView.swift   Buyer / Seller picker
    ├── Feed/
    │   └── FeedView.swift        Social feed
    ├── Discover/
    │   └── DiscoverView.swift    Marketplace grid
    ├── Chat/
    │   ├── InboxView.swift       Conversations list
    │   └── ChatView.swift        Chat thread with message bubbles
    ├── Listing/
    │   └── ListingDetailView.swift   Product detail
    ├── Sell/
    │   └── SellView.swift        Seller dashboard
    ├── Escrow/
    │   └── EscrowView.swift      Deal management
    └── Profile/
        └── ProfileView.swift     Wallet, balance, sign out
```

---

## Getting Started

### Prerequisites

- **Xcode 15+** (Swift 5.9, iOS 17.5 SDK)
- **macOS Sonoma** or later
- An iPhone simulator or physical device

### Run

```bash
git clone https://github.com/OyaShip/mobile.git
cd mobile
open OyaShip.xcodeproj       # or create via Xcode → New Project
# Select iPhone simulator → Cmd+R
```

**Zero external dependencies.** No CocoaPods, no SPM packages. Pure SwiftUI + Apple frameworks.

### Wallet

On first launch, the app generates a Stellar testnet wallet:
1. Ed25519 keypair created via `CryptoKit.Curve25519`
2. Encoded to Stellar StrKey format (`G...` / `S...`)
3. Funded with 10,000 XLM via Friendbot
4. Keys stored in iOS Keychain (persists across launches)

---

## Design System

| Token | Value |
|---|---|
| Brand | `#FF6B35` (coral orange) |
| Background | `#000000` (pure black) |
| Card | `#111111` |
| Text primary | `#FFFFFF` |
| Text secondary | `#8E8E93` |
| Success / Danger | `#30D158` / `#FF453A` |
| Spacing grid | 8pt base |
| Typography | SF Rounded (headers), SF Pro (body) |

---

## User Flow

```
1. Open app                     → Landing screen
2. Tap "Start Trading Safely"   → Stellar wallet created automatically
3. Choose role                  → Buyer or Seller
4. Scroll social feed           → Discover tagged products
5. Tap product → listing detail → Chat with seller
6. Negotiate → lock funds       → Soroban escrow
7. Seller ships → buyer confirms→ Funds release (~5s)
```

---

## License

MIT
