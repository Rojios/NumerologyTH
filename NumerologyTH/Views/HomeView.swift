import SwiftUI

struct HomeView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var showAbout = false

    /// ใช้ binding จาก parent (ContentView → FeatureTabView) ผ่าน selectedTab
    private func switchTab(_ tab: Int) {
        // ใช้ NotificationCenter ส่ง tab index ไป ContentView
        NotificationCenter.default.post(name: .switchTab, object: tab)
    }

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

                VStack(spacing: 12) {
                    Button {
                        switchTab(1)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "phone.fill")
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("เปิดความลับหมายเลขมือถือ")
                                    .font(.headline)
                                Text("วิเคราะห์คู่เลข คะแนน 1,000")
                                    .font(.caption)
                                    .opacity(0.8)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 1.0, green: 0.78, blue: 0.85),
                                                Color(red: 0.92, green: 0.65, blue: 0.75)
                                            ],
                                            startPoint: .topTrailing,
                                            endPoint: .bottomLeading
                                        )
                                    )
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            }
                        )
                        .shadow(color: Color(red: 1.0, green: 0.70, blue: 0.80).opacity(0.5), radius: 12, x: 0, y: 0)
                        .shadow(color: Color(red: 0.85, green: 0.55, blue: 0.65).opacity(0.3), radius: 6, x: 0, y: 4)
                    }

                    Button {
                        switchTab(2)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "flame.fill")
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("เปิดรหัสพลังธาตุ และพลังปีนักษัตร")
                                    .font(.headline)
                                Text("วิเคราะห์อิทธิพลของรหัสธาตุและผลจากปีชงนักษัตร")
                                    .font(.caption)
                                    .opacity(0.8)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 1.0, green: 0.78, blue: 0.85),
                                                Color(red: 0.92, green: 0.65, blue: 0.75)
                                            ],
                                            startPoint: .topTrailing,
                                            endPoint: .bottomLeading
                                        )
                                    )
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            }
                        )
                        .shadow(color: Color(red: 1.0, green: 0.70, blue: 0.80).opacity(0.5), radius: 12, x: 0, y: 0)
                        .shadow(color: Color(red: 0.85, green: 0.55, blue: 0.65).opacity(0.3), radius: 6, x: 0, y: 4)
                    }

                    Button {
                        switchTab(3)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "wand.and.stars")
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("เซียมซีดูดวงรายวัน")
                                    .font(.headline)
                                Text("เสี่ยงเซียมซี พร้อมคำทำนาย")
                                    .font(.caption)
                                    .opacity(0.8)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 1.0, green: 0.78, blue: 0.85),
                                                Color(red: 0.92, green: 0.65, blue: 0.75)
                                            ],
                                            startPoint: .topTrailing,
                                            endPoint: .bottomLeading
                                        )
                                    )
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            }
                        )
                        .shadow(color: Color(red: 1.0, green: 0.70, blue: 0.80).opacity(0.5), radius: 12, x: 0, y: 0)
                        .shadow(color: Color(red: 0.85, green: 0.55, blue: 0.65).opacity(0.3), radius: 6, x: 0, y: 4)
                    }
                }
                .padding(.horizontal)

                Text("โปรแกรมนี้มีวัตถุประสงค์เพื่อความบันเทิง")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.top, 8)
                    .padding(.bottom, 16)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button { showAbout = true } label: {
                Image(systemName: "info.circle")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(
                        Capsule()
                            .fill(Color(red: 1.0, green: 0.75, blue: 0.82))
                    )
            }
            .padding(.top, 10)
            .padding(.trailing, 16)
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}

// MARK: - Notification for tab switching

extension Notification.Name {
    static let switchTab = Notification.Name("switchTab")
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(NavigationRouter())
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
