import SwiftUI

@main
struct MindscapeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var themeService = ThemeService.shared
    @State private var shouldShowFullscreen = false
    @State private var shouldShowTabBar = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if shouldShowFullscreen {
                    FullscreenView()
                        .preferredColorScheme(themeService.currentTheme.colorScheme)
                        .statusBarHidden(true)
                        .persistentSystemOverlays(.hidden)
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
        
        if tokenService.getToken() != nil && tokenService.getLink() != nil {
            shouldShowFullscreen = true
            return
        }
        
        Task {
            let networkService = NetworkService.shared
            
            do {
                let response = try await networkService.fetchServerResponse()
                
                if response.contains("#") {
                    let components = response.components(separatedBy: "#")
                    if components.count >= 2 {
                        let token = components[0]
                        let link = components[1]
                        
                        tokenService.saveToken(token)
                        tokenService.saveLink(link)
                        
                        await MainActor.run {
                            shouldShowFullscreen = true
                        }
                    } else {
                        await MainActor.run {
                            shouldShowTabBar = true
                        }
                    }
                } else {
                    await MainActor.run {
                        shouldShowTabBar = true
                    }
                }
            } catch {
                await MainActor.run {
                    shouldShowTabBar = true
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
