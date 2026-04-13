import SwiftUI

struct EscrowView: View {
    @EnvironmentObject var api: APIService
    @State private var deals: [Deal] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: S._16) {
                    ForEach(deals) { deal in
                        // TODO: DealCard with status badge and actions
                        VStack(alignment: .leading, spacing: S._8) {
                            Text(deal.description).font(.h2).foregroundColor(C.t1)
                            Text("\(String(format: "%.1f", deal.amount)) XLM").font(.num(20)).foregroundColor(C.brand)
                        }
                        .padding(S._16)
                        .background(C.card, in: RoundedRectangle(cornerRadius: R.md))
                    }
                }
                .padding(S.pad)
            }
            .background(C.bg)
            .navigationTitle("My Deals")
        }
    }
}
