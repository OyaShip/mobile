import SwiftUI

struct ChatView: View {
    let conversationId: String
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var api: APIService
    @State private var messages: [Message] = []
    @State private var draft = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: S._8) {
                    ForEach(messages) { msg in
                        // TODO: Message bubble
                        HStack {
                            if msg.senderId == auth.userId { Spacer() }
                            Text(msg.body ?? "")
                                .padding(S._12)
                                .background(msg.senderId == auth.userId ? C.brand : C.card, in: RoundedRectangle(cornerRadius: R.md))
                                .foregroundColor(.white)
                            if msg.senderId != auth.userId { Spacer() }
                        }
                    }
                }
                .padding(S.pad)
            }

            // Input bar
            HStack(spacing: S._12) {
                TextField("Message...", text: $draft)
                    .padding(S._12)
                    .background(C.card, in: RoundedRectangle(cornerRadius: R.lg))

                Button {
                    guard let uid = auth.userId, !draft.isEmpty else { return }
                    let text = draft; draft = ""
                    Task { _ = await api.sendMessage(conversationId: conversationId, senderId: uid, text: text) }
                } label: {
                    Image(systemName: "arrow.up.circle.fill").font(.system(size: 32)).foregroundColor(C.brand)
                }
            }
            .padding(S.pad)
            .background(C.bg)
        }
        .background(C.bg)
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .task { messages = await api.fetchMessages(conversationId: conversationId) }
    }
}
