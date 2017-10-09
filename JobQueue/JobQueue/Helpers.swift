//
//  Helpers.swift
//  JobQueue
//
//  Created by sintaiyuan on 9/7/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

extension FileManager {
    var documentDirectoryURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    var cacheDirectoryURL: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = paths[0]
        return cacheDirectory
    }
}
