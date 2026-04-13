import SwiftUI

struct RoleSelectionView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        VStack(spacing: S._24) {
            Text("How will you use OyaShip?").font(.h1).foregroundColor(C.t1)

            OyaButton(label: "I'm a Buyer", icon: "cart.fill") { auth.setRole("buyer") }
            OyaButton(label: "I'm a Seller", variant: .secondary, icon: "storefront.fill") { auth.setRole("seller") }
        }
        .padding(S.pad)
        .background(C.bg.ignoresSafeArea())
    }
}
