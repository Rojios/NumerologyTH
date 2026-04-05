import SwiftUI

struct HomeView: View {
    @State private var navigateToPhone = false

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
                                .fill(Color(red: 0.68, green: 0.82, blue: 0.96))
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
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(PurchaseViewModel())
    .modelContainer(for: AnalysisSession.self, inMemory: true)
}
