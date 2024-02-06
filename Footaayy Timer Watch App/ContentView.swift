import SwiftUI
import Combine

struct keepScore{
    
    var teamName: String
    
    init(teamName: String) {
        self.teamName = teamName
    }
    
    var times = [Int: (String, Double)](){
        didSet {
            print("Goal Times \(self.teamName):  \(times)")
        }
    }
}

struct globalSettings{
    
    var homeName: String = "Home"
    var homeColour: Color = Color(red: 5/255, green: 0/255, blue: 91/255)
    var awayName: String = "Away"
    var awayColour: Color = Color(red: 1/255, green: 135/255, blue: 73/255)
    var timeDelay: Int = 15
    var matchLocation: String = "Anfield"
    var homeColourText: Color = .white
    var awayColourText: Color = .white
    //var includeKeeperChange: Bool = true
    var keeperChangeTime: Double = 7.5
    var keeperChangeReset: Int = 450
    var thirdButtonToggle: Bool = true
    var thirdButtonText: String = "Tekkers"
    var thirdButtonIcon: String = "thermometer.high"
    var thirdButtonColour: Color = .orange
    
}

enum Pages {
    case controlPanel, mainView, goalListView
}

func watchTimeToReadable(from elapsedTime: Double, timeDelay: Double) -> String {
    //let goalTime = Double(round(100 * elapsedTime) / 100)
    let adjustedTimeWithDelay = elapsedTime - timeDelay
    let formattedTime = elapsedTimeStr(timeInterval: adjustedTimeWithDelay)
    return String(formattedTime)
}

func elapsedTimeStr(timeInterval: TimeInterval) -> String {
    return formatter.string(from: timeInterval) ?? ""
}

