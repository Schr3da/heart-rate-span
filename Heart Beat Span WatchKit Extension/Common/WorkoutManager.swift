//
//  WorkoutManager.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 12.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import HealthKit

class WorkoutManager: NSObject, HKWorkoutSessionDelegate {

    private var store: HKHealthStore = HKHealthStore()
    private var updateCb: ((Int) -> Void)!
    private var session: HKWorkoutSession!
    private let config: HKWorkoutConfiguration = HKWorkoutConfiguration()

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("didChangeTo: " + String(toState.rawValue))
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("error: " + error.localizedDescription)
    }
    
    private func hasPermissions() -> Bool {
        guard let type = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return false
        }
        let status = store.authorizationStatus(for: type)
        return status == HKAuthorizationStatus.sharingAuthorized
    }
    
    private func requestPermissions() {
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        store.requestAuthorization(toShare: allTypes, read: allTypes, completion: { (success, error) in
            if !success {
                return
            }
        })
    }
    
    func run() {
        stop()
        
        do {
            config.activityType = .other
            session = try HKWorkoutSession.init(healthStore: store, configuration: config)
            session.delegate = self
            session.startActivity(with: Date())
            
            let builder = session.associatedWorkoutBuilder()
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: store, workoutConfiguration: config)
            builder.beginCollection(withStart: Date()) { (success, error) in
                print("end")
            }
            
            /*
             let statistics = workoutBuilder.statistics(for: quantityType)
             let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
             let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
             let roundedValue = Double( round( 1 * value! ) / 1 )
             label.setText("\(roundedValue) BPM")
             
             // END
             session.end()
             builder.endCollection(withEnd: Date()) { (success, error) in
                 self.builder.finishWorkout { (workout, error) in
                     // Dispatch to main, because we are updating the interface.
                     DispatchQueue.main.async() {
                         self.dismiss()
                     }
                 }
             }
             
             
             */
            
        } catch {
            print("error")
        }
    }
    
    func setUpdateCb(cb: ((Int) -> Void)!) {
        self.updateCb = cb
    }
    
    func stop() {
        if session == nil {
            return
        }
        session.end()
    }
}

