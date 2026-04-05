import SwiftUI

/// หน้าตัวอย่าง — reuse BaziResultView จริงด้วยข้อมูลจำลอง + ลายน้ำ "ตัวอย่าง"
struct CompatibilityPreviewView: View {
    let phoneDominantElement: AnalysisEngine.ChineseElement

    /// สร้างข้อมูลจำลองพร้อม elementMeaning จาก KB จริง
    private var mockResult: BaziResult {
        let mockDominant: AnalysisEngine.ChineseElement = .fire
        let kb = KnowledgeBaseLoader.shared.elementMeanings
        let meaning = kb["fire"]

        return BaziResult(
            birthDate: mockBirthDate,
            birthTime: mockBirthDate,
            dayElement: .fire,
            monthElement: .wood,
            yearElement: .water,
            hourElement: .earth,
            dominantElement: mockDominant,
            counts: [
                (element: .fire, count: 2),
                (element: .wood, count: 1),
                (element: .water, count: 1),
                (element: .earth, count: 1)
            ],
            description: meaning?.personality ?? "ธาตุไฟ — กระตือรือร้น มีเสน่ห์ เป็นจุดสนใจ",
            hasFourPillars: true,
            elementMeaning: meaning
        )
    }

    /// วันเกิดจำลอง 1 ม.ค. 2533
    private var mockBirthDate: Date {
        var comps = DateComponents()
        comps.year = 1990
        comps.month = 1
        comps.day = 1
        comps.hour = 8
        comps.minute = 30
        return Calendar.current.date(from: comps) ?? Date()
    }

    var body: some View {
        ZStack {
            // ใช้ BaziResultView จริงเลย — scroll ได้ปกติ
            BaziResultView(
                result: mockResult,
                phoneDominantElement: phoneDominantElement
            )
            .allowsHitTesting(false) // กดลิงก์/ปุ่มไม่ได้

            // ลายน้ำ "ตัวอย่าง" ทับ
            GeometryReader { geo in
                VStack(spacing: 120) {
                    ForEach(0..<6, id: \.self) { _ in
                        Text("ตัวอย่าง")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.black.opacity(0.06))
                            .rotationEffect(.degrees(-30))
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .allowsHitTesting(false)
        }
        .navigationTitle("ตัวอย่างผลลัพธ์")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CompatibilityPreviewView(phoneDominantElement: .water)
    }
}
