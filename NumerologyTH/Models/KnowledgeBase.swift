import Foundation

// MARK: - Pair Grades

struct PairGradeEntry: Codable {
    let grade: String
    let score: Double
    let meaning: String
}

struct PairGradesKB: Codable {
    let pairs: [String: PairGradeEntry]
    let defaultGrade: DefaultGrade

    enum CodingKeys: String, CodingKey {
        case pairs
        case defaultGrade = "default_grade"
    }

    struct DefaultGrade: Codable {
        let grade: String
        let score: Double
        let meaning: String
    }
}

// MARK: - Sum Scores

struct SumScoreEntry: Codable {
    let category: String
    let score: Int
    let meaning: String
}

struct SumScoresKB: Codable {
    let sums: [String: SumScoreEntry]
    let meta: SumMeta

    struct SumMeta: Codable {
        let neutralDefault: Int
        let maxScore: Int

        enum CodingKeys: String, CodingKey {
            case neutralDefault = "neutral_default"
            case maxScore = "max_score"
        }
    }
}

// MARK: - Thai Character Map

struct ThaiCharMapKB: Codable {
    let consonants: [String: Int]
    let vowels: [String: Int]
    let toneMarks: [String: Int]
    let special: [String: Int]

    enum CodingKeys: String, CodingKey {
        case consonants, vowels
        case toneMarks = "tone_marks"
        case special
    }

    func numberFor(_ char: String) -> Int? {
        consonants[char] ?? vowels[char] ?? toneMarks[char] ?? special[char]
    }
}

// MARK: - Number Meanings

struct NumberMeaning: Codable {
    let planet: String?
    let meaningTh: String
    let meaningEn: String
    let level: String?
    let isAuspicious: Bool

    enum CodingKeys: String, CodingKey {
        case planet
        case meaningTh = "meaning_th"
        case meaningEn = "meaning_en"
        case level
        case isAuspicious = "is_auspicious"
    }
}

struct NumberMeaningsKB: Codable {
    let meanings: [String: NumberMeaning]
}

// MARK: - Career Bonus

struct CareerBonusEntry: Codable {
    let careers: [String]
    let careersTh: [String]
    let bonusPoints: Int

    enum CodingKeys: String, CodingKey {
        case careers
        case careersTh = "careers_th"
        case bonusPoints = "bonus_points"
    }
}

struct CareerBonusKB: Codable {
    let bonuses: [String: CareerBonusEntry]
}

// MARK: - KB Loader

final class KnowledgeBaseLoader {
    static let shared = KnowledgeBaseLoader()

    lazy var pairGrades: PairGradesKB = load("pair_grades")
    lazy var sumScores: SumScoresKB = load("sum_scores")
    lazy var thaiCharMap: ThaiCharMapKB = load("thai_char_map")
    lazy var numberMeanings: NumberMeaningsKB = load("number_meanings")
    lazy var careerBonus: CareerBonusKB = load("career_bonus")

    private func load<T: Decodable>(_ name: String) -> T {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json", subdirectory: "KnowledgeBase"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Missing KB file: \(name).json")
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode \(name).json: \(error)")
        }
    }
}
