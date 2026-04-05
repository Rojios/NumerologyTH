// ============================================================
// WuXingCompatibility.swift
// แม่หมอเหมียว — Wu Xing Element Compatibility Engine
//
// คำนวณความเข้ากันระหว่าง:
//   - ธาตุเบอร์มือถือ (Lo Shu dominant) vs ธาตุประจำตัว (BaZi Day Master)
// ============================================================

import Foundation

typealias Element = AnalysisEngine.ChineseElement

// MARK: - Compatibility Tier

enum CompatibilityTier: String, Codable {
    case excellent = "เข้ากันมาก"
    case good      = "เข้ากันได้ดี"
    case neutral   = "พอไปได้"
    case tense     = "มีแรงต้าน"
    case difficult = "ต้องปรับตัวมาก"

    var emoji: String {
        switch self {
        case .excellent: "✨"
        case .good:      "💛"
        case .neutral:   "🔵"
        case .tense:     "⚠️"
        case .difficult: "🌊"
        }
    }

    var color: String {
        switch self {
        case .excellent: "#1A8A45"
        case .good:      "#E8B84B"
        case .neutral:   "#5DADE2"
        case .tense:     "#E59866"
        case .difficult: "#E74C3C"
        }
    }
}

// MARK: - Relationship Type

enum ElementRelationship: String, Codable {
    case aGeneratesB = "กำเนิด (A→B)"
    case bGeneratesA = "ได้รับการกำเนิด (B→A)"
    case aControlsB  = "ขัด (A→B)"
    case bControlsA  = "ถูกขัด (B→A)"
    case sameElement = "ธาตุเดียวกัน"

    var shortLabel: String {
        switch self {
        case .aGeneratesB: "เสริม (ให้)"
        case .bGeneratesA: "เสริม (รับ)"
        case .aControlsB:  "ขัด (ฝ่ายครอบ)"
        case .bControlsA:  "ขัด (ฝ่ายถูกครอบ)"
        case .sameElement: "ธาตุเดียวกัน"
        }
    }
}

// MARK: - Score Table (Dual-Perspective)

enum WuXingScoreTable {

    /// คะแนนมุมมองจาก A เมื่อมี B
    static func scoreFromPerspective(of a: Element, givenB b: Element) -> Int {
        if a == b              { return 75 } // เหมือนกัน
        if b.generates == a    { return 90 } // B กำเนิด A → A ได้รับพลัง
        if a.generates == b    { return 65 } // A กำเนิด B → A ให้พลัง (เหนื่อย)
        if b.controls == a     { return 40 } // B ขัด A → A ถูกกดทับ
        if a.controls == b     { return 50 } // A ขัด B → A มีอำนาจ
        return 60
    }

    /// Dual-Perspective average — symmetric
    static func compatibilityScore(a: Element, b: Element) -> Int {
        let scoreA = scoreFromPerspective(of: a, givenB: b)
        let scoreB = scoreFromPerspective(of: b, givenB: a)
        return (scoreA + scoreB) / 2
    }

    static func relationship(from a: Element, to b: Element) -> ElementRelationship {
        if a == b             { return .sameElement }
        if a.generates == b   { return .aGeneratesB }
        if b.generates == a   { return .bGeneratesA }
        if a.controls == b    { return .aControlsB }
        if b.controls == a    { return .bControlsA }
        return .sameElement
    }

    static func tier(score: Int) -> CompatibilityTier {
        switch score {
        case 76...100: .excellent
        case 70...75:  .good
        case 55...69:  .neutral
        case 45...54:  .tense
        default:       .difficult
        }
    }
}

// MARK: - Phone vs Person Result

struct PhoneCompatibilityResult {
    let personElement: Element
    let phoneDominantElement: Element
    let score: Int
    let tier: CompatibilityTier
    let relationship: ElementRelationship
    let summary: String
    let meowQuote: String
}

// MARK: - Main API

