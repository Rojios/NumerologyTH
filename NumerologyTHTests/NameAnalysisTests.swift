import Testing
@testable import NumerologyTH

@Suite("Name Analysis Tests")
struct NameAnalysisTests {

    @Test("Convert Thai character to number")
    func convertThaiChar() {
        let engine = AnalysisEngine.shared
        #expect(engine.thaiCharToNumber("ก") == 1)
        #expect(engine.thaiCharToNumber("ข") == 2)
        #expect(engine.thaiCharToNumber("ค") == 4)
    }

    @Test("Sum reduction to under 100")
    func sumReduction() {
        #expect(AnalysisEngine.reduceSum(156) <= 100)
        #expect(AnalysisEngine.reduceSum(42) == 42)
        #expect(AnalysisEngine.reduceSum(100) == 100)
        #expect(AnalysisEngine.reduceSum(999) <= 100)
    }

    @Test("Full name analysis returns result")
    func fullNameAnalysis() {
        let result = AnalysisEngine.shared.analyzeName(firstName: "สมชาย", lastName: "ใจดี")
        #expect(result != nil)
        #expect(result!.totalScore > 0)
        #expect(result!.totalScore <= 100)
    }
}
