//
//  ContentView.swift
//  Beat Ranger WatchKit Extension
//
//  Created by schr3da on 06.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var state: AppState
    
    @State var upperLimit: Int;
    @State var lowerLimit: Int;
    
    var body: some View {
        ScrollView {
            VStack {
                LimitLabel(value: self.$upperLimit)
                LimitLabel(value: self.$lowerLimit)
                Spacer(minLength: 20)
                Button (action: {
                    self.state.saveData(self.upperLimit, self.lowerLimit)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save").foregroundColor(Color.blue)
                }
                Button (action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel").foregroundColor(Color.white)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(upperLimit: 0, lowerLimit: 0)
            .environmentObject(AppState())
    }
}
