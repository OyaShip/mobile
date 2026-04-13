import SwiftUI

/// Communicates with the OyaShip backend API.
@MainActor
class APIService: ObservableObject {
    private let baseURL = "http://localhost:3000/api"

    // MARK: - Users
    func ensureUser(wallet: String) async -> UserProfile? {
        // TODO: POST /api/users
        nil
    }

    // MARK: - Posts
    func fetchPosts() async -> [Post] {
        // TODO: GET /api/posts
        []
    }

    func createPost(userId: String, text: String) async -> Bool {
        // TODO: POST /api/posts
        false
    }

    // MARK: - Listings
    func fetchListings() async -> [Listing] {
        // TODO: GET /api/listings
        []
    }

    // MARK: - Chat
    func fetchConversations(userId: String) async -> [Conversation] {
        // TODO: GET /api/conversations?userId=
        []
    }

    func fetchMessages(conversationId: String) async -> [Message] {
        // TODO: GET /api/messages?conversationId=
        []
    }

    func sendMessage(conversationId: String, senderId: String, text: String) async -> Bool {
        // TODO: POST /api/messages
        false
    }

    // MARK: - Escrow
    func createDeal(buyerId: String, sellerId: String, amount: Double, description: String) async -> Deal? {
        // TODO: POST /api/deals
        nil
    }

    func getDealsByUser(userId: String) async -> [Deal] {
        // TODO: GET /api/deals?userId=
        []
    }
}
