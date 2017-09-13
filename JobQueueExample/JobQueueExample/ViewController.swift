//
//  ViewController.swift
//  JobQueueExample
//
//  Created by sintaiyuan on 9/7/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import UIKit
import JobQueue

class ViewController: UIViewController {
    @IBAction func buttonTapped(_ sender: Any) {
        
        let job = DocumentUploadService(document: "hello".data(using: .utf8)!)
        
        JobQueueCenter.current.enqueue(job: job)
    }
}
