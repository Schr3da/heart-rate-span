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
    @State var upperLimit: Int
    @State var lowerLimit: Int
    
    private func handleCancel() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func handleSave() {
        self.state.saveData(self.upperLimit, self.lowerLimit)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                LimitLabel(value: self.$upperLimit, type: LimitType.Up)
                LimitLabel(value: self.$lowerLimit, type: LimitType.Down)
                Spacer(minLength: 14)
                ActionButton(title: "Save", color: Color.blue, onClick: self.handleSave)
                ActionButton(title: "Cancel", color: Color.red, onClick: self.handleCancel)
            }
        }.navigationBarTitle("")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(upperLimit: 0, lowerLimit: 0)
            .environmentObject(AppState())
    }
}
