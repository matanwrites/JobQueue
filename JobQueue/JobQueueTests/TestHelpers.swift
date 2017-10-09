//
//  TestHelpers.swift
//  JobQueueTests
//
//  Created by sintaiyuan on 10/9/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

@testable import JobQueue

class DummyJob : NSObject, Job {
    //MARK: -
    //MARK: Our usual business code doing something useful
    var message: String
    
    func execute() {
        print(message)
    }
    
    override init() {
        message = "HI! \(Date())"
        super.init()
    }
    
    
    
    //MARK: -
    //MARK: - Job
    var retryableCount: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        guard let msg = aDecoder.decodeObject(forKey: "message") as? String else { return nil }
        message = msg
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(message, forKey: "message")
    }
    
    func run() {
        execute()
    }
}
