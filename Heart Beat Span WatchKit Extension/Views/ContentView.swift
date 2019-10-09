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
    
    @ViewBuilder
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            TrackingView(
                upperLimit: $state.upperLimit,
                lowerLimit: $state.lowerLimit,
                heartrate: $state.heartrate
            )
            Divider()
            Button(action: {
                self.state.uiState == UIStateEnum.Running ?
                    self.state.stopTracking() : self.state.startTracking()
            }) {
                Text(state.uiState == UIStateEnum.Running ? "Stop" : "Track")
                    .foregroundColor(
                        state.uiState == UIStateEnum.Running ?
                        Color.red : Color.yellow
                    )
            }
            Button(action: { self.showSettings = true }) {
                Text("Edit")
            }.sheet(isPresented: $showSettings) {
                SettingsView(
                    upperLimit: self.state.upperLimit,
                    lowerLimit:  self.state.lowerLimit
                ).environmentObject(self.state)
                .navigationBarTitle("")
            }.opacity(state.uiState == UIStateEnum.Running ? 0.75 : 1)
                .disabled(state.uiState == UIStateEnum.Running)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(upperLimit: 0, lowerLimit: 0)
            .environmentObject(AppState())
    }
}
