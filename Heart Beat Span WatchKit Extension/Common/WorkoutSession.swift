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
    private let onStartCb: () -> Void
    private let onUpdateCb: (Int) -> Void
    private let notifier: NotifyManager

    private var ready: Bool
    private var lowerLimit: Int
    private var upperLimit: Int
    private var session: HKWorkoutSession!
    private var builder: HKLiveWorkoutBuilder!
    
    init(onStart: @escaping () -> Void, onUpdate: @escaping (Int) -> Void) {
        self.ready = false
        self.lowerLimit = 0
        self.upperLimit = 0
        self.config = HKWorkoutConfiguration()
        self.config.activityType = .running
        self.config.locationType = .outdoor
        self.heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        self.notifier = NotifyManager()
        self.onStartCb = onStart
        self.onUpdateCb = onUpdate
        super.init()
    }
    
    static func typesToShare() -> Set<HKWorkoutType> {
        [HKQuantityType.workoutType()]
    }
    
    static func typesToRead() -> Set<HKQuantityType> {
        [HKQuantityType.quantityType(forIdentifier: .heartRate)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!]
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
            self.update(heartRate: Int(value!))
        }
    }
    
    private func update(heartRate: Int) {
        self.onUpdateCb(heartRate)

        if ready == false && heartRate > lowerLimit {
            self.ready = true
            self.onStartCb()
            return
        }

        if ready == false {
            return
        }
            
        if heartRate > upperLimit {
            notifier.notifyAboveUpperLimit()
        } else if heartRate < lowerLimit {
            notifier.notifyBelowLowerLimit()
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
