//
//  Picker.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 09.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

struct HBSPicker: View {
    
    @Binding var value: Int
    
    private let range: ClosedRange<Int>
    
    init(_ value: Binding<Int>, _ range: ClosedRange<Int>) {
        self._value = value
        self.range = range
    }
    
    var body: some View {
        Picker(selection: $value, label: Text("")) {
            ForEach((range), id: \.self) { t in
                Text(String(t))
                    .font(Font.system(size: 32.0))
            }
        }.frame(
            minWidth: 30,
            minHeight: 44
        )
    }
}
