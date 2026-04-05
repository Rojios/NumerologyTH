import Foundation
import SwiftData

@Observable
final class PhoneAnalysisViewModel {
    var phoneInput: String = ""
    var isValid: Bool = false
    var totalScore: Int = 0
    var grade: String = ""
    var pairResults: [PairResult] = []
    var warnings: [String] = []
    var elements: AnalysisEngine.ElementResult?
    var hasResult: Bool = false
    var errorMessage: String?

    func validate() {
        let digits = phoneInput.filter(\.isNumber)
        isValid = digits.count == 10 && digits.hasPrefix("0")
        errorMessage = nil
    }

    func analyze() {
        guard let result = AnalysisEngine.shared.analyzePhone(phoneInput) else {
            errorMessage = "กรุณากรอกเบอร์โทร 10 หลัก (เริ่มด้วย 0)"
            return
        }
        totalScore = result.totalScore
        grade = result.grade
        pairResults = result.pairs
        warnings = result.warnings
        elements = result.elements
        hasResult = true
    }

    func createSession() -> AnalysisSession {
        AnalysisSession(
            mode: .phone,
            input: phoneInput,
            totalScore: totalScore,
            grade: grade,
            pairResults: pairResults
        )
    }

    func reset() {
        phoneInput = ""
        isValid = false
        totalScore = 0
        grade = ""
        pairResults = []
        warnings = []
        hasResult = false
        errorMessage = nil
    }
}
