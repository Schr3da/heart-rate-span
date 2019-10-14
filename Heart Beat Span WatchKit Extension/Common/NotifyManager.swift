//
//  AudioPlayer.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 09.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import WatchKit

class NotifyManager {
    
    func play(haptic: WKHapticType) {
        WKInterfaceDevice.current().play(haptic)
    }
    
    func notifyAboveUpperLimit() {
        play(haptic: WKHapticType.retry)
    }
    
    func notifyBelowLowerLimit() {
        play(haptic: WKHapticType.failure)
    }
}



