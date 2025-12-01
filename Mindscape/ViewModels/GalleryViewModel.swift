import Foundation
import Combine
import UIKit

class GalleryViewModel: ObservableObject {
    @Published var landscapes: [JournalEntry] = []
    
    init() {
        loadLandscapes()
    }
    
    func loadLandscapes() {
        if let data = UserDefaults.standard.data(forKey: "saved_landscapes"),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            landscapes = decoded.sorted { $0.date > $1.date }
        }
    }
    
    func saveLandscape(_ entry: JournalEntry) {
        landscapes.insert(entry, at: 0)
        saveToStorage()
    }
    
    func addImageToEntry(_ entry: JournalEntry, image: UIImage) {
        let imageId = UUID()
        
        if ImageService.shared.saveImage(image, withId: imageId) {
            let updatedEntry = JournalEntry(
                id: entry.id,
                date: entry.date,
                description: entry.description,
                landscapeDescription: entry.landscapeDescription,
                imageId: imageId
            )
            
            if let index = landscapes.firstIndex(where: { $0.id == entry.id }) {
                landscapes[index] = updatedEntry
                saveToStorage()
            }
        }
    }
    
    func createEntryWithImage(description: String, landscapeDescription: String?, image: UIImage) {
        let entryId = UUID()
        let imageId = UUID()
        
        if ImageService.shared.saveImage(image, withId: imageId) {
            let entry = JournalEntry(
                id: entryId,
                date: Date(),
                description: description,
                landscapeDescription: landscapeDescription,
                imageId: imageId
            )
            saveLandscape(entry)
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        if let imageId = entry.imageId {
            ImageService.shared.deleteImage(withId: imageId)
        }
        landscapes.removeAll { $0.id == entry.id }
        saveToStorage()
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(landscapes) {
            UserDefaults.standard.set(encoded, forKey: "saved_landscapes")
        }
    }
}

