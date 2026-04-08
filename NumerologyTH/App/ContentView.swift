import SwiftUI

struct ContentView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @State private var router = NavigationRouter()
    @State private var selectedTab = 0

    var body: some View {
        FeatureTabView(selectedTab: $selectedTab)
            .environment(router)
            .onReceive(NotificationCenter.default.publisher(for: .switchTab)) { notif in
                if let tab = notif.object as? Int {
                    selectedTab = tab
                }
            }
    }
}

// MARK: - Navigation Router

@Observable
final class NavigationRouter {
    var popToRoot = false

    func goHome() {
        popToRoot = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.popToRoot = false
        }
    }
}

#Preview {
    ContentView()
        .environment(PurchaseViewModel())
        .modelContainer(for: AnalysisSession.self, inMemory: true)
}
