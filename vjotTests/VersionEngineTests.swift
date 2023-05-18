//
//  VersionEngineTests.swift
//  Saridakis-vjotTests
//
//  Created by Nikolaos Saridakis on 30/4/23.
//

import XCTest
import SwiftUI

@testable import vjot
final class VersionEngineTests: XCTestCase {

    var versionEngine: VersionEngine!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        versionEngine = VersionEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        versionEngine = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_fetchingCatVersion() {
        let expectation = expectation(description: "CAT VERSION: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            let version = try await versionEngine.fetch(api: .forCats)
            XCTAssertNotEqual(version.message.count, 0)
        }
    }
    
    @MainActor
    func test_fetchingDogVersion() {
        let expectation = expectation(description: "DOG VERSION: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            let version = try await versionEngine.fetch(api: .forDogs)
            XCTAssertNotEqual(version.message.count, 0)
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
