import SwiftUI

/// Card สำหรับ snapshot แชร์ธาตุประจำตัว (390×690 pt)
struct ElementUnlockCard: View {
    let element: AnalysisEngine.ChineseElement
    let birthDateText: String
    let shortDescription: String

    var body: some View {
        ZStack {
            // BG เดียวกับ PhoneResultCard
            Image("ShareBG")
                .resizable()
                .scaledToFill()
                .frame(width: 390, height: 690)
                .clipped()
                .ignoresSafeArea()

            // เนื้อหา
            VStack(spacing: 0) {
                Spacer().frame(height: 12)

                Text("แม่หมอเหมียว")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.purple)

                Spacer().frame(height: 8)

                // วันเดือนปีเกิด — ตัวใหญ่สีดำ
                Text(birthDateText)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.black.opacity(0.8))

                Spacer().frame(height: 8)

                // รหัสธาตุประจำตัว
                Text("รหัสธาตุประจำตัว")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.black.opacity(0.6))

                Spacer().frame(height: 6)

                // ชื่อธาตุ — ตัวใหญ่ขาว
                Text(element.emoji)
                    .font(.system(size: 50))
                Text("ธาตุ\(element.name)")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.2), radius: 4)

                Spacer().frame(height: 16)

                // อิทธิพลธาตุ — ย่อ 3-5 ประโยค ชิดซ้าย
                Text(shortDescription)
                    .font(.system(size: 13))
                    .foregroundStyle(.black.opacity(0.6))
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .frame(width: 390, height: 690)
        .clipped()
        .ignoresSafeArea()
    }
}
