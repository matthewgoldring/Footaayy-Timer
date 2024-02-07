//
//  SaveSettingsButton.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 07/02/2024.
//

import SwiftUI

struct SaveSettingsButton: View {
    @Binding var appSettings: globalSettings
    
    var body: some View {
        Button(action: {
            appSettings.randomToggle.toggle()
        }, label: {
            Text("Save")
        })
    }
}


