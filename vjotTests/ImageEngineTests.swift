//
//  ImageEngineTests.swift
//  Saridakis-vjotTests
//
//  Created by Nikolaos Saridakis on 30/4/23.
//

import XCTest
import SwiftUI

@testable import vjot
final class ImageEngineTests: XCTestCase {
    
    var imageEngine: ImageEngine!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        imageEngine = ImageEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        imageEngine = nil
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
    func test_fetchingCatImages() {
        let expectation = expectation(description: "CAT IMAGES: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            let images = try await imageEngine.fetchCats(
                typesShown: true,
                type: .jpg,
                size: .medium,
                count: 1,
                mixedExcluded: false
            )
            XCTAssertNotEqual(images.count, 0)
        }
    }
    
    @MainActor
    func test_fetchingDogImages() {
        let expectation = expectation(description: "DOG IMAGES: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            let images = try await imageEngine.fetchDogs(
                typesShown: true,
                type: .jpg,
                size: .medium,
                count: 1,
                mixedExcluded: false
            )
            XCTAssertNotEqual(images.count, 0)
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_fetchingCatImage() {
        let expectation = expectation(description: "CAT INDIVIDUAL IMAGE: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            let image = try await imageEngine.fetchCat(
                imageId: "0XYvRd7oD",
                subId: nil,
                size: nil
            )
            XCTAssertEqual(image.id, "0XYvRd7oD")
        }
    }
    
    @MainActor
    func test_fetchingDogImage() {
        let expectation = expectation(description: "DOG INDIVIDUAL IMAGE: FETCHED")
        defer { waitForExpectations(timeout: 60) }
        
        Task.init {
            defer { expectation.fulfill() }
            let image = try await imageEngine.fetchDog(
                imageId: "BJa4kxc4X",
                subId: nil,
                size: nil
            )
            XCTAssertEqual(image.id, "BJa4kxc4X")
        }
    }
    
    // ////////////////////////////////////////////////////////////////////////
    
    @MainActor
    func test_processingCatImage() {
        
        let uploadExpectation = expectation(description: "SAMPLE CAT IMAGE: UPLOADED")
        let fetchUploadedExpectation = expectation(description: "SAMPLE CAT IMAGE: FETCHED")
        let deleteExpectation = expectation(description: "SAMPLE CAT IMAGE: DELETED")
        
        defer { waitForExpectations(timeout: 120) }
        
        let uuid = UUID()
        var id = String()
        
        XCTAssertNoThrow(
            Task.init {
                let path = Bundle.main.path(forResource: "sampleCat", ofType: ".jpg")!
                let image = UIImage(contentsOfFile: path)!
                let status = try await imageEngine.upload(
                    .forCats,
                    file: image,
                    subId: uuid
                )
                id = status.id
                XCTAssertEqual(status.approved, true)
                uploadExpectation.fulfill()
                
                sleep(10)
                
                let images = try await imageEngine.fetchUploadedCats(
                    limit: 1,
                    subId: uuid.uuidString,
                    originalFilename: String()
                )
                XCTAssertEqual(images.count, 1)
                XCTAssertEqual(images[0].id, id)
                fetchUploadedExpectation.fulfill()
                
                sleep(10)
                
                try await imageEngine.delete(.forCats, imageId: id)
                deleteExpectation.fulfill()
            }
        )
    }
    
    @MainActor
    func test_processingDogImage() {
        
        let uploadExpectation = expectation(description: "SAMPLE DOG IMAGE: UPLOADED")
        let fetchUploadedExpectation = expectation(description: "SAMPLE DOG IMAGE: FETCHED")
        let deleteExpectation = expectation(description: "SAMPLE DOG IMAGE: DELETED")
        
        defer { waitForExpectations(timeout: 120) }
        
        let uuid = UUID()
        var id = String()
        
        XCTAssertNoThrow(
            Task.init {
                let path = Bundle.main.path(forResource: "sampleDog", ofType: ".jpg")!
                let image = UIImage(contentsOfFile: path)!
                let status = try await imageEngine.upload(
                    .forDogs,
                    file: image,
                    subId: uuid
                )
                id = status.id
                XCTAssertEqual(status.approved, true)
                uploadExpectation.fulfill()
                
                sleep(10)
                
                let images = try await imageEngine.fetchUploadedDogs(
                    limit: 1,
                    subId: uuid.uuidString,
                    originalFilename: String()
                )
                XCTAssertEqual(images.count, 1)
                XCTAssertEqual(images[0].id, id)
                fetchUploadedExpectation.fulfill()
                
                sleep(10)
                
                try await imageEngine.delete(.forDogs, imageId: id)
                deleteExpectation.fulfill()
            }
        )
    }
    
    // ////////////////////////////////////////////////////////////////////////
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
