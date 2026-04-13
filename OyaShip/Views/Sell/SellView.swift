import SwiftUI

struct SellView: View {
    @EnvironmentObject var api: APIService
    @State private var listings: [Listing] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: S._16) {
                    // TODO: Stats cards
                    // TODO: "Post new listing" button
                    ForEach(listings) { listing in
                        Text(listing.title).foregroundColor(C.t1)
                    }
                }
                .padding(S.pad)
            }
            .background(C.bg)
            .navigationTitle("My Shop")
            .task { listings = await api.fetchListings() }
        }
    }
}
