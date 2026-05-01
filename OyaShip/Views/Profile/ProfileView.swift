import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        NavigationStack {
            ZStack {
                C.bg.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: S._24) {

                        // Avatar + wallet address
                        VStack(spacing: S._12) {
                            Circle()
                                .fill(C.cardHi)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(C.t3)
                                )

                            if let pub = auth.publicKey {
                                Text(shortAddress(pub))
                                    .font(.h2)
                                    .foregroundColor(C.t1)
                                Text("Stellar Testnet")
                                    .font(.cap)
                                    .foregroundColor(C.t2)
                            }
                        }
                        .padding(.top, S._32)

                        // Balance card
                        VStack(spacing: S._4) {
                            Text("Balance")
                                .font(.cap)
                                .foregroundColor(C.t2)
                            Text("\(auth.balance) XLM")
                                .font(.num(32))
                                .foregroundColor(C.t1)
                        }
                        .padding(S._24)
                        .frame(maxWidth: .infinity)
                        .background(C.card, in: RoundedRectangle(cornerRadius: R.lg))
                        .padding(.horizontal, S.pad)

                        // Role badge
                        if let role = auth.userRole {
                            HStack(spacing: S._8) {
                                Image(systemName: role == "seller" ? "storefront" : "cart")
                                    .foregroundColor(C.brand)
                                Text(role.capitalized)
                                    .font(.b2.bold())
                                    .foregroundColor(C.t1)
                            }
                            .padding(S._12)
                            .background(C.brandMuted, in: RoundedRectangle(cornerRadius: R.md))
                        }

                        Divider().background(C.border).padding(.horizontal, S.pad)

                        // Sign out
                        OyaButton(title: "Sign Out", style: .danger) {
                            Tap.med()
                            auth.signOut()
                        }
                        .padding(.horizontal, S.pad)

                        Spacer(minLength: S._32)
                    }
                }
            }
            .navigationTitle("Profile")
            .task { await auth.fetchBalance() }
        }
    }

    private func shortAddress(_ addr: String) -> String {
        guard addr.count > 12 else { return addr }
        return "\(addr.prefix(6))...\(addr.suffix(4))"
    }
}
