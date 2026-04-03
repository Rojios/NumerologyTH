import SwiftUI

struct ScoreGaugeView: View {
    let score: Int
    let maxScore: Int

    private var progress: Double {
        Double(score) / Double(maxScore)
    }

    private var color: Color {
        switch score {
        case 850...: .green
        case 750..<850: .blue
        case 600..<750: .orange
        case 400..<600: .red
        default: .red
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), lineWidth: 12)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.8), value: progress)
        }
        .frame(width: 80, height: 80)
    }
}

#Preview {
    HStack(spacing: 20) {
        ScoreGaugeView(score: 950, maxScore: 1000)
        ScoreGaugeView(score: 742, maxScore: 1000)
        ScoreGaugeView(score: 350, maxScore: 1000)
    }
}
