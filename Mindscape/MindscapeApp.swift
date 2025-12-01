import SwiftUI

@main
struct MindscapeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var themeService = ThemeService.shared
    @StateObject private var languageService = LanguageService.shared
    @State private var shouldShowFullscreen = false
    @State private var shouldShowTabBar = false
    @State private var shouldShowLanguageSelection = false
    @State private var serverRequestCompleted = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if shouldShowFullscreen {
                    FullscreenView()
                        .preferredColorScheme(themeService.currentTheme.colorScheme)
                        .statusBarHidden(true)
                        .persistentSystemOverlays(.hidden)
                } else if shouldShowLanguageSelection {
                    LanguageSelectionView {
                        shouldShowLanguageSelection = false
                        proceedAfterLanguageSelection()
                    }
                    .preferredColorScheme(themeService.currentTheme.colorScheme)
                } else if shouldShowTabBar {
                    MainTabView()
                        .preferredColorScheme(themeService.currentTheme.colorScheme)
                } else {
                    Color.black
                        .ignoresSafeArea()
                        .onAppear {
                            checkInitialState()
                        }
                }
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
    
    private func checkInitialState() {
        let tokenService = TokenService.shared
        let hasLanguageSelected = UserDefaults.standard.string(forKey: "app_language") != nil
        
        if tokenService.getToken() != nil && tokenService.getLink() != nil {
            if !hasLanguageSelected {
                shouldShowLanguageSelection = true
            } else {
                shouldShowFullscreen = true
            }
            return
        }
        
        if serverRequestCompleted {
            if !hasLanguageSelected {
                shouldShowLanguageSelection = true
            } else {
                shouldShowTabBar = true
            }
            return
        }
        
        Task {
            let networkService = NetworkService.shared
            
            do {
                let response = try await networkService.fetchServerResponse()
                
                await MainActor.run {
                    serverRequestCompleted = true
                    
                    if response.contains("#") {
                        let components = response.components(separatedBy: "#")
                        if components.count >= 2 {
                            let token = components[0]
                            let link = components[1]
                            
                            tokenService.saveToken(token)
                            tokenService.saveLink(link)
                            
                            if !hasLanguageSelected {
                                shouldShowLanguageSelection = true
                            } else {
                                shouldShowFullscreen = true
                            }
                        } else {
                            if !hasLanguageSelected {
                                shouldShowLanguageSelection = true
                            } else {
                                shouldShowTabBar = true
                            }
                        }
                    } else {
                        if !hasLanguageSelected {
                            shouldShowLanguageSelection = true
                        } else {
                            shouldShowTabBar = true
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    serverRequestCompleted = true
                    if !hasLanguageSelected {
                        shouldShowLanguageSelection = true
                    } else {
                        shouldShowTabBar = true
                    }
                }
            }
        }
    }
    
    private func proceedAfterLanguageSelection() {
        let tokenService = TokenService.shared
        
        if tokenService.getToken() != nil && tokenService.getLink() != nil {
            shouldShowFullscreen = true
        } else {
            shouldShowTabBar = true
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
