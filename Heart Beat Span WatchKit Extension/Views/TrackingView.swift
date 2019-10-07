//
//  TrackingView.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//
import SwiftUI

struct TrackingView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack {
            Button(action: self.state.stopTracking)  {
                Text("Stop")
            }
        }
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView()
            .environmentObject(AppState())
    }
}
