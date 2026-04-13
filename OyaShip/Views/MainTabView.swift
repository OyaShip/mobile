import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        TabView {
            FeedView()
                .tabItem { Label("Feed", systemImage: "house.fill") }

            if auth.userRole == "buyer" {
                DiscoverView()
                    .tabItem { Label("Discover", systemImage: "magnifyingglass") }
            } else {
                SellView()
                    .tabItem { Label("My Shop", systemImage: "storefront.fill") }
            }

            InboxView()
                .tabItem { Label("Inbox", systemImage: "bubble.left.and.bubble.right.fill") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(C.brand)
    }
}
