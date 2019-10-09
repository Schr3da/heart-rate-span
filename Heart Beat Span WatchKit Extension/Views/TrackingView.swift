//
//  TrackingView.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//
import SwiftUI

struct TrackingView: View {
    @Binding var upperLimit: Int;
    @Binding var lowerLimit: Int
    @Binding var heartrate: Int;
    
    private func getHeartRate() -> String {
        return self.heartrate == 0 ? "♡ -" : "♡ \(heartrate)"
    }
    
    private func getUpperLimit() -> String {
        return upperLimit == 0 ? "- ⤒" : "\(upperLimit) ⤒"
    }
    
    private func getLowerLimit() -> String {
        return lowerLimit == 0 ? "- ⤓" : "\(lowerLimit) ⤓"
    }
    
    var body: some View {
        HStack {
            Text(getHeartRate())
                .font(Font.system(size: 38))
                .padding(0)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 50,
                    maxHeight: .infinity,
                    alignment: Alignment.leading
                )
            VStack {
                Text(self.getUpperLimit())
                    .frame(
                        minWidth: 0,
                        maxWidth: 50,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: Alignment.trailing
                    )
                Text(self.getLowerLimit())
                    .frame(
                        minWidth: 0,
                        maxWidth: 50,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: Alignment.trailing
                    )
            }.foregroundColor(Color.gray)
        }
    }
}
