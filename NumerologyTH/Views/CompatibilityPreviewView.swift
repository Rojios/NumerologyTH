import SwiftUI

/// หน้าตัวอย่าง — reuse BaziResultView จริงด้วยข้อมูลจำลอง + ลายน้ำ "ตัวอย่าง"
struct CompatibilityPreviewView: View {
    let phoneDominantElement: AnalysisEngine.ChineseElement

    private var mockResult: BaziResult {
        let kb = KnowledgeBaseLoader.shared.elementMeanings
        let meaning = kb["fire"]

        return BaziResult(
            birthDate: mockBirthDate,
            birthTime: mockBirthDate,
            dayElement: .fire,
            monthElement: .wood,
            yearElement: .water,
            hourElement: .earth,
            dominantElement: .fire,
            percentages: [
                (element: .fire, percentage: 50),
                (element: .wood, percentage: 20),
                (element: .water, percentage: 10),
                (element: .earth, percentage: 20)
            ],
            description: meaning?.personality ?? "ธาตุไฟ — กระตือรือร้น มีเสน่ห์ เป็นจุดสนใจ",
            hasFourPillars: true,
            elementMeaning: meaning
        )
    }

    private var mockBirthDate: Date {
        var comps = DateComponents()
        comps.year = 1990
        comps.month = 1
        comps.day = 1
        comps.hour = 8
        comps.minute = 30
        return Calendar.current.date(from: comps) ?? Date()
    }

    var body: some View {
        ScrollView {
            ZStack {
                // เนื้อหาจริงจาก BaziResultView body
                mockContent()

                // ลายน้ำซ้อนทับ — ไม่บล็อก scroll
                VStack(spacing: 200) {
                    ForEach(0..<8, id: \.self) { _ in
                        Text("ตัวอย่าง")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.black.opacity(0.06))
                            .rotationEffect(.degrees(-30))
                    }
                }
                .allowsHitTesting(false)
            }
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
        .navigationTitle("ตัวอย่างผลลัพธ์")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Mock Content (จำลอง BaziResultView ทุก section)

    @ViewBuilder
    private func mockContent() -> some View {
        let result = mockResult
        let compat = WuXingCompatibility.phoneVsPerson(
            phoneDominant: phoneDominantElement,
            personElement: result.dominantElement
        )

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
                Text("(ข้อมูลจำลอง)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 8)

            // วันเกิด
            Text("1 มกราคม 2533")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // เสาธาตุ
            VStack(spacing: 12) {
                Text("เสาธาตุทั้ง 4")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 12) {
                    pillarCard(title: "ปี", element: .water)
                    pillarCard(title: "เดือน", element: .wood)
                    pillarCard(title: "วัน", element: .fire)
                    pillarCard(title: "ยาม", element: .earth)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(red: 1.0, green: 0.95, blue: 0.90)))

            // สัดส่วนธาตุ
            VStack(spacing: 12) {
                Text("สัดส่วนธาตุ")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 4) {
                    countItem(name: "ไฟ", pct: "40%", highlight: true)
                    countItem(name: "ไม้", pct: "20%", highlight: false)
                    countItem(name: "น้ำ", pct: "20%", highlight: false)
                    countItem(name: "ดิน", pct: "20%", highlight: false)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.appLavenderLight))

            // ลักษณะเด่น
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

            // จุดแข็ง + จุดอ่อน
            if let em = result.elementMeaning {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("จุดแข็ง").font(.headline)
                        ForEach(em.strengths, id: \.self) { s in
                            HStack(spacing: 6) {
                                Text("✅").font(.caption)
                                Text(s).font(.subheadline)
                            }
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("จุดที่ควรระวัง").font(.headline)
                        ForEach(em.weaknesses, id: \.self) { w in
                            HStack(spacing: 6) {
                                Text("⚠️").font(.caption)
                                Text(w).font(.subheadline)
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.background)
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                )

                // อาชีพ
                VStack(alignment: .leading, spacing: 8) {
                    Text("อาชีพที่เหมาะ").font(.headline)
                    FlowLayout(spacing: 8) {
                        ForEach(em.careers, id: \.self) { career in
                            Text(career)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(Color.appLavenderLight))
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.background)
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                )

                // สิ่งมงคล
                VStack(spacing: 12) {
                    Text("สิ่งมงคลประจำธาตุ")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 16) {
                        luckyItem(icon: "🎨", title: "สีมงคล", value: em.luckyColor)
                        luckyItem(icon: "🧭", title: "ทิศมงคล", value: em.luckyDirection)
                        luckyItem(icon: "🔢", title: "เลขมงคล", value: em.luckyNumber)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(red: 1.0, green: 0.97, blue: 0.92)))
            }

            // Compatibility
            VStack(spacing: 16) {
                Text("ความสมพงศ์กับเบอร์มือถือ")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 8) {
                    Text(compat.tier.emoji).font(.system(size: 40))
                    Text("\(compat.score)/100")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(tierColor(compat.tier))
                    Text(compat.tier.rawValue)
                        .font(.headline)
                        .foregroundStyle(tierColor(compat.tier))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(.white.opacity(0.8)))

                HStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("ธาตุประจำตัว").font(.caption).foregroundStyle(.secondary)
                        Text(compat.personElement.name).font(.headline)
                    }
                    VStack(spacing: 4) {
                        Text(compat.relationship.shortLabel).font(.caption2).foregroundStyle(.secondary)
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.title2)
                            .foregroundStyle(tierColor(compat.tier))
                    }
                    VStack(spacing: 4) {
                        Text("ธาตุเบอร์").font(.caption).foregroundStyle(.secondary)
                        Text(compat.phoneDominantElement.name).font(.headline)
                    }
                }

                Text(compat.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)

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
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 1.0, green: 0.97, blue: 0.92)))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
            )
        }
        .padding()
    }

    // MARK: - Helpers

    private func pillarCard(title: String, element: AnalysisEngine.ChineseElement) -> some View {
        VStack(spacing: 6) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(element.emoji).font(.system(size: 28))
            Text(element.name).font(.subheadline.bold()).foregroundStyle(elementColor(element))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 12).fill(.white.opacity(0.8)))
    }

    private func countItem(name: String, pct: String, highlight: Bool) -> some View {
        VStack(spacing: 2) {
            Text(name).font(.caption.bold())
            Text(pct).font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 8).fill(highlight ? Color.appLavender.opacity(0.3) : Color.gray.opacity(0.08)))
    }

    private func luckyItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(icon).font(.title2)
            Text(title).font(.caption2).foregroundStyle(.secondary)
            Text(value).font(.caption.bold()).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func elementColor(_ element: AnalysisEngine.ChineseElement) -> Color {
        switch element {
        case .water: .blue; case .earth: .brown; case .wood: .green
        case .fire: .red; case .metal: .orange
        }
    }

    private func tierColor(_ tier: CompatibilityTier) -> Color {
        switch tier {
        case .excellent: .green; case .good: .yellow; case .neutral: .blue
        case .tense: .orange; case .difficult: .red
        }
    }
}

#Preview {
    NavigationStack {
        CompatibilityPreviewView(phoneDominantElement: .water)
    }
}
