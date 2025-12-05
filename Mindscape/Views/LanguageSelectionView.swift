import SwiftUI

struct LanguageSelectionView: View {
    @StateObject private var languageService = LanguageService.shared
    @State private var selectedLanguage: AppLanguage
    @State private var refreshID = UUID()
    
    let onLanguageSelected: () -> Void
    
    init(onLanguageSelected: @escaping () -> Void) {
        self.onLanguageSelected = onLanguageSelected
        
        let systemLanguage = Locale.preferredLanguages.first ?? "en"
        
        if let systemLang = AppLanguage(rawValue: systemLanguage) {
            _selectedLanguage = State(initialValue: systemLang)
        } else {
            let languageCode = systemLanguage.components(separatedBy: "-").first ?? "en"
            if let systemLang = AppLanguage(rawValue: languageCode) {
                _selectedLanguage = State(initialValue: systemLang)
            } else {
                _selectedLanguage = State(initialValue: .english)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Image(systemName: "globe")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text(NSLocalizedString("language_selection_title", comment: ""))
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(NSLocalizedString("language_selection_description", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .id(refreshID)
                .padding(.top, 40)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(AppLanguage.allCases, id: \.self) { language in
                            Button(action: {
                                selectedLanguage = language
                                Bundle.setLanguage(language.rawValue)
                                refreshID = UUID()
                            }) {
                                HStack {
                                    Text(language.displayName)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if selectedLanguage == language {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(
                                    selectedLanguage == language
                                        ? Color.blue.opacity(0.1)
                                        : Color(.systemGray6)
                                )
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                }
                
                Button(action: {
                    languageService.currentLanguage = selectedLanguage
                    onLanguageSelected()
                }) {
                    Text(NSLocalizedString("language_selection_continue", comment: ""))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
                .padding(.bottom, 32)
                .id(refreshID)
            }
        }
    }
}

