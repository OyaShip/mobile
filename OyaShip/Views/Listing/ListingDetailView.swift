import SwiftUI

struct ListingDetailView: View {
    let listing: Listing

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: S._20) {
                // TODO: Hero image
                RoundedRectangle(cornerRadius: R.md).fill(C.cardHi).frame(height: 300)

                Text(listing.title).font(.h1).foregroundColor(C.t1)
                Text("\(String(format: "%.1f", listing.price)) XLM").font(.num(28)).foregroundColor(C.brand)
                Text(listing.description).font(.b2).foregroundColor(C.t2).lineSpacing(4)
            }
            .padding(S.pad)
        }
        .background(C.bg)
        .navigationBarTitleDisplayMode(.inline)
    }
}
