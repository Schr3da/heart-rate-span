//
//  WorkoutManager.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 12.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import HealthKit

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
    
    private var updateCb: ((Int) -> Void)!
    private var session: HKWorkoutSession!
    private var builder: HKLiveWorkoutBuilder!

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
            DispatchQueue.main.async {
                self.updateCb(Int(value!))
            }
        }
    }
    
    private func ensurePermissions(cb: @escaping () -> Void) {
        let status = store.authorizationStatus(for: HKQuantityType.workoutType())
        
        if status == HKAuthorizationStatus.sharingAuthorized {
            cb()
            return
        }
        
        store.requestAuthorization(toShare: typesToShare, read: typesToRead, completion: { (success, error) in
            guard success else {
                return
            }
            cb()
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
        if session != nil {
            session.end()
            session = nil
        }
        
        if builder == nil {
            return
        }
  
        builder.endCollection(withEnd: Date()) { (success, error) in
            guard success else {
                print("error: " + error!.localizedDescription)
                return
            }
            self.builder.finishWorkout { (workout, error) in
                self.builder = nil
            }
        }
    }
    
    func setUpdateCb(cb: ((Int) -> Void)!) {
        self.updateCb = cb
    }
        
    func stop() {
        prepareToStop()
    }
    
    func run() {
        ensurePermissions() { () in
            self.prepareToStop()
            self.prepareToStart()
        }
    }
}

