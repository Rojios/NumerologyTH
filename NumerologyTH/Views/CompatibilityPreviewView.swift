import SwiftUI

/// หน้าตัวอย่าง — แสดง mock-up ผลลัพธ์ Bazi + Compatibility แบบ read-only พร้อมลายน้ำ
struct CompatibilityPreviewView: View {
    let phoneDominantElement: AnalysisEngine.ChineseElement

    /// ข้อมูลจำลอง
    private var mockResult: BaziResult {
        BaziResult(
            birthDate: Date(),
            birthTime: Date(),
            dayElement: .fire,
            monthElement: .wood,
            yearElement: .water,
            hourElement: .earth,
            dominantElement: .fire,
            counts: [
                (element: .fire, count: 2),
                (element: .water, count: 1),
                (element: .wood, count: 1),
                (element: .earth, count: 1)
            ],
            description: "",
            hasFourPillars: true,
            elementMeaning: nil
        )
    }

    private var mockCompat: PhoneCompatibilityResult {
        WuXingCompatibility.phoneVsPerson(
            phoneDominant: phoneDominantElement,
            personElement: .fire
        )
    }

    var body: some View {
        ZStack {
            // เนื้อหา mock-up (กดอะไรไม่ได้)
            ScrollView {
                VStack(spacing: 20) {
                    mockBaziHeader()
                    mockPillars()
                    mockElementCounts()
                    mockPersonality()
                    mockCompatibilitySection()
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
            .allowsHitTesting(false) // กดอะไรไม่ได้ทั้งหน้า

            // ลายน้ำ
            VStack(spacing: 80) {
                ForEach(0..<4, id: \.self) { _ in
                    Text("ตัวอย่าง")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.black.opacity(0.06))
                        .rotationEffect(.degrees(-30))
                }
            }
            .allowsHitTesting(false)
        }
        .navigationTitle("ตัวอย่างผลลัพธ์")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Mock Sections

    private func mockBaziHeader() -> some View {
        VStack(spacing: 8) {
            Text("🔥")
                .font(.system(size: 50))
            Text("ธาตุประจำตัวคุณ")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("ไฟ")
                .font(.largeTitle.bold())
                .foregroundStyle(.red)
            Text("(ข้อมูลจำลอง)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    private func mockPillars() -> some View {
        VStack(spacing: 12) {
            Text("เสาธาตุทั้ง 4")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                pillarCard(title: "ปี", name: "น้ำ", emoji: "💧", color: .blue)
                pillarCard(title: "เดือน", name: "ไม้", emoji: "🪵", color: .green)
                pillarCard(title: "วัน", name: "ไฟ", emoji: "🔥", color: .red)
                pillarCard(title: "ยาม", name: "ดิน", emoji: "🌍", color: .brown)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 1.0, green: 0.95, blue: 0.90))
        )
    }

    private func mockElementCounts() -> some View {
        VStack(spacing: 12) {
            Text("สัดส่วนธาตุ")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                countItem(name: "ไฟ", pct: "40%", highlight: true)
                countItem(name: "น้ำ", pct: "20%", highlight: false)
                countItem(name: "ไม้", pct: "20%", highlight: false)
                countItem(name: "ดิน", pct: "20%", highlight: false)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appLavenderLight)
        )
    }

    private func mockPersonality() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ลักษณะเด่นของคุณ")
                .font(.headline)
            Text("ธาตุไฟ — กระตือรือร้น มีเสน่ห์ เป็นจุดสนใจ มีพลังงานสูง เหมาะกับงานที่ต้องแสดงออก...")
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private func mockCompatibilitySection() -> some View {
        let compat = mockCompat
        return VStack(spacing: 16) {
            Text("ความสมพงศ์กับเบอร์มือถือ")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Score
            VStack(spacing: 8) {
                Text(compat.tier.emoji)
                    .font(.system(size: 36))
                Text("\(compat.score)/100")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(tierColor(compat.tier))
                Text(compat.tier.rawValue)
                    .font(.headline)
                    .foregroundStyle(tierColor(compat.tier))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.8))
            )

            // ธาตุ vs ธาตุ
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("ธาตุประจำตัว")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("ไฟ")
                        .font(.headline)
                }
                VStack(spacing: 4) {
                    Text(compat.relationship.shortLabel)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title2)
                        .foregroundStyle(tierColor(compat.tier))
                }
                VStack(spacing: 4) {
                    Text("ธาตุเบอร์")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(phoneDominantElement.name)
                        .font(.headline)
                }
            }

            // คำอธิบาย
            Text(compat.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(4)

            // คำแม่หมอเหมียว
            VStack(alignment: .leading, spacing: 6) {
                Text("แม่หมอเหมียวว่า...")
                    .font(.caption.bold())
                    .foregroundStyle(Color(red: 0.85, green: 0.55, blue: 0.40))
                Text(compat.meowQuote)
                    .font(.subheadline)
                    .lineSpacing(4)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 1.0, green: 0.97, blue: 0.92))
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        )
    }

    // MARK: - Helpers

    private func pillarCard(title: String, name: String, emoji: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(emoji)
                .font(.system(size: 28))
            Text(name)
                .font(.subheadline.bold())
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.8))
        )
    }

    private func countItem(name: String, pct: String, highlight: Bool) -> some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.caption.bold())
            Text(pct)
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(highlight ? Color.appLavender.opacity(0.3) : Color.gray.opacity(0.08))
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
