//
//  AnalysisEngineTests.swift
//  Saridakis-vjotTests
//
//  Created by Nikolaos Saridakis on 30/4/23.
//

import XCTest
import SwiftUI

@testable import vjot
final class AnalysisEngineTests: XCTestCase {

    var analysisEngine: AnalysisEngine!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        analysisEngine = AnalysisEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        analysisEngine = nil
    }


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    func test_fetchingCatAPIAnalysis() {
        let expectation = expectation(description: "fetched TheCatAPI analyses")
        defer { waitForExpectations(timeout: 60) }
    
        Task.init {
            defer { expectation.fulfill() }
            let data = try await fetchAPIAnalyses(
                apiEndpoint: .forCats,
                apiVersion: .v1,
                apiPath: .forImages,
                imageId: "0XYvRd7oD"
            )
            XCTAssertNotNil(data)
            let foldedAnalyses = try decodeAPIAnalyses(data: data)
            XCTAssertNotEqual(foldedAnalyses.count, 0)
            let analyses = unfoldAPIAnalyses(foldedAPIAnalyses: foldedAnalyses)
            XCTAssertNotEqual(analyses.count, 0)
            XCTAssertEqual(foldedAnalyses[0].vendor, analyses[0].vendor)
            XCTAssertEqual(foldedAnalyses[0].createdAt, analyses[0].createdAt)
        }
    }
    
    func test_fetchingDogAPIAnalysis() {
        let expectation = expectation(description: "fetched TheDogAPI analyses")
        defer { waitForExpectations(timeout: 5) }
    
        Task.init {
            defer { expectation.fulfill() }
            let data = try await fetchAPIAnalyses(
                apiEndpoint: .forDogs,
                apiVersion: .v1,
                apiPath: .forImages,
                imageId: "BJa4kxc4X"
            )
            XCTAssertNotNil(data)
            let foldedAnalyses = try decodeAPIAnalyses(data: data)
            XCTAssertNotEqual(foldedAnalyses.count, 0)
            let analyses = unfoldAPIAnalyses(foldedAPIAnalyses: foldedAnalyses)
            XCTAssertNotEqual(analyses.count, 0)
            XCTAssertEqual(foldedAnalyses[0].vendor, analyses[0].vendor)
            XCTAssertEqual(foldedAnalyses[0].createdAt, analyses[0].createdAt)
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_fetchingCatAnalyses() {
        let expectation = expectation(description: "fetched Cat analyses")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            analysisEngine.analyses = []
            try await analysisEngine.fetch(.forCats, imageId: "0XYvRd7oD")
            XCTAssertNotEqual(analysisEngine.analyses.count, 0)
        }
    }
    
    @MainActor
    func test_fetchingDogAnalyses() {
        let expectation = expectation(description: "fetched Dog analyses")
        defer { waitForExpectations(timeout: 5) }
        
        Task.init {
            defer { expectation.fulfill() }
            analysisEngine.analyses = []
            try await analysisEngine.fetch(.forDogs, imageId: "BJa4kxc4X")
            XCTAssertNotEqual(analysisEngine.analyses.count, 0)
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
