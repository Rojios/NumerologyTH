import SwiftUI
import SwiftData

struct PhoneInputView: View {
    @State private var vm = PhoneAnalysisViewModel()
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.modelContext) private var modelContext
    @State private var showResult = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon
            Image(systemName: "phone.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.appLavender)

            Text("กรอกเบอร์โทร 10 หลัก")
                .font(.title2.bold())

            // Input field
            VStack(spacing: 12) {
                TextField("081-234-5678", text: $vm.phoneInput)
                    .keyboardType(.phonePad)
                    .textFieldStyle(.roundedBorder)
                    .font(.title.monospaced())
                    .multilineTextAlignment(.center)
                    .onChange(of: vm.phoneInput) { vm.validate() }

                if let error = vm.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)

            // Button
            Button {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                vm.analyze()
                if vm.hasResult {
                    let session = vm.createSession()
                    modelContext.insert(session)
                    try? modelContext.save()
                    showResult = true
                }
            } label: {
                HStack {
                    Image(systemName: "sparkle.magnifyingglass")
                    Text("ทำนาย")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(vm.isValid ? Color.appLavender : Color.gray.opacity(0.3))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!vm.isValid)
            .padding(.horizontal)

            Spacer()

            Text("โปรแกรมนี้มีวัตถุประสงค์เพื่อความบันเทิง")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
        }
        .background(
            LinearGradient(
                colors: [Color.appLavenderBg, .white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("ทำนายหมายเลขมือถือ")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showResult) {
            PhoneResultPage(vm: vm)
        }
    }
}

/// หน้าแสดงผล — BG พาสเทล
struct PhoneResultPage: View {
    let vm: PhoneAnalysisViewModel

    var body: some View {
        ScrollView {
            ResultView(
                mode: .phone,
                input: vm.phoneInput,
                totalScore: vm.totalScore,
                grade: vm.grade,
                pairResults: vm.pairResults,
                meaning: nil,
                warnings: vm.warnings,
                elements: vm.elements
            )
            .padding()
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.92, blue: 1.0),
                    Color(red: 0.93, green: 0.95, blue: 1.0),
                    Color(red: 0.96, green: 0.94, blue: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("ผลทำนาย \(vm.phoneInput)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PhoneInputView()
    }
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
