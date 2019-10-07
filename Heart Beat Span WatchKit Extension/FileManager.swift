//
//  FileManager.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

struct FileData: Codable {
    let upperLimit: Int
    let lowerLimit: Int
    
    init(_ upperLimit: Int, _ lowerLimit: Int) {
        self.upperLimit = upperLimit
        self.lowerLimit = lowerLimit
    }
}

class FileManager {
    
    func load() -> FileData {
        print("load file")
        return FileData.init(120, 100)
    }
    
    func write(data: FileData) {
        let content = JSONStringify(obj: data, prettyPrinted: true)
        print(content)
    }
}
