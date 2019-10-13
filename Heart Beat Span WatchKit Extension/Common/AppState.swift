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
    case Prepare = "prepare"
    case Running = "running"
}

enum LimitType: String {
    case Up = "up"
    case Down = "down"
}

final class AppState: ObservableObject {

    @Published var uiState: UIStateEnum = UIStateEnum.Stopped
    @Published var upperLimit = 0
    @Published var lowerLimit = 0
    @Published var heartRate = 0
    @Published var permissionDenied = false
    
    static let startRange = 60
    static let endRange = 180
    
    private let file = HBSFileManager()
    private var workout = WorkoutManager()
    
    init() {
        loadSettings()
        workout = WorkoutManager(
            onStart: startTracking,
            onUpdate: update,
            onEnd:  stopTracking
        )
    }
    
    private func loadSettings() {
        let data = file.load()
        upperLimit = data.upperLimit
        lowerLimit = data.lowerLimit
    }
    
    func saveSettings(_ upperLimit: Int, _ lowerLimit: Int) {
        self.upperLimit = max(upperLimit, lowerLimit)
        self.lowerLimit = min(lowerLimit, upperLimit)
        
        let toSave = HBSFileData(
            upperLimit: self.upperLimit,
            lowerLimit: self.lowerLimit
        )
        file.write(data: toSave)
    }
        
    func prepareTracking() {
        heartRate = 0;
        workout.start(upperLimit: upperLimit, lowerLimit: lowerLimit) { (hasPermission) in
            DispatchQueue.main.async {
                self.permissionDenied = hasPermission == false
                if self.permissionDenied {
                    self.stopTracking()
                } else {
                    self.uiState = UIStateEnum.Prepare
                }
            }
        }
    }
    
    func startTracking() {
        DispatchQueue.main.async {
           self.uiState = UIStateEnum.Running
        }
    }
    
    private func update(heartRate: Int) {
        DispatchQueue.main.async {
           self.heartRate = heartRate
        }
    }
    
    func stopTracking() {
        DispatchQueue.main.async {
            self.heartRate = 0;
            self.uiState = UIStateEnum.Stopped
            self.workout.stop()
        }
    }
}
