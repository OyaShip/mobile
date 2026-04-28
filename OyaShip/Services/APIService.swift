import SwiftUI

/// Communicates with the OyaShip backend API.
@MainActor
class APIService: ObservableObject {
    private let baseURL: String

    init(baseURL: String = "http://localhost:3000/api") {
        self.baseURL = baseURL
    }

    // MARK: - Helpers

    private var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }

    private func get<T: Decodable>(_ path: String) async -> T? {
        guard let url = URL(string: baseURL + path) else { return nil }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    private func post<B: Encodable, T: Decodable>(_ path: String, body: B) async -> T? {
        guard let url = URL(string: baseURL + path) else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder(); encoder.keyEncodingStrategy = .convertToSnakeCase
        req.httpBody = try? encoder.encode(body)
        guard let (data, _) = try? await URLSession.shared.data(for: req) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    // MARK: - Users

    func ensureUser(wallet: String) async -> UserProfile? {
        struct Body: Encodable { let wallet: String }
        return await post("/users", body: Body(wallet: wallet))
    }

    func fetchUser(wallet: String) async -> UserProfile? {
        await get("/users/\(wallet)")
    }

    func setRole(_ role: String, userId: String) async -> UserProfile? {
        struct Body: Encodable { let role: String }
        guard let url = URL(string: baseURL + "/users/\(userId)/role") else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "PATCH"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        req.httpBody = try? encoder.encode(Body(role: role))
        guard let (data, _) = try? await URLSession.shared.data(for: req) else { return nil }
        return try? decoder.decode(UserProfile.self, from: data)
    }

    // MARK: - Posts

    func fetchPosts(cursor: String? = nil) async -> PostPage {
        var path = "/posts?limit=20"
        if let c = cursor { path += "&cursor=\(c)" }
        return await get(path) ?? PostPage(posts: [], nextCursor: nil, hasMore: false)
    }

    func createPost(userId: String, text: String, imageUrl: String? = nil) async -> Post? {
        struct Body: Encodable { let userId: String; let text: String; let imageUrl: String? }
        return await post("/posts", body: Body(userId: userId, text: text, imageUrl: imageUrl))
    }

    func likePost(postId: String) async -> Bool {
        struct LikeResponse: Decodable { let likesCount: Int }
        let result: LikeResponse? = await post("/posts/\(postId)/like", body: EmptyBody())
        return result != nil
    }

    // MARK: - Listings

    func fetchListings(category: String? = nil, search: String? = nil) async -> [Listing] {
        var path = "/listings"
        var params: [String] = []
        if let c = category { params.append("category=\(c)") }
        if let s = search { params.append("search=\(s.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? s)") }
        if !params.isEmpty { path += "?" + params.joined(separator: "&") }
        return await get(path) ?? []
    }

    func fetchListing(id: String) async -> Listing? {
        await get("/listings/\(id)")
    }

    // MARK: - Chat

    func fetchConversations(userId: String) async -> [Conversation] {
        await get("/chat/conversations?userId=\(userId)") ?? []
    }

    func fetchMessages(conversationId: String) async -> [Message] {
        await get("/chat/messages?conversationId=\(conversationId)") ?? []
    }

    func sendMessage(conversationId: String, senderId: String, text: String) async -> Message? {
        struct Body: Encodable { let conversationId: String; let senderId: String; let body: String }
        return await post("/chat/messages", body: Body(conversationId: conversationId, senderId: senderId, body: text))
    }

    func startConversation(listingId: String, buyerId: String, sellerId: String) async -> Conversation? {
        struct Body: Encodable { let listingId: String; let buyerId: String; let sellerId: String }
        return await post("/chat/conversations", body: Body(listingId: listingId, buyerId: buyerId, sellerId: sellerId))
    }

    // MARK: - Escrow

    func fetchDeals(userId: String) async -> [Deal] {
        await get("/deals?userId=\(userId)") ?? []
    }

    func fetchDeal(id: String) async -> Deal? {
        await get("/deals/\(id)")
    }

    func shipDeal(dealId: String, sellerId: String) async -> Bool {
        struct Body: Encodable { let sellerId: String }
        struct Resp: Decodable { let success: Bool }
        let r: Resp? = await post("/deals/\(dealId)/ship", body: Body(sellerId: sellerId))
        return r?.success == true
    }

    func confirmDeal(dealId: String, buyerId: String) async -> Bool {
        struct Body: Encodable { let buyerId: String }
        struct Resp: Decodable { let success: Bool }
        let r: Resp? = await post("/deals/\(dealId)/confirm", body: Body(buyerId: buyerId))
        return r?.success == true
    }

    func cancelDeal(dealId: String, buyerId: String) async -> Bool {
        struct Body: Encodable { let buyerId: String }
        struct Resp: Decodable { let success: Bool }
        let r: Resp? = await post("/deals/\(dealId)/cancel", body: Body(buyerId: buyerId))
        return r?.success == true
    }

    func raiseDeal(dealId: String, callerId: String) async -> Bool {
        struct Body: Encodable { let callerId: String }
        struct Resp: Decodable { let success: Bool }
        let r: Resp? = await post("/deals/\(dealId)/dispute", body: Body(callerId: callerId))
        return r?.success == true
    }
}

private struct EmptyBody: Encodable {}