enum WuXingCompatibility {

    /// คำนวณ compatibility เบอร์มือถือ vs ธาตุประจำตัว
    static func phoneVsPerson(
        phoneDominant: Element,
        personElement: Element
    ) -> PhoneCompatibilityResult {

        let score = WuXingScoreTable.compatibilityScore(a: personElement, b: phoneDominant)
        let tier  = WuXingScoreTable.tier(score: score)
        let rel   = WuXingScoreTable.relationship(from: personElement, to: phoneDominant)

        let summary = buildSummary(
            personElement: personElement,
            phoneDominant: phoneDominant,
            relationship: rel,
            tier: tier,
            score: score
        )

        let meow = buildMeow(
            personElement: personElement,
            phoneDominant: phoneDominant,
            relationship: rel
        )

        return PhoneCompatibilityResult(
            personElement: personElement,
            phoneDominantElement: phoneDominant,
            score: score,
            tier: tier,
            relationship: rel,
            summary: summary,
            meowQuote: meow
        )
    }

    // MARK: - Private Helpers

    private static func buildSummary(
        personElement: Element,
        phoneDominant: Element,
        relationship: ElementRelationship,
        tier: CompatibilityTier,
        score: Int
    ) -> String {
        let pName = personElement.name
        let phName = phoneDominant.name
        switch relationship {
        case .bGeneratesA:
            return "ธาตุประจำตัวคุณคือ\(pName) และธาตุเด่นของเบอร์คือ\(phName) — ในวงจรธาตุห้า \(phName)เป็นธาตุที่ให้กำเนิดและหล่อเลี้ยง\(pName)โดยตรง เบอร์นี้จึงทำหน้าที่เหมือนแหล่งพลังงานที่คอยเติมเต็มให้คุณอยู่เสมอ ยิ่งใช้นานยิ่งรู้สึกว่าสิ่งต่างๆ ราบรื่นและลงตัว"
        case .aGeneratesB:
            return "ธาตุประจำตัวคุณคือ\(pName) และธาตุเด่นของเบอร์คือ\(phName) — ในวงจรธาตุห้า \(pName)เป็นธาตุที่ให้กำเนิด\(phName) หมายความว่าพลังงานของคุณจะถูกดูดไปหนุนเสริมเบอร์อยู่ตลอด ถ้าคุณแข็งแกร่งพอก็ไม่มีปัญหา แต่ช่วงไหนที่รู้สึกเหนื่อยล้า เบอร์นี้อาจทำให้รู้สึกหนักขึ้นได้"
        case .sameElement:
            return "ธาตุประจำตัวคุณคือ\(pName) และธาตุเด่นของเบอร์ก็เป็น\(phName)เหมือนกัน — ธาตุเดียวกันทำให้รู้สึกคุ้นเคยและสบายใจ พลังงานไหลเวียนอย่างเป็นธรรมชาติไม่ขัดแย้ง แต่เพราะไม่มีธาตุอื่นมาเสริม อาจขาดแรงผลักดันที่จะพาคุณก้าวข้ามขีดจำกัดเดิมๆ ได้"
        case .aControlsB:
            return "ธาตุประจำตัวคุณคือ\(pName) และธาตุเด่นของเบอร์คือ\(phName) — ในวงจรธาตุห้า \(pName)เป็นฝ่ายควบคุม\(phName) คุณจึงเป็นฝ่ายมีอำนาจเหนือเบอร์นี้ มีแรงต้านอยู่บ้างแต่ไม่มาก ถ้าคุณใช้ด้วยความมุ่งมั่นและตั้งใจ เบอร์นี้จะเชื่อฟังและทำงานให้คุณได้ดี"
        case .bControlsA:
            return "ธาตุประจำตัวคุณคือ\(pName) และธาตุเด่นของเบอร์คือ\(phName) — ในวงจรธาตุห้า \(phName)เป็นฝ่ายครอบงำ\(pName) เบอร์นี้จึงมีพลังกดทับธาตุของคุณอยู่ อาจรู้สึกสะดุดหรือหนักใจเป็นช่วงๆ โดยเฉพาะเวลาที่พลังงานตัวเองตกลง"
        }
    }

