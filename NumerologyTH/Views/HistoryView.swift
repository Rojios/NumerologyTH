import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Query(sort: \AnalysisSession.timestamp, order: .reverse) private var sessions: [AnalysisSession]

    var body: some View {
        Group {
            if sessions.isEmpty {
                ContentUnavailableView(
                    "ยังไม่มีประวัติ",
                    systemImage: "clock.arrow.circlepath",
                    description: Text("ผลวิเคราะห์จะแสดงที่นี่")
                )
            } else {
                List {
                    ForEach(sessions) { session in
                        HStack {
                            Image(systemName: session.analysisMode.icon)
                                .font(.title2)
                                .foregroundStyle(.accent)
                                .frame(width: 40)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(session.input)
                                    .font(.headline)
                                Text(session.analysisMode.displayName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                GradeTagView(grade: session.grade, size: .small)
                                Text(session.timestamp, style: .date)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            modelContext.delete(sessions[index])
                        }
                        try? modelContext.save()
                    }
                }
            }
        }
        .navigationTitle("ประวัติ")
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
