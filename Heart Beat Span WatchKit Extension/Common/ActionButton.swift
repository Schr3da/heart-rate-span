//
//  ActionButton.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 09.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

struct ActionButton: View {
    
    let title: String
    let color: Color
    let onClick: () -> Void
    
    var body: some View {
        Button(action: self.onClick) {
            Text(title)
                .foregroundColor(color)
        }
    }
    
}
