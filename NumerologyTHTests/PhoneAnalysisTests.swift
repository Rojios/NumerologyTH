import Testing
@testable import NumerologyTH

@Suite("Phone Analysis Tests")
struct PhoneAnalysisTests {

    @Test("Validate phone number format")
    func validatePhoneFormat() {
        #expect(AnalysisEngine.validatePhone("0812345678") != nil)
        #expect(AnalysisEngine.validatePhone("081-234-5678") != nil)
        #expect(AnalysisEngine.validatePhone("12345") == nil)
        #expect(AnalysisEngine.validatePhone("abcdefghij") == nil)
        #expect(AnalysisEngine.validatePhone("1234567890") == nil) // doesn't start with 0
    }

    @Test("Extract 6 pairs from last 7 digits")
    func extractPairs() {
        let pairs = AnalysisEngine.extractPairs(from: "0812345678")
        #expect(pairs.count == 6)
        #expect(pairs[0] == "23")
        #expect(pairs[1] == "34")
        #expect(pairs[2] == "45")
        #expect(pairs[3] == "56")
        #expect(pairs[4] == "67")
        #expect(pairs[5] == "78")
    }

    @Test("Grade assignment by score")
    func gradeAssignment() {
        #expect(AnalysisEngine.assignGrade(950) == "A+")
        #expect(AnalysisEngine.assignGrade(850) == "A")
        #expect(AnalysisEngine.assignGrade(750) == "B")
        #expect(AnalysisEngine.assignGrade(600) == "C")
        #expect(AnalysisEngine.assignGrade(400) == "D")
        #expect(AnalysisEngine.assignGrade(300) == "E")
    }

    @Test("Full phone analysis returns result")
    func fullAnalysis() {
        let result = AnalysisEngine.shared.analyzePhone("0815456599")
        #expect(result != nil)
        #expect(result!.pairResults.count == 6)
        #expect(!result!.grade.isEmpty)
    }
}
