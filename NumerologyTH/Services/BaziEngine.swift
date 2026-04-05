import Foundation

struct BaziResult {
    let birthDate: Date
    let dayElement: AnalysisEngine.ChineseElement
    let monthElement: AnalysisEngine.ChineseElement
    let yearElement: AnalysisEngine.ChineseElement
    let dominantElement: AnalysisEngine.ChineseElement
    let counts: [(element: AnalysisEngine.ChineseElement, count: Int)]
    let description: String
}

/// Lo Shu / ธาตุห้า — วิเคราะห์ธาตุประจำตัวจากวันเกิด
enum BaziEngine {

    // MARK: - Heavenly Stems (天干) — 10 วงจร
    // จับ → ดิน, อิ → ดิน, เปี่ย → ไม้, อึด → ไม้,
    // มู่ → ไฟ, กี่ → ไฟ, เกง → ทอง, ซิน → ทอง,
    // เยิ่น → น้ำ, กุ่ย → น้ำ
    private static let stemElements: [AnalysisEngine.ChineseElement] = [
        .wood, .wood,   // 甲乙
        .fire, .fire,   // 丙丁
        .earth, .earth, // 戊己
        .metal, .metal, // 庚辛
        .water, .water  // 壬癸
    ]

    // MARK: - Earthly Branches (地支) — 12 วงจร
    // ชวด=น้ำ, ฉลู=ดิน, ขาล=ไม้, เถาะ=ไม้,
    // มะโรง=ดิน, มะเส็ง=ไฟ, มะเมีย=ไฟ, มะแม=ดิน,
    // วอก=ทอง, ระกา=ทอง, จอ=ดิน, กุน=น้ำ
    private static let branchElements: [AnalysisEngine.ChineseElement] = [
        .water, .earth, .wood, .wood,
        .earth, .fire, .fire, .earth,
        .metal, .metal, .earth, .water
    ]

    /// คำนวณ Stem index จากปี (จีน: 天干 = year % 10)
    private static func stemIndex(year: Int) -> Int {
        // ปี ค.ศ. stem cycle: 4=甲(wood), 5=乙(wood), 6=丙(fire) ...
        return (year + 6) % 10
    }

    /// คำนวณ Branch index จากปี (จีน: 地支 = year % 12)
    private static func branchIndex(year: Int) -> Int {
        // ปี ค.ศ. branch cycle: 4=子(rat/water)
        return (year + 8) % 12
    }

    /// คำนวณธาตุจากวัน — ใช้ stem ของ day pillar
    private static func dayElement(from date: Date) -> AnalysisEngine.ChineseElement {
        // Julian Day Number → Day Stem
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        let y = comps.year!, m = comps.month!, d = comps.day!

        // JDN formula (สำหรับ Gregorian)
        let a = (14 - m) / 12
        let yAdj = y + 4800 - a
        let mAdj = m + 12 * a - 3
        let jdn = d + (153 * mAdj + 2) / 5 + 365 * yAdj + yAdj / 4 - yAdj / 100 + yAdj / 400 - 32045

        // Day stem cycle: JDN mod 10 → stem index
        // Day 0 (甲子) = JDN offset
        let dayStemIdx = (jdn + 9) % 10
        return stemElements[dayStemIdx]
    }

    static func analyze(birthDate: Date) -> BaziResult {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.year, .month, .day], from: birthDate)
        let year = comps.year!

        // Year pillar
        let yearStem = stemIndex(year: year)
        let yearEl = stemElements[yearStem]

        // Month pillar (simplified: ใช้ branch ของเดือน)
        let month = comps.month!
        // เดือน 1(ม.ค.)=寅(ขาล=ไม้), offset +2
        let monthBranchIdx = (month + 1) % 12
        let monthEl = branchElements[monthBranchIdx]

        // Day pillar
        let dayEl = dayElement(from: birthDate)

        // นับรวมธาตุ
        var map: [AnalysisEngine.ChineseElement: Int] = [:]
        for el in AnalysisEngine.ChineseElement.allCases { map[el] = 0 }
        map[yearEl, default: 0] += 1
        map[monthEl, default: 0] += 1
        map[dayEl, default: 0] += 1

        let sorted = map.sorted { $0.value > $1.value }
            .map { (element: $0.key, count: $0.value) }
        let dominant = sorted.first?.element ?? .water

        let desc = elementDescription(dominant)

        return BaziResult(
            birthDate: birthDate,
            dayElement: dayEl,
            monthElement: monthEl,
            yearElement: yearEl,
            dominantElement: dominant,
            counts: sorted,
            description: desc
        )
    }

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
