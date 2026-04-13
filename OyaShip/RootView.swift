import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        Group {
            if !auth.isAuthenticated {
                LandingView()
            } else if auth.userRole == nil {
                RoleSelectionView()
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut, value: auth.isAuthenticated)
    }
}
