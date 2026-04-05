import SwiftUI

struct FortuneMenuView: View {
    @State private var drawnStick: FortuneStick?
    @State private var showFortune = false

    private let sticks = KnowledgeBaseLoader.shared.fortuneSticks.sticks

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("FortuneBG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        Spacer().frame(height: 10)

                        if drawnStick == nil {
                            // ปุ่มเขย่า — วงกลมใหญ่
                            Button {
                                drawnStick = sticks.randomElement()
                                showFortune = false
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.appPastelPink)
                                        .frame(width: 200, height: 200)
                                        .shadow(color: .purple.opacity(0.3), radius: 12, y: 4)

                                    Text("SHAKE")
                                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                                        .foregroundStyle(.white)
                                }
                            }

                            Text("คำทำนายมี 28 ใบ ตามศาสตร์จีนดั้งเดิม")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                                .padding(.top, 4)
                        }

                        // ผลเซียมซี — แทนที่ปุ่ม
                        if let stick = drawnStick {
                            // เลขใหญ่ด้านบน
                            VStack(spacing: 8) {
                                Text(String(format: "%02d", stick.id))
                                    .font(.system(size: 80, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .shadow(color: .purple.opacity(0.4), radius: 8)
                                Text(stick.name)
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.9))
                                levelBadge(stick.level)
                            }
                            .padding(.bottom, 8)
                            VStack(spacing: 12) {
                                if !showFortune {
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

                                if showFortune {
                                    fortuneDetail(stick)

                                    // ปุ่มเสี่ยงใหม่
                                    Button {
                                        drawnStick = sticks.randomElement()
                                        showFortune = false
                                    } label: {
                                        HStack {
                                            Image(systemName: "wand.and.stars")
                                            Text("เสี่ยงใหม่")
                                        }
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.appPastelPink)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // Footer
                Text("โปรแกรมนี้มีวัตถุประสงค์เพื่อความบันเทิง")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Fortune Detail

    @ViewBuilder
    private func fortuneDetail(_ stick: FortuneStick) -> some View {
        VStack(spacing: 12) {
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

            fortuneCategory(icon: "briefcase.fill", title: "การงาน", text: stick.work, color: .blue)
            fortuneCategory(icon: "heart.fill", title: "ความรัก", text: stick.love, color: .pink)
            fortuneCategory(icon: "banknote.fill", title: "การเงิน", text: stick.money, color: .green)
            fortuneCategory(icon: "heart.text.square.fill", title: "สุขภาพ", text: stick.health, color: .orange)
        }
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
        FortuneMenuView()
    }
}
