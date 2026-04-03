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
                    Text("☕")
                        .font(.system(size: 64))
                    Text("เลี้ยงกาแฟ ฿99")
                        .font(.title.bold())
                    Text("ปลดล็อกรายงานเต็ม — จ่ายครั้งเดียว ใช้ตลอดชีพ")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Features comparison
                VStack(alignment: .leading, spacing: 12) {
                    featureRow("คะแนนรวม + เกรด", free: true, paid: true)
                    featureRow("คู่แรก — รายละเอียดเต็ม", free: true, paid: true)
                    featureRow("คู่ที่เหลือ — เกรด + ความหมาย", free: false, paid: true)
                    featureRow("ใช้งานไม่จำกัด", free: false, paid: true)
                    featureRow("ประวัติการวิเคราะห์", free: false, paid: true)
                    featureRow("iCloud sync ข้าม device", free: false, paid: true)
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
                            Text("ปลดล็อก ฿99")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(purchaseVM.isLoading)

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

    private func featureRow(_ title: String, free: Bool, paid: Bool) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            Image(systemName: free ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundStyle(free ? .green : .gray)
                .frame(width: 44)
            Image(systemName: paid ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundStyle(paid ? .green : .gray)
                .frame(width: 44)
        }
    }
}

#Preview {
    PaywallView()
        .environment(PurchaseViewModel())
}
