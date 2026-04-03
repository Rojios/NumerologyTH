import Foundation

extension String {
    var isValidThaiText: Bool {
        let thaiRange = Unicode.Scalar(0x0E01)!...Unicode.Scalar(0x0E5B)!
        let cleaned = self.filter { !$0.isWhitespace }
        guard !cleaned.isEmpty else { return false }
        return cleaned.unicodeScalars.allSatisfy { thaiRange.contains($0) }
    }

    var digitsOnly: String {
        filter(\.isNumber)
    }

    func formatPhoneNumber() -> String {
        let digits = digitsOnly
        guard digits.count == 10 else { return self }
        let i1 = digits.index(digits.startIndex, offsetBy: 3)
        let i2 = digits.index(digits.startIndex, offsetBy: 6)
        return "\(digits[..<i1])-\(digits[i1..<i2])-\(digits[i2...])"
    }
}
