import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var api: APIService
    @State private var listings: [Listing] = []
    @State private var search = ""
    @State private var selectedCategory: String? = nil
    @State private var isLoading = false

    private let categories = ["all", "electronics", "fashion", "home", "beauty", "sports", "food", "other"]

    private let columns = [
        GridItem(.flexible(), spacing: S._12),
        GridItem(.flexible(), spacing: S._12),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                C.bg.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Search bar
                    HStack(spacing: S._8) {
                        Image(systemName: "magnifyingglass").foregroundColor(C.t2)
                        TextField("Search products...", text: $search)
                            .foregroundColor(C.t1)
                            .submitLabel(.search)
                            .onSubmit { Task { await load() } }
                    }
                    .padding(S._12)
                    .background(C.card, in: RoundedRectangle(cornerRadius: R.md))
                    .padding(.horizontal, S.pad)
                    .padding(.top, S._8)

                    // Category chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: S._8) {
                            ForEach(categories, id: \.self) { cat in
                                CategoryChip(label: cat, isSelected: selectedCategory == cat || (cat == "all" && selectedCategory == nil)) {
                                    selectedCategory = cat == "all" ? nil : cat
                                    Task { await load() }
                                }
                            }
                        }
                        .padding(.horizontal, S.pad)
                        .padding(.vertical, S._8)
                    }

                    if isLoading && listings.isEmpty {
                        Spacer()
                        ProgressView().tint(C.brand)
                        Spacer()
                    } else if listings.isEmpty {
                        Spacer()
                        Text("No listings found")
                            .font(.b2).foregroundColor(C.t2)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: S._12) {
                                ForEach(listings) { listing in
                                    NavigationLink(destination: ListingDetailView(listing: listing)) {
                                        ListingCard(listing: listing)
                                    }
                                }
                            }
                            .padding(S.pad)
                        }
                        .refreshable { await load() }
                    }
                }
            }
            .navigationTitle("Discover")
            .task { await load() }
        }
    }

    private func load() async {
        isLoading = true
        listings = await api.fetchListings(
            category: selectedCategory,
            search: search.isEmpty ? nil : search
        )
        isLoading = false
    }
}

// MARK: - Category chip

private struct CategoryChip: View {
    let label: String; let isSelected: Bool; let onTap: () -> Void
    var body: some View {
        Button(action: { Tap.light(); onTap() }) {
            Text(label.capitalized)
                .font(.cap.bold())
                .foregroundColor(isSelected ? .white : C.t2)
                .padding(.horizontal, S._12)
                .padding(.vertical, 6)
                .background(isSelected ? C.brand : C.card, in: Capsule())
        }
    }
}

// MARK: - Listing card

private struct ListingCard: View {
    let listing: Listing
    var body: some View {
        VStack(alignment: .leading, spacing: S._8) {
            Rectangle()
                .fill(C.cardHi)
                .aspectRatio(1, contentMode: .fit)
                .overlay(Image(systemName: "photo").foregroundColor(C.t3))
                .cornerRadius(R.sm)

            Text(listing.title)
                .font(.cap.bold())
                .foregroundColor(C.t1)
                .lineLimit(2)
            Text(String(format: "%.2f XLM", listing.price))
                .font(.cap)
                .foregroundColor(C.brand)
        }
        .padding(S._8)
        .background(C.card, in: RoundedRectangle(cornerRadius: R.md))
    }
}
