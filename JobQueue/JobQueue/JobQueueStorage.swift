//
//  JobQueueStorage.swift
//  JobQueue
//
//  Created by sintaiyuan on 9/13/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

protocol JobQueueStorage : Codable {
    func enqueue(_ element: Job)
    func dequeue()-> Job?
    func dequeueAll()
    
    var storageSaveDate: Date { get }
    var items: [Job] { get }
    
    var isCompatible: Bool { get }
}
