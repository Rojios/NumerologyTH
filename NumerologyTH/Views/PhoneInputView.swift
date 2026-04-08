import SwiftUI
import SwiftData

struct PhoneInputView: View {
    @State private var vm = PhoneAnalysisViewModel()
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.modelContext) private var modelContext
    @State private var showResult = false
    @State private var rememberPhone = PhoneStore.shared.rememberEnabled

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("PhoneBG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            // Input card ด้านบน
            VStack {
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

                    // จำเบอร์
                    Toggle(isOn: $rememberPhone) {
                        Text("จำหมายเลขมือถือนี้ไว้")
                            .font(.subheadline)
                    }
                    .toggleStyle(.switch)
                    .tint(Color.appLavender)
                    .onChange(of: rememberPhone) {
                        PhoneStore.shared.rememberEnabled = rememberPhone
                        if !rememberPhone {
                            PhoneStore.shared.clear()
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
                        .fill(Color.appPastelPink.opacity(0.85))
                )
                .padding()

                Spacer()

                Text("โปรแกรมนี้มีวัตถุประสงค์เพื่อความบันเทิง")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 16)
            }
        }
        .onAppear {
            if PhoneStore.shared.rememberEnabled, let phone = PhoneStore.shared.loadPhone() {
                vm.phoneInput = phone
                vm.validate()
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
    @Environment(NavigationRouter.self) private var router

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
        .onAppear {
            if let elements = vm.elements {
                PhoneStore.shared.save(phone: vm.phoneInput, dominant: elements.dominant)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    sharePhoneResult()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private func sharePhoneResult() {
        let verdict: String = switch vm.totalScore {
        case 900...: "หมายเลขมงคลสูงมาก"
        case 800..<900: "หมายเลขมงคล"
        case 600..<800: "หมายเลขนี้ดี"
        case 400..<600: "หมายเลขทั่วไป"
        default: "หมายเลขนี้เหนื่อย"
        }
        let meaning = vm.pairResults.first?.meaning ?? ""

        let card = PhoneResultCard(
            maskedPhone: ShareHelper.maskedPhone(vm.phoneInput),
            score: vm.totalScore,
            grade: vm.grade,
            verdict: verdict,
            meaning: meaning
        )
        let image = ShareHelper.snapshot(card, size: CGSize(width: 390, height: 690))

        let text = """
        เบอร์ \(ShareHelper.maskedPhone(vm.phoneInput))
        \(verdict) \(vm.totalScore)/1000

        🐱 ดูเบอร์คุณได้ที่ แม่หมอเหมียว.iPhone
        """
        ShareHelper.share(image: image, text: text)
    }
}

#Preview {
    NavigationStack {
        PhoneInputView()
    }
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
