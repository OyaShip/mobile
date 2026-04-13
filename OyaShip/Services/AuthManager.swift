import SwiftUI
import CryptoKit

/// Stellar wallet auth — Ed25519 keypair, Keychain storage, Friendbot funding.
@MainActor
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var publicKey: String?
    @Published var userRole: String?
    @Published var userId: String?
    @Published var balance: String = "0"

    init() { /* TODO: restore from Keychain */ }

    func createWallet() {
        // TODO: Generate Ed25519 keypair via CryptoKit
        // TODO: Encode as Stellar StrKey (G.../S...)
        // TODO: Store in Keychain
        // TODO: Fund via Friendbot
        isAuthenticated = true
    }

    func fetchBalance() async {
        // TODO: GET https://horizon-testnet.stellar.org/accounts/{publicKey}
    }

    func setRole(_ role: String) {
        userRole = role
    }

    func signOut() {
        isAuthenticated = false
        publicKey = nil
        userRole = nil
        userId = nil
        balance = "0"
    }
}
