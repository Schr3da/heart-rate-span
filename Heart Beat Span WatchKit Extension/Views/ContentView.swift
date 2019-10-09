//
//  ContentView.swift
//  Beat Ranger WatchKit Extension
//
//  Created by schr3da on 06.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var state: AppState
    @State var showSettings: Bool = false
    
    private func toggleSettings() {
        showSettings = true
    }
    
    private func toggleTrack() {
        state.uiState == UIStateEnum.Running ?
        state.stopTracking() :
        state.startTracking()
    }
    
    @ViewBuilder
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            TrackerView(
                upperLimit: $state.upperLimit,
                lowerLimit: $state.lowerLimit,
                heartrate: $state.heartRate
            )
            Divider()
            ActionButton(
                title: state.uiState == UIStateEnum.Running ? "Stop" : "Track",
                color: state.uiState == UIStateEnum.Running ? Color.red : Color.yellow,
                onClick: toggleTrack
            )
            ActionButton(title: "Settings", color: Color.white, onClick: toggleSettings )
            .sheet(isPresented: $showSettings) {
                SettingsView(
                    isSoundEnabled: self.state.isSoundEnabled,
                    isVibrationEnabled: self.state.isVibrationEnabled,
                    upperLimit: self.state.upperLimit,
                    lowerLimit:  self.state.lowerLimit
                ).environmentObject(self.state)
            }.opacity(state.uiState == UIStateEnum.Running ? 0.75 : 1)
            .disabled(state.uiState == UIStateEnum.Running)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            isSoundEnabled: false,
            isVibrationEnabled: false,
            upperLimit: 0,
            lowerLimit: 0
        ).environmentObject(AppState())
    }
}
