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
                uiState: state.uiState,
                upperLimit: state.upperLimit,
                lowerLimit: state.lowerLimit,
                heartrate: state.heartRate
            )
            Divider()
            ActionButton(
                title: isStopped(uiState: state.uiState) ? "Track" : "Stop",
                color: isStopped(uiState: state.uiState) ? Color.yellow : Color.red ,
                onClick: toggleTrack
            ).sheet(isPresented: $state.showPrepare) {
                PrepareView()
                .environmentObject(self.state)
            }
            ActionButton(title: "Settings", color: Color.white, onClick: state.toggleSettings)
            .sheet(isPresented: $state.showSettings) {
                SettingsView(
                    upperLimit: self.state.upperLimit,
                    lowerLimit:  self.state.lowerLimit
                ).environmentObject(self.state)
            }.opacity(isStopped(uiState: state.uiState) ? 1 : 0.6)
            .disabled(isRunning(uiState: state.uiState))
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
