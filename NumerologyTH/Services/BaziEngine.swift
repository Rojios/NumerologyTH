import Foundation

struct BaziResult {
    let birthDate: Date
    let birthTime: Date?
    let dayElement: AnalysisEngine.ChineseElement
    let monthElement: AnalysisEngine.ChineseElement
    let yearElement: AnalysisEngine.ChineseElement
    let hourElement: AnalysisEngine.ChineseElement?
    let dominantElement: AnalysisEngine.ChineseElement
    let counts: [(element: AnalysisEngine.ChineseElement, count: Int)]
    let description: String
    let hasFourPillars: Bool
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

    /// Hour pillar: แปลงชั่วโมงเป็น Earthly Branch (2 ชม. = 1 ยาม)
    /// 23-01=子(น้ำ), 01-03=丑(ดิน), 03-05=寅(ไม้), 05-07=卯(ไม้),
    /// 07-09=辰(ดิน), 09-11=巳(ไฟ), 11-13=午(ไฟ), 13-15=未(ดิน),
    /// 15-17=申(ทอง), 17-19=酉(ทอง), 19-21=戌(ดิน), 21-23=亥(น้ำ)
    private static func hourElement(from time: Date) -> AnalysisEngine.ChineseElement {
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: time)
        // แปลงชั่วโมงเป็น branch index (0-11)
        let branchIdx = ((hour + 1) % 24) / 2
        return branchElements[branchIdx]
    }

    static func analyze(birthDate: Date, birthTime: Date? = nil) -> BaziResult {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.year, .month, .day], from: birthDate)
        let year = comps.year!
        let month = comps.month!

        // Year pillar
        let yearStem = stemIndex(year: year)
        let yearEl = stemElements[yearStem]

        // Month pillar
        let monthBranchIdx = (month + 1) % 12
        let monthEl = branchElements[monthBranchIdx]

        // Day pillar
        let dayEl = dayElement(from: birthDate)

        // Hour pillar (optional)
        let hourEl = birthTime.map { hourElement(from: $0) }

        // นับรวมธาตุ
        var map: [AnalysisEngine.ChineseElement: Int] = [:]
        for el in AnalysisEngine.ChineseElement.allCases { map[el] = 0 }
        map[yearEl, default: 0] += 1
        map[monthEl, default: 0] += 1
        map[dayEl, default: 0] += 1
        if let hourEl {
            map[hourEl, default: 0] += 1
        }

        let sorted = map.sorted { $0.value > $1.value }
            .map { (element: $0.key, count: $0.value) }
        let dominant = sorted.first?.element ?? .water

        let desc = elementDescription(dominant)

        return BaziResult(
            birthDate: birthDate,
            birthTime: birthTime,
            dayElement: dayEl,
            monthElement: monthEl,
            yearElement: yearEl,
            hourElement: hourEl,
            dominantElement: dominant,
            counts: sorted,
            description: desc,
            hasFourPillars: birthTime != nil
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
