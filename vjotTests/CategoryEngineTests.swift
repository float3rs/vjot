//
//  CategoryEngineTests.swift
//  Saridakis-vjotTests
//
//  Created by Nikolaos Saridakis on 30/4/23.
//

import XCTest
import SwiftUI

@testable import vjot
final class CategoryEngineTests: XCTestCase {

    var categoryEngine: CategoryEngine!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        categoryEngine = CategoryEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        categoryEngine = nil
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
    func test_fetchingCatCategories() {
        let expectation = expectation(description: "CAT CATEGORIES: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            categoryEngine.catCategories = []
            try await categoryEngine.fetch(.forCats, limit: nil, page: nil)
            XCTAssertNotEqual(categoryEngine.catCategories.count, 0)
        }
    }
    
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    // TheDogAPI PROVIDES NO IMAGE CATEGORIES (...YET?) -][-]
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    
    @MainActor
    func test_fetchingDogCategories() {
        let expectation = expectation(description: "DOG CATEGORIES: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            categoryEngine.dogCategories = []
            try await categoryEngine.fetch(.forDogs, limit: nil, page: nil)
            XCTAssertEqual(categoryEngine.dogCategories.count, 0)
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_savingCatCategories() {
        let expectation = expectation(description: "CAT CATEGORIES: SAVED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            categoryEngine.catCategories = []
            try await categoryEngine.fetch(.forCats, limit: nil, page: nil)
            XCTAssertNoThrow(try categoryEngine.save(.forCats))
            var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            destination = destination.appending(component: "categories")
            destination = destination.appending(path: "catCategories")
            destination = destination.appendingPathExtension("json")
            XCTAssertTrue(FileManager.default.fileExists(atPath: destination.relativePath))
        }
    }
    
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    // TheDogAPI PROVIDES NO IMAGE CATEGORIES (...YET?) -][-]
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    
    @MainActor
    func test_savingDogCategories() {
        let expectation = expectation(description: "DOG CATEGORIES: SAVED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            categoryEngine.dogCategories = []
            try await categoryEngine.fetch(.forDogs, limit: nil, page: nil)
            XCTAssertNoThrow(try categoryEngine.save(.forDogs))
            var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            destination = destination.appending(component: "categories")
            destination = destination.appending(path: "dogCategories")
            destination = destination.appendingPathExtension("json")
            XCTAssertTrue(FileManager.default.fileExists(atPath: destination.relativePath))
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_loadingCatCategories() {
        let expectation = expectation(description: "CAT CATEGORIES: LOADED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            categoryEngine.catCategories = []
            try await categoryEngine.fetch(.forCats, limit: nil, page: nil)
            try categoryEngine.save(.forCats)
            XCTAssertNoThrow(try categoryEngine.load(.forCats))
            XCTAssertNotEqual(categoryEngine.catCategories.count, 0)
        }
    }
    
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    // TheDogAPI PROVIDES NO IMAGE CATEGORIES (...YET?) -][-]
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    
    @MainActor
    func test_loadingDogCategories() {
        let expectation = expectation(description: "DOG CATEGORIES: LOADED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            categoryEngine.dogCategories = []
            try await categoryEngine.fetch(.forDogs, limit: nil, page: nil)
            try categoryEngine.save(.forDogs)
            XCTAssertNoThrow(try categoryEngine.load(.forDogs))
            XCTAssertEqual(categoryEngine.dogCategories.count, 0)
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_fallbackingCatCategories() {
        categoryEngine.catCategories = []
        XCTAssertNoThrow(try categoryEngine.fallback(.forCats))
        XCTAssertNotEqual(categoryEngine.catCategories.count, 0)
    }
    
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    // TheDogAPI PROVIDES NO IMAGE CATEGORIES (...YET?) -][-]
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    
    @MainActor
    func test_fallbackingDogCategories() {
        categoryEngine.dogCategories = []
        XCTAssertNoThrow(try categoryEngine.fallback(.forDogs))
        XCTAssertEqual(categoryEngine.dogCategories.count, 0)
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_refreshingCatCategories() {
        let expectation = expectation(description: "CAT CATEGORIES: REFRESHED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            categoryEngine.catCategories = []
            try await categoryEngine.refresh(.forCats)
            var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            destination = destination.appending(component: "categories")
            destination = destination.appending(path: "catCategories")
            destination = destination.appendingPathExtension("json")
            XCTAssertTrue(FileManager.default.fileExists(atPath: destination.relativePath))
            XCTAssertNotEqual(categoryEngine.catCategories.count, 0)
        }
    }
    
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    // TheDogAPI PROVIDES NO IMAGE CATEGORIES (...YET?) -][-]
    // [-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-][-]
    
    @MainActor
    func test_refreshingDogCategories() {
        let expectation = expectation(description: "DOG CATEGORIES: REFRESHED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            categoryEngine.dogCategories = []
            try await categoryEngine.refresh(.forDogs)
            var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            destination = destination.appending(component: "categories")
            destination = destination.appending(path: "dogCategories")
            destination = destination.appendingPathExtension("json")
            XCTAssertTrue(FileManager.default.fileExists(atPath: destination.relativePath))
            XCTAssertEqual(categoryEngine.dogCategories.count, 0)
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
