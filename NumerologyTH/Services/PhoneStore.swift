import Foundation

/// เก็บเบอร์มือถือ + ธาตุเด่นที่เคยวิเคราะห์ไว้ → ใช้ cross-link กับ BaziResultView
final class PhoneStore {
    static let shared = PhoneStore()
    private init() {}

    private let defaults = UserDefaults.standard
    private let phoneKey = "phone_number"
    private let elementKey = "phone_dominant_element"
    private let rememberKey = "phone_rememberEnabled"

    /// จำเบอร์ไว้หรือไม่
    var rememberEnabled: Bool {
        get { defaults.bool(forKey: rememberKey) }
        set { defaults.set(newValue, forKey: rememberKey) }
    }

    /// บันทึกเบอร์ + ธาตุเด่น
    func save(phone: String, dominant: AnalysisEngine.ChineseElement) {
        defaults.set(phone, forKey: phoneKey)
        defaults.set(dominant.rawValue, forKey: elementKey)
    }

    /// มีข้อมูลเบอร์ที่เคยวิเคราะห์หรือยัง
    var hasSavedResult: Bool {
        defaults.string(forKey: phoneKey) != nil
    }

    /// ดึงธาตุเด่นของเบอร์ที่เก็บไว้
    func loadDominantElement() -> AnalysisEngine.ChineseElement? {
        guard let raw = defaults.string(forKey: elementKey) else { return nil }
        return AnalysisEngine.ChineseElement(rawValue: raw)
    }

    /// ดึงเบอร์ที่เก็บไว้
    func loadPhone() -> String? {
        defaults.string(forKey: phoneKey)
    }

    /// ล้างข้อมูล
    func clear() {
        defaults.removeObject(forKey: phoneKey)
        defaults.removeObject(forKey: elementKey)
    }
}
