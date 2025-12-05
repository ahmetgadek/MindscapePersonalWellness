import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @ObservedObject private var languageService = LanguageService.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("settings_appearance", comment: ""))) {
                    Picker(NSLocalizedString("settings_theme", comment: ""), selection: $viewModel.selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.localizedString).tag(theme)
                        }
                    }
                    
                    Picker(NSLocalizedString("settings_language", comment: ""), selection: $viewModel.selectedLanguage) {
                        ForEach(AppLanguage.allCases, id: \.self) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                }
                
                Section(header: Text(NSLocalizedString("settings_about", comment: ""))) {
                    HStack {
                        Text(NSLocalizedString("settings_version", comment: ""))
                        Spacer()
                        Text(NSLocalizedString("settings_version_number", comment: ""))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(NSLocalizedString("settings_description", comment: ""))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(NSLocalizedString("settings_title", comment: ""))
        }
    }
}

