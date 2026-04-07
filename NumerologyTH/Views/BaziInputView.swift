import SwiftUI

struct BaziInputView: View {
    /// ธาตุเด่นจากเบอร์มือถือ (ส่งมาจาก ResultView, nil ถ้าเข้าจากหน้าแรก)
    var phoneDominantElement: AnalysisEngine.ChineseElement?

    @Environment(PurchaseViewModel.self) private var purchaseVM
    @State private var birthDate = Date()
    @State private var birthTime = Date()
    @State private var showResult = false
    @State private var showPaywall = false
    @State private var baziResult: BaziResult?
    @State private var rememberBirthday = BaziStore.shared.rememberEnabled

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

            VStack {
                Spacer()

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("เปิดรหัสธาตุประจำตัว")
                            .font(.headline)
                        Text("เลือกวันเกิดของคุณ")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    DatePicker(
                        "วันเกิด",
                        selection: $birthDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "th_TH"))
                    .environment(\.calendar, Calendar(identifier: .buddhist))

                    // เวลาเกิด (บังคับ)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("เวลาเกิด")
                            .font(.subheadline.bold())

                        DatePicker(
                            "เวลาเกิด",
                            selection: $birthTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(height: 100)

                    }

                    // จำวันเกิด
                    Toggle(isOn: $rememberBirthday) {
                        Text("จำวันเดือนปีเกิดและเวลานี้ไว้")
                            .font(.subheadline)
                    }
                    .toggleStyle(.switch)
                    .tint(Color(red: 0.85, green: 0.55, blue: 0.40))
                    .onChange(of: rememberBirthday) {
                        BaziStore.shared.rememberEnabled = rememberBirthday
                        if !rememberBirthday {
                            BaziStore.shared.clear()
                        }
                    }

                    Button {
                        if purchaseVM.isUnlocked {
                            analyzeAndShow()
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: purchaseVM.isUnlocked ? "sparkles" : "lock.fill")
                            Text("เปิดรหัสธาตุ")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.85, green: 0.55, blue: 0.40))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // ลิงก์ตัวอย่างบทวิเคราะห์
                    NavigationLink {
                        CompatibilityPreviewView(phoneDominantElement: .fire)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "eye")
                                .font(.subheadline)
                            Text("ดูตัวอย่างความลับที่ซ่อนในรหัสธาตุ")
                                .font(.subheadline)
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                    }

                    Text("จำเป็นต้องรู้เวลาเกิดเพื่อความแม่นยำ")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
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
        .onAppear {
            if BaziStore.shared.rememberEnabled, BaziStore.shared.hasSavedResult,
               let (date, time) = BaziStore.shared.loadDates() {
                birthDate = date
                birthTime = time
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showResult) {
            if let result = baziResult {
                BaziResultView(result: result, phoneDominantElement: phoneDominantElement)
            }
        }
        .sheet(isPresented: $showPaywall, onDismiss: {
            // ถ้า unlock สำเร็จหลังปิด paywall → เปิดผลเลย
            if purchaseVM.isUnlocked {
                analyzeAndShow()
            }
        }) {
            PaywallView()
        }
    }

    private func analyzeAndShow() {
        baziResult = BaziEngine.analyze(birthDate: birthDate, birthTime: birthTime)
        BaziStore.shared.save(birthDate: birthDate, birthTime: birthTime)
        showResult = true
    }
}

#Preview {
    NavigationStack {
        BaziInputView()
            .environment(PurchaseViewModel())
    }
}
