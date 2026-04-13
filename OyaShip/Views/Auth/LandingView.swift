import SwiftUI

struct LandingView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var showSignIn = false

    var body: some View {
        ZStack {
            C.bg.ignoresSafeArea()
            VStack(spacing: S._24) {
                Spacer()
                Text("OyaShip").font(.d1).foregroundColor(C.t1)
                Text("Pay your supplier. Get your goods.")
                    .font(.b1).foregroundColor(C.t2).multilineTextAlignment(.center)
                Spacer()
                OyaButton(label: "Start Trading Safely", icon: "arrow.right") {
                    showSignIn = true
                }
                .padding(.horizontal, S.pad)
            }
            .padding(.bottom, S._32)
        }
        .sheet(isPresented: $showSignIn) {
            // TODO: Sign-in sheet
            Text("Sign In").padding()
        }
    }
}
