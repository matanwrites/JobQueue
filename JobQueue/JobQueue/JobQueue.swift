//
//  JobQueue.swift
//  JobQueue
//
//  Created by sintaiyuan on 8/18/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

class JobQueue : NSObject, JobQueueStorage {
    fileprivate var array = [Job]()
    
//    var version: String = "myappversion"
    
    var isCompatible: Bool {
        return true
    }
    
    private(set) var storageSaveDate = Date()
    
    
    
    override init () {}

    
    
    //MARK: Persistence
    required init?(coder aDecoder: NSCoder) {
        guard
//            let version     = aDecoder.decodeObject(forKey: "version") as? String,
            let array       = aDecoder.decodeObject(forKey: "array") as? [Job]
            else {
                print("Error: JobQueue-initWithCoder")
                return nil
        }
        
//        self.version = version
        self.array = array
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        storageSaveDate = Date()
//        aCoder.encode(version,                forKey: "version")
        aCoder.encode(NSArray(array: array),  forKey: "array")
    }
    
    
    var items: [Job] { return array }
    var isEmpty: Bool { return array.isEmpty }
    var count: Int { return array.count }
    
    func enqueue(_ element: Job) {
        array.append(element)
    }
    
    func dequeue() -> Job? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    func dequeueAll() {
        array.removeAll()
    }
    
    var front: Job? {
        return array.first
    }
}

