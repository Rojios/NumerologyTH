import SwiftUI

struct HomeView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 4) {
                    Text("เลขศาสตร์ TH")
                        .font(.largeTitle.bold())
                    Text("วิเคราะห์เลขศาสตร์ประยุกต์ไทย")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // Status badge
                    HStack(spacing: 6) {
                        Image(systemName: purchaseVM.isUnlocked ? "checkmark.seal.fill" : "lock.fill")
                        Text(purchaseVM.isUnlocked ? "ปลดล็อกแล้ว" : "ฟรี")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(purchaseVM.isUnlocked ? .green : .orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(purchaseVM.isUnlocked ? .green.opacity(0.1) : .orange.opacity(0.1))
                    )
                    .padding(.top, 4)
                }
                .padding(.top, 8)

                // Mode cards
                ForEach(AnalysisMode.allCases, id: \.self) { mode in
                    NavigationLink {
                        destinationView(for: mode)
                    } label: {
                        ModeCardView(mode: mode)
                    }
                    .buttonStyle(.plain)
                }

                // Disclaimer
                Text("แอปนี้สร้างขึ้นเพื่อความบันเทิงเท่านั้น")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("")
    }

    @ViewBuilder
    private func destinationView(for mode: AnalysisMode) -> some View {
        switch mode {
        case .phone: PhoneInputView()
        case .name: NameInputView()
        case .plate: PlateInputView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(PurchaseViewModel())
}
