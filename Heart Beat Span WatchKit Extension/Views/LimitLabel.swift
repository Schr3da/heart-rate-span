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
                .font(Font.system(size: 18.0))
                .frame(
                    minWidth: 18.0,
                    maxWidth: CGFloat.infinity,
                    minHeight: 0.0,
                    maxHeight: 18.0,
                    alignment: Alignment.leading
            )
            
            HStack {
                Picker(selection: $value, label: Text("")) {
                    ForEach(60 ..< 181) {
                        Text(String($0))
                            .font(Font.system(size: 32.0))
                    }
                }
            
                Image(systemName: "arrow.up.to.line")
                    .font(Font.system(size: 24.0))
                    .foregroundColor(Color.red)
                    .offset(x: 0, y: 2)
                    .frame(
                        minWidth: 0.0,
                        maxWidth: CGFloat.infinity,
                        minHeight: 0.0,
                        maxHeight: CGFloat.infinity,
                        alignment: Alignment.leading)
            }
        }.frame(
            minWidth: 0,
            maxWidth: CGFloat.infinity,
            minHeight: 72,
            maxHeight: CGFloat.infinity
        )
    }
}
