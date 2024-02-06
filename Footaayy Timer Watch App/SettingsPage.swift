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
    
    
    let colorChoices: [String: String] = [
        "FF0000":"Red",
        "05005B":"Blue",
        "018749":"Green",
        "000000":"Black",
        "FFA500":"Orange",
        "FFFFFF":"White",
        "FFFF00":"Yellow",
        "#CA2D25": "LFC",        // Color(red: 202/255, green: 45/255, blue: 37/255)
        "#1D5BA4": "QPR",        // Color(red: 29/255, green: 91/255, blue: 164/255)
        "#A8133E": "Barca",      // Color(red: 168/255, green: 19/255, blue: 62/255)
        "#004D98": "Barca",      // Color(red: 0/255, green: 77/255, blue: 152/255)
        "#7A263A": "WHU",        // Color(red: 122/255, green: 38/255, blue: 58/255)
        "#1BB1E7": "Blue"
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
                                        .fill(Color(hex:color))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .cornerRadius(5)
                                        .tag(Color(hex:color))
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
                                        .fill(Color(hex:color))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .cornerRadius(5)
                                        .tag(Color(hex:color))
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
                                        .fill(Color(hex:color))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .cornerRadius(5)
                                        .tag(Color(hex:color))
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
                                        .fill(Color(hex:color))
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .cornerRadius(5)
                                        .tag(Color(hex:color))
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
                
                
                SettingItems(settingItem: "Keeper Change Clock", settingValue: $appSettings.includeKeeperChange)
                
                if appSettings.includeKeeperChange {
                    
                    NavigationLink{
                        Stepper(String(format: "%.1f", appSettings.keeperChangeTime), value: $appSettings.keeperChangeTime, in: 0.5...25, step: 0.5)
                            .font(.title3)
                    } label: {
                        SettingItems(settingItem: "Keeper Change (Minutes)", settingValue: String(appSettings.keeperChangeTime))
                    }
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
                            ForEach(colorChoices.keys.sorted(by: { color1, color2 in
                                let name1 = colorChoices[color1] ?? ""
                                let name2 = colorChoices[color2] ?? ""
                                return name1 < name2
                            }), id: \.self) { color in
                                HStack{
                                    Rectangle()
                                        .fill(Color(hex:color))
                                        .frame(width: 50, height: 30)
                                        .cornerRadius(5)
                                        .tag(Color(hex:color))
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
                    appSettings.matchLocation = "Anfield"
                    appSettings.thirdButtonToggle = true
                    appSettings.thirdButtonIcon = "thermometer.high"
                    appSettings.thirdButtonText = "Tekkers"
                    appSettings.includeKeeperChange = true
                    appSettings.keeperChangeTime = 7.5
                    
                }, label: {
                    Text("Reset Settings")
                })
                
                
            }
            
            
        }
        
    }
    
    
    //#Preview {
    //    SettingsPage()
    //}
}
