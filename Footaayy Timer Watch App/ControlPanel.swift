//
//  ControlPanel.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 07/02/2024.
//

import SwiftUI

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
                Text("Footaayy Time")
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
                    appSettings.keeperRunning = false
                    
                }) {
                    Image(systemName: "gobackward")
                }
                .disabled(resetDisabledCondition)
                .foregroundColor(resetDisabledCondition ? .gray : .white)
                .font(.title2)
                
            }
            
            HStack{
                
                let settingsDisabledCondition = mainStopwatch.isRunning
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
                    
                    
                    SettingsPage(mainStopwatch: mainStopwatch, homeScores: $homeScores,awayScores: $awayScores, appSettings: $appSettings).navigationTitle("Settings").frame(maxWidth: .infinity, maxHeight: .infinity).background(.black)}
                                 
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
