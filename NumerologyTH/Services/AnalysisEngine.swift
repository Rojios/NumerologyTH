import Foundation

struct PairScore {
    let pair: String
    let grade: String
    let score: Double
    let meaning: String
}

final class AnalysisEngine {
    static let shared = AnalysisEngine()
    private let kb = KnowledgeBaseLoader.shared

    // MARK: - Phone Analysis (Mode A)

    static func validatePhone(_ input: String) -> String? {
        let digits = input.filter(\.isNumber)
        guard digits.count == 10, digits.hasPrefix("0") else { return nil }
        return digits
    }

    static func extractPairs(from digits: String) -> [String] {
        let lastSeven = Array(digits.suffix(7))
        var pairs: [String] = []
        for i in 0..<6 {
            let pair = String(lastSeven[i]) + String(lastSeven[i + 1])
            pairs.append(pair)
        }
        return pairs
    }

    func scorePair(_ pair: String) -> PairScore {
        if let entry = kb.pairGrades.pairs[pair] {
            return PairScore(pair: pair, grade: entry.grade, score: entry.score, meaning: entry.meaning)
        }
        let d = kb.pairGrades.defaultGrade
        return PairScore(pair: pair, grade: d.grade, score: d.score, meaning: d.meaning)
    }

    func scoreSum(_ digits: String) -> (score: Int, meaning: String) {
        let sum = digits.compactMap(\.wholeNumberValue).reduce(0, +)
        let key = String(sum)
        if let entry = kb.sumScores.sums[key] {
            return (entry.score, entry.meaning)
        }
        return (kb.sumScores.meta.neutralDefault, "พลังงานกลาง ไม่เด่นไม่ด้อย")
    }

    func scoreCloser(_ digits: String) -> PairScore {
        let closer = String(digits.suffix(2))
        return scorePair(closer)
    }

    func analyzePhone(_ input: String) -> (totalScore: Int, grade: String, pairs: [PairResult], warnings: [String])? {
        guard let digits = Self.validatePhone(input) else { return nil }

        let pairStrings = Self.extractPairs(from: digits)
        var pairResults: [PairResult] = []
        var totalPositive: Double = 0
        var totalPenalty: Double = 0

        // Score 6 pairs (max 700 pts)
        for p in pairStrings {
            let ps = scorePair(p)
            pairResults.append(PairResult(pair: ps.pair, grade: ps.grade, score: Int(ps.score), meaning: ps.meaning))
            if ps.score > 0 {
                totalPositive += ps.score
            } else {
                totalPenalty += abs(ps.score)
            }
        }

        // Sum score (max 200 pts)
        let (sumScore, _) = scoreSum(digits)

        // Closer score (max 100 pts)
        let closerResult = scoreCloser(digits)

        // Special bonuses
        var specialBonus = 0
        // Dragon sequence 789
        if digits.contains("789") { specialBonus += 50 }
        // Sum = 100
        let digitSum = digits.compactMap(\.wholeNumberValue).reduce(0, +)
        if digitSum == 100 { specialBonus += 50 }

        let rawScore = pairResults.map(\.score).reduce(0, +) + sumScore + Int(closerResult.score) + specialBonus
        let totalScore = max(0, min(1000, rawScore))
        let grade = Self.assignGrade(totalScore)

        var warnings: [String] = []
        if totalPositive > 0, totalPenalty / totalPositive > 0.3 {
            warnings.append("ควรเปลี่ยนเบอร์ทันที — พลังงานลบสูงกว่า 30%")
        }

        return (totalScore, grade, pairResults, warnings)
    }

    static func assignGrade(_ score: Int) -> String {
        switch score {
        case 950...1000: return "A+"
        case 850..<950: return "A"
        case 750..<850: return "B"
        case 600..<750: return "C"
        case 400..<600: return "D"
        default: return "E"
        }
    }

    // MARK: - Name Analysis (Mode B)

