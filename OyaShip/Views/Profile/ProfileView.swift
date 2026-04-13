import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        NavigationStack {
            VStack(spacing: S._24) {
                // TODO: Avatar, handle, wallet address
                Text(auth.publicKey ?? "No wallet").font(.cap).foregroundColor(C.t2)
                Text("\(auth.balance) XLM").font(.num(34)).foregroundColor(C.t1)

                Spacer()

                OyaButton(label: "Sign Out", variant: .danger, icon: "rectangle.portrait.and.arrow.right") {
                    auth.signOut()
                }
            }
            .padding(S.pad)
            .background(C.bg.ignoresSafeArea())
            .navigationTitle("Profile")
        }
    }
}
