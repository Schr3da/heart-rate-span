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
            HStack {
                Text("♡ 100")
                    .font(Font.system(size: 38))
                    .padding(0)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 50,
                        maxHeight: .infinity,
                        alignment: Alignment.trailing
                    )
                VStack {
                    Text("\(state.upperLimit) ⤒")
                        .frame(
                            minWidth: 0,
                            maxWidth: 50,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: Alignment.trailing
                        )
                    Text("\(state.lowerLimit) ⤓")
                        .frame(
                            minWidth: 0,
                            maxWidth: 50,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: Alignment.trailing
                        )
                }.foregroundColor(Color.gray)
            }
            Divider()
            Button(action: state.startTracking) {
                Text("Track")
                    .foregroundColor(Color.yellow)
            }
            Button(action: { self.showSettings = true }) {
                Text("Edit")
            }.sheet(isPresented: $showSettings) {
                SettingsView(
                    upperLimit: self.state.upperLimit,
                    lowerLimit:  self.state.lowerLimit
                ).environmentObject(self.state)
                .navigationBarTitle("")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(upperLimit: 0, lowerLimit: 0)
            .environmentObject(AppState())
    }
}
