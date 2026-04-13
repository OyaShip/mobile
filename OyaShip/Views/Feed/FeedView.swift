import SwiftUI

struct FeedView: View {
    @EnvironmentObject var api: APIService
    @State private var posts: [Post] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: S._16) {
                    ForEach(posts) { post in
                        // TODO: PostCard view
                        Text(post.text)
                            .padding(S._16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(C.card, in: RoundedRectangle(cornerRadius: R.md))
                    }
                }
                .padding(S.pad)
            }
            .background(C.bg)
            .navigationTitle("Feed")
            .task { posts = await api.fetchPosts() }
        }
    }
}
