import Foundation

// MARK: - User

struct UserProfile: Codable, Identifiable {
    let id: String
    let wallet: String
    let handle: String
    let displayName: String?
    let avatarUrl: String?
    let role: String?
    let createdAt: String?
}

// MARK: - Listing

struct Listing: Codable, Identifiable {
    let id: String
    let sellerId: String
    let title: String
    let description: String
    let price: Double
    let category: String
    let moq: Int
    let shipDays: Int
    let imageUrl: String?
    let status: String
}

// MARK: - Post

struct Post: Codable, Identifiable {
    let id: String
    let userId: String
    let text: String
    let imageUrl: String?
    let taggedListingId: String?
    let likesCount: Int
    let commentsCount: Int
    let createdAt: String
}

// MARK: - Conversation

struct Conversation: Codable, Identifiable {
    let id: String
    let listingId: String?
    let buyerId: String
    let sellerId: String
    let lastMessage: String?
    let lastAt: String
}

// MARK: - Message

struct Message: Codable, Identifiable {
    let id: String
    let conversationId: String
    let senderId: String
    let type: String       // text | offer | system
    let body: String?
    let offerAmount: Double?
    let offerStatus: String?
    let createdAt: String
}

// MARK: - Deal (escrow)

enum DealStatus: Int, Codable {
    case none = 0
    case created = 1
    case shipped = 2
    case confirmed = 3
    case disputed = 4
    case resolved = 5
    case cancelled = 6
}

struct Deal: Codable, Identifiable {
    let id: String
    let buyer: String
    let seller: String
    let amount: Double
    let description: String
    let status: DealStatus
    let createdAt: String
}
