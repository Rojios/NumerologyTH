import SwiftUI

/// Card สำหรับ snapshot แชร์ผลทำนายเบอร์มือถือ
struct PhoneResultCard: View {
    let maskedPhone: String
    let score: Int
    let grade: String
    let verdict: String
    let meaning: String

    var body: some View {
        ZStack {
            // BG เต็มจอ
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

                // หมายเลข masked
                Text(maskedPhone)
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                    .foregroundStyle(.black.opacity(0.8))

                Spacer().frame(height: 6)

                // Verdict
                Text(verdict)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.black)

                Spacer().frame(height: 4)

                // คะแนน
                Text("\(score)/1,000")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.5))

                Spacer().frame(height: 14)

                // ความหมาย — ชิดซ้าย
                Text(meaning)
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
