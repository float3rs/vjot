//
//  SourcesEngineTests.swift
//  Saridakis-vjotTests
//
//  Created by Nikolaos Saridakis on 30/4/23.
//

import XCTest
import SwiftUI

@testable import vjot
final class SourcesEngineTests: XCTestCase {
    
    var sourcesEngine: SourcesEngine!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
            sourcesEngine = SourcesEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sourcesEngine = nil
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
    func test_fetchCatSources() {
        let expectation = expectation(description: "CAT SOURCES: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            let sources = try await sourcesEngine.fetchCats(count: 7)
            XCTAssertEqual(sources.count, 7)
        }
    }
    
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    // TheDogAPI PROVIDES NO SOURCES (...YET?) -][-][-][-][-]
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]

    // ////////////////////////////////////////////////////////////////////////

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
