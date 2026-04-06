import Foundation

/// เก็บข้อมูลวันเกิด/เวลาเกิดที่เคยวิเคราะห์ไว้ → recompute BaziResult เมื่อต้องการ
final class BaziStore {
    static let shared = BaziStore()
    private init() {}

    private let defaults = UserDefaults.standard
    private let birthDateKey = "bazi_birthDate"
    private let birthTimeKey = "bazi_birthTime"

    /// บันทึกวันเกิด + เวลาเกิดที่เคยวิเคราะห์
    func save(birthDate: Date, birthTime: Date) {
        defaults.set(birthDate, forKey: birthDateKey)
        defaults.set(birthTime, forKey: birthTimeKey)
    }

    /// มีข้อมูลธาตุที่เคยวิเคราะห์หรือยัง
    var hasSavedResult: Bool {
        defaults.object(forKey: birthDateKey) != nil
    }

    /// ล้างประวัติรหัสธาตุ
    func clear() {
        defaults.removeObject(forKey: birthDateKey)
        defaults.removeObject(forKey: birthTimeKey)
    }

    /// คำนวณ BaziResult ใหม่จากข้อมู���ที่เก็บไว้
    func loadResult() -> BaziResult? {
        guard let birthDate = defaults.object(forKey: birthDateKey) as? Date,
              let birthTime = defaults.object(forKey: birthTimeKey) as? Date else {
            return nil
        }
        return BaziEngine.analyze(birthDate: birthDate, birthTime: birthTime)
    }
}
