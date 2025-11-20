import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var selectedTheme: AppTheme {
        didSet {
            ThemeService.shared.currentTheme = selectedTheme
        }
    }
    
    init() {
        self.selectedTheme = ThemeService.shared.currentTheme
    }
}

