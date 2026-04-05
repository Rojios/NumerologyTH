import SwiftUI

struct PairRowView: View {
    let pair: PairResult
    let isLocked: Bool
    var bgColor: Color = Color.blue.opacity(0.03)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Text(pair.pair)
                    .font(.title3.monospaced().bold())
                    .frame(width: 40)

                GradeTagView(grade: isLocked ? "*" : pair.grade, size: .small)

                Spacer()

                if !isLocked {
                    Text("\(pair.score) pts")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                }
            }

            if isLocked {
                Text("░░░░░░░░░░░░░░░░░░░░░")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text(pair.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isLocked ? .gray.opacity(0.05) : bgColor)
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
