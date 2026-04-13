import SwiftUI

enum BtnVariant { case primary, secondary, ghost, danger }

struct OyaButton: View {
    let label: String
    var variant: BtnVariant = .primary
    var icon: String? = nil
    var loading: Bool = false
    var action: () -> Void

    var body: some View {
        Button {
            Tap.light()
            action()
        } label: {
            HStack(spacing: 8) {
                if loading {
                    ProgressView().tint(.white).scaleEffect(0.8)
                } else {
                    if let icon { Image(systemName: icon).font(.system(size: 14, weight: .semibold)) }
                    Text(label).font(.h2)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 54)
            .foregroundColor(variant == .primary ? .white : C.t1)
            .background(variant == .primary ? C.brand : C.cardHi, in: RoundedRectangle(cornerRadius: R.md))
        }
        .disabled(loading)
        .buttonStyle(.plain)
    }
}
