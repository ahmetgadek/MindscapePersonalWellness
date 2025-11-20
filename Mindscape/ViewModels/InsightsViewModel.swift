import Foundation
import Combine

class InsightsViewModel: ObservableObject {
    @Published var totalEntries: Int = 0
    @Published var thisWeekEntries: Int = 0
    @Published var mostCommonMood: String = "Calm"
    
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
            if text.contains("happy") || text.contains("joy") {
                moods.append("Happy")
            } else if text.contains("sad") || text.contains("down") {
                moods.append("Sad")
            } else if text.contains("anxious") || text.contains("worried") {
                moods.append("Anxious")
            } else if text.contains("energetic") || text.contains("excited") {
                moods.append("Energetic")
            } else if text.contains("calm") || text.contains("peace") {
                moods.append("Calm")
            } else {
                moods.append("Neutral")
            }
        }
        
        return moods
    }
    
    private func findMostCommonMood(_ moods: [String]) -> String {
        guard !moods.isEmpty else { return "Neutral" }
        
        let counts = Dictionary(grouping: moods, by: { $0 })
        return counts.max(by: { $0.value.count < $1.value.count })?.key ?? "Neutral"
    }
}

