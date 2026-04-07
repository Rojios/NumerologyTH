import Foundation

/// เก็บสถานะเซียมซี: วันละ 1 ครั้ง + เก็บ/เผาใบเซียมซี
final class FortuneStore {
    static let shared = FortuneStore()
    private init() {}

    private let defaults = UserDefaults.standard
    private let lastDrawDateKey = "fortune_lastDrawDate"
    private let keptStickIdKey = "fortune_keptStickId"
    private let lastDrawnStickIdKey = "fortune_lastDrawnStickId"
    private let burnedDateKey = "fortune_burnedDate"

    private var todayString: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: Date())
    }

    // MARK: - วันละ 1 ครั้ง

    /// ยังสุ่มได้วันนี้ไหม
    var canDrawToday: Bool {
        defaults.string(forKey: lastDrawDateKey) != todayString
    }

    /// บันทึกว่าสุ่มแล้ววันนี้ + เก็บ stickId ที่ได้
    func recordDraw(stickId: Int) {
        defaults.set(todayString, forKey: lastDrawDateKey)
        defaults.set(stickId, forKey: lastDrawnStickIdKey)
    }

    /// ใบเซียมซีที่สุ่มได้วันนี้ (ยังไม่ได้เก็บ/เผา)
    func lastDrawnStick() -> FortuneStick? {
        guard defaults.string(forKey: lastDrawDateKey) == todayString else { return nil }
        let id = defaults.integer(forKey: lastDrawnStickIdKey)
        guard id > 0 else { return nil }
        return KnowledgeBaseLoader.shared.fortuneSticks.sticks.first { $0.id == id }
    }

    // MARK: - เก็บ/เผาใบเซียมซี

    /// เก็บใบเซียมซีไว้
    func keepStick(id: Int) {
        defaults.set(id, forKey: keptStickIdKey)
    }

    /// เผาใบเซียมซีทิ้ง
    func burnStick() {
        defaults.removeObject(forKey: keptStickIdKey)
        defaults.set(todayString, forKey: burnedDateKey)
    }

    /// เผาไปแล้ววันนี้ไหม
    var hasBurnedToday: Bool {
        defaults.string(forKey: burnedDateKey) == todayString
    }

    /// มีใบที่เก็บไว้ไหม
    var hasKeptStick: Bool {
        defaults.integer(forKey: keptStickIdKey) > 0
    }

    /// ดึงใบเซียมซีที่เก็บไว้
    func keptStick() -> FortuneStick? {
        let id = defaults.integer(forKey: keptStickIdKey)
        guard id > 0 else { return nil }
        return KnowledgeBaseLoader.shared.fortuneSticks.sticks.first { $0.id == id }
    }
}
