import SwiftUI

struct AboutView: View {
    @Environment(PurchaseViewModel.self) private var purchaseVM
    @Environment(\.dismiss) private var dismiss

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // BG
                GeometryReader { geo in
                    Image("AboutBG")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Spacer().frame(height: 380)

                        Text("แม่หมอเหมียว")
                            .font(.title.bold())
                            .foregroundStyle(.white)

                        // Menu items
                        VStack(spacing: 0) {
                            // Version
                            HStack(spacing: 14) {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.white)
                                    .frame(width: 24)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("เวอร์ชัน")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.white)
                                    Text("\(appVersion) (\(buildNumber))")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)

                            Divider().padding(.leading, 52)

                            // นักพัฒนา
                            aboutRow(icon: "person.fill", title: "นักพัฒนา", subtitle: "Rojios Studio  © 2026")

                            Divider().padding(.leading, 52)

                            aboutButton(icon: "arrow.clockwise", title: "กู้คืนการซื้อ") {
                                Task { await purchaseVM.restore() }
                            }

                            Divider().padding(.leading, 52)

                            aboutLink(icon: "star.fill", title: "ให้คะแนนแอพ",
                                      url: "https://apps.apple.com/app/id0000000000")

                            Divider().padding(.leading, 52)

                            aboutLink(icon: "envelope.fill", title: "ติดต่อเรา",
                                      url: "mailto:rojios.studio@gmail.com")
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.black.opacity(0.1))
                        )
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("เกี่ยวกับ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("ปิด") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: - Row Components

    private func aboutRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func aboutButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundStyle(.white)
                    .frame(width: 24)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }

    private func aboutLink(icon: String, title: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundStyle(.white)
                    .frame(width: 24)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    AboutView()
        .environment(PurchaseViewModel())
}
