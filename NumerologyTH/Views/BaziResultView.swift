import SwiftUI

struct BaziResultView: View {
    let result: BaziResult

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.locale = Locale(identifier: "th_TH")
        f.calendar = Calendar(identifier: .buddhist)
        return f
    }()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text(result.dominantElement.emoji)
                        .font(.system(size: 60))

                    Text("ธาตุประจำตัวคุณ")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(result.dominantElement.name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(elementColor(result.dominantElement))
                }
                .padding(.top, 8)

                // วันเกิด
                Text(dateFormatter.string(from: result.birthDate))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // เสาธาตุ
                VStack(spacing: 12) {
                    Text(result.hasFourPillars ? "เสาธาตุทั้ง 4" : "เสาธาตุทั้ง 3")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if !result.hasFourPillars {
                        Text("ใส่เวลาเกิดเพื่อเพิ่มเสาที่ 4 (ยาม)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack(spacing: 12) {
                        pillarCard(title: "ปี", element: result.yearElement)
                        pillarCard(title: "เดือน", element: result.monthElement)
                        pillarCard(title: "วัน", element: result.dayElement)
                        if let hourEl = result.hourElement {
                            pillarCard(title: "ยาม", element: hourEl)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 1.0, green: 0.95, blue: 0.90))
                )

                // สัดส่วนธาตุ
                VStack(spacing: 12) {
                    Text("สัดส่วนธาตุ")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(result.counts, id: \.element) { item in
                        HStack {
                            Text(item.element.emoji)
                            Text(item.element.name)
                                .frame(width: 40, alignment: .leading)

                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(elementColor(item.element))
                                    .frame(width: geo.size.width * CGFloat(item.count) / CGFloat(result.hasFourPillars ? 4 : 3))
                            }
                            .frame(height: 20)

                            Text("\(item.count)")
                                .font(.caption.bold())
                                .frame(width: 20)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.appLavenderLight)
                )

                // คำอธิบาย
                VStack(alignment: .leading, spacing: 8) {
                    Text("ลักษณะเด่นของคุณ")
                        .font(.headline)

                    Text(result.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.background)
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                )
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.96, blue: 0.92),
                    Color(red: 0.98, green: 0.94, blue: 0.96),
                    Color(red: 0.96, green: 0.94, blue: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("รหัสธาตุประจำตัว")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func pillarCard(title: String, element: AnalysisEngine.ChineseElement) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(element.emoji)
                .font(.system(size: 32))
            Text(element.name)
                .font(.subheadline.bold())
                .foregroundStyle(elementColor(element))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.8))
        )
    }

    private func elementColor(_ element: AnalysisEngine.ChineseElement) -> Color {
        switch element {
        case .water: .blue
        case .earth: .brown
        case .wood: .green
        case .fire: .red
        case .metal: .orange
        }
    }
}

#Preview {
    NavigationStack {
        BaziResultView(result: BaziResult(
            birthDate: Date(),
            birthTime: nil,
            dayElement: .fire,
            monthElement: .wood,
            yearElement: .water,
            hourElement: nil,
            dominantElement: .fire,
            counts: [
                (element: .fire, count: 2),
                (element: .water, count: 1),
                (element: .wood, count: 1),
                (element: .earth, count: 0),
                (element: .metal, count: 0)
            ],
            description: "คุณเป็นคนธาตุไฟ — กระตือรือร้น มีเสน่ห์",
            hasFourPillars: false
        ))
    }
}
