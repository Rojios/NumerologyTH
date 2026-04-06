import Foundation
import StoreKit

@Observable
final class PurchaseViewModel {
    private(set) var isUnlocked: Bool = false
    private(set) var product: Product?
    private(set) var isLoading: Bool = false
    var errorMessage: String?

    static let productID = "com.rojios.numerologyth.unlock"

    init() {
        Task { await checkEntitlement() }
        Task { await loadProduct() }
        listenForTransactions()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
        } catch {
            errorMessage = "ไม่สามารถโหลดข้อมูลสินค้าได้"
        }
    }

    func purchase() async {
        // StoreKit product ยังโหลดไม่ได้ (เช่น ยังไม่ได้ตั้ง StoreKit Config / ยังไม่มี Dev Account)
        // → debug unlock ระหว่างพัฒนา
        #if DEBUG
        if product == nil {
            isUnlocked = true
            return
        }
        #endif

        guard let product else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    isUnlocked = true
                }
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = "การซื้อล้มเหลว กรุณาลองใหม่"
        }
    }

    func restore() async {
        isLoading = true
        defer { isLoading = false }
        try? await AppStore.sync()
        await checkEntitlement()
    }

    private func checkEntitlement() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID {
                isUnlocked = true
                return
            }
        }
    }

    private func listenForTransactions() {
        Task.detached {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result,
                   transaction.productID == Self.productID {
                    await transaction.finish()
                    await MainActor.run { self.isUnlocked = true }
                }
            }
        }
    }
}
