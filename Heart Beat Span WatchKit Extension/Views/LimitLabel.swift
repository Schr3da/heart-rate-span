//
//  LimitView.swift
//  Beat Ranger WatchKit Extension
//
//  Created by schr3da on 06.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

enum LimitType: String {
    case Up = "up"
    case Down = "down"
}

struct LimitLabel: View {
    
    @Binding var value: Int
    
    private let type: LimitType

    init(value: Binding<Int>, type: LimitType) {
        self.type = type
        self._value = value
    }
    
    private func getTitle() -> String {
        type == LimitType.Down ? "Lower Limit" : "Upper Limit"
    }
    
    private func getPrefix() -> String {
        type == LimitType.Down ? Ascii.Lower.rawValue : Ascii.Upper.rawValue
    }
    
    private func getLimitRange() -> ClosedRange<Int> {
        AppState.startRange ... AppState.endRange
    }
    
    var body: some View {
        VStack {
            Text(getTitle())
                .font(Font.system(size: 14.0))
            HStack {
                Icon(ascii: Ascii.Heart.rawValue)
                HBSPicker($value, getLimitRange())
                Icon(ascii: getPrefix())

            }
        }
    }
}
