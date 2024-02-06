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
        Color(red: 5/255, green: 0/255, blue: 91/255):"Blue",
        Color(red: 1/255, green: 135/255, blue: 73/255):"Green",
        Color.black:"Black",
        Color.orange:"Orange",
        Color.white:"White",
        Color.yellow:"Yellow",
        Color(red: 202/255, green: 45/255, blue: 37/255):"LFC",
        Color(red: 29/255, green: 91/255, blue: 164/255):"QPR",
        Color(red: 168/255, green: 19/255, blue: 62/255):"Barca",
        Color(red: 0/255, green: 77/255, blue: 152/255):"Barca",
        Color(red: 122/255, green: 38/255, blue: 58/255):"WHU",
        Color(red: 27/255, green: 177/255, blue: 231/255):"Blue"
    ]
    
    
    let iconChoices: [String] = [
        
        "thermometer.high",
        "snowflake",
        "tornado",
        "figure.dance",
        "display"
        
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
                    HStack{
                        Picker("Colour 1", selection: $appSettings.homeColour){
                            ForEach(colorChoices.keys.sorted(by: { color1, color2 in
                                let name1 = colorChoices[color1] ?? ""
                                let name2 = colorChoices[color2] ?? ""
                                return name1 < name2
                            }), id: \.self) { color in
                                HStack{
                                    Rectangle()
                                        .fill(color)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .cornerRadius(5)
                                        .tag(color)
                                }
                            }}
                        
                        Picker("Colour 2", selection: $appSettings.homeColourText){
                            ForEach(colorChoices.keys.sorted(by: { color1, color2 in
                                let name1 = colorChoices[color1] ?? ""
                                let name2 = colorChoices[color2] ?? ""
                                return name1 < name2
                            }), id: \.self) { color in
                                HStack{
                                    Rectangle()
                                        .fill(color)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .cornerRadius(5)
                                        .tag(color)
                                }
                            }}
                    }
                } label: {
                    SettingItems(settingItem: "Home Colours", settingValue: colorChoices[appSettings.homeColour]! + "/" + colorChoices[appSettings.homeColourText]!)}
                
                
                
                NavigationLink{
                    TextField("Away Team", text:$appSettings.awayName)
                        .onChange(of: appSettings.awayName) { awayScores.teamName = appSettings.awayName}
                } label: {
                    SettingItems(settingItem: "Away Team", settingValue: appSettings.awayName)
                }
                
                NavigationLink{
                    HStack{
                        Picker("Colour 1", selection: $appSettings.awayColour){
                            ForEach(colorChoices.keys.sorted(by: { color1, color2 in
                                let name1 = colorChoices[color1] ?? ""
                                let name2 = colorChoices[color2] ?? ""
                                return name1 < name2
                            }), id: \.self) { color in
                                HStack{
                                    Rectangle()
                                        .fill(color)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .cornerRadius(5)
                                        .tag(color)
                                }
                            }}
                        
                        Picker("Colour 2", selection: $appSettings.awayColourText){
                            ForEach(colorChoices.keys.sorted(by: { color1, color2 in
                                let name1 = colorChoices[color1] ?? ""
                                let name2 = colorChoices[color2] ?? ""
                                return name1 < name2
                            }), id: \.self) { color in
                                HStack{
                                    Rectangle()
                                        .fill(color)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .cornerRadius(5)
                                        .tag(color)
                                }
                            }}
                    }
                    
                } label: {
                    SettingItems(settingItem: "Away Colours", settingValue: colorChoices[appSettings.awayColour]! + "/" + colorChoices[appSettings.awayColourText]!)}
                
                
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
                
                NavigationLink{
                    Stepper(String(format: "%.1f", appSettings.keeperChangeTime), value: $appSettings.keeperChangeTime, in: 1...25, step: 0.5)
                        .font(.title3)
                } label: {
                    SettingItems(settingItem: "Keeper Change (Minutes)", settingValue: String(appSettings.keeperChangeTime))
                }.onChange(of: appSettings.keeperChangeTime) { appSettings.keeperChangeReset = Int(appSettings.keeperChangeTime * 60)}
                
                
                SettingItems(settingItem: "Enable Third Button", settingValue: $appSettings.thirdButtonToggle)
                
                
                if appSettings.thirdButtonToggle {
                    
                    NavigationLink{
                        TextField("Third Button Text", text:$appSettings.thirdButtonText)
                    } label: {
                        SettingItems(settingItem: "Third Button Text", settingValue: appSettings.thirdButtonText)
                    }
                    
                    NavigationLink{
                        Picker("Third Button Colour", selection: $appSettings.thirdButtonColour){
                            ForEach(colorChoices.keys.sorted(by: { color1, color2 in
                                let name1 = colorChoices[color1] ?? ""
                                let name2 = colorChoices[color2] ?? ""
                                return name1 < name2
                            }), id: \.self) { color in
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
                    
                    
                    NavigationLink{
                        Picker("Third Button Icon", selection: $appSettings.thirdButtonIcon){
                            ForEach(iconChoices.sorted(by: { $0.description < $1.description }), id: \.self) { icon in
                                HStack{
                                    Image(systemName:icon)
                                    Text(icon)
                                }
                            }}
                    } label: {
                        SettingItems(settingItem: "Third Button Icon", settingValue: appSettings.thirdButtonIcon)}
                    
                    
                    
                    
                    
                    
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
                    appSettings.thirdButtonIcon = "thermometer.high"
                    appSettings.thirdButtonText = "Tekkers"
                    appSettings.keeperChangeTime = 7.5
                    appSettings.keeperChangeReset = 450
                    
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
