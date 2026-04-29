import SwiftUI

struct EscrowView: View {
    @EnvironmentObject var api: APIService
    @EnvironmentObject var auth: AuthManager
    @State private var deals: [Deal] = []
    @State private var isLoading = false
    @State private var errorMsg: String?
    @State private var actionInProgress = false

    var body: some View {
        NavigationStack {
            ZStack {
                C.bg.ignoresSafeArea()

                if isLoading && deals.isEmpty {
                    ProgressView()
                        .tint(C.brand)
                } else if deals.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: S._12) {
                            if let err = errorMsg {
                                Text(err)
                                    .font(.cap)
                                    .foregroundColor(C.red)
                                    .padding(.horizontal, S.pad)
                            }
                            ForEach(deals) { deal in
                                DealCard(
                                    deal: deal,
                                    walletAddress: auth.publicKey ?? "",
                                    onShip:    { Task { await handleShip(deal) } },
                                    onConfirm: { Task { await handleConfirm(deal) } },
                                    onCancel:  { Task { await handleCancel(deal) } },
                                    onDispute: { Task { await handleDispute(deal) } }
                                )
                                .padding(.horizontal, S.pad)
                            }
                        }
                        .padding(.vertical, S._16)
                    }
                    .refreshable { await loadDeals() }
                }
            }
            .navigationTitle("My Deals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isLoading {
                        ProgressView().tint(C.brand)
                    }
                }
            }
            .task { await loadDeals() }
        }
    }

    // MARK: - Data loading

    private func loadDeals() async {
        guard let uid = auth.userId else { return }
        isLoading = true
        deals = await api.fetchDeals(userId: uid)
        isLoading = false
    }

    // MARK: - Actions

    private func handleShip(_ deal: Deal) async {
        guard let uid = auth.userId else { return }
        actionInProgress = true
        let ok = await api.shipDeal(dealId: deal.id, sellerId: uid)
        if ok { await loadDeals() } else { errorMsg = "Failed to mark shipped." }
        actionInProgress = false
    }

    private func handleConfirm(_ deal: Deal) async {
        guard let uid = auth.userId else { return }
        actionInProgress = true
        let ok = await api.confirmDeal(dealId: deal.id, buyerId: uid)
        if ok { await loadDeals() } else { errorMsg = "Failed to confirm receipt." }
        actionInProgress = false
    }

    private func handleCancel(_ deal: Deal) async {
        guard let uid = auth.userId else { return }
        actionInProgress = true
        let ok = await api.cancelDeal(dealId: deal.id, buyerId: uid)
        if ok { await loadDeals() } else { errorMsg = "Failed to cancel deal." }
        actionInProgress = false
    }

    private func handleDispute(_ deal: Deal) async {
        guard let uid = auth.userId else { return }
        actionInProgress = true
        let ok = await api.raiseDeal(dealId: deal.id, callerId: uid)
        if ok { await loadDeals() } else { errorMsg = "Failed to raise dispute." }
        actionInProgress = false
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: S._16) {
            Image(systemName: "shippingbox")
                .font(.system(size: 48))
                .foregroundColor(C.t3)
            Text("No deals yet")
                .font(.h2)
                .foregroundColor(C.t1)
            Text("Lock funds in escrow when you're ready to trade.")
                .font(.b2)
                .foregroundColor(C.t2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, S._32)
        }
    }
}
