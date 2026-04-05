import SwiftUI

struct LuckyNumberView: View {
    @State private var drawnPair: String?

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("HomeBG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    if let pair = drawnPair {
                        // แสดงเลขที่สุ่มได้
                        VStack(spacing: 12) {
                            Text(pair)
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)

                        }
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )

                    }

                    Button {
                        drawNumber()
                    } label: {
                        HStack {
                            Image(systemName: "number.circle.fill")
                            Text(drawnPair == nil ? "ขอชุดเลข" : "ขอเลขใหม่")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.85, green: 0.55, blue: 0.40))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                .padding()

                Text("โปรแกรมนี้มีวัตถุประสงค์เพื่อความบันเทิง")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 16)
            }
        }
        .navigationTitle("ขอชุดเลข")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func drawNumber() {
        let num = Int.random(in: 11...99)
        drawnPair = String(format: "%02d", num)
    }
}

#Preview {
    NavigationStack {
        LuckyNumberView()
    }
}
