import SwiftUI
import UIKit

/// ตัวเลข 2 หลักแบบ slot machine — หลักสิบล็อกก่อน หลักหน่วยตาม
struct SlotNumberView: View {
    let targetNumber: Int
    let fontSize: CGFloat
    let color: Color

    @State private var displayTens: Int = 0
    @State private var displayOnes: Int = 0
    @State private var tensLocked = false
    @State private var onesLocked = false
    @State private var isRolling = false

    /// Timer ที่หมุนเลข
    @State private var rollTimer: Timer?

    /// haptic ตอนล็อกแต่ละหลัก
    private let tickHaptic = UIImpactFeedbackGenerator(style: .light)
    private let lockHaptic = UIImpactFeedbackGenerator(style: .medium)

    init(targetNumber: Int, fontSize: CGFloat = 72, color: Color = .white) {
        self.targetNumber = targetNumber
        self.fontSize = fontSize
        self.color = color
    }

    private var targetTens: Int { targetNumber / 10 }
    private var targetOnes: Int { targetNumber % 10 }

    var body: some View {
        HStack(spacing: 2) {
            // หลักสิบ
            digitView(displayTens, locked: tensLocked)
            // หลักหน่วย
            digitView(displayOnes, locked: onesLocked)
        }
        .onChange(of: targetNumber) {
            startRolling()
        }
        .onAppear {
            // ถ้ามีค่าตั้งแต่แรก ให้วิ่งเลย
            startRolling()
        }
    }

    @ViewBuilder
    private func digitView(_ digit: Int, locked: Bool) -> some View {
        Text("\(digit)")
            .font(.system(size: fontSize, weight: .bold, design: .rounded))
            .foregroundStyle(color)
            .contentTransition(.numericText())
            .scaleEffect(locked ? 1.0 : 0.95)
            .opacity(locked ? 1.0 : 0.7)
            .frame(minWidth: fontSize * 0.6)
    }

    private func startRolling() {
        // Reset state
        tensLocked = false
        onesLocked = false
        isRolling = true

        var tick = 0
        let tensLockAt = 8    // ล็อกหลักสิบหลัง ~8 ticks
        let onesLockAt = 14   // ล็อกหลักหน่วยหลัง ~14 ticks
        let interval: TimeInterval = 0.07

        rollTimer?.invalidate()
        rollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            tick += 1

            // หลักสิบ — วิ่งจนถึง lock
            if tick <= tensLockAt {
                withAnimation(.easeInOut(duration: interval)) {
                    displayTens = Int.random(in: 0...2)  // เซียมซี 1-28 → หลักสิบ 0-2
                }
                tickHaptic.impactOccurred(intensity: 0.3)
            }

            // ล็อกหลักสิบ
            if tick == tensLockAt {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    displayTens = targetTens
                    tensLocked = true
                }
                lockHaptic.impactOccurred()
            }

            // หลักหน่วย — วิ่งต่อ
            if tick <= onesLockAt {
                withAnimation(.easeInOut(duration: interval)) {
                    displayOnes = Int.random(in: 0...9)
                }
                if tick > tensLockAt {
                    tickHaptic.impactOccurred(intensity: 0.3)
                }
            }

            // ล็อกหลักหน่วย → จบ
            if tick == onesLockAt {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    displayOnes = targetOnes
                    onesLocked = true
                }
                lockHaptic.impactOccurred()
                isRolling = false
                timer.invalidate()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SlotNumberView(targetNumber: 17, fontSize: 80)
    }
}
