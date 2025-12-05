import Foundation
import Combine

class FullscreenViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var destination: String?
    
    private let tokenService = TokenService.shared
    private let networkService = NetworkService.shared
    
    func checkTokenAndLoad() async {
        if tokenService.getToken() != nil,
           let link = tokenService.getLink() {
            await MainActor.run {
                self.destination = link
                // isLoading remains true until page loads
            }
            return
        }
        
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
                        self.destination = link
                        // isLoading remains true until page loads
                    }
                } else {
                    await MainActor.run {
                        self.destination = nil
                        self.isLoading = false
                    }
                }
            } else {
                await MainActor.run {
                    self.destination = nil
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.destination = nil
                self.isLoading = false
            }
        }
    }
    
    func onPageLoaded() {
        isLoading = false
    }
}

