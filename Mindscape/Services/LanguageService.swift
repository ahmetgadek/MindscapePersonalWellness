import Foundation
import SwiftUI
import Combine
import ObjectiveC

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

enum AppLanguage: String, CaseIterable {
    case arabic = "ar"
    case catalan = "ca"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case dutch = "nl"
    case english = "en"
    case englishAustralia = "en-AU"
    case englishCanada = "en-CA"
    case englishUK = "en-GB"
    case finnish = "fi"
    case french = "fr"
    case frenchCanada = "fr-CA"
    case german = "de"
    case greek = "el"
    case hebrew = "he"
    case hindi = "hi"
    case hungarian = "hu"
    case indonesian = "id"
    case italian = "it"
    case japanese = "ja"
    case korean = "ko"
    case malay = "ms"
    case norwegian = "no"
    case polish = "pl"
    case portugueseBrazil = "pt-BR"
    case portuguesePortugal = "pt-PT"
    case romanian = "ro"
    case russian = "ru"
    case slovak = "sk"
    case spanish = "es"
    case spanishMexico = "es-MX"
    case swedish = "sv"
    case thai = "th"
    case turkish = "tr"
    case ukrainian = "uk"
    case vietnamese = "vi"
    
    var displayName: String {
        switch self {
        case .arabic:
            return "العربية"
        case .catalan:
            return "Català"
        case .chineseSimplified:
            return "简体中文"
        case .chineseTraditional:
            return "繁體中文"
        case .croatian:
            return "Hrvatski"
        case .czech:
            return "Čeština"
        case .danish:
            return "Dansk"
        case .dutch:
            return "Nederlands"
        case .english:
            return "English (U.S.)"
        case .englishAustralia:
            return "English (Australia)"
        case .englishCanada:
            return "English (Canada)"
        case .englishUK:
            return "English (U.K.)"
        case .finnish:
            return "Suomi"
        case .french:
            return "Français"
        case .frenchCanada:
            return "Français (Canada)"
        case .german:
            return "Deutsch"
        case .greek:
            return "Ελληνικά"
        case .hebrew:
            return "עברית"
        case .hindi:
            return "हिन्दी"
        case .hungarian:
            return "Magyar"
        case .indonesian:
            return "Bahasa Indonesia"
        case .italian:
            return "Italiano"
        case .japanese:
            return "日本語"
        case .korean:
            return "한국어"
        case .malay:
            return "Bahasa Melayu"
        case .norwegian:
            return "Norsk"
        case .polish:
            return "Polski"
        case .portugueseBrazil:
            return "Português (Brasil)"
        case .portuguesePortugal:
            return "Português (Portugal)"
        case .romanian:
            return "Română"
        case .russian:
            return "Русский"
        case .slovak:
            return "Slovenčina"
        case .spanish:
            return "Español (España)"
        case .spanishMexico:
            return "Español (México)"
        case .swedish:
            return "Svenska"
        case .thai:
            return "ไทย"
        case .turkish:
            return "Türkçe"
        case .ukrainian:
            return "Українська"
        case .vietnamese:
            return "Tiếng Việt"
        }
    }
    
    var locale: Locale {
        return Locale(identifier: rawValue)
    }
}

class LanguageService: ObservableObject {
    static let shared = LanguageService()
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "app_language")
            Bundle.setLanguage(currentLanguage.rawValue)
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "app_language"),
           let language = AppLanguage(rawValue: savedLanguage) {
            self.currentLanguage = language
            Bundle.setLanguage(currentLanguage.rawValue)
        } else {
            let systemLanguage = Locale.preferredLanguages.first ?? "en"
            
            if let language = AppLanguage(rawValue: systemLanguage) {
                self.currentLanguage = language
            } else {
                let languageCode = systemLanguage.components(separatedBy: "-").first ?? "en"
                if let language = AppLanguage(rawValue: languageCode) {
                    self.currentLanguage = language
                } else {
                    self.currentLanguage = .english
                }
            }
            Bundle.setLanguage(currentLanguage.rawValue)
        }
    }
    
    func getSystemLanguage() -> AppLanguage? {
        let systemLanguage = Locale.preferredLanguages.first ?? "en"
        
        if let language = AppLanguage(rawValue: systemLanguage) {
            return language
        }
        
        let languageCode = systemLanguage.components(separatedBy: "-").first ?? "en"
        return AppLanguage(rawValue: languageCode)
    }
}

extension Bundle {
    private static var bundleKey: UInt8 = 0
    
    static func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    var localizedPath: String? {
        return objc_getAssociatedObject(self, &Bundle.bundleKey) as? String
    }
}

class AnyLanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = self.localizedPath,
              let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

