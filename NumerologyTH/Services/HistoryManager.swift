import Foundation
import SwiftData

final class HistoryManager {
    static let shared = HistoryManager()

    func save(session: AnalysisSession, context: ModelContext) {
        context.insert(session)
        try? context.save()
    }

    func fetchAll(context: ModelContext) -> [AnalysisSession] {
        let descriptor = FetchDescriptor<AnalysisSession>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func delete(session: AnalysisSession, context: ModelContext) {
        context.delete(session)
        try? context.save()
    }
}