    private static func buildMeow(
        personElement: Element,
        phoneDominant: Element,
        relationship: ElementRelationship
    ) -> String {
        let pName = personElement.name
        let phName = phoneDominant.name
        switch relationship {
        case .bGeneratesA:
            return "เบอร์นี้เหมือนมีคนคอยเติมพลังให้เจ้าตลอดเวลาเลยนะคะ \(phName)เสริม\(pName)ได้ดีมากๆ พลังงานดีๆ จะไหลเข้าหาเจ้าผ่านเบอร์นี้อย่างต่อเนื่อง ไม่ว่าจะเป็นเรื่องงาน การเงิน หรือความสัมพันธ์ เหมียวบอกเลยว่าเบอร์นี้เป็นเบอร์มงคลสำหรับเจ้าโดยเฉพาะ รักษาไว้ให้ดีนะคะ 🐱✨"
        case .aGeneratesB:
            return "เบอร์นี้เจ้าต้องคอยให้พลังกับมันอยู่ตลอดนะคะ เหมือนเจ้าเป็นคนเลี้ยงเบอร์ ถ้าเจ้าแข็งแกร่งมีพลังเหลือเฟือก็ใช้ได้ดี แต่ช่วงไหนที่รู้สึกเหนื่อยล้าหรือท้อแท้ เบอร์นี้อาจดูดพลังเจ้าเพิ่มอีก เหมียวแนะนำว่าถ้าใช้เบอร์นี้ ให้หมั่นเติมพลังตัวเองด้วยสิ่งมงคลธาตุ\(pName)เป็นประจำนะคะ 🐱💪"
        case .sameElement:
            return "เบอร์ธาตุเดียวกับเจ้าเลยนะคะ! ใช้แล้วรู้สึกสบาย คุ้นเคย ไม่มีแรงกระทบกระเทือนใดๆ พลังงานไหลเวียนราบรื่นดี แต่เหมียวอยากบอกตามตรงว่า ธาตุเดียวกันก็เหมือนอยู่ใน comfort zone — สบายแต่ขาดตัวเสริมที่จะพาเจ้าไปข้างหน้า ถ้าอยากเติบโตเร็วขึ้น ลองหาเบอร์ธาตุที่เสริมเจ้าโดยตรงดูนะคะ 🐱💛"
        case .aControlsB:
            return "เจ้าเป็นนายเบอร์นี้นะคะ ธาตุ\(pName)ของเจ้าควบคุมธาตุ\(phName)ของเบอร์ได้ มีแรงต้านอยู่บ้างเล็กน้อยเหมือนขี่ม้าที่ยังไม่เชื่อง แต่ถ้าเจ้าใช้ด้วยความมุ่งมั่นและตั้งใจ เบอร์นี้จะเชื่อฟังและทำงานให้เจ้าได้ดี เหมียวว่าเหมาะกับคนที่ชอบความท้าทายนะคะ 🐱⚡"
        case .bControlsA:
            return "เบอร์นี้มีธาตุ\(phName)ที่กดธาตุ\(pName)ของเจ้าอยู่นิดนึงนะคะ อาจรู้สึกสะดุดหรือไม่ลื่นไหลเท่าที่ควรเป็นช่วงๆ โดยเฉพาะเวลาที่พลังงานตัวเองตกลง เหมียวแนะนำว่าถ้ามีโอกาสเลือกเบอร์ใหม่ ลองหาเบอร์ธาตุ\(personElement.generatedBy.name)หรือธาตุ\(pName)จะเข้ากับเจ้าได้ดีกว่านะคะ 🐱🌸"
        }
    }
}
