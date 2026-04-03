import Foundation
import SwiftData

@Observable
final class HistoryViewModel {
    var sessions: [AnalysisSession] = []

    func load(context: ModelContext) {
        let descriptor = FetchDescriptor<AnalysisSession>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        sessions = (try? context.fetch(descriptor)) ?? []
    }

    func delete(session: AnalysisSession, context: ModelContext) {
        context.delete(session)
        try? context.save()
        load(context: context)
    }
}
