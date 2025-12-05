import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var selectedTheme: AppTheme {
        didSet {
            ThemeService.shared.currentTheme = selectedTheme
        }
    }
    
    @Published var selectedLanguage: AppLanguage {
        didSet {
            LanguageService.shared.currentLanguage = selectedLanguage
        }
    }
    
    init() {
        self.selectedTheme = ThemeService.shared.currentTheme
        self.selectedLanguage = LanguageService.shared.currentLanguage
    }
}

