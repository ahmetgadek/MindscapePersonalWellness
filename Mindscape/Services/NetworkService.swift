import Foundation
import UIKit
import AppsFlyerLib

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private func getDeviceModel() -> String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine).lowercased()
    }
    
    func fetchServerResponse() async throws -> String {
        let osVersion = UIDevice.current.systemVersion
        let fullLanguage = Locale.preferredLanguages.first ?? "en"
        let language = fullLanguage.components(separatedBy: "-").first ?? "en"
        let deviceModel = getDeviceModel()
        let country = Locale.current.region?.identifier ?? "US"
        let appID = AppsFlyerLib.shared().getAppsFlyerUID()
        
        var components = URLComponents(string: "https://gtappinfo.site/ios-mindscape-personalwellness/server.php")!
        components.queryItems = [
            URLQueryItem(name: "p", value: "Bs2675kDjkb5Ga"),
            URLQueryItem(name: "os", value: osVersion),
            URLQueryItem(name: "lng", value: language),
            URLQueryItem(name: "devicemodel", value: deviceModel),
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "appsflyerid", value: appID)
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let response = String(data: data, encoding: .utf8) else {
            throw NetworkError.invalidResponse
        }
        
        return response
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}

