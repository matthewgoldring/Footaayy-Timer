//
//  SettingsPage.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 01/02/2024.
//

import SwiftUI

struct SettingsPage: View {
    
    @Binding var homeScores: keepScore
    @Binding var awayScores: keepScore
    @Binding var appSettings: globalSettings
    
    
    let colorChoices: [Color: String] = [
        Color.red:"Red",
        Color.blue:"Blue",
        Color.green:"Green",
        Color.black:"Black",
        Color.orange:"Orange"
        ]
    
    var body: some View {
        NavigationView{
            List{
                NavigationLink{
                        TextField("Home Team", text:$appSettings.homeName).onChange(of: appSettings.homeName) { homeScores.teamName = appSettings.homeName}
                } label: {
                    SettingItems(settingItem: "Home Team", settingValue: appSettings.homeName)
                }
                
                NavigationLink{
                    Picker("Home Colour", selection: $appSettings.homeColour){
                        ForEach(colorChoices.keys.sorted(by: { $0.description < $1.description }), id: \.self) { color in
                            HStack{
                                Rectangle()
                                    .fill(color)
                                    .frame(width: 50, height: 30)
                                    .cornerRadius(5)
                                    .tag(color)
                                Text(colorChoices[color]!)
                            }
                        }}
                } label: {
                    SettingItems(settingItem: "Home Colour", settingValue: colorChoices[appSettings.homeColour]!)}
                
                
                
                NavigationLink{
                        TextField("Away Team", text:$appSettings.awayName)
                    .onChange(of: appSettings.awayName) { awayScores.teamName = appSettings.awayName}
                } label: {
                    SettingItems(settingItem: "Away Team", settingValue: appSettings.awayName)
                }
                
                NavigationLink{
                    Picker("Away Colour", selection: $appSettings.awayColour){
                        ForEach(colorChoices.keys.sorted(by: { $0.description < $1.description }), id: \.self) { color in
                            HStack{
                                Rectangle()
                                    .fill(color)
                                    .frame(width: 50, height: 30)
                                    .cornerRadius(5)
                                    .tag(color)
                                Text(colorChoices[color]!)
                            }
                        }}
                } label: {
                    SettingItems(settingItem: "Away Colour", settingValue: colorChoices[appSettings.awayColour]!)}
                
                
                NavigationLink{
                        TextField("Location", text:$appSettings.matchLocation)
                } label: {
                    SettingItems(settingItem: "Location", settingValue: appSettings.matchLocation)
                }
                
                NavigationLink{
                        Stepper("\(appSettings.timeDelay)", value: $appSettings.timeDelay, in: 0...30)
                            .font(.title3)
                } label: {
                    SettingItems(settingItem: "Timer Delay (Seconds)", settingValue: String(appSettings.timeDelay))
                }
                
                SettingItems(settingItem: "Enable Third Button", settingValue: $appSettings.thirdButtonToggle)
                
                
                if appSettings.thirdButtonToggle {
                    
                    NavigationLink{
                        TextField("Third Button Text", text:$appSettings.thirdButtonText)
                    } label: {
                        SettingItems(settingItem: "Third Button Text", settingValue: appSettings.thirdButtonText)
                    }
                    
                    NavigationLink{
                        Picker("Third Button Colour", selection: $appSettings.thirdButtonColour){
                            ForEach(colorChoices.keys.sorted(by: { $0.description < $1.description }), id: \.self) { color in
                                HStack{
                                    Rectangle()
                                        .fill(color)
                                        .frame(width: 50, height: 30)
                                        .cornerRadius(5)
                                        .tag(color)
                                    Text(colorChoices[color]!)
                                }
                            }}
                    } label: {
                        SettingItems(settingItem: "Third Button Colour", settingValue: colorChoices[appSettings.thirdButtonColour]!)}
                    
                }
                
                Button(action: {
                    homeScores.teamName = "Home"
                    appSettings.homeName = homeScores.teamName
                    awayScores.teamName = "Away"
                    appSettings.awayName = awayScores.teamName
                    appSettings.timeDelay = 15
                    //timeDelay = appSettings.timeDelay
                    appSettings.matchLocation = "Anfield"
                    //locationName = appSettings.matchLocation
                    appSettings.thirdButtonToggle = true
                    appSettings.thirdButtonText = "Tekkers"
                    
                }, label: {
                    Text("Reset Settings")
                })
                
                
            }
            
            
        }
        
        //        VStack {
        //            HStack{
        //                VStack{
        //                    Text("Home Name").font(.system(size: 13))
        //                    TextField("Home Name", text:$homeName).font(.system(size: 13))
        //                }
        //                VStack{
        //                    Text("Away Name").font(.system(size: 13))
        //                    TextField("Away Name", text:$awayName).font(.system(size: 13))
        //                }
        //
        //            }
        //            .onChange(of: homeName) { homeScores.teamName = homeName}
        //            .onChange(of: awayName) { awayScores.teamName = awayName}
        //
        //            HStack{
        //                VStack{
        //                    Text("Location").font(.system(size: 13))
        //                    TextField("Location", text:$locationName).font(.system(size: 13))
        //                }
        //                VStack{
        //                    Text("Time Delay").font(.system(size: 13))
        //                    TextField("Time Delay", value: $timeDelay, formatter: NumberFormatter()).font(.system(size: 13))
        //                }
        //            }
        //            .onChange(of: timeDelay) { appSettings.timeDelay = Int(timeDelay)}
        //
        //            Button(action: {
        //                homeScores.teamName = "Home"
        //                awayScores.teamName = "Away"
        //                appSettings.timeDelay = 15
        //                appSettings.matchLocation = "Anfield"
        //
        //            }, label: {
        //                Text("Reset")
        //            }).controlSize(.mini)
        //                .font(.system(size: 9))
        //        }
        
    }
    
    
    //#Preview {
    //    SettingsPage()
    //}
}
