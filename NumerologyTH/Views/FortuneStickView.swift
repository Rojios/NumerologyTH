import SwiftUI

struct FortuneStickView: View {
    @State private var drawnStick: FortuneStick?
    @State private var showFortune = false
    @State private var isShaking = false

    private let sticks = KnowledgeBaseLoader.shared.fortuneSticks.sticks

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("HomeBG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            if showFortune, let stick = drawnStick {
                // แสดงคำทำนายเต็มจอ
                fortuneDetail(stick)
            } else {
                // หน้าเขย่าเซียมซี
                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        if let stick = drawnStick {
                            // แสดงเลขที่สุ่มได้
                            VStack(spacing: 8) {
                                Text(String(format: "%02d", stick.id))
                                    .font(.system(size: 72, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)

                                Text(stick.name)
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.9))

                                levelBadge(stick.level)
                            }
                            .padding(.vertical, 24)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                            )

                            Button {
                                showFortune = true
                            } label: {
                                HStack {
                                    Image(systemName: "eye.fill")
                                    Text("ดูคำทำนาย")
                                }
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.appLavender)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        Button {
                            drawStick()
                        } label: {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                Text(drawnStick == nil ? "เขย่าเซียมซี" : "เขย่าใหม่")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.85, green: 0.55, blue: 0.40))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    .padding()

                    Text("โปรแกรมนี้มีวัตถุประสงค์เพื่อความบันเทิง")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("เสี่ยงเซียมซี")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func drawStick() {
        showFortune = false
        drawnStick = sticks.randomElement()
    }

    // MARK: - Fortune Detail

    @ViewBuilder
    private func fortuneDetail(_ stick: FortuneStick) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    Text(String(format: "%02d", stick.id))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                    Text(stick.name)
                        .font(.headline)
                        .foregroundStyle(.black.opacity(0.7))
                    levelBadge(stick.level)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appLavenderLight)
                )

                // Overall
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.purple)
                        Text("คำทำนายรวม")
                            .font(.headline)
                    }
                    Text(stick.overall)
                        .font(.body)
                        .foregroundStyle(.black.opacity(0.7))
                        .lineSpacing(4)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appPastelPink.opacity(0.5))
                )

                // Categories
                fortuneCategory(icon: "briefcase.fill", title: "การงาน", text: stick.work, color: .blue)
                fortuneCategory(icon: "heart.fill", title: "ความรัก", text: stick.love, color: .pink)
                fortuneCategory(icon: "banknote.fill", title: "การเงิน", text: stick.money, color: .green)
                fortuneCategory(icon: "heart.text.square.fill", title: "สุขภาพ", text: stick.health, color: .orange)

                // เขย่าใหม่
                Button {
                    drawStick()
                } label: {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("เขย่าใหม่")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.85, green: 0.55, blue: 0.40))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.96, blue: 0.92),
                    Color(red: 0.98, green: 0.94, blue: 0.96),
                    Color(red: 0.96, green: 0.94, blue: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    private func fortuneCategory(icon: String, title: String, text: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
            }
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.7))
                .lineSpacing(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private func levelBadge(_ level: String) -> some View {
        Text(level)
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(levelColor(level))
            )
    }

    private func levelColor(_ level: String) -> Color {
        switch level {
        case "ดี":    .green
        case "กลาง":  .yellow
        case "ระวัง": .orange
        default:      .gray
        }
    }
}

#Preview {
    NavigationStack {
        FortuneStickView()
    }
}
