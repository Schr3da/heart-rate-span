//
//  AppState.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 06.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import HealthKit

enum UIStateEnum: String {
    case Stopped = "stopped"
    case Running = "running"
}

final class AppState: ObservableObject {
    @Published var startRange = 60
    @Published var selectableRange = 120
    @Published var uiState: UIStateEnum = UIStateEnum.Stopped
    
    private let filename = "heart_beat_span_appstate"
    private let fileExtension = ".txt"
    private let sampler = Sampler()
    
    func loadData() {
        print("Add logic to save Data")
    }
    
    func saveData(_ upperLimit: Int, _ lowerLimit: Int) {
        let max = upperLimit + startRange
        let min = lowerLimit + startRange
        print("Add logic to save Data \(min) \(max)")
    }
        
    func startTracking() {
        uiState = UIStateEnum.Running
        self.sampler.run()
    }
    
    func stopTracking() {
        uiState = UIStateEnum.Stopped
        self.sampler.stop()
    }
}
