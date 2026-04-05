import SwiftUI

extension Color {
    static func gradeColor(for grade: String) -> Color {
        switch grade.uppercased() {
        case "S": Color(red: 0.0, green: 0.5, blue: 0.0) // เขียวเข้ม
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
    // โทนม่วงอ่อนตามโลโก้
    static let appLavender = Color(red: 0.78, green: 0.73, blue: 0.93)
    static let appLavenderLight = Color(red: 0.92, green: 0.89, blue: 0.98)
    static let appLavenderBg = Color(red: 0.96, green: 0.94, blue: 1.0)
}
