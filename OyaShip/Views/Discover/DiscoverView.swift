import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var api: APIService
    @State private var listings: [Listing] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: S._16) {
                    ForEach(listings) { listing in
                        // TODO: ListingCard view
                        VStack(alignment: .leading, spacing: S._8) {
                            RoundedRectangle(cornerRadius: R.sm)
                                .fill(C.cardHi)
                                .frame(height: 140)
                            Text(listing.title).font(.h2).foregroundColor(C.t1).lineLimit(2)
                            Text("\(String(format: "%.1f", listing.price)) XLM").font(.num(16)).foregroundColor(C.brand)
                        }
                        .padding(S._12)
                        .background(C.card, in: RoundedRectangle(cornerRadius: R.md))
                    }
                }
                .padding(S.pad)
            }
            .background(C.bg)
            .navigationTitle("Discover")
            .task { listings = await api.fetchListings() }
        }
    }
}
