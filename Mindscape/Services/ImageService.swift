import UIKit
import SwiftUI

class ImageService {
    static let shared = ImageService()
    
    private let documentsPath: URL
    
    private init() {
        documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveImage(_ image: UIImage, withId id: UUID) -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return false }
        
        let fileURL = documentsPath.appendingPathComponent("\(id.uuidString).jpg")
        
        do {
            try imageData.write(to: fileURL)
            return true
        } catch {
            return false
        }
    }
    
    func loadImage(withId id: UUID) -> UIImage? {
        let fileURL = documentsPath.appendingPathComponent("\(id.uuidString).jpg")
        
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        return UIImage(data: imageData)
    }
    
    func deleteImage(withId id: UUID) {
        let fileURL = documentsPath.appendingPathComponent("\(id.uuidString).jpg")
        try? FileManager.default.removeItem(at: fileURL)
    }
}

