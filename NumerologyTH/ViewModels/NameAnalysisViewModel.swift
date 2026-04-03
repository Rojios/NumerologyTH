import Foundation

@Observable
final class NameAnalysisViewModel {
    var firstName: String = ""
    var lastName: String = ""
    var totalScore: Int = 0
    var grade: String = ""
    var meaning: String = ""
    var breakdown: [PairResult] = []
    var hasResult: Bool = false
    var errorMessage: String?

    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        firstName.isValidThaiText &&
        lastName.isValidThaiText
    }

    func analyze() {
        guard isValid else {
            errorMessage = "กรุณากรอกชื่อ-นามสกุลภาษาไทย"
            return
        }
        guard let result = AnalysisEngine.shared.analyzeName(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces)
        ) else {
            errorMessage = "ไม่สามารถวิเคราะห์ได้ กรุณาตรวจสอบชื่อ-นามสกุล"
            return
        }
        totalScore = result.totalScore
        grade = result.grade
        meaning = result.meaning
        breakdown = result.breakdown
        hasResult = true
        errorMessage = nil
    }

    func createSession() -> AnalysisSession {
        AnalysisSession(
            mode: .name,
            input: "\(firstName) \(lastName)",
            totalScore: totalScore,
            grade: grade,
            pairResults: breakdown
        )
    }

    func reset() {
        firstName = ""
        lastName = ""
        totalScore = 0
        grade = ""
        meaning = ""
        breakdown = []
        hasResult = false
        errorMessage = nil
    }
}
