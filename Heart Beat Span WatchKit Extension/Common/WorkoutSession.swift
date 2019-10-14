//
//  WorkoutSession.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 13.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import HealthKit

class WorkoutSession: NSObject, HKLiveWorkoutBuilderDelegate {

    private let config: HKWorkoutConfiguration
    private let heartRateUnit: HKUnit
    private let notifier: NotifyManager
    private let onStartCb: () -> Void
    private let onUpdateCb: (Int) -> Void
    private let onEndCb: () -> Void

    private var readyToTrack: Bool
    private var lowerLimit: Int
    private var upperLimit: Int
    private var limitTimestamp: Date!
    private var session: HKWorkoutSession!
    private var builder: HKLiveWorkoutBuilder!
    
    init(onStart: @escaping () -> Void, onUpdate: @escaping (Int) -> Void, onEnd: @escaping () -> Void) {
        self.readyToTrack = false
        self.lowerLimit = 0
        self.upperLimit = 0
        self.limitTimestamp = nil
        self.config = HKWorkoutConfiguration()
        self.config.activityType = .running
        self.config.locationType = .outdoor
        self.heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        self.notifier = NotifyManager()
        self.onStartCb = onStart
        self.onUpdateCb = onUpdate
        self.onEndCb = onEnd
        super.init()
    }
    
    static func typesToShare() -> Set<HKWorkoutType> {
        [HKQuantityType.workoutType()]
    }
    
    static func typesToRead() -> Set<HKQuantityType> {
        [HKQuantityType.quantityType(forIdentifier: .heartRate)!]
    }
        
    private func handleTimestampLimit(heartRate: Int) {
        if hasReachedTimestampLimit(date: limitTimestamp) {
            onEndCb()
            return
        }
        
        if isInRange(value: heartRate, upperLimit: upperLimit, lowerLimit: lowerLimit) {
            limitTimestamp = nil
        } else if limitTimestamp == nil {
            limitTimestamp = Date()
        }
    }
    
    private func handleLimits(heartRate: Int) {
        if isAboveUpperLimit(value: heartRate, limit: upperLimit) {
            notifier.notifyAboveUpperLimit()
        } else if isBellowLowerLimit(value: heartRate, limit: lowerLimit) {
            notifier.notifyBelowLowerLimit()
        }
    }
    
    private func handleReadyToTrack(heartRate: Int) {
        if readyToTrack == true || isAboveLowerLimit(value: heartRate, limit: lowerLimit) == false {
            return
        }
        self.readyToTrack = true
        self.onStartCb()
    }
    
    private func update(value: Int) {
        self.onUpdateCb(value)

        handleReadyToTrack(heartRate: value)
        if readyToTrack == false {
            return;
        }
        
        handleLimits(heartRate: value)
        handleTimestampLimit(heartRate: value)
    }
     
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) { }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                continue
            }
                     
            if quantityType.is(compatibleWith: heartRateUnit) == false {
                continue
            }

            guard let statistics = workoutBuilder.statistics(for: quantityType) else {
                continue
            }
            
            let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
            self.update(value: Int(value!))
        }
    }
    
    func create(store: HKHealthStore, upperLimit: Int, lowerLimit: Int) {
        if session != nil || builder != nil {
            return
        }
        
        self.upperLimit = upperLimit;
        self.lowerLimit = lowerLimit;
        
        do {
            session = try HKWorkoutSession(healthStore: store, configuration: config)
            builder = session.associatedWorkoutBuilder()
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: store, workoutConfiguration: config)
            builder.delegate = self;
            session.startActivity(with: Date())
            builder.beginCollection(withStart: Date()) { (success, error) in }
        } catch { }
    }
    
    func destroy() {
        limitTimestamp = nil
        readyToTrack = false
        
        if session != nil {
            session.end()
            session = nil
        }
      
        if builder == nil {
            return
        }

        builder.endCollection(withEnd: Date()) { (success, error) in
            guard success else {
                return
            }
            self.builder.finishWorkout { (workout, error) in
                self.builder = nil
            }
        }
    }
    
}
