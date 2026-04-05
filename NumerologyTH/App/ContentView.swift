import SwiftUI

struct ContentView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM

    var body: some View {
        NavigationStack {
            PhoneInputView()
        }
    }
}

#Preview {
    ContentView()
        .environment(PurchaseViewModel())
        .modelContainer(for: AnalysisSession.self, inMemory: true)
}
