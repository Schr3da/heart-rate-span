//
//  FileManager.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import Foundation

struct HBSFileData: Codable {
    
    let upperLimit: Int
    let lowerLimit: Int
    let isSoundEnabled: Bool
    let isVibrationEnabled: Bool
    
    init(enableSound: Bool, enableVibration: Bool, upperLimit: Int, lowerLimit: Int) {
        self.isSoundEnabled = enableSound
        self.isVibrationEnabled = enableVibration
        self.upperLimit = upperLimit
        self.lowerLimit = lowerLimit
    }
}

class HBSFileManager {
    
    private let filename = "HBSSettings"
    
    private func getFileUrl() -> URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return dir.appendingPathComponent(filename)
        }
        return nil
    }
    
    func load() -> HBSFileData {
        let defautValue = HBSFileData.init(
            enableSound: true,
            enableVibration: true,
            upperLimit: 120,
            lowerLimit: 100
        )
        
        if let file = getFileUrl() {
            do {
                let content = try String(contentsOf: file, encoding: .utf8)
                return JSONParse(jsonString: content.data(using: .utf8)!)
            }
            catch {
                return defautValue
            }
        }
        
        return defautValue
    }
    
    func write(data: HBSFileData) {
        let content = JSONStringify(obj: data, prettyPrinted: true)
        if let file = getFileUrl() {
            do {
                try content.write(to: file, atomically: false, encoding: .utf8)
            }
            catch {
                print("Unable to send")
            }
        }
    }
}
