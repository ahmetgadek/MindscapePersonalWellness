import Foundation
import Combine

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    init() {
        loadEntries()
    }
    
    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "journal_entries"),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            entries = decoded.sorted { $0.date > $1.date }
        }
    }
    
    func addEntry(_ entry: JournalEntry) {
        entries.insert(entry, at: 0)
        saveToStorage()
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
        saveToStorage()
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "journal_entries")
        }
    }
}

