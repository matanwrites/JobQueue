//
//  JobQueueTests.swift
//  JobQueueTests
//
//  Created by sintaiyuan on 8/18/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import XCTest
import Nimble
import Quick

@testable import JobQueue

class JobQueueCenterSpec: QuickSpec {
    override func spec() {
        describe("JobQueueCenter items") {
            
            beforeEach {
                JobQueueCenter.current.flush()
            }
            
            context("When no jobs") {
                it("returns an empty array") {
                    let s = JobQueueCenter.current.items
                    
                    expect(s).to(beEmpty())
                }
            }
            
            context("When has a job") {
                it("returns a job") {
                    JobQueueCenter.current.enqueue(job: DummyJob())
                    expect(JobQueueCenter.current.items).toEventuallyNot(beEmpty(), timeout: 1)
                }
            }
        }
        
        
        describe("JobQueueCenter flush") {
            it("empty the storage") {
                JobQueueCenter.current.enqueue(job: DummyJob())
                JobQueueCenter.current.flush()
                expect(JobQueueCenter.current.items).toEventually(beEmpty(), timeout: 1)
            }
        }
    }
}
