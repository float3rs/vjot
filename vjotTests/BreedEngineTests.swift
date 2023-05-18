//
//  BreedEngineTests.swift
//  Saridakis-vjotTests
//
//  Created by Nikolaos Saridakis on 30/4/23.
//

import XCTest
import SwiftUI

@testable import vjot
final class BreedEngineTests: XCTestCase {
    
    var breedEngine: BreedEngine!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        breedEngine = BreedEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        breedEngine = nil
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
    func test_fetchingCatBreeds() {
        let expectation = expectation(description: "CAT BREEDS: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            breedEngine.catBreeds = []
            try await breedEngine.fetch(.forCats, limit: nil, page: nil)
            XCTAssertNotEqual(breedEngine.catBreeds.count, 0)
        }
    }
    
    @MainActor
    func test_fetchingDogBreeds() {
        let expectation = expectation(description: "DOG BREEDS FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            breedEngine.dogBreeds = []
            try await breedEngine.fetch(.forDogs, limit: nil, page: nil)
            XCTAssertNotEqual(breedEngine.dogBreeds.count, 0)
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_savingCatBreeds() {
        let expectation = expectation(description: "CAT BREEDS: SAVED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            breedEngine.catBreeds = []
            try await breedEngine.fetch(.forCats, limit: nil, page: nil)
            XCTAssertNoThrow(try breedEngine.save(.forCats))
            var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            destination = destination.appending(component: "breeds")
            destination = destination.appending(path: "catBreeds")
            destination = destination.appendingPathExtension("json")
            XCTAssertTrue(FileManager.default.fileExists(atPath: destination.relativePath))
        }
    }
    
    @MainActor
    func test_savingDogBreeds() {
        let expectation = expectation(description: "DOG BREEDS: SAVED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            breedEngine.dogBreeds = []
            try await breedEngine.fetch(.forDogs, limit: nil, page: nil)
            XCTAssertNoThrow(try breedEngine.save(.forDogs))
            var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            destination = destination.appending(component: "breeds")
            destination = destination.appending(path: "dogBreeds")
            destination = destination.appendingPathExtension("json")
            XCTAssertTrue(FileManager.default.fileExists(atPath: destination.relativePath))
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_loadingCatBreeds() {
        let expectation = expectation(description: "CAT BREEDS: LOADED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            breedEngine.catBreeds = []
            try await breedEngine.fetch(.forCats, limit: nil, page: nil)
            try breedEngine.save(.forCats)
            XCTAssertNoThrow(try breedEngine.load(.forCats))
            XCTAssertNotEqual(breedEngine.catBreeds.count, 0)
        }
    }
    
    @MainActor
    func test_loadingDogBreeds() {
        let expectation = expectation(description: "DOG BREEDS: LOADED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            breedEngine.dogBreeds = []
            try await breedEngine.fetch(.forDogs, limit: nil, page: nil)
            try breedEngine.save(.forDogs)
            XCTAssertNoThrow(try breedEngine.load(.forDogs))
            XCTAssertNotEqual(breedEngine.dogBreeds.count, 0)
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_fallbackingCatBreeds() {
        breedEngine.catBreeds = []
        XCTAssertNoThrow(try breedEngine.fallback(.forCats))
        XCTAssertNotEqual(breedEngine.catBreeds.count, 0)
    }
    
    @MainActor
    func test_fallbackingDogBreeds() {
        breedEngine.dogBreeds = []
        XCTAssertNoThrow(try breedEngine.fallback(.forDogs))
        XCTAssertNotEqual(breedEngine.dogBreeds.count, 0)
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_refreshingCatBreeds() {
        let expectation = expectation(description: "CAT BREEDS: REFRESHED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            breedEngine.catBreeds = []
            try await breedEngine.refresh(.forCats)
            var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            destination = destination.appending(component: "breeds")
            destination = destination.appending(path: "catBreeds")
            destination = destination.appendingPathExtension("json")
            XCTAssertTrue(FileManager.default.fileExists(atPath: destination.relativePath))
            XCTAssertNotEqual(breedEngine.catBreeds.count, 0)
        }
    }
    
    @MainActor
    func test_refreshingDogBreeds() {
        let expectation = expectation(description: "DOG BREEDS: REFRESHED")
        defer { waitForExpectations(timeout: 60) }
        Task.init {
            defer { expectation.fulfill() }
            breedEngine.dogBreeds = []
            try await breedEngine.refresh(.forDogs)
            var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            destination = destination.appending(component: "breeds")
            destination = destination.appending(path: "dogBreeds")
            destination = destination.appendingPathExtension("json")
            XCTAssertTrue(FileManager.default.fileExists(atPath: destination.relativePath))
            XCTAssertNotEqual(breedEngine.dogBreeds.count, 0)
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
