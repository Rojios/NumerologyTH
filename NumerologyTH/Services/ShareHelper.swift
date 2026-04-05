import SwiftUI
import UIKit

enum ShareHelper {

    // MARK: - Share via UIActivityViewController

    static func share(image: UIImage, text: String) {
        let items: [Any] = [image, text]
        let av = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }).first,
              let vc = scene.windows.first?.rootViewController else { return }

        // iPad popover support
        av.popoverPresentationController?.sourceView = vc.view
        av.popoverPresentationController?.sourceRect = CGRect(
            x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0
        )
        av.popoverPresentationController?.permittedArrowDirections = []

        // Find topmost presented VC
        var top = vc
        while let presented = top.presentedViewController { top = presented }
        top.present(av, animated: true)
    }

    // MARK: - Snapshot SwiftUI View → UIImage

    static func snapshot<V: View>(_ view: V, size: CGSize) -> UIImage {
        let wrappedView = view
            .frame(width: size.width, height: size.height)
            .ignoresSafeArea()

        let controller = UIHostingController(rootView: wrappedView)
        controller.safeAreaRegions = []
        controller.view.frame = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear

        // ต้อง add เข้า window เพื่อให้ Image asset โหลดได้
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.view.layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        window.isHidden = true
        return image
    }

    // MARK: - Snapshot with auto height (long screenshot)

    static func snapshotFit<V: View>(_ view: V, width: CGFloat) -> UIImage {
        let controller = UIHostingController(rootView: view)
        // ให้ intrinsic size กำหนดความสูงเอง
        controller.view.bounds = CGRect(origin: .zero, size: CGSize(width: width, height: 10000))
        controller.view.backgroundColor = .clear
        controller.view.layoutIfNeeded()

        let intrinsic = controller.view.intrinsicContentSize
        let finalHeight = max(intrinsic.height > 0 ? intrinsic.height : 800, 200)
        let finalSize = CGSize(width: width, height: finalHeight)
        controller.view.bounds = CGRect(origin: .zero, size: finalSize)
        controller.view.layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(size: finalSize)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }

    // MARK: - Masked Phone

    static func maskedPhone(_ phone: String) -> String {
        let digits = phone.filter(\.isNumber)
        guard digits.count == 10 else { return phone }
        let arr = Array(digits)
        // Format: 0XX-xxx-xx50 — แสดงแค่ 3 หลักแรก + 2 หลักท้าย
        let masked = "\(arr[0])\(arr[1])\(arr[2])-xxx-xx\(arr[8])\(arr[9])"
        return masked
    }
}