func formatThirdButton(thirdButtonData: [Int: (String, Double)], thirdButtonLabel: String) -> [Double:String] {
    var thirdButtonFormattedData: [Double:String] = [:]
    for (_, thirdButtonTimes) in thirdButtonData {
        
        let goalTime = thirdButtonTimes.1
        let formattedTime = thirdButtonTimes.0
        let completeGoalsString = "\(thirdButtonLabel) (\(formattedTime))"
        
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
            ControlPanel(mainStopwatch: mainStopwatch, homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton,appSettings: $appSettings).tag(Pages.controlPanel)
            MainView(mainStopwatch: mainStopwatch, homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton,appSettings: $appSettings).tag(Pages.mainView)
            if !awayScores.times.isEmpty || !homeScores.times.isEmpty {
                GoalListView(homeScores: $homeScores, awayScores: $awayScores, thirdButton: $thirdButton, appSettings: $appSettings).tag(Pages.goalListView)
            }
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
                let resetDisabledCondition = mainStopwatch.isRunning || (mainStopwatch.elapsedTime == 0)
                
                
                Button(action: {
                    mainStopwatch.isRunning.toggle()
                }) {
                    playPauseImage
                }.font(.title2)
                
                
                Button(action: {
                    mainStopwatch.reset()
                    homeScores.times = [:]
                    awayScores.times = [:]
                    thirdButton.times = [:]
                    
                }) {
                    Image(systemName: "gobackward")
                }
                .disabled(resetDisabledCondition)
                .foregroundColor(resetDisabledCondition ? .gray : .white)
                .font(.title2)
                
            }
            
            HStack{
                
                let settingsDisabledCondition = !(mainStopwatch.elapsedTime == 0)
                let listDisabledCondition = mainStopwatch.isRunning || (mainStopwatch.elapsedTime == 0)
                
                Button(action: {
                    settingsIsPresented.toggle()
                }) {
                    Image(systemName: "gear")
                }
                .font(.title2)
                .foregroundColor(settingsDisabledCondition ? .gray : .white)
                .disabled(settingsDisabledCondition)
                .fullScreenCover(isPresented:  $settingsIsPresented, content:{
                    
                    
                    SettingsPage(homeScores: $homeScores,awayScores: $awayScores, appSettings: $appSettings).navigationTitle("Settings").frame(maxWidth: .infinity, maxHeight: .infinity).background(.black)}
                                 
                )
                
                
                Button(action: {
                    timelistIsPresented.toggle()
                }) {
                    Image(systemName: "list.clipboard")
                }.font(.title2)
                    .disabled(listDisabledCondition)
                    .foregroundColor(listDisabledCondition ? .gray : .white)
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
    
    @State var keeperEndTime: Double = -1
    
    
    
    var body: some View {
        VStack {
            HStack{
                
                
             
                    Button(action: {
                        
                        let currentGameTime = mainStopwatch.elapsedTime
                        
                        keeperEndTime = currentGameTime + Double(appSettings.keeperChangeReset)
                    }
                    
                    
                    ){
                        let keeperTimeLeft = Int(round(mainStopwatch.elapsedTime - keeperEndTime)) * -1
    
                        
                        if keeperTimeLeft < 0 || keeperTimeLeft > appSettings.keeperChangeReset {
                            
                            Image(systemName: "hand.wave.fill")
                                .resizable()
                                .scaledToFit()
                           
                        }
                        
                        else  {
                                    Text(String(keeperTimeLeft))
                                        .font(.system(size: 10))
                                }
                          
                        }
                    .frame(width: 37,height: 37)
                    .controlSize(.mini)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .disabled(!mainStopwatch.isRunning)
                    
                
                
                Spacer()
                
                Text(elapsedTimeStr(timeInterval: mainStopwatch.elapsedTime))
                    .font(.system(size: 16, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                Text("\(thirdButton.times.count)")
                    .font(.system(size: 15))
                    .frame(width: 37,height: 37)
                
            }.frame(height: 40)
            
            Divider()
            
            HStack {
                Text("\(homeScores.teamName)")
                    .font(.system(size: 15))
                    .frame(width: 44)
                    //.background(appSettings.homeColour)
                    //.foregroundStyle(Color(appSettings.homeColourText))
                
                HStack{
                    Text(String("\(homeScores.times.count)"))
                        .fontWeight(.bold)
                        .font(.system(size: 25, design: .monospaced))
                    
                    Text("-")
                    
                    Text(String("\(awayScores.times.count)"))
                        .fontWeight(.bold)
                        .font(.system(size: 25, design: .monospaced))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Text("\(awayScores.teamName)")
                    .font(.system(size: 15))
                    .frame(width: 44)
            }
            Divider()
            
            HStack {
                Button(action: {
                    let homeScoreCount = homeScores.times.count + 1
                    homeScores.times[homeScoreCount] = (String(watchTimeToReadable(from: Double(mainStopwatch.elapsedTime), timeDelay: Double(appSettings.timeDelay))),mainStopwatch.elapsedTime)
                }){
                    Image(systemName: "soccerball.inverse")
                }.foregroundColor(appSettings.homeColourText)
                    .font(.title)
                    .background(appSettings.homeColour)
                    .cornerRadius(100)
                    .disabled(!mainStopwatch.isRunning)
                    .clipShape(Circle())
                
                
                
                if appSettings.thirdButtonToggle {
                    
                    Button(action: {
                        let thirdButtonCount = thirdButton.times.count + 1
                        thirdButton.times[thirdButtonCount] = (String(watchTimeToReadable(from: Double(mainStopwatch.elapsedTime), timeDelay: Double(appSettings.timeDelay))),(mainStopwatch.elapsedTime))
                    }){
                        Image(systemName: appSettings.thirdButtonIcon)
                    }.foregroundColor(.white)
                        .font(.title)
                        .background(appSettings.thirdButtonColour)
                        .cornerRadius(100)
                        .disabled(!mainStopwatch.isRunning)
                        .clipShape(Circle())
                    
                }
                
                
                
                Button(action: {
                    let awayScoreCount = awayScores.times.count + 1
                    awayScores.times[awayScoreCount] = (String(watchTimeToReadable(from: Double(mainStopwatch.elapsedTime), timeDelay: Double(appSettings.timeDelay))),(mainStopwatch.elapsedTime))
                }){
                    Image(systemName: "soccerball.inverse")
                }.foregroundColor(appSettings.awayColourText)
                    .font(.title)
                    .background(appSettings.awayColour)
                    .cornerRadius(100)
                    .disabled(!mainStopwatch.isRunning)
                    .clipShape(Circle())
                
                

            }
//            HStack{
//                if appSettings.thirdButtonToggle {
//                    Text("\(thirdButton.times.count)").font(.system(size: 15))
//                        .frame( alignment: .trailing)
//                }
//            }.frame(height: 1)
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
