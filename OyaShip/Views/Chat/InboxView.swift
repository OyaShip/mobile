import SwiftUI

struct InboxView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var api: APIService
    @State private var conversations: [Conversation] = []

    var body: some View {
        NavigationStack {
            List(conversations) { convo in
                NavigationLink {
                    ChatView(conversationId: convo.id)
                } label: {
                    VStack(alignment: .leading, spacing: S._4) {
                        Text("Conversation").font(.h2).foregroundColor(C.t1)
                        Text(convo.lastMessage ?? "No messages yet").font(.b2).foregroundColor(C.t2).lineLimit(1)
                    }
                    .padding(.vertical, S._8)
                }
            }
            .listStyle(.plain)
            .background(C.bg)
            .navigationTitle("Inbox")
            .task {
                if let uid = auth.userId {
                    conversations = await api.fetchConversations(userId: uid)
                }
            }
        }
    }
}
