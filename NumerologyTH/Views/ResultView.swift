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

    @State private var showPaywall = false

    @ViewBuilder
    private func elementIcon(_ element: AnalysisEngine.ChineseElement, size: CGFloat) -> some View {
        if let imgName = element.imageName {
            Image(imgName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            Text(element.emoji)
                .font(.system(size: size * 0.8))
        }
    }

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

    var body: some View {
        VStack(spacing: 16) {
            // Score header
            VStack(spacing: 8) {
                if mode == .phone {
                    ScoreGaugeView(score: totalScore, maxScore: 1000, grade: verdict.grade)
                }

                VStack(spacing: 2) {
                    // คำประเมินตัวใหญ่
                    Text(verdict.text)
                        .font(.title2.bold())
                        .foregroundStyle(totalScore >= 400 ? .green : .red)

                    // คะแนนตัวเล็ก
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

            // ธาตุห้า
            if let elements, mode == .phone {
                VStack(spacing: 8) {
                    HStack {
                        Text("ธาตุเด่น")
                            .font(.headline)
                        Spacer()
                        HStack(spacing: 6) {
                            elementIcon(elements.dominant, size: 28)
                            Text(elements.dominant.name)
                                .font(.title3.bold())
                        }
                    }

                    // แถบสัดส่วนธาตุ
                    HStack(spacing: 4) {
                        ForEach(elements.counts, id: \.element) { item in
                            if item.count > 0 {
                                VStack(spacing: 2) {
                                    elementIcon(item.element, size: 24)
                                    Text("\(item.count)")
                                        .font(.caption2.bold())
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(item.element == elements.dominant
                                              ? Color.appLavender.opacity(0.3)
                                              : Color.gray.opacity(0.08))
                                )
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
            }

            // Meaning (for Mode B/D)
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

            // Warnings
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

            // Pair results
            if !pairResults.isEmpty && mode == .phone {
                VStack(alignment: .leading, spacing: 8) {
                    // ผลรวม (ตัวแรก) — พื้นชมพูพาสเทล
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

                    // เรียงคะแนนสูงก่อน — พื้นม่วงพาสเทล
                    ForEach(Array(sortedPairs.enumerated()), id: \.offset) { _, pair in
                        PairRowView(pair: pair, isLocked: false, bgColor: purplePastel)
                    }
                }
            }

            // ลิงก์ไป Bazi
            if mode == .phone {
                NavigationLink {
                    BaziInputView(phoneDominantElement: elements?.dominant)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ตรวจสอบความสมพงศ์ของดิถีธาตุประจำตัว")
                                .font(.subheadline.bold())
                            Text("เปิดรหัสธาตุประจำตัว")
                                .font(.caption)
                                .opacity(0.85)
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
