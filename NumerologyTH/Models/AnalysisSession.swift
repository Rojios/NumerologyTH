import Foundation
import SwiftData

enum AnalysisMode: String, Codable, CaseIterable {
    case phone = "phone"
    case name = "name"
    case plate = "plate"

    var displayName: String {
        switch self {
        case .phone: "เบอร์โทร"
        case .name: "ชื่อ-นามสกุล"
        case .plate: "ทะเบียนรถ"
        }
    }

    var icon: String {
        switch self {
        case .phone: "phone.fill"
        case .name: "person.text.rectangle.fill"
        case .plate: "car.fill"
        }
    }
}

struct PairResult: Codable, Identifiable {
    var id: String { pair }
    let pair: String
    let grade: String
    let score: Int
    let meaning: String
}

@Model
final class AnalysisSession {
    var id: UUID
    var mode: String
    var input: String
    var totalScore: Int
    var grade: String
    var pairResultsData: Data
    var timestamp: Date

    var analysisMode: AnalysisMode {
        AnalysisMode(rawValue: mode) ?? .phone
    }

    var pairResults: [PairResult] {
        get {
            (try? JSONDecoder().decode([PairResult].self, from: pairResultsData)) ?? []
        }
        set {
            pairResultsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    init(mode: AnalysisMode, input: String, totalScore: Int, grade: String, pairResults: [PairResult]) {
        self.id = UUID()
        self.mode = mode.rawValue
        self.input = input
        self.totalScore = totalScore
        self.grade = grade
        self.pairResultsData = (try? JSONEncoder().encode(pairResults)) ?? Data()
        self.timestamp = Date()
    }
}
