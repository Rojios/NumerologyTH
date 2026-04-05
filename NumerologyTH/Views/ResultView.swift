import SwiftUI

struct ResultView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM

    let mode: AnalysisMode
    let input: String
    let totalScore: Int
    let grade: String
    let pairResults: [PairResult]
    let meaning: String?
    let warnings: [String]
    var elements: AnalysisEngine.ElementResult?

    /// คำประเมินตามคะแนน
    private var verdict: (text: String, grade: String, color: Color) {
        switch totalScore {
        case 900...:     ("หมายเลขมงคลสูงมาก", "A+", .green)
        case 800..<900:  ("หมายเลขมงคล", "A", .green)
        case 600..<800:  ("หมายเลขนี้ดี", "B", .green)
        case 400..<600:  ("หมายเลขทั่วไป", "C", .green)
        default:         ("หมายเลขนี้เหนื่อย", "D", .red)
        }
    }

    /// สีพาสเทล
    private let pinkPastel = Color(red: 1.0, green: 0.85, blue: 0.9)
    private let purplePastel = Color(red: 0.9, green: 0.87, blue: 1.0)

    /// คู่เลข (ไม่รวมผลรวม) เรียงคะแนนสูงก่อน
    private var sortedPairs: [PairResult] {
        pairResults.dropFirst().sorted { $0.score > $1.score }
    }

    /// ความหมายธาตุจาก KB
    private func elementMeaning(for element: AnalysisEngine.ChineseElement) -> ElementMeaning? {
        let key: String = switch element {
        case .water: "water"
        case .fire:  "fire"
        case .wood:  "wood"
        case .earth: "earth"
        case .metal: "metal"
        }
        return KnowledgeBaseLoader.shared.elementMeanings[key]
    }

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Score header
            VStack(spacing: 8) {
                if mode == .phone {
                    ScoreGaugeView(score: totalScore, maxScore: 1000, grade: verdict.grade)
                }

                VStack(spacing: 2) {
                    Text(verdict.text)
                        .font(.title2.bold())
                        .foregroundStyle(totalScore >= 400 ? .green : .red)

                    Text("\(totalScore)/1,000")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )

            // MARK: - Meaning (for Mode B/D)
            if let meaning, !meaning.isEmpty {
                Text(meaning)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.yellow.opacity(0.1))
                    )
            }

            // MARK: - Warnings
            ForEach(warnings, id: \.self) { warning in
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                    Text(warning)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.red.opacity(0.1))
                )
            }

            // MARK: - Pair results
            if !pairResults.isEmpty && mode == .phone {
                VStack(alignment: .leading, spacing: 8) {
                    // ผลรวม — พื้นชมพูพาสเทล
                    if let sumResult = pairResults.first, sumResult.pair.hasPrefix("ผลรวม") {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("🔮 ความหมายของผู้ถือครองหมายเลขนี้")
                                .font(.headline)
                            Text(sumResult.meaning)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(pinkPastel)
                        )
                    }

                    Text("รายละเอียดแต่ละคู่เลข")
                        .font(.headline)
                        .padding(.top, 4)

                    ForEach(Array(sortedPairs.enumerated()), id: \.offset) { _, pair in
                        PairRowView(pair: pair, isLocked: false, bgColor: purplePastel)
                    }
                }
            }

            // MARK: - ธาตุห้า (ท้ายสุด)
            if let elements, mode == .phone {
                VStack(alignment: .leading, spacing: 16) {

                    // สรุป
                    Text("หมายเลขที่ดีต้องมีรหัสธาตุที่ส่งเสริมกับรหัสธาตุประจำตัวของผู้ใช้")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    // ธาตุเด่น
                    VStack(alignment: .leading, spacing: 8) {
                        Text("หมายเลขนี้มีธาตุเด่นคือ ธาตุ\(elements.dominant.name)")
                            .font(.headline)

                        // ตารางสัดส่วนธาตุ
                        VStack(spacing: 6) {
                            ForEach(elements.counts, id: \.element) { item in
                                if item.count > 0 {
                                    HStack {
                                        Text(item.element.name)
                                            .font(.subheadline)
                                            .frame(width: 36, alignment: .leading)

                                        GeometryReader { geo in
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(item.element == elements.dominant
                                                      ? Color.appLavender
                                                      : Color.gray.opacity(0.3))
                                                .frame(width: geo.size.width * CGFloat(item.count) / 10.0)
                                        }
                                        .frame(height: 16)

                                        Text("\(item.count)")
                                            .font(.caption.bold())
                                            .frame(width: 20)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )

                    // ความหมายธาตุ — บรรยายคนใช้มือถือนี้
                    if let em = elementMeaning(for: elements.dominant) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("คนที่ใช้หมายเลขธาตุ\(elements.dominant.name)")
                                .font(.headline)

                            Text(em.personality)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 1.0, green: 0.97, blue: 0.92))
                        )
                    }

                    // ลิงก์ตรวจสมพงศ์
                    NavigationLink {
                        BaziInputView(phoneDominantElement: elements.dominant)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.title3)
                            Text("ดูว่าหมายเลขนี้เสริมรหัสธาตุประจำตัวไหม")
                                .font(.subheadline.bold())
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
            }
        }
    }
}

#Preview {
    ScrollView {
        ResultView(
            mode: .phone,
            input: "0812345678",
            totalScore: 884,
            grade: "A",
            pairResults: [
                PairResult(pair: "ผลรวม 48→3", grade: "ดี", score: 150, meaning: "พลังแห่งความกล้า"),
                PairResult(pair: "51", grade: "S", score: 116, meaning: "เสน่ห์และความสมบูรณ์"),
                PairResult(pair: "15", grade: "S", score: 116, meaning: "สติปัญญาและเสน่ห์"),
                PairResult(pair: "56", grade: "S", score: 116, meaning: "ทรัพย์คู่ปัญญา"),
                PairResult(pair: "64", grade: "A", score: 100, meaning: "โชคและเสน่ห์"),
                PairResult(pair: "45", grade: "S", score: 116, meaning: "ปัญญาและโชคลาภ"),
                PairResult(pair: "89", grade: "Penalty_Medium", score: -50, meaning: "ระวังความหลงระเริง")
            ],
            meaning: nil,
            warnings: []
        )
        .environment(PurchaseViewModel())
        .padding()
    }
}
