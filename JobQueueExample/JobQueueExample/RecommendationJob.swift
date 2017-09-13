//
//  RecommendationJob.swift
//  JobQueueExample
//
//  Created by sintaiyuan on 9/13/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import Foundation
import JobQueue

class SurfingSpotRecommendationInteractor : NSObject, Job {
    //MARK: -
    //MARK: Our usual business code doing something useful
    var spotName: String
    
    func execute(visitedSpotCoordinates: [Double]) {
        
    }
    
    //MARK: -
    //MARK: - Job
    var retryableCount: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        guard let spotName = aDecoder.decodeObject(forKey: "spotName") as? String else { return nil }
        self.spotName = spotName
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(spotName, forKey: "spotName")
    }
    
    func run() {
//        execute(visitedSpotCoordinates: <#T##[Double]#>)
    }
}
