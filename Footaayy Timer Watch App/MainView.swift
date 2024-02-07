//
//  MainView.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 07/02/2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainStopwatch: Stopwatch
    @Binding var homeScores: keepScore
    @Binding var awayScores: keepScore
    @Binding var thirdButton: keepScore
    @Binding var appSettings: globalSettings
    
    @State var keeperEndTime: Double = -1
    
    var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [ .hour, .minute, .second ] // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale
        formatter.allowsFractionalUnits = true
        return formatter
    }()
    
    func elapsedTimeStr(timeInterval: TimeInterval) -> String {
        return formatter.string(from: timeInterval) ?? ""
    }
    
    func getTimeMinusDelay(elapsedTime: Double) -> String {
        let adjustedTimeWithDelay = elapsedTime - Double(appSettings.timeDelay)
        let formattedTime = elapsedTimeStr(timeInterval: adjustedTimeWithDelay)
        return String(formattedTime)
    }
    
    func goalTimesBeforeOrAfterDelay(elapsedTime: TimeInterval) -> (String, TimeInterval) {
        if Double(elapsedTime) <= Double(appSettings.timeDelay) {
            return ("00:00:00", elapsedTime)
        } else {
            let newTime = getTimeMinusDelay(elapsedTime: elapsedTime)
            return (String(newTime), elapsedTime)
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                
                if appSettings.includeKeeperChange {
                    
                    Button(action: {
                        
                        let currentGameTime = mainStopwatch.elapsedTime
                        
                        keeperEndTime = currentGameTime + (appSettings.keeperChangeTime * 60)
                        
                        appSettings.keeperRunning = true
                    }
                           
                           
                    ){
                        
                        if appSettings.keeperRunning{
                            
                            if appSettings.keeperRemainingTime < 90 {
                                Text("\(appSettings.keeperRemainingTime)")
                                    .font(.system(size: 10))
                            } else {
                                Text("\(Int((Double(appSettings.keeperRemainingTime) / 60)))")
                                .font(.system(size: 18))}
                            
                        } else {
                            Image(systemName: "hand.wave.fill")
                        }
                        
                    }
                    .frame(width: 32,height: 32)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .disabled(!mainStopwatch.isRunning)
                    
                    
                    
                    
                    
                } else {
                    Spacer().frame(width: 32, height: 32)
                    
                }
                
                Text(elapsedTimeStr(timeInterval: mainStopwatch.elapsedTime))
                    .font(.system(size: 18, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                
                if appSettings.thirdButtonToggle {
                    Text("\(thirdButton.times.count)")
                        .font(.system(size: 16))
                        .frame(width: 32,height: 32)
                        .foregroundStyle(Color(hex:appSettings.thirdButtonColour))
                } else {
                    Spacer().frame(width: 32, height: 32)
                }
            }.frame(height: 40)
            
            
                .onChange(of: mainStopwatch.elapsedTime) {
                    appSettings.keeperRemainingTime = Int(round(mainStopwatch.elapsedTime - keeperEndTime)) * -1
                }
                .onChange(of: appSettings.keeperRemainingTime) {if  appSettings.keeperRemainingTime == 0 && appSettings.keeperRunning == true {
                    appSettings.alertKeeperDone = true
                    appSettings.keeperRunning = false
                }
                }
                .alert("Keeper Change", isPresented: $appSettings.alertKeeperDone){Button("OK",role: .cancel){
                    
                }}
                .sensoryFeedback(.warning, trigger: appSettings.alertKeeperDone == true)
            
            
            
            Divider()
            
            HStack {
                Text("\(appSettings.homeName)")
                    .font(.system(size: 15))
                    .frame(width: 44)
                
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
                
                Text("\(appSettings.awayName)")
                    .font(.system(size: 15))
                    .frame(width: 44)
            }
            Divider()
            
            HStack {
                Button(action: {
                    let homeScoreCount = homeScores.times.count + 1
                    
                    homeScores.times[homeScoreCount] = goalTimesBeforeOrAfterDelay(elapsedTime: mainStopwatch.elapsedTime)
                    
                    
                }){
                    Image(systemName: "soccerball.inverse")
                }.foregroundColor(Color(hex:appSettings.homeColourText))
                    .font(.title)
                    .background(Color(hex:appSettings.homeColour))
                    .cornerRadius(100)
                    .disabled(!mainStopwatch.isRunning)
                    .clipShape(Circle())
                
                
                
                if appSettings.thirdButtonToggle {
                    
                    Button(action: {
                        let thirdButtonCount = thirdButton.times.count + 1
                        
                        thirdButton.times[thirdButtonCount] =  goalTimesBeforeOrAfterDelay(elapsedTime: mainStopwatch.elapsedTime)
                    }){
                        Image(systemName: appSettings.thirdButtonIcon)
                    }
                    .foregroundColor(.white)
                    .font(.title)
                    .background(Color(hex:appSettings.thirdButtonColour))
                    .cornerRadius(100)
                    .disabled(!mainStopwatch.isRunning)
                    .clipShape(Circle())
                    
                }
                
                
                
                Button(action: {
                    let awayScoreCount = awayScores.times.count + 1
                    awayScores.times[awayScoreCount] = goalTimesBeforeOrAfterDelay(elapsedTime: mainStopwatch.elapsedTime)
                }){
                    Image(systemName: "soccerball.inverse")
                }.foregroundColor(Color(hex:appSettings.awayColourText))
                    .font(.title)
                    .background(Color(hex:appSettings.awayColour))
                    .cornerRadius(100)
                    .disabled(!mainStopwatch.isRunning)
                    .clipShape(Circle())
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .padding()
        .background(Color(red: 190/255, green: 39/255, blue: 51/255))
    }
}
