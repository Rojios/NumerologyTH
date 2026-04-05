import SwiftUI

struct BaziResultView: View {
    let result: BaziResult
    var phoneDominantElement: AnalysisEngine.ChineseElement?

    /// Compatibility result (คำนวณเมื่อมี phoneDominantElement)
    private var compatibility: PhoneCompatibilityResult? {
        guard let phoneEl = phoneDominantElement else { return nil }
        return WuXingCompatibility.phoneVsPerson(
            phoneDominant: phoneEl,
            personElement: result.dominantElement
        )
    }

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.locale = Locale(identifier: "th_TH")
        f.calendar = Calendar(identifier: .buddhist)
        return f
    }()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text(result.dominantElement.emoji)
                        .font(.system(size: 60))

                    Text("ธาตุประจำตัวคุณ")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(result.dominantElement.name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(elementColor(result.dominantElement))
                }
                .padding(.top, 8)

                // วันเกิด
                Text(dateFormatter.string(from: result.birthDate))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // เสาธาตุ
                VStack(spacing: 12) {
                    Text(result.hasFourPillars ? "เสาธาตุทั้ง 4" : "เสาธาตุทั้ง 3")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if !result.hasFourPillars {
                        Text("ใส่เวลาเกิดเพื่อเพิ่มเสาที่ 4 (ยาม)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack(spacing: 12) {
                        pillarCard(title: "ปี", element: result.yearElement)
                        pillarCard(title: "เดือน", element: result.monthElement)
                        pillarCard(title: "วัน", element: result.dayElement)
                        if let hourEl = result.hourElement {
                            pillarCard(title: "ยาม", element: hourEl)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 1.0, green: 0.95, blue: 0.90))
                )

                // สัดส่วนธาตุ
                VStack(spacing: 12) {
                    Text("สัดส่วนธาตุ")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(result.counts, id: \.element) { item in
                        HStack {
                            Text(item.element.emoji)
                            Text(item.element.name)
                                .frame(width: 40, alignment: .leading)

                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(elementColor(item.element))
                                    .frame(width: geo.size.width * CGFloat(item.count) / CGFloat(result.hasFourPillars ? 4 : 3))
                            }
                            .frame(height: 20)

                            Text("\(item.count)")
                                .font(.caption.bold())
                                .frame(width: 20)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appLavenderLight)
                )

                // คำอธิบาย
                VStack(alignment: .leading, spacing: 8) {
                    Text("ลักษณะเด่นของคุณ")
                        .font(.headline)

                    Text(result.description)
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

                // MARK: - Compatibility Section
                if let compat = compatibility {
                    compatibilitySection(compat)
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
        .navigationTitle("รหัสธาตุประจำตัว")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Compatibility View

    @ViewBuilder
    private func compatibilitySection(_ compat: PhoneCompatibilityResult) -> some View {
        VStack(spacing: 16) {
            // Header
            Text("ความสมพงศ์กับเบอร์มือถือ")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Score badge
            VStack(spacing: 8) {
                Text(compat.tier.emoji)
                    .font(.system(size: 40))

                Text("\(compat.score)/100")
                    .font(.system(size: 36, weight: .bold))
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
                    Text(compat.personElement.emoji)
                        .font(.system(size: 32))
                    Text(compat.personElement.name)
                        .font(.subheadline.bold())
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
                    Text(compat.phoneDominantElement.emoji)
                        .font(.system(size: 32))
                    Text(compat.phoneDominantElement.name)
                        .font(.subheadline.bold())
                }
            }
            .frame(maxWidth: .infinity)

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

    private func pillarCard(title: String, element: AnalysisEngine.ChineseElement) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(element.emoji)
                .font(.system(size: 32))
            Text(element.name)
                .font(.subheadline.bold())
                .foregroundStyle(elementColor(element))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.8))
        )
    }

    private func elementColor(_ element: AnalysisEngine.ChineseElement) -> Color {
        switch element {
        case .water: .blue
        case .earth: .brown
        case .wood: .green
        case .fire: .red
        case .metal: .orange
        }
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

#Preview("With Phone") {
    NavigationStack {
        BaziResultView(
            result: BaziResult(
                birthDate: Date(),
                birthTime: nil,
                dayElement: .fire,
                monthElement: .wood,
                yearElement: .water,
                hourElement: nil,
                dominantElement: .fire,
                counts: [
                    (element: .fire, count: 2),
                    (element: .water, count: 1),
                    (element: .wood, count: 1),
                    (element: .earth, count: 0),
                    (element: .metal, count: 0)
                ],
                description: "คุณเป็นคนธาตุไฟ — กระตือรือร้น มีเสน่ห์",
                hasFourPillars: false
            ),
            phoneDominantElement: .wood
        )
    }
}

#Preview("No Phone") {
    NavigationStack {
        BaziResultView(
            result: BaziResult(
                birthDate: Date(),
                birthTime: nil,
                dayElement: .earth,
                monthElement: .metal,
                yearElement: .water,
                hourElement: nil,
                dominantElement: .earth,
                counts: [
                    (element: .earth, count: 1),
                    (element: .metal, count: 1),
                    (element: .water, count: 1),
                    (element: .fire, count: 0),
                    (element: .wood, count: 0)
                ],
                description: "คุณเป็นคนธาตุดิน — มั่นคง น่าเชื่อถือ",
                hasFourPillars: false
            )
        )
    }
}
