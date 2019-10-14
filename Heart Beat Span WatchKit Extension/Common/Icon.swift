//
//  Icon.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 09.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

struct Icon: View {

    let ascii: String
    
    var body: some View {
        Text(ascii)
            .font(Font.system(size: 24.0))
            .foregroundColor(Color.gray)
    }
}
