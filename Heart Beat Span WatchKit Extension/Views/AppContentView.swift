//
//  AppContentView.swift
//  Beat Ranger WatchKit Extension
//
//  Created by schr3da on 06.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import SwiftUI

struct AppContentView: View {
    var body: some View {
        ContentView()
            .navigationBarTitle("HBS")
            .environmentObject(AppState())
    }
}

struct AppContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppContentView()
            .environmentObject(AppState())
    }
}
