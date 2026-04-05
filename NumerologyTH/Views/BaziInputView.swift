import SwiftUI

struct BaziInputView: View {
    /// ธาตุเด่นจากเบอร์มือถือ (ส่งมาจาก ResultView, nil ถ้าเข้าจากหน้าแรก)
    var phoneDominantElement: AnalysisEngine.ChineseElement?

    @State private var birthDate = Date()
    @State private var birthTime = Date()
    @State private var showResult = false
    @State private var baziResult: BaziResult?

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

                    Button {
                        baziResult = BaziEngine.analyze(birthDate: birthDate, birthTime: birthTime)
                        showResult = true
                    } label: {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("เปิดรหัสธาตุ")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.85, green: 0.55, blue: 0.40))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Text("จำเป็นต้องรู้เวลาเกิดเพื่อความแม่นยำ ใช้คำนวณรหัสธาตุ 4 เสาหลัก")
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showResult) {
            if let result = baziResult {
                BaziResultView(result: result, phoneDominantElement: phoneDominantElement)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BaziInputView()
    }
}
