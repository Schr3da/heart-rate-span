//
//  Json.swift
//  Heart Beat Span WatchKit Extension
//
//  Created by schr3da on 07.10.19.
//  Copyright © 2019 schreda. All rights reserved.
//

import Foundation

func JSONStringify(obj: HBSFileData, prettyPrinted: Bool = false) -> String {
    do {
        let data = try JSONEncoder().encode(obj)
        let string = String(data: data, encoding: .utf8)!
        return string
    } catch {
        print(error)
        return ""
    }
}

func JSONParse(jsonString: Data) -> HBSFileData {
    do {
        return try JSONDecoder().decode(HBSFileData.self, from: jsonString)
    } catch {
        print(error)
        return HBSFileData.init(0, 0)
    }
}
