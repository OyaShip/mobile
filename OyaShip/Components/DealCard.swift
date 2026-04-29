import SwiftUI

struct DealCard: View {
    let deal: Deal
    let walletAddress: String
    var onShip:    (() -> Void)? = nil
    var onConfirm: (() -> Void)? = nil
    var onCancel:  (() -> Void)? = nil
    var onDispute: (() -> Void)? = nil

    private var isBuyer:  Bool { deal.buyer  == walletAddress }
    private var isSeller: Bool { deal.seller == walletAddress }

    var body: some View {
        VStack(alignment: .leading, spacing: S._12) {

            // Header row
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(deal.description)
                        .font(.h2)
                        .foregroundColor(C.t1)
                        .lineLimit(2)
                    Text(isBuyer ? "You bought" : "You sold")
                        .font(.cap)
                        .foregroundColor(C.t2)
                }
                Spacer()
                StatusBadge(status: deal.status)
            }

            // Amount
            Text(String(format: "%.4f XLM", deal.amount))
                .font(.num(22))
                .foregroundColor(C.brand)

            // Counterparty
            HStack(spacing: S._8) {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(C.t3)
                let party = isBuyer ? deal.seller : deal.buyer
                Text(shortAddress(party))
                    .font(.cap)
                    .foregroundColor(C.t2)
            }

            // Action buttons
            if deal.isActive {
                Divider().background(C.border)
                HStack(spacing: S._8) {
                    if isSeller && deal.status == "created", let onShip {
                        ActionButton("Mark Shipped", icon: "shippingbox", color: C.blue, action: onShip)
                    }
                    if isBuyer && deal.status == "shipped", let onConfirm {
                        ActionButton("Confirm Receipt", icon: "checkmark.seal", color: C.green, action: onConfirm)
                    }
                    if isBuyer && deal.status == "created", let onCancel {
                        ActionButton("Cancel", icon: "xmark.circle", color: C.red, action: onCancel)
                    }
                    if deal.isActive, let onDispute {
                        ActionButton("Dispute", icon: "exclamationmark.triangle", color: C.yellow, action: onDispute)
                    }
                }
            }
        }
        .padding(S._16)
        .background(C.card, in: RoundedRectangle(cornerRadius: R.md))
    }

    private func shortAddress(_ addr: String) -> String {
        guard addr.count > 10 else { return addr }
        return "\(addr.prefix(6))...\(addr.suffix(4))"
    }
}

// MARK: - Status Badge

private struct StatusBadge: View {
    let status: String
    var body: some View {
        Text(label)
            .font(.cap)
            .fontWeight(.semibold)
            .padding(.horizontal, S._8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundColor(color)
    }
    private var label: String {
        switch status {
        case "created":   return "Awaiting"
        case "shipped":   return "In Transit"
        case "confirmed": return "Completed"
        case "disputed":  return "Disputed"
        case "resolved":  return "Resolved"
        case "cancelled": return "Cancelled"
        default:          return status.capitalized
        }
    }
    private var color: Color {
        switch status {
        case "created":   return C.yellow
        case "shipped":   return C.blue
        case "confirmed": return C.green
        case "disputed":  return C.red
        case "resolved":  return C.green
        case "cancelled": return C.t3
        default:          return C.t2
        }
    }
}

// MARK: - Action Button

private struct ActionButton: View {
    let title: String; let icon: String; let color: Color; let action: () -> Void
    init(_ title: String, icon: String, color: Color, action: @escaping () -> Void) {
        self.title = title; self.icon = icon; self.color = color; self.action = action
    }
    var body: some View {
        Button(action: { Tap.light(); action() }) {
            Label(title, systemImage: icon)
                .font(.cap.bold())
                .foregroundColor(color)
                .padding(.horizontal, S._12)
                .padding(.vertical, S._8)
                .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: R.sm))
        }
    }
}
