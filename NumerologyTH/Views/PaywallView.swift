import SwiftUI

struct PaywallView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // Hero
                VStack(spacing: 12) {
                    Text("🔮")
                        .font(.system(size: 64))
                    Text("เปิดรหัสธาตุประจำตัว")
                        .font(.title2.bold())

                    if let product = purchaseVM.product {
                        Text("฿\(product.displayPrice) — จ่ายครั้งเดียว ใช้ตลอดชีพ")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("฿99 — จ่ายครั้งเดียว ใช้ตลอดชีพ")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                // Features
                VStack(alignment: .leading, spacing: 14) {
                    featureItem("sparkles", "วิเคราะห์ธาตุ 4 เสาหลัก (ปี/เดือน/วัน/ยาม)")
                    featureItem("arrow.triangle.2.circlepath", "เปลี่ยนวันเกิดได้ไม่จำกัด")
                    featureItem("person.2.fill", "ดูดวงให้เพื่อน/ครอบครัว")
                    featureItem("wand.and.stars", "ความสมพงศ์ธาตุ กับเบอร์มือถือ")
                    featureItem("calendar", "ดวงรายปี + ปีชงนักษัตร")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                )

                Spacer()

                // Purchase button
                VStack(spacing: 12) {
                    Button {
                        Task { await purchaseVM.purchase() }
                    } label: {
                        if purchaseVM.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            HStack {
                                Image(systemName: "lock.open.fill")
                                Text("ปลดล็อก")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                    .background(Color(red: 0.85, green: 0.55, blue: 0.40))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(purchaseVM.isLoading || purchaseVM.product == nil)

                    Button("กู้คืนการซื้อ") {
                        Task { await purchaseVM.restore() }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    if let error = purchaseVM.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Text("เพื่อความบันเทิงเท่านั้น")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("ปิด") { dismiss() }
                }
            }
            .onChange(of: purchaseVM.isUnlocked) {
                if purchaseVM.isUnlocked { dismiss() }
            }
        }
    }

    private func featureItem(_ icon: String, _ title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color(red: 0.85, green: 0.55, blue: 0.40))
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
        }
    }
}

#Preview {
    PaywallView()
        .environment(PurchaseViewModel())
}
