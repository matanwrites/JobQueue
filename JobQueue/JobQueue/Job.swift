//
//  Job.swift
//  JobQueue
//
//  Created by sintaiyuan on 9/7/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

public protocol Job: NSCoding {
    var retryableCount: Int { get }
    func run()
}
