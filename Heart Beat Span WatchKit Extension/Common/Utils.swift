//
//  Utils.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 13.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import Foundation

func hasReachedTimestampLimit(date: Date!) -> Bool {
    if date == nil {
        return false
    }
    
    let timestamp = date.timeIntervalSince1970
    let currentTimestamp = Date().timeIntervalSince1970
    return currentTimestamp - timestamp > 300
}

func isPreparing(state: UIStateEnum) -> Bool {
    state == UIStateEnum.Prepare
}

func isRunning(state: UIStateEnum) -> Bool {
    state == UIStateEnum.Running
}

func isStopped(state: UIStateEnum) -> Bool {
    state == UIStateEnum.Stopped
}

func isInRange(value: Int, upperLimit: Int, lowerLimit: Int) -> Bool {
    isAboveUpperLimit(value: value, limit: upperLimit) == false &&
    isBellowLowerLimit(value: value, limit: lowerLimit) == false
}

func isAboveUpperLimit(value: Int, limit: Int) -> Bool {
   value > limit
}

func isBellowLowerLimit(value: Int, limit: Int) -> Bool {
   value < limit
}

func isAboveLowerLimit(value: Int, limit: Int) -> Bool {
    value > limit
}
