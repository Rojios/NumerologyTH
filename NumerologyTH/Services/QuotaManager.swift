import Foundation

final class QuotaManager {
    static let shared = QuotaManager()
    private let defaults = UserDefaults.standard
    private let calendar = Calendar.current

    private func key(for mode: AnalysisMode) -> String {
        "quota_\(mode.rawValue)_lastUsed"
    }

    func canUse(mode: AnalysisMode) -> Bool {
        guard let lastUsed = defaults.object(forKey: key(for: mode)) as? Date else {
            return true
        }
        return !calendar.isDate(lastUsed, equalTo: Date(), toGranularity: .weekOfYear)
    }

    func consume(mode: AnalysisMode) {
        defaults.set(Date(), forKey: key(for: mode))
    }

    func remainingUses(mode: AnalysisMode) -> Int {
        canUse(mode: mode) ? 1 : 0
    }
}
