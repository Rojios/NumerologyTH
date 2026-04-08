import SwiftUI

struct FeatureTabView: View {
    @Binding var selectedTab: Int

    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab

        // Tab bar styling
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(red: 0.10, green: 0.06, blue: 0.18, alpha: 0.4)

        // Selected
        let selectedColor = UIColor(red: 0.77, green: 0.71, blue: 0.99, alpha: 1) // #c4b5fd
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        // Unselected
        let unselectedColor = UIColor(red: 0.77, green: 0.71, blue: 0.99, alpha: 0.4)
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]

        // ไม่มี separator line
        appearance.shadowColor = .clear

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 0: Home
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("หน้าแรก")
            }
            .tag(0)

            // Tab 1: เบอร์มือถือ
            NavigationStack {
                PhoneInputView()
            }
            .tabItem {
                Image(systemName: "phone.fill")
                Text("เบอร์มือถือ")
            }
            .tag(1)

            // Tab 2: รหัสธาตุ
            NavigationStack {
                BaziInputView()
            }
            .tabItem {
                Image(systemName: "flame.fill")
                Text("รหัสธาตุ")
            }
            .tag(2)

            // Tab 3: เซียมซี
            NavigationStack {
                FortuneMenuView()
            }
            .tabItem {
                Image(systemName: "sparkles")
                Text("เซียมซี")
            }
            .tag(3)
        }
    }
}

#Preview {
    FeatureTabView(selectedTab: .constant(0))
        .environment(NavigationRouter())
        .environment(PurchaseViewModel())
        .modelContainer(for: AnalysisSession.self, inMemory: true)
}
