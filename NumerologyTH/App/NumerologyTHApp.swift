import SwiftUI
import SwiftData

@main
struct NumerologyTHApp: App {
    @State private var purchaseVM = PurchaseViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(purchaseVM)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: AnalysisSession.self)
    }
}
