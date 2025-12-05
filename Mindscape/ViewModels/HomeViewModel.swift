import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var todayDescription: String = ""
    @Published var isGenerating = false
    @Published var generatedLandscape: String?
    
    func generateLandscape() {
        guard !todayDescription.isEmpty else { return }
        
        isGenerating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.generatedLandscape = self.createLandscapeDescription(from: self.todayDescription)
            self.isGenerating = false
        }
    }
    
    private func createLandscapeDescription(from description: String) -> String {
        let lowercased = description.lowercased()
        
        if lowercased.contains("good") || lowercased.contains("great") || lowercased.contains("excellent") || 
           lowercased.contains("wonderful") || lowercased.contains("amazing") || lowercased.contains("fantastic") ||
           lowercased.contains("awesome") || lowercased.contains("perfect") || lowercased.contains("brilliant") ||
           lowercased.contains("хорош") || lowercased.contains("отличн") || lowercased.contains("замечательн") ||
           lowercased.contains("прекрасн") || lowercased.contains("великолепн") {
            return NSLocalizedString("landscape_good", comment: "")
        }
        
        if lowercased.contains("bad") || lowercased.contains("terrible") || lowercased.contains("awful") ||
           lowercased.contains("horrible") || lowercased.contains("worst") || lowercased.contains("dreadful") ||
           lowercased.contains("плох") || lowercased.contains("ужасн") || lowercased.contains("отвратительн") {
            return NSLocalizedString("landscape_bad", comment: "")
        }
        
        if lowercased.contains("cool") || lowercased.contains("nice") || lowercased.contains("fine") ||
           lowercased.contains("okay") || lowercased.contains("alright") || lowercased.contains("decent") ||
           lowercased.contains("нормальн") || lowercased.contains("неплох") || lowercased.contains("приемлем") {
            return NSLocalizedString("landscape_cool", comment: "")
        }
        
        if lowercased.contains("happy") || lowercased.contains("joy") || lowercased.contains("glad") ||
           lowercased.contains("cheerful") || lowercased.contains("delighted") || lowercased.contains("pleased") ||
           lowercased.contains("счастлив") || lowercased.contains("радост") || lowercased.contains("доволен") {
            return NSLocalizedString("landscape_happy", comment: "")
        }
        
        if lowercased.contains("sad") || lowercased.contains("down") || lowercased.contains("melancholy") ||
           lowercased.contains("depressed") || lowercased.contains("unhappy") || lowercased.contains("gloomy") ||
           lowercased.contains("грустн") || lowercased.contains("печал") || lowercased.contains("тоск") {
            return NSLocalizedString("landscape_sad", comment: "")
        }
        
        if lowercased.contains("anxious") || lowercased.contains("worried") || lowercased.contains("troubled") ||
           lowercased.contains("nervous") || lowercased.contains("stressed") || lowercased.contains("tense") ||
           lowercased.contains("тревож") || lowercased.contains("беспоко") || lowercased.contains("нервн") {
            if lowercased.contains("calm") || lowercased.contains("peace") || lowercased.contains("evening") ||
               lowercased.contains("relaxed") || lowercased.contains("settled") ||
               lowercased.contains("спокойн") || lowercased.contains("мирн") || lowercased.contains("расслаб") {
                return NSLocalizedString("landscape_anxious_calm", comment: "")
            }
            return NSLocalizedString("landscape_anxious_stormy", comment: "")
        }
        
        if lowercased.contains("energetic") || lowercased.contains("ideas") || lowercased.contains("excited") ||
           lowercased.contains("enthusiastic") || lowercased.contains("motivated") || lowercased.contains("inspired") ||
           lowercased.contains("энергичн") || lowercased.contains("восторг") || lowercased.contains("вдохновен") {
            return NSLocalizedString("landscape_energetic", comment: "")
        }
        
        if lowercased.contains("apathetic") || lowercased.contains("nothing") || lowercased.contains("empty") ||
           lowercased.contains("numb") || lowercased.contains("indifferent") || lowercased.contains("lifeless") ||
           lowercased.contains("апатичн") || lowercased.contains("пуст") || lowercased.contains("равнодушн") {
            return NSLocalizedString("landscape_apathetic", comment: "")
        }
        
        if lowercased.contains("angry") || lowercased.contains("mad") || lowercased.contains("furious") ||
           lowercased.contains("irritated") || lowercased.contains("annoyed") || lowercased.contains("frustrated") ||
           lowercased.contains("зл") || lowercased.contains("раздражен") || lowercased.contains("ярост") {
            return NSLocalizedString("landscape_angry", comment: "")
        }
        
        if lowercased.contains("calm") || lowercased.contains("peaceful") || lowercased.contains("serene") ||
           lowercased.contains("relaxed") || lowercased.contains("tranquil") || lowercased.contains("quiet") ||
           lowercased.contains("спокойн") || lowercased.contains("мирн") || lowercased.contains("тих") {
            return NSLocalizedString("landscape_calm", comment: "")
        }
        
        if lowercased.contains("tired") || lowercased.contains("exhausted") || lowercased.contains("weary") ||
           lowercased.contains("drained") || lowercased.contains("fatigued") ||
           lowercased.contains("устал") || lowercased.contains("изнурен") || lowercased.contains("изможден") {
            return NSLocalizedString("landscape_tired", comment: "")
        }
        
        if lowercased.contains("confused") || lowercased.contains("lost") || lowercased.contains("uncertain") ||
           lowercased.contains("unclear") || lowercased.contains("bewildered") ||
           lowercased.contains("запутан") || lowercased.contains("потерян") || lowercased.contains("неуверен") {
            return NSLocalizedString("landscape_confused", comment: "")
        }
        
        if lowercased.contains("grateful") || lowercased.contains("thankful") || lowercased.contains("appreciative") ||
           lowercased.contains("blessed") || lowercased.contains("благодарен") || lowercased.contains("признателен") {
            return NSLocalizedString("landscape_grateful", comment: "")
        }
        
        if lowercased.contains("lonely") || lowercased.contains("alone") || lowercased.contains("isolated") ||
           lowercased.contains("solitary") || lowercased.contains("одинок") || lowercased.contains("изолирован") {
            return NSLocalizedString("landscape_lonely", comment: "")
        }
        
        if lowercased.contains("hopeful") || lowercased.contains("optimistic") || lowercased.contains("positive") ||
           lowercased.contains("promising") || lowercased.contains("надежд") || lowercased.contains("оптимистичн") {
            return NSLocalizedString("landscape_hopeful", comment: "")
        }
        
        return NSLocalizedString("landscape_default", comment: "")
    }
}

