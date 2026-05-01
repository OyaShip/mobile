import SwiftUI

enum OyaButtonStyle { case primary, secondary, ghost, danger }

struct OyaButton: View {
    let title: String
    var style: OyaButtonStyle = .primary
    var icon: String? = nil
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: { if !isLoading && !isDisabled { action() } }) {
            HStack(spacing: S._8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(fgColor)
                        .scaleEffect(0.8)
                } else if let icon {
                    Image(systemName: icon).font(.b2.bold())
                }
                Text(title).font(.b2.bold())
            }
            .foregroundColor(isDisabled ? C.t3 : fgColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, S._16)
            .background(isDisabled ? C.card : bgColor, in: RoundedRectangle(cornerRadius: R.md))
            .overlay(
                style == .ghost || style == .secondary
                    ? RoundedRectangle(cornerRadius: R.md).stroke(borderColor, lineWidth: 1)
                    : nil
            )
        }
        .disabled(isLoading || isDisabled)
        .animation(.easeInOut(duration: 0.15), value: isLoading)
    }

    private var bgColor: Color {
        switch style {
        case .primary:   return C.brand
        case .secondary: return .clear
        case .ghost:     return .clear
        case .danger:    return C.red.opacity(0.12)
        }
    }

    private var fgColor: Color {
        switch style {
        case .primary:   return .white
        case .secondary: return C.t1
        case .ghost:     return C.t2
        case .danger:    return C.red
        }
    }

    private var borderColor: Color {
        switch style {
        case .secondary: return C.border
        case .ghost:     return C.border
        default:         return .clear
        }
    }
}
