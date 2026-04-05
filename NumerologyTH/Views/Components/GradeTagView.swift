import SwiftUI

struct GradeTagView: View {
    let grade: String
    let size: TagSize

    enum TagSize {
        case small, large

        var font: Font {
            switch self {
            case .small: .caption.bold()
            case .large: .title2.bold()
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
            case .large: EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
            }
        }
    }

    private var color: Color {
        Color.gradeColor(for: grade)
    }

    private var displayText: String {
        switch grade.uppercased() {
        case "S": "👍👍👍 S"
        case "A", "A+": "👍 \(grade)"
        default: grade
        }
    }

    var body: some View {
        Text(displayText)
            .font(size.font)
            .foregroundStyle(color)
            .padding(size.padding)
            .background(
                Capsule()
                    .fill(color.opacity(0.15))
            )
    }
}

#Preview {
    HStack {
        GradeTagView(grade: "S", size: .large)
        GradeTagView(grade: "A+", size: .small)
        GradeTagView(grade: "B", size: .small)
        GradeTagView(grade: "Penalty", size: .small)
    }
}
