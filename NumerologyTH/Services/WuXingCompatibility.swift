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
        let base = "ธาตุประจำตัว (\(personElement.name)) กับธาตุเด่นของเบอร์ (\(phoneDominant.name))"
        switch relationship {
        case .bGeneratesA:
            return "\(base) — เบอร์นี้เสริมธาตุของคุณโดยตรง พลังงานไหลเข้าหาคุณ"
        case .aGeneratesB:
            return "\(base) — คุณเสริมธาตุเบอร์ พลังงานของคุณถูกดูดไปหนุนเบอร์"
        case .sameElement:
            return "\(base) — ธาตุเดียวกัน เข้าใจกัน รู้สึกสบาย แต่ระวังความซ้ำซ้อน"
        case .aControlsB:
            return "\(base) — ธาตุคุณควบคุมธาตุเบอร์ มีแรงต้านเล็กน้อย แต่คุณเป็นฝ่ายมีอำนาจ"
        case .bControlsA:
            return "\(base) — ธาตุเบอร์กดทับธาตุคุณ อาจรู้สึกหนักหรือสะดุด"
        }
    }

    private static func buildMeow(
        personElement: Element,
        phoneDominant: Element,
        relationship: ElementRelationship
    ) -> String {
        switch relationship {
        case .bGeneratesA:
            return "เบอร์นี้เหมือนมีคนคอยเติมพลังให้เจ้าตลอดเวลา \(phoneDominant.name)เสริม\(personElement.name)ได้ดีมาก เหมียวแนะนำ!"
        case .aGeneratesB:
            return "เบอร์นี้เจ้าต้องคอยให้พลังกับมันตลอด ถ้าเจ้าแข็งแกร่งพอก็ไม่เป็นไร แต่ถ้ารู้สึกเหนื่อยบ่อยๆ ลองเปลี่ยนเบอร์ดูนะคะ"
        case .sameElement:
            return "เบอร์ธาตุเดียวกับเจ้า! รู้สึกสบายใช้งานได้ดี แต่ขาดตัวเสริมที่จะช่วยพาไปข้างหน้า"
        case .aControlsB:
            return "เจ้าเป็นนายเบอร์นี้ มีแรงต้านเล็กน้อย แต่เจ้าคุมได้ ถ้าจะใช้ต้องมีความมุ่งมั่นหน่อยนะคะ"
        case .bControlsA:
            return "เบอร์นี้กดธาตุเจ้าอยู่นิดนึง รู้สึกสะดุดได้บ้าง ถ้ามีตัวเลือกอื่น เหมียวแนะนำให้หาเบอร์ธาตุ\(personElement.generatedBy.name)หรือธาตุ\(personElement.name)แทนนะคะ"
        }
    }
}
