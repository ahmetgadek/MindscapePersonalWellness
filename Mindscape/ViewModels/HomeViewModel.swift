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
           lowercased.contains("awesome") || lowercased.contains("perfect") || lowercased.contains("brilliant") {
            return "Vibrant sunset over a peaceful lake with colorful reflections and gentle ripples"
        }
        
        if lowercased.contains("bad") || lowercased.contains("terrible") || lowercased.contains("awful") ||
           lowercased.contains("horrible") || lowercased.contains("worst") || lowercased.contains("dreadful") {
            return "Dark, overcast sky above a desolate landscape with barren trees and heavy fog"
        }
        
        if lowercased.contains("cool") || lowercased.contains("nice") || lowercased.contains("fine") ||
           lowercased.contains("okay") || lowercased.contains("alright") || lowercased.contains("decent") {
            return "Clear blue sky above a tranquil meadow with a gentle breeze and distant mountains"
        }
        
        if lowercased.contains("happy") || lowercased.contains("joy") || lowercased.contains("glad") ||
           lowercased.contains("cheerful") || lowercased.contains("delighted") || lowercased.contains("pleased") {
            return "Golden sunrise over rolling hills with wildflowers swaying gently in the warm light"
        }
        
        if lowercased.contains("sad") || lowercased.contains("down") || lowercased.contains("melancholy") ||
           lowercased.contains("depressed") || lowercased.contains("unhappy") || lowercased.contains("gloomy") {
            return "Quiet autumn landscape with falling leaves and soft rain, gray clouds overhead"
        }
        
        if lowercased.contains("anxious") || lowercased.contains("worried") || lowercased.contains("troubled") ||
           lowercased.contains("nervous") || lowercased.contains("stressed") || lowercased.contains("tense") {
            if lowercased.contains("calm") || lowercased.contains("peace") || lowercased.contains("evening") ||
               lowercased.contains("relaxed") || lowercased.contains("settled") {
                return "Restless, stormy sea gradually transitioning into a calm bay with the first stars appearing"
            }
            return "Stormy ocean with dark clouds and turbulent waves crashing against rocky shores"
        }
        
        if lowercased.contains("energetic") || lowercased.contains("ideas") || lowercased.contains("excited") ||
           lowercased.contains("enthusiastic") || lowercased.contains("motivated") || lowercased.contains("inspired") {
            return "Bright, sunny day over a blooming meadow with fireflies dancing in the warm afternoon air"
        }
        
        if lowercased.contains("apathetic") || lowercased.contains("nothing") || lowercased.contains("empty") ||
           lowercased.contains("numb") || lowercased.contains("indifferent") || lowercased.contains("lifeless") {
            return "Windless, frozen forest in mist, where time seems to stand still"
        }
        
        if lowercased.contains("angry") || lowercased.contains("mad") || lowercased.contains("furious") ||
           lowercased.contains("irritated") || lowercased.contains("annoyed") || lowercased.contains("frustrated") {
            return "Thunderous sky above jagged mountains with lightning illuminating the dark landscape"
        }
        
        if lowercased.contains("calm") || lowercased.contains("peaceful") || lowercased.contains("serene") ||
           lowercased.contains("relaxed") || lowercased.contains("tranquil") || lowercased.contains("quiet") {
            return "Still, mirror-like lake surrounded by ancient trees, with mist rising gently at dawn"
        }
        
        if lowercased.contains("tired") || lowercased.contains("exhausted") || lowercased.contains("weary") ||
           lowercased.contains("drained") || lowercased.contains("fatigued") {
            return "Dusk settling over a quiet valley, with the last rays of sun fading behind distant hills"
        }
        
        if lowercased.contains("confused") || lowercased.contains("lost") || lowercased.contains("uncertain") ||
           lowercased.contains("unclear") || lowercased.contains("bewildered") {
            return "Misty crossroads in a dense forest, where paths fade into the fog ahead"
        }
        
        if lowercased.contains("grateful") || lowercased.contains("thankful") || lowercased.contains("appreciative") ||
           lowercased.contains("blessed") {
            return "Warm, golden hour light streaming through ancient oak trees in a sacred grove"
        }
        
        if lowercased.contains("lonely") || lowercased.contains("alone") || lowercased.contains("isolated") ||
           lowercased.contains("solitary") {
            return "Vast, empty desert under a starry night sky, with a single distant light on the horizon"
        }
        
        if lowercased.contains("hopeful") || lowercased.contains("optimistic") || lowercased.contains("positive") ||
           lowercased.contains("promising") {
            return "Early morning light breaking through clouds over a field of new spring growth"
        }
        
        return "Serene mountain vista with clouds drifting slowly across the peaks, a balanced landscape of earth and sky"
    }
}

