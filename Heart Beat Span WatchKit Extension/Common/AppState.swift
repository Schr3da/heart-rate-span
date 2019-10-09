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
        self.upperLimit = upperLimit
        self.lowerLimit = lowerLimit
        
        let toSave = HBSFileData(
            enableSound: isSoundEnabled,
            enableVibration: isSoundEnabled,
            upperLimit: upperLimit,
            lowerLimit: lowerLimit
        )
        file.write(data: toSave)
    }
    
    func updateHeartRate(rate: Int) {
        heartRate = rate
        if isAboveUpperLimit() {
            return
        }
        
        if isBellowLowerLimit() {
            return
        }
    }
    
    func  isAboveUpperLimit() -> Bool {
        if heartRate <= upperLimit {
            return false
        }
        player.play(sound: HBSSound.UpperLimit.rawValue)
        return true
    }
    
    func  isBellowLowerLimit() -> Bool {
        if heartRate >= lowerLimit {
            return false
        }
        player.play(sound: HBSSound.LowerLimit.rawValue)
        return true
    }
        
    func startTracking() {
        uiState = UIStateEnum.Running
        sampler.run()
    }
    
    func stopTracking() {
        uiState = UIStateEnum.Stopped
        sampler.stop()
    }
}
