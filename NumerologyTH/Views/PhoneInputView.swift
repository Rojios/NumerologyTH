import SwiftUI
import SwiftData

struct PhoneInputView: View {
    @State private var vm = PhoneAnalysisViewModel()
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("เบอร์โทรศัพท์")
                    .font(.headline)
                TextField("081-234-5678", text: $vm.phoneInput)
                    .keyboardType(.phonePad)
                    .textFieldStyle(.roundedBorder)
                    .font(.title2.monospaced())
                    .onChange(of: vm.phoneInput) { vm.validate() }

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
                    mode: .phone,
                    input: vm.phoneInput,
                    totalScore: vm.totalScore,
                    grade: vm.grade,
                    pairResults: vm.pairResults,
                    meaning: nil,
                    warnings: vm.warnings
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle("วิเคราะห์เบอร์โทร")
    }
}

#Preview {
    NavigationStack {
        PhoneInputView()
    }
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
