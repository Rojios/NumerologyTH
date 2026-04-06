import SwiftUI

struct HomeView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var navigateToPhone = false
    @State private var navigateToFortune = false
    @State private var navigateToBazi = false

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
                        navigateToPhone = true
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
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 1.0, green: 0.75, blue: 0.82))
                        )
                    }

                    // เปิดรหัสธาตุประจำตัว
                    Button {
                        navigateToBazi = true
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
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 1.0, green: 0.75, blue: 0.82))
                        )
                    }

                    // เซียมซีประจำวัน
                    Button {
                        navigateToFortune = true
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
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 1.0, green: 0.75, blue: 0.82))
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
        .navigationDestination(isPresented: $navigateToFortune) {
            FortuneMenuView()
        }
        .onChange(of: router.popToRoot) {
            if router.popToRoot {
                navigateToPhone = false
                navigateToBazi = false
                navigateToFortune = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(NavigationRouter())
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
