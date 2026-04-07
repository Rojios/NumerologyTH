import SwiftUI

struct PaywallView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.dismiss) private var dismiss

    private let accentBrown = Color(red: 0.85, green: 0.55, blue: 0.40)

    var body: some View {
        ZStack {
            // Background — ภาพแมวพ่อมดเต็มจอ
            GeometryReader { geo in
                Image("PaywallBG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            // Sparkle dots
            sparkleOverlay

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // ปุ่มปิด
                    HStack {
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    .padding(.horizontal)

                    Spacer().frame(height: 300)

                    // Title
                    VStack(spacing: 8) {
                        Text("เปิดความลับรหัสธาตุ")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                        Text("ด้วยศาสตร์จีนดั้งเดิม 5 ธาตุ 4 แกน")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                        Text("แอพพลิเคชั่นเดียวที่ถอดความลับ\nด้วยศาสตร์รหัสธาตุผูกกับเลขศาสตร์")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }

                    // Price card
                    VStack(spacing: 8) {
                        Text("฿99")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.white)
                        Text("จ่ายครั้งเดียว • ใช้ตลอดชีพ • ไม่จำกัดรหัสและหมายเลข")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.12))
                    )
                    .padding(.horizontal)

                    // Features
                    VStack(spacing: 0) {
                        featureRow("flame.fill", "รหัสธาตุประจำตัว + รหัสธาตุมือถือ", "ไม่จำกัด")
                        featureRow("heart.fill", "ความสมพงศ์ธาตุประจำตัวและธาตุหมายเลข", "", badge: "ใหม่")
                        featureRow("cat.fill", "ดวงรายปี + ปีชงนักษัตร", "")
                        featureRow("person.2.fill", "ดูดวงให้เพื่อน/ครอบครัว", "")
                    }
                    .padding(.horizontal)

                    // Tagline
                    Text("แอพพลิเคชั่นเดียว ที่เปิดความลับด้วยศาสตร์จีน\n5 ธาตุ 4 แกน ร่วมกับเลขศาสตร์โบราณ")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Purchase button
                    Button {
                        Task { await purchaseVM.purchase() }
                    } label: {
                        if purchaseVM.isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            HStack {
                                Image(systemName: "sparkles")
                                Text("เปิดรหัสธาตุประจำตัว")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                    .background(accentBrown)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                    .disabled(purchaseVM.isLoading)

                    Text("ไม่มีซ่อนค่าใช้จ่าย — จ่ายครั้งเดียวจบ")
                        .font(.caption)
                        .foregroundStyle(.white)

                    // Restore
                    Button {
                        Task { await purchaseVM.restore() }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down.circle")
                                .font(.title2)
                            Text("กู้คืนการซื้อ")
                                .font(.caption)
                        }
                        .foregroundStyle(.white.opacity(0.5))
                    }

                    if let error = purchaseVM.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onChange(of: purchaseVM.isUnlocked) {
            if purchaseVM.isUnlocked { dismiss() }
        }
    }

    // MARK: - Feature Row

    private func featureRow(_ icon: String, _ title: String, _ subtitle: String, badge: String? = nil) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    if let badge {
                        Text(badge)
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.pink))
                    }
                }
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }

            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.08))
        )
        .padding(.bottom, 8)
    }

    // MARK: - Sparkle dots

    private var sparkleOverlay: some View {
        GeometryReader { geo in
            let dots: [(CGFloat, CGFloat, CGFloat)] = [
                (0.1, 0.15, 4), (0.85, 0.12, 3), (0.5, 0.08, 5),
                (0.15, 0.45, 3), (0.9, 0.40, 4), (0.7, 0.55, 3),
                (0.05, 0.70, 4), (0.95, 0.68, 3), (0.4, 0.75, 5),
                (0.2, 0.88, 3), (0.75, 0.85, 4), (0.55, 0.92, 3),
            ]
            ForEach(Array(dots.enumerated()), id: \.offset) { _, dot in
                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: dot.2, height: dot.2)
                    .position(x: geo.size.width * dot.0, y: geo.size.height * dot.1)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PaywallView()
        .environment(PurchaseViewModel())
}
