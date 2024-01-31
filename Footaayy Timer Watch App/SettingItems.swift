//
//  SettingItems.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 03/02/2024.
//

import SwiftUI

struct SettingItems: View {
    
    let settingItem: String
    let settingValue: String
    
    var body: some View {
        
        
        
        HStack{
            Text("\(settingItem)")
                .frame(alignment: .leading)
            Spacer()
            Text("\(settingValue)")
                .frame( alignment: .trailing)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            
        }
        
    }
}

#Preview {
    SettingItems(settingItem: "Home Team", settingValue: "Home")
}
