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

enum LimitType: String {
    case Up = "up"
    case Down = "down"
}

final class AppState: ObservableObject {

    @Published var uiState: UIStateEnum = UIStateEnum.Stopped
    @Published var upperLimit = 0
    @Published var lowerLimit = 0
    @Published var isSoundEnabled = false
    @Published var isVibrationEnabled = false
    @Published var heartRate = 120
    
    static let startRange = 60
    static let endRange = 180
    
    private let player = AudioPlayer()
    private let file = HBSFileManager()
    private let sampler = SampleManager()
    
    init() {
        loadSettings()
        sampler.setUpdateCb(cb: updateHeartRate)
    }
    
    func loadSettings() {
        let data = file.load()
        upperLimit = data.upperLimit
        lowerLimit = data.lowerLimit
        isSoundEnabled = data.isSoundEnabled
        isVibrationEnabled = data.isVibrationEnabled
    }
    
    func saveSettings(_ upperLimit: Int, _ lowerLimit: Int) {
        self.upperLimit = max(upperLimit, lowerLimit)
        self.lowerLimit = min(lowerLimit, upperLimit)
        
        let toSave = HBSFileData(
            enableSound: isSoundEnabled,
            enableVibration: isSoundEnabled,
            upperLimit: self.upperLimit,
            lowerLimit: self.lowerLimit
        )
        file.write(data: toSave)
    }
    
    func updateHeartRate(rate: Int) {
        heartRate = rate

        if isAboveUpperLimit() {
            player.play(sound: HBSSound.UpperLimit.rawValue)
            return
        }
        
        if isBellowLowerLimit() {
            player.play(sound: HBSSound.LowerLimit.rawValue)
            return
        }
    }
    
    func  isAboveUpperLimit() -> Bool {
        heartRate > upperLimit
    }
    
    func  isBellowLowerLimit() -> Bool {
        heartRate < lowerLimit
    }
        
    func startTracking() {
        //heartRate = 0;
        uiState = UIStateEnum.Running
        sampler.run()
    }
    
    func stopTracking() {
        //heartRate = 0;
        uiState = UIStateEnum.Stopped
        sampler.stop()
    }
}
