import Foundation
import Combine

class InsightsViewModel: ObservableObject {
    @Published var totalEntries: Int = 0
    @Published var thisWeekEntries: Int = 0
    @Published var mostCommonMood: String = NSLocalizedString("mood_calm", comment: "")
    
    func loadInsights() {
        if let data = UserDefaults.standard.data(forKey: "journal_entries"),
           let entries = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            totalEntries = entries.count
            
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            thisWeekEntries = entries.filter { $0.date >= weekAgo }.count
            
            let moodKeywords = extractMoods(from: entries)
            mostCommonMood = findMostCommonMood(moodKeywords)
        }
    }
    
    private func extractMoods(from entries: [JournalEntry]) -> [String] {
        var moods: [String] = []
        
        for entry in entries {
            let text = entry.description.lowercased()
            if text.contains("happy") || text.contains("joy") || text.contains("счастлив") || text.contains("радост") {
                moods.append("happy")
            } else if text.contains("sad") || text.contains("down") || text.contains("грустн") || text.contains("печал") {
                moods.append("sad")
            } else if text.contains("anxious") || text.contains("worried") || text.contains("тревож") || text.contains("беспоко") {
                moods.append("anxious")
            } else if text.contains("energetic") || text.contains("excited") || text.contains("энергичн") || text.contains("восторг") {
                moods.append("energetic")
            } else if text.contains("calm") || text.contains("peace") || text.contains("спокойн") || text.contains("мирн") {
                moods.append("calm")
            } else {
                moods.append("neutral")
            }
        }
        
        return moods
    }
    
    private func findMostCommonMood(_ moods: [String]) -> String {
        guard !moods.isEmpty else { return NSLocalizedString("mood_neutral", comment: "") }
        
        let counts = Dictionary(grouping: moods, by: { $0 })
        guard let mostCommon = counts.max(by: { $0.value.count < $1.value.count })?.key else {
            return NSLocalizedString("mood_neutral", comment: "")
        }
        
        switch mostCommon {
        case "happy":
            return NSLocalizedString("mood_happy", comment: "")
        case "sad":
            return NSLocalizedString("mood_sad", comment: "")
        case "anxious":
            return NSLocalizedString("mood_anxious", comment: "")
        case "energetic":
            return NSLocalizedString("mood_energetic", comment: "")
        case "calm":
            return NSLocalizedString("mood_calm", comment: "")
        default:
            return NSLocalizedString("mood_neutral", comment: "")
        }
    }
}

