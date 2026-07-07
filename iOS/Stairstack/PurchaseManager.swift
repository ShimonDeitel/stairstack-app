import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productID = "stairstack.pro.monthly"

    @Published var isPro: Bool = false
    @Published var product: Product?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                await self?.handle(update)
            }
        }
        Task { await load() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func load() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
        } catch {
            product = nil
        }
        await refreshEntitlement()
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            if case .success(let verification) = result {
                await handle(verification)
            }
        } catch {
            // purchase failed or cancelled
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlement()
    }

    private func handle(_ verification: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = verification else { return }
        await transaction.finish()
        await refreshEntitlement()
    }

    private func refreshEntitlement() async {
        var pro = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let t) = result, t.productID == Self.productID {
                pro = true
            }
        }
        isPro = pro
    }
}
