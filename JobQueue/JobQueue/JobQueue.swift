//
//  JobQueue.swift
//  JobQueue
//
//  Created by sintaiyuan on 8/18/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

class JobQueue: NSObject, JobQueueStorage {
    private(set) var storageSaveDate = Date()
    private var datastructure = [Job]()

    override init () {}



    // MARK: - Asking about the state of the JobQueue
    var isCompatible: Bool { return true }
    var items: [Job] { return datastructure }
    var isEmpty: Bool { return datastructure.isEmpty }
    var count: Int { return datastructure.count }
    var front: Job? { return datastructure.first }



    // MARK: - Mutating the queue
    func enqueue(_ element: Job) {
        datastructure.append(element)
    }

    func dequeue() -> Job? {
        return isEmpty == true ? nil : datastructure.removeFirst()
    }

    func dequeueAll() {
        datastructure.removeAll()
    }



    // MARK: - Persistence
    required init?(coder aDecoder: NSCoder) {
        guard
            let datastructure       = aDecoder.decodeObject(forKey: "datastructure") as? [Job]
            else {
                print("Error: JobQueue-initWithCoder")
                return nil
        }
        self.datastructure = datastructure
        super.init()
    }

    func encode(with aCoder: NSCoder) {
        storageSaveDate = Date()
        aCoder.encode(NSArray(array: datastructure), forKey: "datastructure")
    }
}
