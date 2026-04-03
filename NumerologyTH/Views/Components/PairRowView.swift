import SwiftUI

struct PairRowView: View {
    let pair: PairResult
    let isLocked: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(pair.pair)
                .font(.title3.monospaced().bold())
                .frame(width: 40)

            if isLocked {
                GradeTagView(grade: "*", size: .small)
                Text("░░░░░░░░░░░░░░░░░░░░░")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                GradeTagView(grade: pair.grade, size: .small)
                Text(pair.meaning)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isLocked ? .gray.opacity(0.05) : .clear)
        )
    }
}

#Preview {
    VStack {
        PairRowView(
            pair: PairResult(pair: "14", grade: "S", score: 116, meaning: "มีความเป็นมงคลสูง"),
            isLocked: false
        )
        PairRowView(
            pair: PairResult(pair: "23", grade: "B", score: 70, meaning: "พลังงานปานกลาง"),
            isLocked: true
        )
    }
    .padding()
}
