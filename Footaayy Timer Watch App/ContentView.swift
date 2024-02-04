import SwiftUI
import Combine

struct keepScore{
    
    var teamName: String
    
    init(teamName: String) {
            self.teamName = teamName
        }
    
    var score: Int = 0 {
        didSet {
            print("\(self.teamName) have scored \(score)")
                }
    }
    var times = [Int: (String, Double)](){
        didSet {
                    print("Goal Times:  \(times)")
                }
    }
}

struct globalSettings{
    
    var homeName: String = "Home"
    var homeColour: Color = .blue
    var awayName: String = "Away"
    var awayColour: Color = .green
    var timeDelay: Int = 15
    var matchLocation: String = "Anfield"
    //var homeColourText: Color = .white
    //var awayColourText: Color = .white
    //var keeperChangeTime: Int = 8
    //var thirdButtonToggle: true
    //var thirdButtonText: "Tekkers"
    //var thirdButtonIcon: "thermometer.high"
    //var thirdButtonColour: Color = .orange
    
}

enum Pages {
    case controlPanel, mainView, goalListView
}

func watchTimeToReadable(from timeAsString: Float16, timeDelay: Double) -> String {
    let goalTime = Double(round(100 * timeAsString) / 100)
    let goalVideoTime = (goalTime - timeDelay)
    let goalVideoTimeFormatted = elapsedTimeStr(timeInterval: goalVideoTime)
    return String(goalVideoTimeFormatted)
}

func elapsedTimeStr(timeInterval: TimeInterval) -> String {
   return formatter.string(from: timeInterval) ?? ""
}

func formatThirdButton(thirdButtonData: [Int: (String, Double)], thirdButtonLabel: String) -> [Double:String] {
    var thirdButtonFormattedData: [Double:String] = [:]
    for (_, thirdButtonTimes) in thirdButtonData {
        
        let goalTime = thirdButtonTimes.1
        let formattedTime = thirdButtonTimes.0
        
        let completeGoalsString = "\(thirdButtonLabel) - (\(formattedTime))"
        
        thirdButtonFormattedData[goalTime] = completeGoalsString
    }

    return thirdButtonFormattedData

}

func mergeAndSortGoals(team1Goals: [Int: (String, Double)], team2Goals: [Int: (String, Double)]) -> [Double:String] {
    var mergedGoals: [Double:String] = [:]
    for (goalNumber, team1Time) in team1Goals {
        
        let goalTime = team1Time.1
        let formattedTime = team1Time.0
        let team1Score  = goalNumber
        
        let filteredTeam1ScoreTimes = team2Goals.filter { (_, time) in
            
            let (_, time) = time
            return time < goalTime
        }
        
        let team2Score = filteredTeam1ScoreTimes.count
        
        let completeGoalsString = "\(team1Score) - \(team2Score) (\(formattedTime))"
        
        mergedGoals[goalTime] = completeGoalsString
    }
    
    for (goalNumber, team2Time) in team2Goals {
        
        let goalTime = team2Time.1
        let formattedTime = team2Time.0
        let team2Score  = goalNumber
        
        let filteredTeam2ScoreTimes = team1Goals.filter { (_, time) in
            
            let (_, time) = time
            return time < goalTime
        }
        
        let team1Score = filteredTeam2ScoreTimes.count
        
        let completeGoalsString = "\(team1Score) - \(team2Score) (\(formattedTime))"
        
        mergedGoals[goalTime] = completeGoalsString
    }
    
    return mergedGoals
}
    
var formatter: DateComponentsFormatter = {
       let formatter = DateComponentsFormatter()
       formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
       formatter.allowedUnits = [ .hour, .minute, .second ] // Units to display in the formatted string
       formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale
       formatter.allowsFractionalUnits = true
       return formatter
   }()


struct ContentView: View {
    @ObservedObject var mainStopwatch = Stopwatch()
    @State var appSettings = globalSettings()
    @State var homeScores = keepScore(teamName: "Home")
    @State var awayScores = keepScore(teamName: "Away")
    @State var thirdButton = keepScore(teamName: "Tekkers")
    @State private var selectedTab: Pages = .mainView

    
    var body: some View {
        TabView(selection: $selectedTab) {
            //SettingsPage(homeScores: $homeScores)
            ControlPanel(mainStopwatch: mainStopwatch, homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton,appSettings: $appSettings).tag(Pages.controlPanel)
            MainView(mainStopwatch: mainStopwatch, homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton,appSettings: $appSettings).tag(Pages.mainView)
            //GoalListView(homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton, appSettings: $appSettings).tag(Pages.goalListView)
            
            
        }
    }
    
}
    
            
            


struct ControlPanel: View {
    @ObservedObject var mainStopwatch: Stopwatch
    @Binding var homeScores: keepScore
    @Binding var awayScores: keepScore
    @Binding var thirdButton: keepScore
    @Binding var appSettings: globalSettings
    @State  var timelistIsPresented = false
    @State  var settingsIsPresented = false
    
