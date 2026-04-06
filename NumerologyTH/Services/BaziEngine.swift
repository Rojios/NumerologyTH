import Foundation

struct BaziResult {
    let birthDate: Date
    let birthTime: Date?
    let dayElement: AnalysisEngine.ChineseElement
    let monthElement: AnalysisEngine.ChineseElement
    let yearElement: AnalysisEngine.ChineseElement
    let hourElement: AnalysisEngine.ChineseElement?
    let dominantElement: AnalysisEngine.ChineseElement
    /// สัดส่วนธาตุถ่วงน้ำหนักตามเสา (percentage 0–100)
    let percentages: [(element: AnalysisEngine.ChineseElement, percentage: Double)]
    let description: String
    let hasFourPillars: Bool
    let elementMeaning: ElementMeaning?
}

/// Lo Shu / ธาตุห้า — วิเคราะห์ธาตุประจำตัวจากวันเกิด
enum BaziEngine {

    // MARK: - Heavenly Stems (天干) — 10 วงจร
    private static let stemElements: [AnalysisEngine.ChineseElement] = [
        .wood, .wood,   // 甲乙
        .fire, .fire,   // 丙丁
        .earth, .earth, // 戊己
        .metal, .metal, // 庚辛
        .water, .water  // 壬癸
    ]

    // MARK: - Earthly Branches (地支) — 12 วงจร
    private static let branchElements: [AnalysisEngine.ChineseElement] = [
        .water, .earth, .wood, .wood,
        .earth, .fire, .fire, .earth,
        .metal, .metal, .earth, .water
    ]

    private static func stemIndex(year: Int) -> Int {
        return (year + 6) % 10
    }

    private static func dayElement(from date: Date) -> AnalysisEngine.ChineseElement {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        let y = comps.year!, m = comps.month!, d = comps.day!

        let a = (14 - m) / 12
        let yAdj = y + 4800 - a
        let mAdj = m + 12 * a - 3
        let jdn = d + (153 * mAdj + 2) / 5 + 365 * yAdj + yAdj / 4 - yAdj / 100 + yAdj / 400 - 32045

        let dayStemIdx = (jdn + 9) % 10
        return stemElements[dayStemIdx]
    }

    /// Month Stem: คำนวณ Heavenly Stem ของเดือนจาก Year Stem + เดือน
    /// สูตร 五虎遁 (Five Tiger Escape)
    /// Yin-Yang pairs: 甲己(0), 乙庚(1), 丙辛(2), 丁壬(3), 戊癸(4)
    private static func monthStemIndex(yearStem: Int, month: Int) -> Int {
        // Gregorian month → offset จาก 寅(Feb): Feb=0, Mar=1, ..., Jan=11
        let monthBranchOffset = ((month + 10) % 12)
        let baseStems = [2, 4, 6, 8, 0]  // 甲/己→丙, 乙/庚→戊, 丙/辛→庚, 丁/壬→壬, 戊/癸→甲
        let baseStem = baseStems[yearStem % 5]
        return (baseStem + monthBranchOffset) % 10
    }

    /// Day Stem Index (ใช้คำนวณ Hour Stem)
    private static func dayStemIndex(from date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        let y = comps.year!, m = comps.month!, d = comps.day!
        let a = (14 - m) / 12
        let yAdj = y + 4800 - a
        let mAdj = m + 12 * a - 3
        let jdn = d + (153 * mAdj + 2) / 5 + 365 * yAdj + yAdj / 4 - yAdj / 100 + yAdj / 400 - 32045
        return (jdn + 9) % 10
    }

