//
//  WorkoutManager.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 12.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import HealthKit
import WatchKit

let typesToShare: Set = [
    HKQuantityType.workoutType()
]

let typesToRead: Set = [
    HKQuantityType.quantityType(forIdentifier: .heartRate)!,
    HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
]

let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())

func getConfig() -> HKWorkoutConfiguration {
    let config = HKWorkoutConfiguration();
    config.activityType = .running
    config.locationType = .outdoor
    return config
}

class WorkoutManager: NSObject, HKLiveWorkoutBuilderDelegate {
    private let store: HKHealthStore = HKHealthStore()
    private let config = getConfig()
    private let notifier = NotifyManager()

    private var upperLimit = 0
    private var lowerLimit = 0
    private var ready = false
    private var session: HKWorkoutSession!
    private var builder: HKLiveWorkoutBuilder!
    private var updateCb: ((Int) -> Void)!
    private var startCb: (() -> Void)!
    
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
            self.update(heartRate: Int(value!))
        }
    }
    
    private func ensurePermissions(cb: @escaping (Bool) -> Void) {
        store.requestAuthorization(toShare: typesToShare, read: typesToRead, completion: { (success, error) in
            let status = self.store.authorizationStatus(for: HKQuantityType.workoutType())
            cb(status == HKAuthorizationStatus.sharingAuthorized)
        })
    }
    
    private func prepareToStart() {
        do {
            session = try HKWorkoutSession(healthStore: store, configuration: config)
            builder = session.associatedWorkoutBuilder()
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: store, workoutConfiguration: config)
            builder.delegate = self;
            session.startActivity(with: Date())
            builder.beginCollection(withStart: Date()) { (success, error) in }
        } catch { }
    }
    
    private func prepareToStop() {
        ready = false
        
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
    
    private func setLimits(_ upper: Int, _ lower: Int) {
        upperLimit = upper
        lowerLimit = lower
    }
    
    private func update(heartRate: Int) {
        DispatchQueue.main.async {
            self.updateCb(heartRate)
        }
        
        if ready == false && heartRate > lowerLimit {
            ready = true
            self.startCb()
        }
        
        if ready == false {
            return
        }
            
        if heartRate > upperLimit {
            notifier.play(haptic: WKHapticType.directionUp)
        } else if heartRate < lowerLimit {
            notifier.play(haptic: WKHapticType.directionDown)
        }
    }
    
    func setStartCb(cb: (() -> Void)!) {
        self.startCb = cb
    }
    
    func setUpdateCb(cb: ((Int) -> Void)!) {
        self.updateCb = cb
    }
    
    func stop() {
        prepareToStop()
    }
    
    func run(upperLimit: Int, lowerLimit: Int,  cb: @escaping (Bool) -> Void) {
        ensurePermissions() { (hasPermission) in
            let permissionCb = { () in
                DispatchQueue.main.async {
                    cb(hasPermission)
                }
            }
            
            if hasPermission == false {
                return permissionCb()
            }
            
            self.setLimits(upperLimit, upperLimit)
            self.prepareToStop()
            self.prepareToStart()
            permissionCb()
        }
    }
}

