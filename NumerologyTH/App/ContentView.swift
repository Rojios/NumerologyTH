import SwiftUI

struct ContentView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @State private var router = NavigationRouter()

    var body: some View {
        NavigationStack {
            HomeView()
        }
        .environment(router)
    }
}

// MARK: - Navigation Router

@Observable
final class NavigationRouter {
    var popToRoot = false

    func goHome() {
        popToRoot = true
        // Reset หลัง animation เสร็จ
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
