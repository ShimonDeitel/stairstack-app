import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Theme.accent)
                Text("Stairstack Pro")
                    .font(Theme.titleFont)
                Text("Weekly/monthly totals and building-specific logs")
                    .font(Theme.bodyFont)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                Spacer()
                Button {
                    Task {
                        await purchases.purchase()
                        if purchases.isPro { dismiss() }
                    }
                } label: {
                    Text(purchases.product != nil ? "Subscribe – \(purchases.product!.displayPrice)/mo" : "Subscribe – $1.99/mo")
                        .font(Theme.headlineFont)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
                .accessibilityIdentifier("subscribeButton")
                .padding(.horizontal)

                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .accessibilityIdentifier("paywallRestoreButton")
            }
            .padding()
            .navigationTitle("Go Pro")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("closePaywallButton")
                }
            }
        }
    }
}

#Preview {
    PaywallView()
        .environmentObject(PurchaseManager())
}
