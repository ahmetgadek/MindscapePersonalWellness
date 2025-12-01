import Foundation

class TokenService {
    static let shared = TokenService()
    
    private let tokenKey = "mindscape_token"
    private let linkKey = "mindscape_link"
    
    private init() {}
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func saveLink(_ link: String) {
        UserDefaults.standard.set(link, forKey: linkKey)
    }
    
    func getLink() -> String? {
        return UserDefaults.standard.string(forKey: linkKey)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: linkKey)
    }
}

