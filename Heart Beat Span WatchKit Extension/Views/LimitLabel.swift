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
    @Binding var value: Int;

    var body: some View {
        VStack {
            Text("Upper Limit")
                .font(Font.system(size: 14.0))
            HStack {
                Text("♡")
                    .font(Font.system(size: 24.0))
                    .foregroundColor(Color.gray)
                Picker(selection: $value, label: Text("")) {
                    ForEach((AppState.startRange ... AppState.startRange + AppState.selectableRange), id: \.self) { t in
                        Text(String(t))
                            .font(Font.system(size: 32.0))
                    }
                }.frame(
                    minWidth: 30,
                    minHeight: 44
                )
                Text("⤒")
                    .font(Font.system(size: 24.0))
                    .foregroundColor(Color.gray)
            }
        }
    }
}
