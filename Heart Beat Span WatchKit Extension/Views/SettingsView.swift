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
    @State var isSoundEnabled: Bool
    @State var isVibrationEnabled: Bool
    @State var upperLimit: Int
    @State var lowerLimit: Int
    
    private func handleCancel() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func handleSave() {
        state.saveSettings(upperLimit, lowerLimit)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isSaveDisabled() -> Bool {
        $upperLimit.wrappedValue == $lowerLimit.wrappedValue
    }
    
    var body: some View {
        ScrollView {
            VStack {
                LimitLabel(value: $upperLimit, type: LimitType.Up)
                LimitLabel(value: $lowerLimit, type: LimitType.Down)
                Spacer(minLength: 14)
                ActionButton(title: "Save", color: Color.blue, onClick: handleSave)
                    .disabled(isSaveDisabled())
                    .opacity(isSaveDisabled() ? 0.6 : 1)
                ActionButton(title: "Cancel", color: Color.red, onClick: handleCancel)
            }
            }.navigationBarTitle("")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            isSoundEnabled: false,
            isVibrationEnabled: false,
            upperLimit: 0,
            lowerLimit: 0
        
        ).environmentObject(AppState())
    }
}
