import SwiftUI

struct HomeView: View {
    @State private var navigateToPhone = false
    @State private var navigateToBazi = false

    var body: some View {
        ZStack {
            // Background เดียวกับ PhoneInputView
            GeometryReader { geo in
                Image("HomeBG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            // 2 แถบเลือกด้านล่าง
            VStack {
                Spacer()

                VStack(spacing: 12) {
                    // แถบ 1: ทำนายหมายเลขมือถือ
                    Button {
                        navigateToPhone = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "phone.fill")
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ทำนายหมายเลขมือถือ")
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
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appLavender)
                        )
                    }

                    // แถบ 2: เปิดรหัสธาตุประจำตัว
                    Button {
                        navigateToBazi = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("เปิดรหัสธาตุประจำตัว")
                                    .font(.headline)
                                Text("วิเคราะห์ธาตุห้าจากวันเกิด")
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
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.85, green: 0.55, blue: 0.40))
                        )
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
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToPhone) {
            PhoneInputView()
        }
        .navigationDestination(isPresented: $navigateToBazi) {
            BaziInputView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
