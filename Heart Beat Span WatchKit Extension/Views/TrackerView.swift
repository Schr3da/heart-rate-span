//
//  TrackingView.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//
import SwiftUI

struct TrackerView: View {
    
    @Binding var upperLimit: Int
    @Binding var lowerLimit: Int
    @Binding var heartrate: Int
    
    private func getHeartRate() -> String {
        heartrate == 0 ?
            "\(Ascii.Heart.rawValue) -" :
            "\(Ascii.Upper.rawValue) \(heartrate)"
    }
    
    private func getUpperLimit() -> String {
        upperLimit == 0 ?
            "- \(Ascii.Upper.rawValue)" :
            "\(upperLimit) \(Ascii.Upper.rawValue)"
    }
    
    private func getLowerLimit() -> String {
        lowerLimit == 0 ?
            "- \(Ascii.Lower.rawValue)" :
            "\(lowerLimit) \(Ascii.Lower.rawValue)"
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
                Text(getUpperLimit())
                    .frame(
                        minWidth: 0,
                        maxWidth: 50,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: Alignment.trailing
                    )
                Text(getLowerLimit())
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
