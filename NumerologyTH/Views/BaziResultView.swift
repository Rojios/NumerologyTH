import SwiftUI

struct BaziResultView: View {
    let result: BaziResult
    var phoneDominantElement: AnalysisEngine.ChineseElement?
    @State private var navigateToPhone = false
    @Environment(NavigationRouter.self) private var router

    /// Compatibility result — ใช้ phoneDominantElement ที่ส่งมา หรือดึงจาก PhoneStore
    private var compatibility: PhoneCompatibilityResult? {
        let phoneEl = phoneDominantElement ?? PhoneStore.shared.loadDominantElement()
        guard let phoneEl else { return nil }
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
                // Header — ม่วงพาสเทล + ตัวอักษรดำ
                VStack(spacing: 8) {
                    Text(result.dominantElement.emoji)
                        .font(.system(size: 60))

                    Text("ธาตุประจำตัวคุณ")
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.6))

                    Text(result.dominantElement.name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.black)

                    Text(dateFormatter.string(from: result.birthDate))
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.5))
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appLavenderLight)
                )

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

                // คำอธิบาย — ชมพูพาสเทล
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.purple)
                        Text("อิทธิพลของพลังธาตุที่ส่งผลกับตัวคุณ")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }

                    Text(result.description)
                        .font(.body)
                        .foregroundStyle(.black.opacity(0.7))
                        .lineSpacing(4)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appPastelPink.opacity(0.5))
                )

                // จุดแข็ง + จุดอ่อน
                if let em = result.elementMeaning {
                    VStack(alignment: .leading, spacing: 12) {
                        // จุดแข็ง
                        VStack(alignment: .leading, spacing: 6) {
                            Text("จุดแข็ง")
                                .font(.headline)
                            ForEach(em.strengths, id: \.self) { s in
                                HStack(spacing: 6) {
                                    Text("✅")
                                        .font(.caption)
                                    Text(s)
                                        .font(.subheadline)
                                }
                            }
                        }

                        Divider()

                        // จุดอ่อน
                        VStack(alignment: .leading, spacing: 6) {
                            Text("จุดที่ควรระวัง")
                                .font(.headline)
                            ForEach(em.weaknesses, id: \.self) { w in
                                HStack(spacing: 6) {
                                    Text("⚠️")
                                        .font(.caption)
                                    Text(w)
                                        .font(.subheadline)
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

                    // อาชีพที่เหมาะ
                    VStack(alignment: .leading, spacing: 8) {
                        Text("อาชีพที่เหมาะ")
                            .font(.headline)

                        FlowLayout(spacing: 8) {
                            ForEach(em.careers, id: \.self) { career in
                                Text(career)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.appLavenderLight)
                                    )
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.background)
                            .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                    )

                    // มงคล
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
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 1.0, green: 0.97, blue: 0.92))
                    )
                }

                // MARK: - Compatibility Section
                if let compat = compatibility {
                    compatibilitySection(compat)
                }

                // MARK: - Annual Forecast Section
                annualForecastSection()

                // MARK: - Monthly Forecast Section
                monthlyForecastSection()

                // MARK: - Cross-link ไปทำนายมือถือ (เมื่อยังไม่มีข้อมูลเบอร์)
                if compatibility == nil {
                    Button {
                        navigateToPhone = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "phone.fill")
                            VStack(alignment: .leading, spacing: 2) {
                                Text("รหัสธาตุของคุณคือ \(result.dominantElement.name)")
                                    .font(.headline)
                                Text("ดูความสมพงศ์ของหมายเลขมือถือได้ทันที")
                                    .font(.headline)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.85, green: 0.55, blue: 0.40))
                        )
                    }
                }

                // MARK: - Share Button (ล่างสุด)
                Button {
                    shareElement()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("แชร์ธาตุของฉัน")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appPastelPink)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.goHome()
                } label: {
                    Image(systemName: "house.fill")
                }
            }
        }
        .navigationDestination(isPresented: $navigateToPhone) {
            PhoneInputView()
        }
    }

    // MARK: - Annual Forecast

    @ViewBuilder
    private func annualForecastSection() -> some View {
        let yearElement = BaziEngine.currentYearStemElement()
        let isClash = BaziEngine.isNaksatClash(userBirthDate: result.birthDate)
        let forecast = AnnualForecastKB.forecast(
            dayMasterElement: result.dominantElement,
            yearElement: yearElement,
            isClash: isClash
        )

        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        let currentAnimalName = BaziEngine.yearAnimalName(year: currentYear)
        let thaiYear = currentYear + 543

        // ปีเกิดเจ้าของ
        let birthYear = Calendar(identifier: .gregorian).component(.year, from: result.birthDate)
        let birthAnimalName = BaziEngine.yearAnimalName(year: birthYear)

        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 6) {
                Text(yearElement.emoji)
                Text("ดวงรายปี \(String(thaiYear))")
                    .font(.headline)
            }

            // ข้อมูลเจ้าของ + ปีนี้
            VStack(alignment: .leading, spacing: 10) {
                // เจ้าของ
                HStack(spacing: 4) {
                    Text(result.yearElement.emoji)
                    Text("รหัสธาตุและปีนักษัตรคุณ : \(birthAnimalName)-\(result.yearElement.name)")
                        .font(.subheadline.bold())
                }

                Divider()

                // ธาตุประจำปีนี้
                HStack(spacing: 4) {
                    Text(yearElement.emoji)
                    Text("รหัสธาตุประจำปีนี้ : \(yearElement.name)")
                        .font(.subheadline)
                }

                // ปีนักษัตรปีนี้
                HStack(spacing: 4) {
                    Text("🐴")
                    Text("ปีนักษัตรปีนี้ : \(currentAnimalName)")
                        .font(.subheadline)
                }

                // ปีชง
                HStack(spacing: 4) {
                    if isClash {
                        Text("⚠️")
                        Text("ปีชงนักษัตร : ชงกับปีเกิดของคุณ")
                            .font(.subheadline.bold())
                            .foregroundStyle(.red)
                    } else {
                        Text("✅")
                        Text("ปีชงนักษัตร : ไม่ชง")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.8))
            )

            // บทความ
            Text(forecast)
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.7))
                .lineSpacing(5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appPastelPink.opacity(0.5))
        )
    }

    // MARK: - Monthly Forecast

    @ViewBuilder
    private func monthlyForecastSection() -> some View {
        let monthElement = BaziEngine.currentMonthStemElement()
        let thaiMonth = BaziEngine.currentThaiMonth()
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        let thaiYear = currentYear + 543

        if let entry = KnowledgeBaseLoader.shared.monthlyForecast.forecast(
            personalElement: result.dominantElement,
            monthElement: monthElement
        ) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack(spacing: 6) {
                    Text(monthElement.emoji)
                    Text("\(thaiMonth) \(String(thaiYear)) — \(entry.theme)")
                        .font(.headline)
                }

                // ข้อมูลธาตุเดือน
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Text(monthElement.emoji)
                        Text("ธาตุประจำเดือน : \(monthElement.name)")
                            .font(.subheadline.bold())
                    }
                    HStack(spacing: 4) {
                        Text("⚡")
                        Text("ความสัมพันธ์ : \(entry.interaction)")
                            .font(.subheadline)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.8))
                )

                // Intro
                Text(entry.intro)
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.7))
                    .lineSpacing(5)

                // Body
                Text(entry.body)
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.7))
                    .lineSpacing(5)

                // Closing emoji
                Text(entry.closingEmoji)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appLavender.opacity(0.4))
            )
        }
    }

    // MARK: - Compatibility View

    @ViewBuilder
    private func compatibilitySection(_ compat: PhoneCompatibilityResult) -> some View {
        VStack(spacing: 16) {
            // Header
            HStack(spacing: 6) {
                Image(systemName: "heart.circle.fill")
                    .foregroundStyle(.purple)
                Text("ความสมพงศ์กับเบอร์มือถือ")
                    .font(.headline)
                    .foregroundStyle(.black)
            }
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
                        .foregroundStyle(.black.opacity(0.5))
                    Text(compat.personElement.emoji)
                        .font(.system(size: 32))
                    Text(compat.personElement.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(.black)
                }

                VStack(spacing: 4) {
                    Text(compat.relationship.shortLabel)
                        .font(.caption2)
                        .foregroundStyle(.black.opacity(0.5))
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title2)
                        .foregroundStyle(tierColor(compat.tier))
                }

                VStack(spacing: 4) {
                    Text("ธาตุเบอร์")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.5))
                    Text(compat.phoneDominantElement.emoji)
                        .font(.system(size: 32))
                    Text(compat.phoneDominantElement.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity)

            // คำอธิบาย
            Text(compat.summary)
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.7))
                .lineSpacing(4)

            // คำแม่หมอเหมียว
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "cat.fill")
                        .foregroundStyle(.purple)
                    Text("แม่หมอเหมียวว่า...")
                        .font(.caption.bold())
                        .foregroundStyle(.purple)
                }

                Text(compat.meowQuote)
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.7))
                    .lineSpacing(4)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appLavenderLight)
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appPastelPink.opacity(0.4))
        )
    }

    // MARK: - Helpers

    private func shareElement() {
        let birthText = dateFormatter.string(from: result.birthDate)

        // ย่ออิทธิพลธาตุ 3-5 ประโยค
        let fullDesc = result.elementMeaning?.personality ?? "ธาตุ\(result.dominantElement.name)"
        let sentences = fullDesc.components(separatedBy: " ")
        let shortDesc: String
        if sentences.count > 3 {
            // ตัดประมาณ 150 ตัวอักษร
            shortDesc = String(fullDesc.prefix(200))
        } else {
            shortDesc = fullDesc
        }

        let card = ElementUnlockCard(
            element: result.dominantElement,
            birthDateText: birthText,
            shortDescription: shortDesc
        )
        let image = ShareHelper.snapshot(card, size: CGSize(width: 390, height: 690))

        let text = """
        วันเกิด \(birthText)
        รหัสธาตุประจำตัว: ธาตุ\(result.dominantElement.name) \(result.dominantElement.emoji)

        🐱 พบความลับธาตุของคุณจาก "แม่หมอเหมียว" App Store
        """
        ShareHelper.share(image: image, text: text)
    }

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

    private func luckyItem(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.title2)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
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

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(subviews: subviews, proposal: proposal)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(subviews: subviews, proposal: proposal)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(subviews: Subviews, proposal: ProposedViewSize) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
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
                percentages: [
                    (element: .fire, percentage: 50),
                    (element: .water, percentage: 12.5),
                    (element: .wood, percentage: 37.5),
                    (element: .earth, percentage: 0),
                    (element: .metal, percentage: 0)
                ],
                description: "คุณเป็นคนธาตุไฟ — กระตือรือร้น มีเสน่ห์",
                hasFourPillars: false,
                elementMeaning: nil
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
                percentages: [
                    (element: .earth, percentage: 50),
                    (element: .metal, percentage: 37.5),
                    (element: .water, percentage: 12.5),
                    (element: .fire, percentage: 0),
                    (element: .wood, percentage: 0)
                ],
                description: "คุณเป็นคนธาตุดิน — มั่นคง น่าเชื่อถือ",
                hasFourPillars: false,
                elementMeaning: nil
            )
        )
    }
}
