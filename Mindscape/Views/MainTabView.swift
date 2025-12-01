import SwiftUI

struct MainTabView: View {
    @ObservedObject private var languageService = LanguageService.shared
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(NSLocalizedString("tab_home", comment: ""), systemImage: "house.fill")
                }
            
            GalleryView()
                .tabItem {
                    Label(NSLocalizedString("tab_gallery", comment: ""), systemImage: "photo.on.rectangle.angled")
                }
            
            JournalView()
                .tabItem {
                    Label(NSLocalizedString("tab_journal", comment: ""), systemImage: "book.closed")
                }
            
            InsightsView()
                .tabItem {
                    Label(NSLocalizedString("tab_insights", comment: ""), systemImage: "chart.bar.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label(NSLocalizedString("tab_settings", comment: ""), systemImage: "gearshape.fill")
                }
        }
    }
}

