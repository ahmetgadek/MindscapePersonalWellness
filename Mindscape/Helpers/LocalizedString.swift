import Foundation

func NSLocalizedString(_ key: String, comment: String = "") -> String {
    return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
}

func formatDate(_ date: Date) -> String {
    let languageService = LanguageService.shared
    let locale = languageService.currentLanguage.locale
    
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    
    return formatter.string(from: date)
}

