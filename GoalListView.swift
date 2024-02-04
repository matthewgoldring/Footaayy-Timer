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
                Section("\(homeScores.teamName)") {
                    ForEach(Array(homeScores.times.keys.sorted()), id: \.self) { key in
                        if let goalDetails = homeScores.times[key] {
                            HStack {
                                Text("\(key): \(goalDetails.0)")
                                Spacer()
                            }
                        }
                    }
                    .onDelete { indices in
                        deleteGoals(at: indices, for: \.homeScores)
                    }
                }

                Section("\(awayScores.teamName)") {
                    ForEach(Array(awayScores.times.keys.sorted()), id: \.self) { key in
                        if let goalDetails = awayScores.times[key] {
                            HStack {
                                Text("\(key): \(goalDetails.0)")
                                Spacer()
                            }
                        }
                    }
                    .onDelete { indices in
                        deleteGoals(at: indices, for: \.awayScores)
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
        default:
            break
        }
    }

    private func deleteItems(at indices: IndexSet, from dictionary: [Int: (String, Double)]) -> [Int: (String, Double)] {
        var updatedDictionary = dictionary
        for index in indices {
            let key = Array(updatedDictionary.keys.sorted())[index]
            updatedDictionary.removeValue(forKey: key)
        }
        return updatedDictionary
    }
}


//#Preview {
//    GoalListView()
//}
