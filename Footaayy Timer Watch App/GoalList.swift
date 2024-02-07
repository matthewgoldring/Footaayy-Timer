//
//  GoalList.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 04/02/2024.
//

import SwiftUI

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

struct GoalList: View {
    
    @Binding var homeScores: keepScore
    @Binding var awayScores: keepScore
    @Binding var thirdButton: keepScore
    @Binding var appSettings: globalSettings
    
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Footaay").font(.system(size:  16))
                Text("\(appSettings.homeName) vs \(appSettings.awayName)").font(.system(size: 12))
                
                (Text("\(appSettings.matchLocation) - ") + Text(Date.now, format: .dateTime.day().month().year())).font(.system(size: 12))
                
                let mergedGoals = mergeAndSortGoals(team1Goals: homeScores.times, team2Goals: awayScores.times)
                
                let thirdButtonData = formatThirdButton(thirdButtonData: thirdButton.times,thirdButtonLabel: appSettings.thirdButtonText)
                
                let goalsWithThirdButton = mergedGoals.merging(thirdButtonData) { (existing, new) in
                    return existing // If keys conflict, use the value from dict1
                }
                
                let sortedGoalsWithThirdButton = goalsWithThirdButton.sorted{$0.key < $1.key}
                
                ForEach(sortedGoalsWithThirdButton, id: \.0) { (_, value) in
                    Text(value)}
                
                
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.black)
    }
}

