import SwiftUI

/// แสดงตัวอย่างผลลัพธ์ compatibility ทุกธาตุกับเลขหมายปัจจุบัน
struct CompatibilityPreviewView: View {
    let phoneDominantElement: AnalysisEngine.ChineseElement

    private let allElements = AnalysisEngine.ChineseElement.allCases

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Header
                VStack(spacing: 8) {
                    Text("ตัวอย่างความเข้ากันได้")
                        .font(.title3.bold())

                    Text("หมายเลขนี้เป็นธาตุ\(phoneDominantElement.name) — ดูว่าถ้ารหัสธาตุประจำตัวคุณเป็นธาตุต่างๆ จะเข้ากันอย่างไร")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)

                // ตารางทุกธาตุ
                ForEach(allElements, id: \.self) { personEl in
                    let result = WuXingCompatibility.phoneVsPerson(
                        phoneDominant: phoneDominantElement,
                        personElement: personEl
                    )
                    compatCard(result: result)
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.96, blue: 0.92),
                    Color(red: 0.98, green: 0.94, blue: 0.96),
                    Color(red: 0.96, green: 0.94, blue: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("ตัวอย่างความเข้ากัน")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func compatCard(result: PhoneCompatibilityResult) -> some View {
        VStack(spacing: 12) {
            // ธาตุ vs ธาตุ + score
            HStack {
                // ธาตุประจำตัว
                VStack(spacing: 2) {
                    Text("ธาตุประจำตัว")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(result.personElement.name)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)

                // Score
                VStack(spacing: 2) {
                    Text(result.tier.emoji)
                        .font(.title3)
                    Text("\(result.score)")
                        .font(.title2.bold())
                        .foregroundStyle(tierColor(result.tier))
                    Text(result.tier.rawValue)
                        .font(.caption2)
                        .foregroundStyle(tierColor(result.tier))
                }
                .frame(maxWidth: .infinity)

                // ธาตุเบอร์
                VStack(spacing: 2) {
                    Text("ธาตุเบอร์")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(result.phoneDominantElement.name)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
            }

            // ความสัมพันธ์
            Text(result.relationship.shortLabel)
                .font(.caption)
                .foregroundStyle(.secondary)

            // คำแม่หมอเหมียว
            Text(result.meowQuote)
                .font(.caption)
                .foregroundStyle(.primary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private func tierColor(_ tier: CompatibilityTier) -> Color {
        switch tier {
        case .excellent: .green
        case .good:      .yellow
        case .neutral:   .blue
        case .tense:     .orange
        case .difficult: .red
        }
    }
}

#Preview {
    NavigationStack {
        CompatibilityPreviewView(phoneDominantElement: .water)
    }
}
