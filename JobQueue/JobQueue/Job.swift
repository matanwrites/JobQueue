//
//  Job.swift
//  JobQueue
//
//  Created by sintaiyuan on 9/7/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation

public protocol Job : Codable {
    var retryableCount: Int { get }
    
    init()
    
    func run()
}

public struct AnyJob : Codable {
    var base: Job
    var concreteType: String
    
    init(_ base: Job) {
        self.base = base
        self.concreteType = "JobQueueExample.DocumentUploadService"
    }
    
    private enum CodingKeys : CodingKey {
        case type, base
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(String.self, forKey: .type)
        
       let c = NSClassFromString(type) as! Job.Type
        
        self.base = try c.init(from: container.superDecoder(forKey: .base))
        self.concreteType = type
//        self.base = try c.init(from: container.superDecoder(forKey: .base))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(concreteType, forKey: .type)
        try base.encode(to: container.superEncoder(forKey: .base))
    }
}
