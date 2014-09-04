//
//  LearnSwiftTests.swift
//  LearnSwiftTests
//
//  Created by Mady Mellor on 8/10/14.
//  Copyright (c) 2014 Mady Mellor. All rights reserved.
//

import Cocoa
import XCTest
import LearnSwift
import Foundation

class LearnSwiftTests: XCTestCase {
    
    //let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
    var appDelegate: AppDelegate = AppDelegate()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        appDelegate.customView.clearScreen()
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