    func thaiCharToNumber(_ char: String) -> Int? {
        kb.thaiCharMap.numberFor(char)
    }

    func analyzeName(firstName: String, lastName: String) -> (totalScore: Int, grade: String, meaning: String, breakdown: [PairResult])? {
        let fullName = firstName + lastName
        var numbers: [Int] = []

        for char in fullName {
            let s = String(char)
            if let num = thaiCharToNumber(s) {
                numbers.append(num)
            }
            // Skip spaces and unrecognized characters
        }

        guard !numbers.isEmpty else { return nil }

        var sum = numbers.reduce(0, +)
        sum = Self.reduceSum(sum)

        let meaning = kb.numberMeanings.meanings[String(sum)]
        let meaningText = meaning?.meaningTh ?? "ไม่พบความหมาย"
        let isAuspicious = meaning?.isAuspicious ?? false
        let grade = isAuspicious ? "ดี" : "ควรระวัง"

        let breakdown = numbers.enumerated().map { i, num in
            PairResult(
                pair: String(Array(fullName)[i]),
                grade: String(num),
                score: num,
                meaning: ""
            )
        }

        return (sum, grade, meaningText, breakdown)
    }

    static func reduceSum(_ sum: Int) -> Int {
        var s = sum
        while s > 100 {
            s = String(s).compactMap(\.wholeNumberValue).reduce(0, +)
        }
        return s
    }

    // MARK: - Plate Analysis (Mode D)

    struct PlateComponents {
        let leadingDigit: String?
        let letters: String
        let digits: String
    }

    static func parsePlate(_ input: String) -> PlateComponents? {
        let cleaned = input.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        guard !cleaned.isEmpty else { return nil }

        var leadingDigit: String?
        var letters = ""
        var digits = ""
        var inLetterSection = false
        var pastLetters = false

        for char in cleaned {
            let s = String(char)
            if !pastLetters && char.isNumber && letters.isEmpty {
                leadingDigit = s
            } else if !pastLetters && !char.isNumber {
                inLetterSection = true
                letters += s
            } else if inLetterSection && char.isNumber {
                pastLetters = true
                digits += s
            } else if pastLetters {
                digits += s
            }
        }

        guard !letters.isEmpty || !digits.isEmpty else { return nil }
        return PlateComponents(leadingDigit: leadingDigit, letters: letters, digits: digits)
    }

    func analyzePlate(_ input: String) -> (totalScore: Int, grade: String, pairs: [PairResult], meaning: String)? {
        guard let components = Self.parsePlate(input) else { return nil }

        // Convert letters to numbers
        var allNumbers: [Int] = []
        if let ld = components.leadingDigit, let n = Int(ld) {
            allNumbers.append(n)
        }
        for char in components.letters {
            if let num = thaiCharToNumber(String(char)) {
                allNumbers.append(num)
            }
        }
        for char in components.digits {
            if let n = char.wholeNumberValue {
                allNumbers.append(n)
            }
        }

        guard allNumbers.count >= 2 else { return nil }

        // Calculate pairs
        var pairResults: [PairResult] = []
        for i in 0..<(allNumbers.count - 1) {
            let pair = "\(allNumbers[i])\(allNumbers[i + 1])"
            let ps = scorePair(pair)
            pairResults.append(PairResult(pair: ps.pair, grade: ps.grade, score: Int(ps.score), meaning: ps.meaning))
        }

        // Sum and meaning
        var sum = allNumbers.reduce(0, +)
        sum = Self.reduceSum(sum)
        let meaning = kb.numberMeanings.meanings[String(sum)]?.meaningTh ?? "ไม่พบความหมาย"

        let rawScore = pairResults.map(\.score).reduce(0, +)
        let totalScore = max(0, min(1000, rawScore))
        let grade = Self.assignGrade(totalScore)

        return (totalScore, grade, pairResults, meaning)
    }
}
