//
//  JobQueueCenter.swift
//  JobQueue
//
//  Created by sintaiyuan on 9/7/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let JobFailedNotification = Notification.Name("jobFailedNotification")
}

public class JobQueueCenter {
    static let storageURL = FileManager.default.cacheDirectoryURL.appendingPathComponent("JobQueueCenter.storage")
    fileprivate let storageAccessQueue = DispatchQueue(label: "com.JobQueue.JobQueueCenter.storageAccessQueue")
    let saveInterval: TimeInterval = 3
    
    
    
    fileprivate init() {
        NotificationCenter.default.addObserver(self, selector: #selector(tryPersist), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tryPersist), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tryPersist), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tryPersist), name: .UIApplicationWillTerminate, object: nil)
        
        NotificationCenter.default.addObserver(forName: Notification.Name.JobFailedNotification, object: nil, queue: nil) { notification in
            let job = notification.object as! Job
            if job.retryableCount > 0 {
                print("Enqueing job again for retry \(job.retryableCount) times left")
                self.enqueue(job: job)
            } else {
                 print("Job cannot be retried anymore, already ran it \(job.retryableCount) times")
            }
        }
    }
    
    fileprivate lazy var storage: JobQueueStorage = {
        let archivedQ = NSKeyedUnarchiver.unarchiveObject(withFile: storageURL.path)
        
        if let queue = archivedQ as? JobQueueStorage {
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
            DispatchQueue(label: "com.JobQueueCenter.executionQueue").async {
                self.storage.enqueue(job)
            }
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
    
    @objc public func tryPersist() {
        print("JobQueueCenter: tryPersisting")
        guard Date().timeIntervalSince(storage.storageSaveDate) > saveInterval else {
            return print("JobQueueCenter: ignoring tryPersisting, time since last save is too short")
        }
        
        persist()
    }
    
    @objc public func persist() {
        self.storageAccessQueue.async {
            print("JobQueueCenter: persisting")
            guard NSKeyedArchiver.archiveRootObject(self.storage, toFile: JobQueueCenter.storageURL.path) == true else {
                return print("Error: NSKeyedArchiver.archiveRootObject")
            }
        }
    }
}
