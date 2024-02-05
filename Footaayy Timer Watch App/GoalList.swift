//
//  GoalList.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 04/02/2024.
//

import SwiftUI



struct GoalList: View {
    
    @Binding var homeScores: keepScore
    @Binding var awayScores: keepScore
    @Binding var thirdButton: keepScore
    @Binding var appSettings: globalSettings
    
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Footaay").font(.system(size:  16))
                Text("\(homeScores.teamName) vs \(awayScores.teamName)").font(.system(size: 12))
                
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

