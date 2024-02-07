import SwiftUI

struct keepScore{
    
    var teamName: String
    
    init(teamName: String) {
        self.teamName = teamName
    }
    
    var times = [Int: (String, Double)]()
//    {
//        didSet {
//            print("Goal Times \(self.teamName):  \(times)")
//        }
//    }
}

struct globalSettings {
    @AppStorage("homeName") var homeName: String = "Home"
    @AppStorage("homeColour") var homeColour: String = "05005B"
    @AppStorage("awayName") var awayName: String = "Away"
    @AppStorage("awayColour") var awayColour: String = "018749"
    @AppStorage("timeDelay") var timeDelay: Int = 0
    @AppStorage("matchLocation") var matchLocation: String = "Anfield"
    @AppStorage("homeColourText") var homeColourText: String = "FFFFFF"
    @AppStorage("awayColourText") var awayColourText: String = "FFFFFF"
    @AppStorage("includeKeeperChange") var includeKeeperChange: Bool = false
    @AppStorage("keeperChangeTime") var keeperChangeTime: Double = 5.0
    @AppStorage("thirdButtonToggle") var thirdButtonToggle: Bool = false
    @AppStorage("thirdButtonText") var thirdButtonText: String = "Tekkers"
    @AppStorage("thirdButtonIcon") var thirdButtonIcon: String = "thermometer.high"
    @AppStorage("thirdButtonColour") var thirdButtonColour: String = "FFA500"
    var alertKeeperDone: Bool = false
    var keeperRemainingTime: Int = -1
    var keeperRunning: Bool = false
    var randomToggle: Bool = false
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum Pages {
    case controlPanel, mainView, goalListView
}

struct ContentView: View {
    @ObservedObject var mainStopwatch = Stopwatch()
    @State var appSettings = globalSettings()
    @State var homeScores = keepScore(teamName: "Home")
    @State var awayScores = keepScore(teamName: "Away")
    @State var thirdButton = keepScore(teamName: "Tekkers")
    @State private var selectedTab: Pages = .mainView
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ControlPanel(mainStopwatch: mainStopwatch, homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton,appSettings: $appSettings).tag(Pages.controlPanel)
            MainView(mainStopwatch: mainStopwatch, homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton,appSettings: $appSettings).tag(Pages.mainView)
            if !awayScores.times.isEmpty || !homeScores.times.isEmpty {
                GoalListView(homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton, appSettings: $appSettings).tag(Pages.goalListView)
            }
        }
    }
    
}

#Preview {
    ContentView()
    
}
