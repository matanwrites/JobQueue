//
//  DummyJob.swift
//  JobQueueExample
//
//  Created by sintaiyuan on 9/13/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation
import JobQueue

class PrintInteractor : NSObject, Job {
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





class DoSomethingIncredible_Interactor : NSObject, Job {
    //MARK: -
    //MARK: Our usual business code doing something useful
    var incredibleVariableToCompute: String
    
    func execute() {
        //our long fake computing method
        DispatchQueue(label: "computing.queue").asyncAfter(deadline: .now() + 5) {
            let afterProcessingString = self.incredibleVariableToCompute.uppercased()
            DispatchQueue.main.async {
                print("after our incredible processing '\(self.incredibleVariableToCompute)' becomes ..' '\(afterProcessingString)' !")
            }
            
        }
        
    }
    
    init(stringToCompute: String) {
        incredibleVariableToCompute = stringToCompute
        super.init()
    }
    
    
    
    //MARK: -
    //MARK: - Job
    var retryableCount: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        guard let x = aDecoder.decodeObject(forKey: "incredibleVariableToCompute") as? String else { return nil }
        incredibleVariableToCompute = x
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(incredibleVariableToCompute, forKey: "incredibleVariableToCompute")
    }
    
    func run() {
        execute()
    }
}
