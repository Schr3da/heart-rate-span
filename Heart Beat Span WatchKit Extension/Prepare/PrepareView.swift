//
//  PrepareView.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 14.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

struct PrepareView: View {
    
    @EnvironmentObject var state: AppState
        
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            HStack {
                Text("\(Ascii.Heart.rawValue)")
                Text("\(state.heartRate == 0 ? "" : String(state.heartRate))")
            }
            .font(Font.system(size: 38))
            .foregroundColor(Color.gray)
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            Text("Tracking starts once heartrate is higher than \(state.lowerLimit)")
                .frame(
                    minHeight: 64,
                    maxHeight: .infinity,
                    alignment: .center
                )
            Divider()
            ActionButton(title: "Cancel", color: Color.red, onClick: state.stopTracking)
        }.navigationBarTitle("")
    }
}
