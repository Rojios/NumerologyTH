import SwiftUI
import UIKit

// MARK: - Shake-detecting ViewController

/// UIViewController ที่ตรวจจับการเขย่า iPhone แล้วเรียก callback
final class ShakeDetectViewController: UIViewController {
    var onShake: (() -> Void)?

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            onShake?()
        }
    }
}

// MARK: - UIViewControllerRepresentable

/// Wrap ShakeDetectViewController เป็น SwiftUI-compatible view
struct ShakeDetectorView: UIViewControllerRepresentable {
    let onShake: () -> Void

    func makeUIViewController(context: Context) -> ShakeDetectViewController {
        let vc = ShakeDetectViewController()
        vc.onShake = onShake
        return vc
    }

    func updateUIViewController(_ uiViewController: ShakeDetectViewController, context: Context) {
        uiViewController.onShake = onShake
    }
}

// MARK: - ViewModifier

/// ViewModifier ให้ใช้ `.onShake { }` ใน SwiftUI ได้สะดวก
struct ShakeGestureModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .background(
                ShakeDetectorView(onShake: action)
                    .allowsHitTesting(false)
            )
    }
}

// MARK: - View Extension

extension View {
    /// ตรวจจับการเขย่า iPhone — ใช้ `.onShake { doSomething() }`
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(ShakeGestureModifier(action: action))
    }
}
