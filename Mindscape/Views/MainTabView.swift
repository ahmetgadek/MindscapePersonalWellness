import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            GalleryView()
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle.angled")
                }
            
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book.closed")
                }
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

