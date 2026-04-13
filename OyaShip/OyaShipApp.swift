import SwiftUI

@main
struct OyaShipApp: App {
    @StateObject private var auth = AuthManager()
    @StateObject private var api = APIService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .environmentObject(api)
                .preferredColorScheme(.dark)
        }
    }
}
