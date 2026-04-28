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

struct PostPage: Codable {
    let posts: [Post]
    let nextCursor: String?
    let hasMore: Bool
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

// MARK: - Deal

struct Deal: Codable, Identifiable {
    let id: String
    let buyer: String
    let seller: String
    let amount: Double
    let description: String
    let status: String     // created | shipped | confirmed | disputed | resolved | cancelled
    let txHash: String?
    let createdAt: String
}

// MARK: - Deal status helpers

extension Deal {
    var statusLabel: String {
        switch status {
        case "created":   return "Awaiting Shipment"
        case "shipped":   return "In Transit"
        case "confirmed": return "Completed"
        case "disputed":  return "Disputed"
        case "resolved":  return "Resolved"
        case "cancelled": return "Cancelled"
        default:          return status.capitalized
        }
    }

    var statusColor: String {
        switch status {
        case "created":   return "yellow"
        case "shipped":   return "blue"
        case "confirmed": return "green"
        case "disputed":  return "red"
        case "resolved":  return "green"
        case "cancelled": return "gray"
        default:          return "gray"
        }
    }

    var isActive: Bool { status == "created" || status == "shipped" }
    var isBuyer:  Bool { false } // resolved with wallet context at call site
}
