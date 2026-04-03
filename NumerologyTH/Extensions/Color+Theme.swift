import SwiftUI

extension Color {
    static func gradeColor(for grade: String) -> Color {
        switch grade.uppercased() {
        case "S": .yellow
        case "A+", "A": .green
        case "B": .blue
        case "C": .orange
        case "D", "E": .red
        case let g where g.contains("PENALTY"): .red
        case "*": .gray
        case "ดี": .green
        case "ควรระวัง": .orange
        default: .secondary
        }
    }

    static let appGold = Color(red: 0.886, green: 0.522, blue: 0.231)
    static let appBackground = Color(.systemGroupedBackground)
}
