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
        Button(action: state.startTracking) {
            Text("Start")
        }
        Button(action: { self.showSettings = true }) {
            Text("Edit")
        }.sheet(isPresented: $showSettings) {
            SettingsView(upperLimit: 0, lowerLimit: 0)
                .environmentObject(AppState())
                .navigationBarTitle("")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(upperLimit: 0, lowerLimit: 0)
            .environmentObject(AppState())
    }
}
