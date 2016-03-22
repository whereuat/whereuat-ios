//
//  contactTests.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/23/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import XCTest
@testable import whereuat_ios

class contactTests: XCTestCase {
    let contact1 = Contact(firstName: "Julius", lastName: "Alexander IV", phoneNumber: "+12029550202", autoShare: false, requestedCount: 0)
    let contact2 = Contact(firstName: "Raymond", lastName: "Jacobson", phoneNumber: "+13014672874", autoShare: false, requestedCount: 20)
    let contact3 = Contact(firstName: "Raymond Shu", lastName: "Jacobson", phoneNumber: "+13014672008", autoShare: false, requestedCount: 500)
    let contact4 = Contact(firstName: "Raymond", lastName: "", phoneNumber: "+12029552003", autoShare: false, requestedCount: 700)
    let contact5 = Contact(firstName: "", lastName: "Jacobson", phoneNumber: "+11111111111", autoShare: true, requestedCount: 502)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGenerateInitials() {
        XCTAssertEqual("JA", self.contact1.generateInitials())
        XCTAssertEqual("RJ", self.contact2.generateInitials())
        XCTAssertEqual("RJ", self.contact3.generateInitials())
        XCTAssertEqual("R", self.contact4.generateInitials())
        XCTAssertEqual("J", self.contact5.generateInitials())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
