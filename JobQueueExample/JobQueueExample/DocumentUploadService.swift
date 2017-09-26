//
//  DocumentUploadService
//  JobQueueExample
//
//  Created by sintaiyuan on 9/13/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation
import JobQueue

class DocumentUploadService : NSObject, Job {
    //MARK: -
    //MARK: Logic
    var document: Data
    
    init(document: Data) {
        self.document = document
        super.init()
    }
    
    required override init() {
        self.document = Data()
    }
    
    func execute(complete: @escaping (Bool)->Void) {
        //do something with the document argument
        print(document)
        
        //our long fake networking method
        DispatchQueue(label: "networking").asyncAfter(deadline: .now() + 5) {
            
            DispatchQueue.main.async {
                //let's say it only succeed after the second time
                if self.retryableCount == 1 {
                    print("successfully uploaded our document!")
                    complete(true)
                } else {
                    print("something went wrong.")
                    complete(false)
                }
            }
        }
    }
    
    
    
    //MARK: -
    //MARK: Job
    enum CodingKeys : String, CodingKey {
        case retryableCount
        case document
    }
    
    var retryableCount: Int = 3
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.retryableCount = try container.decode(type(of: retryableCount), forKey: .retryableCount)
        self.document = try container.decode(type(of: document), forKey: .document)
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(retryableCount, forKey: .retryableCount)
        try container.encode(document, forKey: .document)
    }
    
    
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let document = aDecoder.decodeObject(forKey: "document") as? Data else { return nil }
        let retryableCount = aDecoder.decodeInteger(forKey: "retryableCount")
        
        self.init(document: document)
        self.retryableCount = retryableCount
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(document, forKey: "document")
        aCoder.encode(retryableCount, forKey: "retryableCount")
    }
    
    func run() {
        retryableCount = retryableCount - 1
        execute {
            //if the job suceedeed there is nothing left to do.
            guard $0 == false else { return }
            
             NotificationCenter.default.post(name: Notification.Name.JobFailedNotification, object: self)
        }
    }
}
