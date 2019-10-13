//
//  WorkoutManager.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 12.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import HealthKit
import WatchKit

class WorkoutManager {
    
    private let store: HKHealthStore
    private let session: WorkoutSession
    
    init() {
        store = HKHealthStore()
        session = WorkoutSession(
            onStart: {() in },
            onUpdate: {(_) in },
            onEnd: {() in }
        )
    }
    
    init(onStart: @escaping () -> Void, onUpdate: @escaping (Int) -> Void, onEnd: @escaping () -> Void ) {
        store = HKHealthStore()
        session = WorkoutSession(
            onStart: onStart,
            onUpdate: onUpdate,
            onEnd: onEnd
        )
    }
    
    private func ensurePermissions(cb: @escaping (Bool) -> Void) {
        store.requestAuthorization(
            toShare: WorkoutSession.typesToShare(),
            read: WorkoutSession.typesToRead(),
            completion: { (success, error) in
                let status = self.store.authorizationStatus(for: HKQuantityType.workoutType())
                cb(status == HKAuthorizationStatus.sharingAuthorized)
            }
        )
    }
    
    func stop() {
        session.destroy()
    }
    
    func start(upperLimit: Int, lowerLimit: Int,  cb: @escaping (Bool) -> Void) {
        ensurePermissions() { (hasPermission) in
            let permissionCb = { () in
                DispatchQueue.main.async {
                    cb(hasPermission)
                }
            }
            
            if hasPermission == false {
                return permissionCb()
            }
            
            self.stop()
            self.session.create(
                store: self.store,
                upperLimit: upperLimit,
                lowerLimit: lowerLimit
            )
            permissionCb()
        }
    }
}

