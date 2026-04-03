import SwiftUI
import SwiftData

struct PlateInputView: View {
    @State private var vm = PlateAnalysisViewModel()
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("ทะเบียนรถ")
                    .font(.headline)
                TextField("กธ 6450", text: $vm.plateInput)
                    .textFieldStyle(.roundedBorder)
                    .font(.title2)

                Text("รูปแบบ: กธ 6450, ก 1234, 4กธ 6450")
                    .font(.caption)
                    .foregroundStyle(.secondary)

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
                    mode: .plate,
                    input: vm.plateInput,
                    totalScore: vm.totalScore,
                    grade: vm.grade,
                    pairResults: vm.pairResults,
                    meaning: vm.meaning,
                    warnings: []
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle("วิเคราะห์ทะเบียนรถ")
    }
}

#Preview {
    NavigationStack {
        PlateInputView()
    }
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
