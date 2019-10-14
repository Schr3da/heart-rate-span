//
//  TrackerLimitLabel.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 12.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

typealias ColorCb = () -> Color

struct TrackerLimitLabel: View {
    
    let title: String
    let color: ColorCb
    
    var body: some View {
        Text(title)
            .foregroundColor(color())
            .frame(
                minWidth: 0,
                maxWidth: 50,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: Alignment.trailing
            )
    }
}
