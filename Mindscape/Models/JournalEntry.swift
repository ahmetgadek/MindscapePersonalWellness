import Foundation

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let description: String
    let landscapeDescription: String?
    let imageId: UUID?
    
    init(id: UUID = UUID(), date: Date = Date(), description: String, landscapeDescription: String? = nil, imageId: UUID? = nil) {
        self.id = id
        self.date = date
        self.description = description
        self.landscapeDescription = landscapeDescription
        self.imageId = imageId
    }
}

