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

// MARK: - Element Meanings

struct ElementMeaning: Codable {
    let name: String
    let emoji: String
    let personality: String
    let strengths: [String]
    let weaknesses: [String]
    let careers: [String]
    let luckyColor: String
    let luckyDirection: String
    let luckyNumber: String
    let compatibleElements: [String]
    let conflictElements: [String]
}

typealias ElementMeaningsKB = [String: ElementMeaning]

// MARK: - Fortune Sticks (เซียมซี)

struct FortuneStick: Codable {
    let id: Int
    let name: String
    let level: String
    let overall: String
    let work: String
    let love: String
    let money: String
    let health: String
}

struct FortuneStickKB: Codable {
    let meta: FortuneStickMeta
    let sticks: [FortuneStick]

    struct FortuneStickMeta: Codable {
        let total: Int
        let levels: [String]
        let categories: [String]
        let character: String
        let version: String
    }
}

// MARK: - Monthly Forecast (ดวงรายเดือน)

struct MonthlyForecastEntry: Codable {
    let id: String
    let personalElement: String
    let monthElement: String
    let interaction: String
    let theme: String
    let intro: String
    let body: String
    let closingEmoji: String

    enum CodingKeys: String, CodingKey {
        case id
        case personalElement = "personal_element"
        case monthElement = "month_element"
        case interaction, theme, intro, body
        case closingEmoji = "closing_emoji"
    }
}

struct MonthlyForecastKB: Codable {
    let version: String
    let description: String
    let entries: [MonthlyForecastEntry]

    /// Lookup: ธาตุประจำตัว + ธาตุเดือน → entry
    func forecast(personalElement: AnalysisEngine.ChineseElement,
                  monthElement: AnalysisEngine.ChineseElement) -> MonthlyForecastEntry? {
        let key = "\(personalElement.kbKey)_\(monthElement.kbKey)"
        return entries.first { $0.id == key }
    }
}

// MARK: - KB Loader

final class KnowledgeBaseLoader {
    static let shared = KnowledgeBaseLoader()

    lazy var pairGrades: PairGradesKB = load("pair_grades")
    lazy var sumScores: SumScoresKB = load("sum_scores")
    lazy var thaiCharMap: ThaiCharMapKB = load("thai_char_map")
    lazy var numberMeanings: NumberMeaningsKB = load("number_meanings")
    lazy var careerBonus: CareerBonusKB = load("career_bonus")
    lazy var elementMeanings: ElementMeaningsKB = load("element_meanings")
    lazy var fortuneSticks: FortuneStickKB = load("fortune_sticks_v2")
    lazy var monthlyForecast: MonthlyForecastKB = load("monthly_forecast")

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
