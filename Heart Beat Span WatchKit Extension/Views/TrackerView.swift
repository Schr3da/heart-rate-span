//
//  TrackingView.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//
import SwiftUI

struct TrackerView: View {
    
    @Binding var uiState: UIStateEnum
    @Binding var upperLimit: Int
    @Binding var lowerLimit: Int
    @Binding var heartrate: Int

    private func isTracking() -> Bool {
        uiState == UIStateEnum.Running
    }
    
    private func getHeartRate() -> String {
        isTracking() == false || heartrate == 0 ?
            "-" :
            "\(heartrate)"
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
            Text(Ascii.Heart.rawValue)
                .font(Font.system(size: 38))
                .foregroundColor(Color.gray)            
            Text(getHeartRate())
                .font(Font.system(size: 38))
                .foregroundColor(Color.white)
                .padding(0)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 50,
                    maxHeight: .infinity,
                    alignment: Alignment.leading
                )
            VStack {
                TrackerLimitLabel(title: getUpperLimit(), color: { () in
                    self.isTracking() && self.heartrate > self.upperLimit ?
                    Color.white : Color.gray
                })
                TrackerLimitLabel(title: getLowerLimit(), color: { () in
                    self.isTracking() && self.heartrate < self.lowerLimit ?
                    Color.white : Color.gray
                })
                
            }
        }
    }
}
