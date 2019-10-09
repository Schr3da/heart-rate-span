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
    @Published var uiState: UIStateEnum = UIStateEnum.Stopped
    @Published var upperLimit = 0
    @Published var lowerLimit = 0
    @Published var heartrate = 0
    
    static let startRange = 60
    static let endRange = 180
    
    private let file = HBSFileManager()
    private let sampler = SampleManager()
    
    init() {
        self.loadData()
    }
    
    func loadData() {
        let data = file.load()
        self.upperLimit = data.upperLimit
        self.lowerLimit = data.lowerLimit
    }
    
    func saveData(_ upperLimit: Int, _ lowerLimit: Int) {
        self.upperLimit = upperLimit
        self.lowerLimit = lowerLimit
        self.file.write(data: HBSFileData(upperLimit, lowerLimit))
    }
        
    func startTracking() {
        uiState = UIStateEnum.Running
        self.sampler.run()
    }
    
    func stopTracking() {
        uiState = UIStateEnum.Stopped
        self.loadData()
        self.sampler.stop()
    }
}