    /// Hour Stem: คำนวณ Heavenly Stem ของยามจาก Day Stem + ชั่วโมง
    /// สูตร 五鼠遁 (Five Rat Escape)
    /// Yin-Yang pairs: 甲己(0), 乙庚(1), 丙辛(2), 丁壬(3), 戊癸(4)
    private static func hourStemElement(from time: Date, dayStemIdx: Int) -> AnalysisEngine.ChineseElement {
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: time)
        let branchIdx = ((hour + 1) % 24) / 2  // 0=子, 1=丑, ...
        let baseStems = [0, 2, 4, 6, 8]  // 甲/己→甲, 乙/庚→丙, 丙/辛→戊, 丁/壬→庚, 戊/癸→壬
        let baseStem = baseStems[dayStemIdx % 5]
        let hourStemIdx = (baseStem + branchIdx) % 10
        return stemElements[hourStemIdx]
    }

    static func analyze(birthDate: Date, birthTime: Date? = nil) -> BaziResult {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.year, .month, .day], from: birthDate)
        let year = comps.year!
        let month = comps.month!

        // Year pillar — Heavenly Stem
        let yearStem = stemIndex(year: year)
        let yearEl = stemElements[yearStem]

        // Month pillar — Heavenly Stem (五虎遁)
        let monthStem = monthStemIndex(yearStem: yearStem, month: month)
        let monthEl = stemElements[monthStem]

        // Day pillar — Heavenly Stem (JDN)
        let dayEl = dayElement(from: birthDate)
        let dayStem = dayStemIndex(from: birthDate)

        // Hour pillar — Heavenly Stem (五鼠遁)
        let hourEl = birthTime.map { hourStemElement(from: $0, dayStemIdx: dayStem) }

        // น้ำหนักเสาตามหลัก Bazi (月令 สำคัญสุด)
        // 4 เสา: ปี 10%, เดือน 40%, วัน 30%, ยาม 20%
        // 3 เสา (ไม่มียาม): ปี 12.5%, เดือน 50%, วัน 37.5%
        var weightMap: [AnalysisEngine.ChineseElement: Double] = [:]
        for el in AnalysisEngine.ChineseElement.allCases { weightMap[el] = 0 }

        if let hourEl {
            weightMap[yearEl,  default: 0] += 10
            weightMap[monthEl, default: 0] += 40
            weightMap[dayEl,   default: 0] += 30
            weightMap[hourEl,  default: 0] += 20
        } else {
            weightMap[yearEl,  default: 0] += 12.5
            weightMap[monthEl, default: 0] += 50
            weightMap[dayEl,   default: 0] += 37.5
        }

        let sorted = weightMap.sorted { $0.value > $1.value }
            .map { (element: $0.key, percentage: $0.value) }

        // ธาตุประจำตัว (เจ้าชะตา/日主) = Day Stem เสมอ ตามหลัก Bazi
        let dominant = dayEl

        // ดึงจาก KB
        let kb = KnowledgeBaseLoader.shared.elementMeanings
        let elementKey = elementKeyFor(dominant)
        let meaning = kb[elementKey]
        let desc = meaning?.personality ?? elementDescription(dominant)

        return BaziResult(
            birthDate: birthDate,
            birthTime: birthTime,
            dayElement: dayEl,
            monthElement: monthEl,
            yearElement: yearEl,
            hourElement: hourEl,
            dominantElement: dominant,
            percentages: sorted,
            description: desc,
            hasFourPillars: birthTime != nil,
            elementMeaning: meaning
        )
    }

    /// แปลง ChineseElement → JSON key
    private static func elementKeyFor(_ element: AnalysisEngine.ChineseElement) -> String {
        switch element {
        case .water: "water"
        case .fire:  "fire"
        case .wood:  "wood"
        case .earth: "earth"
        case .metal: "metal"
        }
    }

    /// Fallback เมื่อไม่มี KB
    private static func elementDescription(_ element: AnalysisEngine.ChineseElement) -> String {
        switch element {
        case .water:
            return "คุณเป็นคนธาตุน้ำ — ชาญฉลาด ยืดหยุ่น ปรับตัวเก่ง มีความคิดสร้างสรรค์ เหมาะกับงานที่ต้องใช้ไหวพริบ การสื่อสาร และการเจรจาต่อรอง ธาตุน้ำส่งเสริมให้มีสัญชาตญาณดี อ่านคนเก่ง"
        case .earth:
            return "คุณเป็นคนธาตุดิน — มั่นคง น่าเชื่อถือ เป็นหลักให้คนรอบข้างได้ มีความอดทนสูง เหมาะกับงานที่ต้องใช้ความละเอียดรอบคอบ การบริหารจัดการ ธาตุดินส่งเสริมให้เป็นศูนย์กลางของทีม"
        case .wood:
            return "คุณเป็นคนธาตุไม้ — มีพลังเติบโต มุ่งมั่น ชอบพัฒนาตัวเอง มีเมตตา ใจกว้าง เหมาะกับงานสร้างสรรค์ การศึกษา และงานที่ต้องวางแผนระยะยาว ธาตุไม้ส่งเสริมให้เป็นผู้นำที่อ่อนน้อม"
        case .fire:
            return "คุณเป็นคนธาตุไฟ — กระตือรือร้น มีเสน่ห์ เป็นจุดสนใจ มีพลังงานสูง เหมาะกับงานที่ต้องแสดงออก การตลาด การขาย ธาตุไฟส่งเสริมให้มีความเป็นผู้นำ กล้าตัดสินใจ"
        case .metal:
            return "คุณเป็นคนธาตุทอง — เด็ดเดี่ยว มีระเบียบ เป็นคนตรงไปตรงมา ยุติธรรม เหมาะกับงานที่ต้องใช้ความแม่นยำ กฎหมาย การเงิน ธาตุทองส่งเสริมให้มีความมุ่งมั่นไม่ย่อท้อ"
        }
    }
}
