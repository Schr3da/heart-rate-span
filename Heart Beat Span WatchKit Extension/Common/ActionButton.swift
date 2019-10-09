//
//  ActionButton.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 09.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

struct ActionButton: View {
    
    private let title: String
    private let color: Color
    private let onClick: () -> Void
    
    init(title: String, color: Color, onClick: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.onClick = onClick
    }
    
    var body: some View {
        Button(action: self.onClick) {
            Text(title)
                .foregroundColor(color)
        }
    }
    
}