    var playPauseImage: Image {
        return Image(systemName: mainStopwatch.isRunning ? "pause":"figure.soccer")
    }
    var body: some View {
            VStack {
                
                if (mainStopwatch.elapsedTime == 0) {
                    Text("Footaayy Timer")
                } else {
                    Text(mainStopwatch.isRunning ? "Kicked Off":"Paused")
                    
                }
                
                
                
                HStack{
                    
                    Button(action: {
                        mainStopwatch.isRunning.toggle()
                    }) {
                        playPauseImage
                    }.font(.title2)
                    
                    Button(action: {
                        mainStopwatch.reset()
                        homeScores.score = 0
                        homeScores.times = [:]
                        awayScores.score = 0
                        awayScores.times = [:]
                        thirdButton.score = 0
                        thirdButton.times = [:]
                    }) {
                        Image(systemName: "gobackward")
                    }
                    .disabled(mainStopwatch.isRunning)
                    .foregroundColor(mainStopwatch.isRunning ? .gray : .white)
                    .font(.title2)
                    
                }
                
                HStack{
                    
                    Button(action: {
                        settingsIsPresented.toggle()
                    }) {
                        Image(systemName: "gear")
                    }
                    .font(.title2)
                    .foregroundColor(!(mainStopwatch.elapsedTime == 0) ? .gray : .white)
                    .disabled(!(mainStopwatch.elapsedTime == 0))
                    .fullScreenCover(isPresented:  $settingsIsPresented, content:{
                            
                            
                            SettingsPage(homeScores: $homeScores,awayScores: $awayScores, appSettings: $appSettings).navigationTitle("Settings").frame(maxWidth: .infinity, maxHeight: .infinity).background(.black)}
                                         
                        )
                    
                    
                    Button(action: {
                        print(homeScores.teamName)
                        timelistIsPresented.toggle()
                    }) {
                        Image(systemName: "list.clipboard")
                    }.font(.title2)
                        .fullScreenCover(isPresented:  $timelistIsPresented, content:{
                            
                            
                            GoalList(homeScores: $homeScores,awayScores: $awayScores, thirdButton: $thirdButton, appSettings: $appSettings)
                        }
                        )
                }
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }


struct MainView: View {
    @ObservedObject var mainStopwatch: Stopwatch
    @Binding var homeScores: keepScore
    @Binding var awayScores: keepScore
    @Binding var thirdButton: keepScore
    @Binding var appSettings: globalSettings

    var body: some View {
        VStack {
            HStack{
                Text("\(thirdButton.score)").font(.system(size: 15))
                    .frame(alignment: .leading)
                Text(elapsedTimeStr(timeInterval: mainStopwatch.elapsedTime))
                    .font(.system(size: 16, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Text("\(thirdButton.score)").font(.system(size: 15))
                    .frame( alignment: .trailing)
            }
                Divider()
            HStack {
                Text("\(homeScores.teamName)").font(.system(size: 15))
                
                Text(String("\(homeScores.score)"))
                    .fontWeight(.bold)
                    .font(.system(size: 25, design: .monospaced))
                
                Text("-")
                
                Text(String("\(awayScores.score)"))
                    .fontWeight(.bold)
                    .font(.system(size: 25, design: .monospaced))
                
                Text("\(awayScores.teamName)").font(.system(size: 15))
                
            }
            Divider()
            
        HStack {
            Button(action: {
                homeScores.score += 1
                homeScores.times[homeScores.score] = (String(watchTimeToReadable(from: Float16(mainStopwatch.elapsedTime), timeDelay: Double(appSettings.timeDelay))),mainStopwatch.elapsedTime)
                //let currentScore = getscore()
                //newGoal(scoreOrTek: currentScore)
                
                
            }){
                Image(systemName: "soccerball.inverse")
            }.foregroundColor(.white)
                .font(.title)
                .background(appSettings.homeColour)
                .cornerRadius(100)
                .disabled(!mainStopwatch.isRunning)
            
            Button(action: {
                thirdButton.score += 1
                thirdButton.times[thirdButton.score] = (String(watchTimeToReadable(from: Float16(mainStopwatch.elapsedTime), timeDelay: Double(appSettings.timeDelay))),(mainStopwatch.elapsedTime))
                //let currentScore = getscore()
                //newGoal(scoreOrTek: currentScore)
                
                
            }){
                Image(systemName: "thermometer.high")
            }.foregroundColor(.white)
                .font(.title)
                .background(Color.orange)
                .cornerRadius(100)
                .disabled(!mainStopwatch.isRunning)
            
            Button(action: {
                awayScores.score += 1
                awayScores.times[awayScores.score] = (String(watchTimeToReadable(from: Float16(mainStopwatch.elapsedTime), timeDelay: Double(appSettings.timeDelay))),(mainStopwatch.elapsedTime))
                //let currentScore = getscore()
                //newGoal(scoreOrTek: currentScore)
                
                
            }){
                Image(systemName: "soccerball.inverse")
            }.foregroundColor(.white)
                .font(.title)
                .background(appSettings.awayColour)
                .cornerRadius(100)
                .disabled(!mainStopwatch.isRunning)
            
        }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .padding()
        .background(Color(red: 190/255, green: 39/255, blue: 51/255))
    }
}

#Preview {
    ContentView()
       
}
