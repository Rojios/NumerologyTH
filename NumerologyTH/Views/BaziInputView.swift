import SwiftUI

struct BaziInputView: View {
    @State private var birthDate = Date()
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

                    Button {
                        baziResult = BaziEngine.analyze(birthDate: birthDate)
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
                BaziResultView(result: result)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BaziInputView()
    }
}
