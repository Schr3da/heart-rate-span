//
//  Sampler.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import HealthKit
import AVFoundation

class SampleManager {
    
    private var store: HKHealthStore = HKHealthStore()
    private var updateCb: ((Int) -> Void)!
    
    func setUpdateCb(cb: ((Int) -> Void)!) {
        self.updateCb = cb
    }
    
    func hasPermissions() -> Bool {
        guard let type = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return false
        }
        let status = store.authorizationStatus(for: type)
        return status == HKAuthorizationStatus.sharingAuthorized
    }
    
    func requestPermissions() {
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        store.requestAuthorization(toShare: allTypes, read: allTypes, completion: { (success, error) in
            if !success {
                return
            }
        })
    }
    
    func fetchLatestHeartRateSample(completion: @escaping (_ sample: HKQuantitySample?) -> Void) {
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
    
    func prepareQuery() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        let query = HKObserverQuery.init(sampleType: sampleType, predicate: nil) { [weak self] _, _, error in
            self?.fetchLatestHeartRateSample(completion: { (sample) in
                guard let sample = sample else {
                    print("not a valid sample")
                    return
                }

                DispatchQueue.main.async {
                  let heartRateUnit = HKUnit(from: "count/min")
                  let heartRate = sample
                    .quantity
                    .doubleValue(for: heartRateUnit)

                    print(heartRate)
                }
            })
        }
        store.execute(query)
    }
    
    func run() {
        if hasPermissions() == false {
            requestPermissions()
            return
        }
        prepareQuery()
    }
    
    func stop() {
        print("Stop sampler")
    }
}
