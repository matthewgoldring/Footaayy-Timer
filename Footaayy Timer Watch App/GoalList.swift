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
    @Binding var appSettings: globalSettings
    
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Footaay").font(.system(size:  16))
                Text("\(homeScores.teamName) vs \(awayScores.teamName)").font(.system(size: 12))
                
                (Text("\(appSettings.matchLocation) - ") + Text(Date.now, format: .dateTime.day().month().year())).font(.system(size: 12))
                
                Text("Timer Delay: \(appSettings.timeDelay)")
                
                
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.black)
    }
}

