import SwiftUI

struct FeedView: View {
    @EnvironmentObject var api: APIService
    @EnvironmentObject var auth: AuthManager
    @State private var posts: [Post] = []
    @State private var nextCursor: String?
    @State private var hasMore = false
    @State private var isLoading = false
    @State private var showCompose = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                C.bg.ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(posts) { post in
                            PostCard(post: post, onLike: { Task { await like(post) } })
                                .onAppear {
                                    if post.id == posts.last?.id && hasMore {
                                        Task { await loadMore() }
                                    }
                                }
                        }
                        if isLoading {
                            ProgressView().tint(C.brand).padding(S._24)
                        }
                    }
                }
                .refreshable { await refresh() }

                // Compose button
                Button { showCompose = true } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(C.brand, in: Circle())
                        .shadow(color: C.brand.opacity(0.4), radius: 12, y: 4)
                }
                .padding(S._24)
            }
            .navigationTitle("Feed")
            .task { await refresh() }
        }
    }

    private func refresh() async {
        isLoading = true
        let page = await api.fetchPosts()
        posts = page.posts; nextCursor = page.nextCursor; hasMore = page.hasMore
        isLoading = false
    }

    private func loadMore() async {
        guard !isLoading else { return }
        isLoading = true
        let page = await api.fetchPosts(cursor: nextCursor)
        posts += page.posts; nextCursor = page.nextCursor; hasMore = page.hasMore
        isLoading = false
    }

    private func like(_ post: Post) async {
        _ = await api.likePost(postId: post.id)
        if let idx = posts.firstIndex(where: { $0.id == post.id }) {
            // optimistic update
            let updated = Post(
                id: post.id, userId: post.userId, text: post.text,
                imageUrl: post.imageUrl, taggedListingId: post.taggedListingId,
                likesCount: post.likesCount + 1, commentsCount: post.commentsCount,
                createdAt: post.createdAt
            )
            posts[idx] = updated
        }
    }
}

// MARK: - PostCard

private struct PostCard: View {
    let post: Post
    let onLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: S._12) {
            // Author row
            HStack(spacing: S._8) {
                Circle()
                    .fill(C.cardHi)
                    .frame(width: 36, height: 36)
                    .overlay(Image(systemName: "person.fill").foregroundColor(C.t3).font(.caption))
                Text(shortId(post.userId))
                    .font(.cap.bold())
                    .foregroundColor(C.t1)
                Spacer()
                Text(shortDate(post.createdAt))
                    .font(.cap)
                    .foregroundColor(C.t2)
            }

            // Post body
            Text(post.text)
                .font(.b2)
                .foregroundColor(C.t1)

            // Like button
            HStack(spacing: S._4) {
                Button(action: { Tap.light(); onLike() }) {
                    Image(systemName: "heart")
                        .foregroundColor(C.t2)
                }
                Text("\(post.likesCount)")
                    .font(.cap)
                    .foregroundColor(C.t2)
            }
        }
        .padding(S.pad)
        .background(C.bg)
        Divider().background(C.border)
    }

    private func shortId(_ id: String) -> String {
        id.count > 8 ? String(id.prefix(8)) : id
    }

    private func shortDate(_ str: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: str) else { return "" }
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .abbreviated
        return f.localizedString(for: date, relativeTo: Date())
    }
}
