import SwiftUI

@MainActor
final class ShareManager {

    static func generateTextCard(session: AnalysisSession) -> String {
        var text = """
        ผลวิเคราะห์\(session.analysisMode.displayName)
        ━━━━━━━━━━━━━━━━━━━━
        ข้อมูล: \(session.input)
        คะแนนรวม: \(session.totalScore)
        เกรด: \(session.grade)
        ━━━━━━━━━━━━━━━━━━━━
        """

        for pair in session.pairResults {
            text += "\n\(pair.pair)  เกรด \(pair.grade)  \(pair.meaning)"
        }

        text += "\n\n📱 วิเคราะห์โดย เลขศาสตร์ TH"
        return text
    }

    @MainActor
    static func generateImage(session: AnalysisSession) -> UIImage? {
        let view = ShareCardView(session: session)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3.0
        return renderer.uiImage
    }
}

// Internal share card view
private struct ShareCardView: View {
    let session: AnalysisSession

    var body: some View {
        VStack(spacing: 12) {
            Text("เลขศาสตร์ TH")
                .font(.headline)
            Text(session.input)
                .font(.title2.bold())
            HStack {
                Text("คะแนน: \(session.totalScore)")
                Text("เกรด: \(session.grade)")
                    .bold()
            }
            .font(.subheadline)
        }
        .padding(24)
        .frame(width: 360)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 4)
        )
    }
}
