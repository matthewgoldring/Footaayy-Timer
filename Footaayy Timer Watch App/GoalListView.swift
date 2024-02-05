//
//  GoalListView.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 04/02/2024.
//

import SwiftUI

struct GoalListView: View {
    @Binding var homeScores: keepScore
    @Binding var awayScores: keepScore
    @Binding var thirdButton: keepScore
    @Binding var appSettings: globalSettings
    
    var body: some View {
        VStack {
            Text("Goal Times").font(.system(size: 16))
            
            List {
                if !homeScores.times.isEmpty {
                    Section("\(homeScores.teamName)") {
                        ForEach(Array(homeScores.times.keys.sorted()), id: \.self) { key in
                            if let goalDetails = homeScores.times[key] {
                                HStack {
                                    Text("\(key) - \(goalDetails.0)")
                                    Spacer()
                                }
                            }
                        }
                        .onDelete { indices in
                            deleteGoals(at: indices, for: \.homeScores)
                        }
                    }
                }
                
                if !awayScores.times.isEmpty {
                    Section("\(awayScores.teamName)") {
                        ForEach(Array(awayScores.times.keys.sorted()), id: \.self) { key in
                            if let goalDetails = awayScores.times[key] {
                                HStack {
                                    Text("\(key) - \(goalDetails.0)")
                                    Spacer()
                                }
                            }
                        }
                        .onDelete { indices in
                            deleteGoals(at: indices, for: \.awayScores)
                        }
                    }
                }
                
                
                if !thirdButton.times.isEmpty {
                    Section("\(thirdButton.teamName)") {
                        ForEach(Array(thirdButton.times.keys.sorted()), id: \.self) { key in
                            if let goalDetails = thirdButton.times[key] {
                                HStack {
                                    Text("\(key) - \(goalDetails.0)")
                                    Spacer()
                                }
                            }
                        }
                        .onDelete { indices in
                            deleteGoals(at: indices, for: \.thirdButton)
                        }
                    }
                }
                
                
                
            }
        }
    }
    
    private func deleteGoals(at indices: IndexSet, for teamScoreKeyPath: WritableKeyPath<GoalListView, keepScore>) {
        // Update the appropriate keepScore based on the key path
        switch teamScoreKeyPath {
        case \GoalListView.homeScores:
            homeScores.times = deleteItems(at: indices, from: homeScores.times)
        case \GoalListView.awayScores:
            awayScores.times = deleteItems(at: indices, from: awayScores.times)
        case \GoalListView.thirdButton:
            thirdButton.times = deleteItems(at: indices, from: thirdButton.times)
        default:
            break
        }
    }
    
    private func deleteItems(at indices: IndexSet, from dictionary: [Int: (String, Double)]) -> [Int: (String, Double)] {
        var updatedDictionary = [Int: (String, Double)]()
        
        if let deletedIndex = indices.first {
            print(deletedIndex)
            for (oldKey, value) in dictionary {
                print(oldKey)
                print(value)
                if oldKey > deletedIndex + 1 {
                    // Update keys greater than the deleted goal number
                    let newKey = oldKey - 1
                    updatedDictionary[newKey] = value
                } else if oldKey < deletedIndex + 1 {
                    // Keep keys less than the deleted goal number
                    updatedDictionary[oldKey] = value
                }
                // Skip the deleted goal entry
            }
        }
        return updatedDictionary
    }
    
}
//#Preview {
//    GoalListView()
//}
