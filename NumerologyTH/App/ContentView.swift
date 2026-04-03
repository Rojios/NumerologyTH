import SwiftUI

struct ContentView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM

    var body: some View {
        TabView {
            Tab("หน้าหลัก", systemImage: "sparkles") {
                NavigationStack {
                    HomeView()
                }
            }
            Tab("ประวัติ", systemImage: "clock.arrow.circlepath") {
                NavigationStack {
                    HistoryView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(PurchaseViewModel())
        .modelContainer(for: AnalysisSession.self, inMemory: true)
}
