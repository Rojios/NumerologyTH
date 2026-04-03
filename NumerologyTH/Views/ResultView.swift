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

    @State private var showPaywall = false

    var body: some View {
        VStack(spacing: 16) {
            // Score header
            VStack(spacing: 8) {
                if mode == .phone {
                    ScoreGaugeView(score: totalScore, maxScore: 1000)
                }

                HStack(spacing: 12) {
                    VStack {
                        Text(mode == .phone ? "\(totalScore)" : "\(totalScore)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                        Text(mode == .phone ? "/ 1,000 คะแนน" : "ผลรวม")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    GradeTagView(grade: grade, size: .large)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )

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
                VStack(alignment: .leading, spacing: 4) {
                    Text("รายละเอียดแต่ละคู่เลข")
                        .font(.headline)
                        .padding(.bottom, 4)

                    ForEach(Array(pairResults.enumerated()), id: \.offset) { index, pair in
                        let isLocked = index > 0 && !purchaseVM.isUnlocked
                        PairRowView(pair: pair, isLocked: isLocked)
                    }
                }
            }

            // Paywall CTA for free users
            if !purchaseVM.isUnlocked {
                Button {
                    showPaywall = true
                } label: {
                    HStack {
                        Text("☕")
                        Text("เลี้ยงกาแฟ ฿99 — ปลดล็อกรายงานเต็ม")
                    }
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .sheet(isPresented: $showPaywall) {
                    PaywallView()
                }
            }
        }
    }
}

#Preview {
    ResultView(
        mode: .phone,
        input: "0812345678",
        totalScore: 742,
        grade: "A",
        pairResults: [
            PairResult(pair: "14", grade: "S", score: 116, meaning: "มีความเป็นมงคลสูง"),
            PairResult(pair: "23", grade: "B", score: 70, meaning: "พลังงานปานกลาง"),
            PairResult(pair: "45", grade: "S", score: 116, meaning: "เสริมการเงิน")
        ],
        meaning: nil,
        warnings: []
    )
    .environment(PurchaseViewModel())
    .padding()
}
