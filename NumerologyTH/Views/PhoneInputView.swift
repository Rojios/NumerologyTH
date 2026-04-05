import SwiftUI
import SwiftData

struct PhoneInputView: View {
    @State private var vm = PhoneAnalysisViewModel()
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.modelContext) private var modelContext
    @State private var showResult = false

    var body: some View {
        ZStack {
            // Background เดียวกับหน้าแรก
            GeometryReader { geo in
                Image("HomeBG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            // Input card ด้านล่าง
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("กรอกเบอร์โทร 10 หลัก")
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
                            Text("เปิดความลับหมายเลข")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.isValid ? Color.appLavender : Color.gray.opacity(0.3))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!vm.isValid)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                .padding()

                Text("โปรแกรมนี้มีวัตถุประสงค์เพื่อความบันเทิง")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 16)
            }
        }
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
