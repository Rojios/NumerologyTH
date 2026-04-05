import Foundation

// MARK: - Pair Grades

struct PairGradeEntry: Codable {
    let grade: String
    let score: Double
    let meaning: String
}

struct PairGradesKB: Codable {
    let pairs: [String: PairGradeEntry]
    let meta: PairGradesMeta

    struct PairGradesMeta: Codable {
        let defaultGrade: DefaultGrade

        enum CodingKeys: String, CodingKey {
            case defaultGrade = "default_grade"
        }
    }

    struct DefaultGrade: Codable {
        let grade: String
        let score: Double
        let note: String
    }

    var defaultGrade: DefaultGrade { meta.defaultGrade }
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
        let maxScore: Int
        let neutralDefault: Int

        enum CodingKeys: String, CodingKey {
            case maxScore = "max_score"
            case neutralDefault
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            maxScore = (try? container.decode(Int.self, forKey: .maxScore)) ?? 200
            neutralDefault = (try? container.decode(Int.self, forKey: .neutralDefault)) ?? 50
        }
    }
}

// MARK: - Thai Character Map

struct ThaiCharMapKB: Codable {
    let characters: [String: Int]

    func numberFor(_ char: String) -> Int? {
        characters[char]
    }
}

// MARK: - Number Meanings

struct NumberMeaning: Codable {
    let planet: String?
    let meaningTh: String
    let grade: String?
    let isAuspicious: Bool

    enum CodingKeys: String, CodingKey {
        case planet
        case meaningTh = "meaning_th"
        case grade
        case isAuspicious = "is_auspicious"
    }
}

struct NumberMeaningsKB: Codable {
    let meanings: [String: NumberMeaning]
}

// MARK: - Career Bonus

struct CareerBonusEntry: Codable {
    let careersTh: [String]
    let careersEn: [String]
    let descriptionTh: String

    enum CodingKeys: String, CodingKey {
        case careersTh = "careers_th"
        case careersEn = "careers_en"
        case descriptionTh = "description_th"
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
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
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
