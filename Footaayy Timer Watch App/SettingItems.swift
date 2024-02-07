//
//  SettingItems.swift
//  Footaayy Timer Watch App
//
//  Created by Matthew on 03/02/2024.
//

import SwiftUI

struct SettingItems: View {
    
    let settingItem: String
    let settingValue: Any
    
    var body: some View {
            HStack {
                Text("\(settingItem)")
                    .frame(alignment: .leading)
                Spacer()
                
                if settingItem.contains("Icon"){
                    let stringValue = settingValue as? String
                    Image(systemName:String(stringValue!))
                        .foregroundColor(.blue)
                } else if let stringValue = settingValue as? String {
                    Text("\(stringValue)")
                        .foregroundColor(.blue)
                } else if let stringValue = settingValue as? Double {
                    Text(String(format: "%.1f", stringValue))
                        .foregroundColor(.blue)
                } else if let stringValue = settingValue as? Int {
                    Text("\(stringValue)")
                        .foregroundColor(.blue)
                } else if settingValue is Binding<Bool> {
                    Toggle("", isOn: settingValue as! Binding<Bool>)
                        .labelsHidden()
                } else {
                    // Handle other types if needed
                    Text("Unsupported Type")
                        .foregroundColor(.red)
                }
            }
        }
    }


#Preview {
    SettingItems(settingItem: "Home Team", settingValue: "Home")
}
