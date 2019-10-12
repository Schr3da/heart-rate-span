//
//  Sampler.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import HealthKit

class SampleManager {
    
    private var store: HKHealthStore = HKHealthStore()
    private var updateCb: ((Int) -> Void)! = nil
    private var observerQuery: HKObserverQuery! = nil
    private var task: DispatchWorkItem! = nil;
    
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
    
    private func fetchLatestHeartRateSample(completion: @escaping (_ sample: HKQuantitySample?) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(nil)
            return
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: Date.distantPast,
            end: Date(),
            options: .strictEndDate
        )

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )

        let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: predicate,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor]) { (_, results, error) in
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                
                if results == nil || results!.isEmpty {
                    completion(nil)
                    return
                }
              
                guard let result = results?[0] as? HKQuantitySample else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                completion(result)
            }

        store.execute(query)
    }
    
    private func prepareQuery() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        observerQuery = HKObserverQuery.init(sampleType: sampleType, predicate: nil) { [weak self] _, _, error in
            self?.fetchLatestHeartRateSample(completion: { (sample) in
                guard let sample = sample else {
                    print("not a valid sample")
                    return
                }

                let task = DispatchWorkItem {
                    let heartRateUnit = HKUnit(from: "count/min")
                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    self?.updateCb(Int(heartRate))
                }
                
                self!.task = task;
                DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: self!.task)
            })
        }

        store.execute(observerQuery)
    }
    
    func run() {
        stop()
        if hasPermissions() == false {
            requestPermissions()
            return
        }
        prepareQuery()
    }
    
    func setUpdateCb(cb: ((Int) -> Void)!) {
        self.updateCb = cb
        self.task = nil
    }
    
    func stop() {
        if (observerQuery != nil) {
            store.stop(observerQuery)
        }
        
        if task == nil || task.isCancelled == false {
            return
        }
        task.cancel()
    }
}
