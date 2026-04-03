import SwiftUI

struct ModeCardView: View {
    let mode: AnalysisMode

    private var description: String {
        switch mode {
        case .phone: "วิเคราะห์คู่เลข คะแนน 1,000"
        case .name: "แปลงอักษรไทย → เลข → ความหมาย"
        case .plate: "แปลงทะเบียน → คะแนน → เกรด"
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: mode.icon)
                .font(.title)
                .foregroundStyle(.accent)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(.accent.opacity(0.1))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(mode.displayName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }
}

#Preview {
    VStack {
        ModeCardView(mode: .phone)
        ModeCardView(mode: .name)
        ModeCardView(mode: .plate)
    }
    .padding()
}
