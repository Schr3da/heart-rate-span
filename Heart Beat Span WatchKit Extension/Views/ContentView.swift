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
        showSettings = !showSettings
    }
    
    private func toggleTrack() {
        state.uiState == UIStateEnum.Stopped ?
            state.prepareTracking() :
            state.stopTracking()
    }
    
    @ViewBuilder
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            TrackerView(
                uiState: $state.uiState,
                upperLimit: $state.upperLimit,
                lowerLimit: $state.lowerLimit,
                heartrate: $state.heartRate
            )
            Divider()
            ActionButton(
                title: state.uiState == UIStateEnum.Stopped  ? "Track" : "Stop",
                color: state.uiState == UIStateEnum.Stopped ? Color.yellow : Color.red ,
                onClick: toggleTrack
            )
            ActionButton(title: "Settings", color: Color.white, onClick: toggleSettings )
            .sheet(isPresented: $showSettings) {
                SettingsView(
                    upperLimit: self.state.upperLimit,
                    lowerLimit:  self.state.lowerLimit
                ).environmentObject(self.state)
            }.opacity(state.uiState == UIStateEnum.Stopped ? 1 : 0.6)
            .disabled(state.uiState != UIStateEnum.Stopped)
        }.alert(isPresented: $state.permissionDenied) { () -> Alert in
            Alert.init(
                title: Text("Permission Denied"),
                message: Text("HBS requires read and write access to data to work"),
                dismissButton: Alert.Button.cancel(Text("Ok"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            upperLimit: 0,
            lowerLimit: 0
        ).environmentObject(AppState())
    }
}
