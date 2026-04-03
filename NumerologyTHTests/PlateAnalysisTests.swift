import Testing
@testable import NumerologyTH

@Suite("Plate Analysis Tests")
struct PlateAnalysisTests {

    @Test("Parse standard plate format - 2 letters + 4 digits")
    func parseStandardPlate() {
        let result = AnalysisEngine.parsePlate("กธ 6450")
        #expect(result != nil)
        #expect(result!.letters == "กธ")
        #expect(result!.digits == "6450")
    }

    @Test("Parse single letter plate")
    func parseSingleLetterPlate() {
        let result = AnalysisEngine.parsePlate("ก 1234")
        #expect(result != nil)
        #expect(result!.letters == "ก")
        #expect(result!.digits == "1234")
    }

    @Test("Parse plate with leading digit")
    func parseLeadingDigitPlate() {
        let result = AnalysisEngine.parsePlate("4กธ 6450")
        #expect(result != nil)
        #expect(result!.leadingDigit == "4")
        #expect(result!.letters == "กธ")
        #expect(result!.digits == "6450")
    }

    @Test("Full plate analysis returns result")
    func fullPlateAnalysis() {
        let result = AnalysisEngine.shared.analyzePlate("กธ 6450")
        #expect(result != nil)
        #expect(!result!.grade.isEmpty)
    }
}
