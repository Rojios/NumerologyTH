import SwiftUI
import SwiftData

struct NameInputView: View {
    @State private var vm = NameAnalysisViewModel()
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("ชื่อ")
                    .font(.headline)
                TextField("ชื่อภาษาไทย", text: $vm.firstName)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3)

                Text("นามสกุล")
                    .font(.headline)
                TextField("นามสกุลภาษาไทย", text: $vm.lastName)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3)

                if let error = vm.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            Button {
                vm.analyze()
                if vm.hasResult {
                    let session = vm.createSession()
                    modelContext.insert(session)
                    try? modelContext.save()
                }
            } label: {
                HStack {
                    Image(systemName: "sparkle.magnifyingglass")
                    Text("วิเคราะห์")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(vm.isValid ? Color.accentColor : Color.gray.opacity(0.3))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!vm.isValid)

            if vm.hasResult {
                ResultView(
                    mode: .name,
                    input: "\(vm.firstName) \(vm.lastName)",
                    totalScore: vm.totalScore,
                    grade: vm.grade,
                    pairResults: vm.breakdown,
                    meaning: vm.meaning,
                    warnings: []
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle("วิเคราะห์ชื่อ")
    }
}

#Preview {
    NavigationStack {
        NameInputView()
    }
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
