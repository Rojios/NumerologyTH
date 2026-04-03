import Foundation

@Observable
final class PlateAnalysisViewModel {
    var plateInput: String = ""
    var totalScore: Int = 0
    var grade: String = ""
    var pairResults: [PairResult] = []
    var meaning: String = ""
    var hasResult: Bool = false
    var errorMessage: String?

    var isValid: Bool {
        !plateInput.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func analyze() {
        guard isValid else {
            errorMessage = "กรุณากรอกทะเบียนรถ"
            return
        }
        guard let result = AnalysisEngine.shared.analyzePlate(plateInput) else {
            errorMessage = "รูปแบบทะเบียนไม่ถูกต้อง (เช่น กธ 6450)"
            return
        }
        totalScore = result.totalScore
        grade = result.grade
        pairResults = result.pairs
        meaning = result.meaning
        hasResult = true
        errorMessage = nil
    }

    func createSession() -> AnalysisSession {
        AnalysisSession(
            mode: .plate,
            input: plateInput,
            totalScore: totalScore,
            grade: grade,
            pairResults: pairResults
        )
    }

    func reset() {
        plateInput = ""
        totalScore = 0
        grade = ""
        pairResults = []
        meaning = ""
        hasResult = false
        errorMessage = nil
    }
}
