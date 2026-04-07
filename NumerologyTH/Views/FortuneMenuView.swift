import SwiftUI
import UIKit

struct FortuneMenuView: View {
    @State private var drawnStick: FortuneStick?
    @State private var showFortune = false
    @State private var isShaking = false
    @State private var shakeAngle: Double = 0
    @State private var overlayImage: String?
    @State private var showOverlay = false
    @State private var overlayMessage: String?
    @State private var hasBurnedToday = false

    private let store = FortuneStore.shared
    private let sticks = KnowledgeBaseLoader.shared.fortuneSticks.sticks
    private let haptic = UIImpactFeedbackGenerator(style: .heavy)

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

                        if hasBurnedToday {
                            // เผาแล้ววันนี้ (set จาก shakeAndDraw เท่านั้น)
                            burnedView
                        } else if let stick = drawnStick {
                            // มีใบที่สุ่มได้ (หรือดึงจาก store) → แสดงผล
                            if store.hasKeptStick {
                                keptStickView(stick)
                            } else {
                                alreadyDrawnView(stick)
                            }
                        } else {
                            // ยังไม่ได้สุ่ม (หรือเพิ่งเข้ามา) → ปุ่ม SHAKE เสมอ
                            shakeButton
                        }
                    }
                    .padding(.horizontal)
                }

                Text("โปรแกรมนี้มีวัตถุประสงค์เพื่อความบันเทิง")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }

            // Image overlay (เก็บ/เผา)
            if showOverlay, let img = overlayImage {
                imageOverlay(img)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onShake {
            guard !isShaking, drawnStick == nil else { return }
            shakeAndDraw()
        }
    }

    // MARK: - Shake Button

    private var shakeButton: some View {
        VStack(spacing: 12) {
            Button {
                shakeAndDraw()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.appPastelPink)
                        .frame(width: 180, height: 180)
                        .shadow(color: .purple.opacity(0.3), radius: 12, y: 4)

                    Text("SHAKE")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .rotationEffect(.degrees(shakeAngle))
            .disabled(isShaking)

            HStack(spacing: 5) {
                Image(systemName: "iphone.radiowaves.left.and.right")
                    .font(.body)
                Text("เขย่ามือถือ หรือ กดปุ่มด้านบน")
                    .font(.body.weight(.medium))
            }
            .foregroundStyle(.white.opacity(0.8))
            .padding(.top, 6)

            Text("คำทำนายมี 28 ใบ ตามศาสตร์จีนดั้งเดิม")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.top, 2)
        }
    }

    // MARK: - Already Drawn View (สุ่มแล้ววันนี้)

    private func alreadyDrawnView(_ stick: FortuneStick) -> some View {
        VStack(spacing: 16) {
            stickHeader(stick)

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
                keepBurnButtons(stick)
            }

            comeBackTomorrowBadge
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }

    // MARK: - Kept Stick View (มีใบที่เก็บไว้)

    private func keptStickView(_ stick: FortuneStick) -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(.orange)
                Text("ใบเซียมซีของคุณ")
                    .font(.headline)
                    .foregroundStyle(.white)
            }

            stickHeader(stick)
            fortuneDetail(stick)

            // ปุ่มเผาอย่างเดียว
            Button {
                showBurnOverlay()
            } label: {
                HStack {
                    Image(systemName: "flame.fill")
                    Text("เผาใบเซียมซีนี้ทิ้ง")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange.opacity(0.8))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }

    // MARK: - Burned View (เผาแล้ววันนี้)

    private var burnedView: some View {
        VStack(spacing: 20) {
            Image("FortuneBurn")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("วันนี้ไม่รับใบเซียมซี")
                .font(.title3.bold())
                .foregroundStyle(.white)

            Text("คุณจะเสี่ยงทายใหม่ได้อีกครั้งพรุ่งนี้")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }

    // MARK: - Come Back Tomorrow

    private var comeBackTomorrowView: some View {
        VStack(spacing: 12) {
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.6))
            Text("เสี่ยงได้อีกครั้งพรุ่งนี้")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("วันนี้คุณได้เสี่ยงเซียมซีแล้ว")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 40)
    }

    private var comeBackTomorrowBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "moon.stars")
                .font(.caption)
            Text("เสี่ยงได้อีกครั้งพรุ่งนี้")
                .font(.caption)
        }
        .foregroundStyle(.white.opacity(0.6))
    }

    // MARK: - Keep / Burn Buttons

    private func keepBurnButtons(_ stick: FortuneStick) -> some View {
        HStack(spacing: 12) {
            Button {
                showKeepOverlay(stick)
            } label: {
                HStack {
                    Image(systemName: "bookmark.fill")
                    Text("เก็บใบนี้ไว้")
                }
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.appLavender)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                showBurnOverlay()
            } label: {
                HStack {
                    Image(systemName: "flame.fill")
                    Text("เผาทิ้ง")
                }
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange.opacity(0.8))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Overlay Actions

    private func showKeepOverlay(_ stick: FortuneStick) {
        store.keepStick(id: stick.id)
        overlayImage = "FortuneKeep"
        withAnimation(.easeIn(duration: 0.4)) {
            showOverlay = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.4)) {
                showOverlay = false
            }
        }
    }

    private func showBurnOverlay() {
        store.burnStick()
        drawnStick = nil
        showFortune = false
        overlayImage = "FortuneBurn"
        withAnimation(.easeIn(duration: 0.4)) {
            showOverlay = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.4)) {
                showOverlay = false
                hasBurnedToday = true
            }
        }
    }

    // MARK: - Image Overlay

    private func imageOverlay(_ imageName: String) -> some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 30)

                if let msg = overlayMessage {
                    Text(msg)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .transition(.opacity)
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                showOverlay = false
                overlayMessage = nil
            }
        }
    }

    // MARK: - Shake & Draw

    private func shakeAndDraw() {
        // เผาแล้ววันนี้ → แสดงภาพเผา + ข้อความ แล้วค่อยแสดง burnedView
        if store.hasBurnedToday {
            overlayImage = "FortuneBurn"
            overlayMessage = "ใบเซียมซีของวันนี้ถูกเผาไปแล้ว"
            withAnimation(.easeIn(duration: 0.4)) {
                showOverlay = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.4)) {
                    showOverlay = false
                    overlayMessage = nil
                }
                hasBurnedToday = true
            }
            return
        }

        // สุ่มแล้ววันนี้ + เก็บไว้แล้ว → แสดงภาพเก็บ + ข้อความ แล้วค่อยแสดงใบ
        if !store.canDrawToday, store.hasKeptStick, let existing = store.keptStick() {
            overlayImage = "FortuneKeep"
            overlayMessage = "คุณมีใบเซียมซีของวันนี้ที่เก็บไว้แล้ว"
            withAnimation(.easeIn(duration: 0.4)) {
                showOverlay = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.4)) {
                    showOverlay = false
                    overlayMessage = nil
                }
                drawnStick = existing
            }
            return
        }

        // สุ่มแล้ววันนี้ (ยังไม่ได้เก็บ) → ดึงใบเก่ามาแสดง
        if !store.canDrawToday, let existing = store.lastDrawnStick() {
            isShaking = true
            showFortune = false
            withAnimation(.easeInOut(duration: 0.08).repeatCount(5, autoreverses: true)) {
                shakeAngle = 8
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.1)) { shakeAngle = 0 }
                haptic.impactOccurred()
                drawnStick = existing
                isShaking = false
            }
            return
        }

        // สุ่มใหม่
        isShaking = true
        showFortune = false

        withAnimation(.easeInOut(duration: 0.08).repeatCount(5, autoreverses: true)) {
            shakeAngle = 8
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.1)) {
                shakeAngle = 0
            }
            haptic.impactOccurred()
            let stick = sticks.randomElement()!
            drawnStick = stick
            store.recordDraw(stickId: stick.id)
            isShaking = false
        }
    }

    // MARK: - Stick Header

    private func stickHeader(_ stick: FortuneStick) -> some View {
        VStack(spacing: 8) {
            SlotNumberView(
                targetNumber: stick.id,
                fontSize: 80,
                color: .white
            )
            .shadow(color: .purple.opacity(0.4), radius: 8)
            Text(stick.name)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.9))
            levelBadge(stick.level)
        }
        .padding(.bottom, 8)
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
                Text(formatOverall(stick.overall))
                    .font(.body)
                    .foregroundStyle(.black.opacity(0.7))
                    .lineSpacing(6)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
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

    /// แปลงกลอน: ขึ้นบรรทัดใหม่ทุกช่องว่าง
    private func formatOverall(_ text: String) -> String {
        text.replacingOccurrences(of: " ", with: "\n")
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
