# Changelog

All notable changes to OyaShip Mobile are documented here.

## [Unreleased]

### Added
- **APIService** — full URLSession implementation for all endpoints:
  users, posts (paginated), listings (with search + category filter),
  chat (conversations + messages), and escrow deals lifecycle
- **AuthManager** — Ed25519 keypair generation via CryptoKit,
  Stellar StrKey encoding (G.../S...), iOS Keychain storage, Friendbot funding,
  live XLM balance fetching from Horizon
- **DealCard** — reusable component with status badge, amount display,
  and contextual action buttons (Ship, Confirm, Cancel, Dispute)
- **EscrowView** — live deal list with pull-to-refresh, action handlers,
  and empty state
- **FeedView** — paginated social feed with optimistic like updates
  and infinite scroll
- **DiscoverView** — listings grid with search bar and category filter chips
- **ProfileView** — wallet address display, live XLM balance, role badge,
  and sign-out
- **OyaButton** — danger and ghost styles added alongside existing primary/secondary
- `PostPage` pagination model
- `Deal.statusLabel`, `Deal.statusColor`, `Deal.isActive` model extensions
- `CONTRIBUTING.md`

### Changed
- `Models.swift` — `Deal.status` changed from enum to `String` for Codable compatibility;
  display helpers moved to extensions
