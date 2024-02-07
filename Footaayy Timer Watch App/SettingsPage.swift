//
//  SettingsPage.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 01/02/2024.
//

import SwiftUI

struct SettingsPage: View {
    
    @ObservedObject var mainStopwatch: Stopwatch
    @Binding var homeScores: keepScore
    @Binding var awayScores: keepScore
    @Binding var appSettings: globalSettings
    @State var helpPresented: Bool = false
   
    
    
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
    
    let videoDelayChoices: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    
    let keeperChangeChoices: [Double] =
    [0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0,10.5,11.0,11.5,12.0,12.5,13.0,13.5,14.0,14.5,15.0]
    
    let boolChoices: [Bool:String] = [
        true:"On",
        false:"Off"]
    
    var body: some View {
        
        let settingsDisabledCondition = (mainStopwatch.elapsedTime == 0)
        
        
        NavigationView{
            List{
                
                NavigationLink{
                    TextField("Home Team", text:$appSettings.homeName)
                    SaveSettingsButton(appSettings: $appSettings)
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
                    SaveSettingsButton(appSettings: $appSettings)
                } label: {
                    SettingItems(settingItem: "Home Colours", settingValue: colorChoices[appSettings.homeColour]! + "/" + colorChoices[appSettings.homeColourText]!)}
                
                
                
                NavigationLink{
                    TextField("Away Team", text:$appSettings.awayName)
                    SaveSettingsButton(appSettings: $appSettings)
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
                    SaveSettingsButton(appSettings: $appSettings)
                } label: {
                    SettingItems(settingItem: "Away Colours", settingValue: colorChoices[appSettings.awayColour]! + "/" + colorChoices[appSettings.awayColourText]!)}
                
                
                NavigationLink{
                    TextField("Location", text:$appSettings.matchLocation)
                    SaveSettingsButton(appSettings: $appSettings)
                } label: {
                    SettingItems(settingItem: "Location", settingValue: appSettings.matchLocation)
                }
                
                if settingsDisabledCondition{
                    
                    NavigationLink{
                        Picker("Video Time Delay", selection: $appSettings.timeDelay) {
                            ForEach(videoDelayChoices, id: \.self) { videotime in
                                Text("\(videotime) Seconds").tag(videotime)
                            }
                        }
                        SaveSettingsButton(appSettings: $appSettings)
                    } label: {
                        SettingItems(settingItem: "Video Time Delay", settingValue: appSettings.timeDelay)}
                    
                    
                }
                
                
                NavigationLink{
                    Picker("Keeper Change Clock", selection: $appSettings.includeKeeperChange) {
                        ForEach(boolChoices.sorted(by: { $0.value < $1.value }), id: \.key) { key, value in
                            Text(value).tag(key)
                        }
                    }
                    SaveSettingsButton(appSettings: $appSettings)
                } label: {
                    SettingItems(settingItem: "Keeper Change Clock", settingValue: boolChoices[appSettings.includeKeeperChange]!)}
                
                //ideally this would be a toggle, need to find better way to update the appsettings
                //SettingItems(settingItem: "Keeper Change Clock", settingValue: $appSettings.includeKeeperChange)
                
                if appSettings.includeKeeperChange {
                    
                    NavigationLink{
                        Picker("Keeper Change Time", selection: $appSettings.keeperChangeTime) {
                            ForEach(keeperChangeChoices, id: \.self) { keepertime in
                                HStack{Text(String(format: "%.1f", keepertime))
                                    Text("Minutes")}.tag(keepertime)
                            }
                        }
                        Button(action: {
                            appSettings.randomToggle.toggle()
                            appSettings.keeperRunning = false
                        }, label: {
                            Text("Save")
                        })
                        
                    } label: {
                        SettingItems(settingItem: "Keeper Change Time", settingValue: appSettings.keeperChangeTime)}
                    
                    
                    
                    //again, stepper would be better but hard to make work
                    //                    NavigationLink{
                    //                        Stepper(String(format: "%.1f", appSettings.keeperChangeTime), value: $appSettings.keeperChangeTime, in: 0.5...25, step: 0.5)
                    //                            .font(.title3)
                    //                    } label: {
                    //                        SettingItems(settingItem: "Keeper Change (Minutes)", settingValue: String(appSettings.keeperChangeTime))
                    //                    }
                }
                
                NavigationLink{
                    Picker("Enable Third Button", selection: $appSettings.thirdButtonToggle) {
                        ForEach(boolChoices.sorted(by: { $0.value < $1.value }), id: \.key) { key, value in
                            Text(value).tag(key)
                        }
                    }
                    SaveSettingsButton(appSettings: $appSettings)
                } label: {
                    SettingItems(settingItem: "Enable Third Button", settingValue: boolChoices[appSettings.thirdButtonToggle]!)}
                
                //SettingItems(settingItem: "Enable Third Button", settingValue: $appSettings.thirdButtonToggle)
                
                
                if appSettings.thirdButtonToggle {
                    
                    NavigationLink{
                        TextField("Third Button Text", text:$appSettings.thirdButtonText)
                        SaveSettingsButton(appSettings: $appSettings)
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
                        SaveSettingsButton(appSettings: $appSettings)
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
                        SaveSettingsButton(appSettings: $appSettings)
                    } label: {
                        SettingItems(settingItem: "Third Button Icon", settingValue: appSettings.thirdButtonIcon)}

                }
                
                
                if settingsDisabledCondition{
                    Button(action: {
                        appSettings.homeName = "Home"
                        appSettings.awayName = "Away"
                        appSettings.homeColour = "05005B"
                        appSettings.awayColour  = "018749"
                        appSettings.timeDelay = 15
                        appSettings.matchLocation = "Anfield"
                        appSettings.homeColourText = "FFFFFF"
                        appSettings.awayColourText = "FFFFFF"
                        appSettings.includeKeeperChange = true
                        appSettings.keeperChangeTime = 5.0
                        appSettings.thirdButtonToggle = true
                        appSettings.thirdButtonText = "Tekkers"
                        appSettings.thirdButtonIcon = "thermometer.high"
                        appSettings.thirdButtonColour = "FFA500"
                        appSettings.alertKeeperDone = false
                        appSettings.keeperRemainingTime = -1
                        appSettings.keeperRunning = false
                        
                        appSettings.randomToggle.toggle()
                        
                    }, label: {
                        Text("Reset Settings")
                    })
                }
                
                Button(action: {
                    helpPresented.toggle()
                    
                }, label: {
                    Text("Help")
                }).fullScreenCover(isPresented: $helpPresented, content:{
                    
                    ScrollView {
                        VStack{
                            Text("Footaayy").font(.headline)
                            Text("Thanks for downloading the app. This was designed for a specific purpose, so I would like to explain some features and future plans").font(.body)
                            Spacer()
                            Text("Main Features").font(.headline)
                            Text("The app is to keep the score at your local 5-a-side game. You can customise the colours and names of each team and hit the goal button when each team scores. This will record the goal time and keep track of the score. There is the option to add a third button if you want to keep track of something else within the game such as hitting the post or a memorable moment. There is also an option to add in a secondary countdown timer to indicate when it is time to change the goalkeepers.").font(.body)
                            Spacer()
                            Text("Control Panel").font(.headline)
                            Text("Scroll to the left screen to access the control panel. Here you can start and stop the game, and reset the time when the game is paused. You can also access the settings from here when the game is paused. Some additional settings are available only when the game is been reset. Finally, there is a list view, to see all goals and events in the game, in chronological order.").font(.body)
                            Spacer()
                            Text("Video Delay").font(.headline)
                            Text("The video time delay is designed to help when uploading goal times to YouTube. It adds a delay to the listed goal times so that the time of the build up to a goal can be captured. If you simply want to record the goal times, just make this delay 0").font(.body)
                            Spacer()
                            Text("Goal Times").font(.headline)
                            Text("When goals have been scored, you can scroll to the right screen and see a breakdown of the goals and the times they were scored for each team. You are able to swipe these to delete them if they were recorded by accident. Note that if a delay is set, the recorded time will be 00:00:00 if it occurs before the delay period.").font(.body)
                            Spacer()
                            
                                
                        }
                    }.padding()
                    
                }
                )
            
                
                
            }.id(UUID())
            
            
        }
        
    }
    
    
    //#Preview {
    //    SettingsPage()
    //}
}
