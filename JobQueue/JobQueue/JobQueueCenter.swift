//
//  JobQueueCenter.swift
//  JobQueue
//
//  Created by sintaiyuan on 9/7/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

public class JobQueueCenter {
    static let storageURL = FileManager.default.documentDirectoryURL.appendingPathComponent("JobQueueCenter.storage")
    fileprivate let storageAccessQueue = DispatchQueue(label: "com.JobQueue.JobQueueCenter.storageAccessQueue")
    let saveInterval: TimeInterval = 3
    
    
    
    fileprivate init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil, queue: nil) { _ in
            self.persist()
        }
    }
    
    fileprivate lazy var storage: JobQueue = {
        let archivedQ = NSKeyedUnarchiver.unarchiveObject(withFile: storageURL.path)
        
        if let queue = archivedQ as? JobQueue {
            guard queue.isCompatible == true else {
                do {
                    try FileManager.default.removeItem(at: JobQueueCenter.storageURL)
                } catch {
                    print("Error: FileManager.removeItem(at:) - \(error)")
                }
                
                return JobQueue()
            }
            return queue
            
        } else {
            return JobQueue()
        }
    }()
}


//MARK: -
//MARK: Public API
public extension JobQueueCenter {
    public static let current = JobQueueCenter()
    
    public var items: [Job] {
        var list: [Job]!
        
        storageAccessQueue.sync { list = storage.items }
        
        return list
    }
    
    public func enqueue(job: Job) {
        storageAccessQueue.async {
            print("JobQueueCenter: enqueuing job \(job)")
            self.storage.enqueue(job)
        }
    }
    
    public func executeNext() {
        print("JobQueueCenter: 0. list of items to process:")
        print(items)
        
        storageAccessQueue.async {
            print("JobQueueCenter: 1. trying to execute next job in queue")
            if let job = self.storage.dequeue() {
                print("JobQueueCenter: 2. executing job: \(job)")
                job.run()
            } else {
                print("JobQueueCenter: 2. there is no job in queue")
            }
        }
    }
    
    public func flush() {
        storageAccessQueue.sync {
            print("JobQueueCenter: flushing")
            self.storage.dequeueAll()
        }
    }
    
    public func tryPersist() {
        print("JobQueueCenter: tryPersisting")
        guard Date().timeIntervalSince(storage.storageSaveDate) > saveInterval else {
            return print("JobQueueCenter: ignoring tryPersisting, time since last save is too short")
        }
        
        persist()
    }
    
    public func persist() {
        self.storageAccessQueue.async {
            print("JobQueueCenter: persisting")
            guard NSKeyedArchiver.archiveRootObject(self.storage, toFile: JobQueueCenter.storageURL.path) == true else {
                return print("Error: NSKeyedArchiver.archiveRootObject")
            }
        }
    }
}
