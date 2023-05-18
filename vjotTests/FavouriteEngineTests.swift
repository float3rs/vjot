//
//  FavouriteEngineTests.swift
//  Saridakis-vjotTests
//
//  Created by Nikolaos Saridakis on 30/4/23.
//

import XCTest
import SwiftUI

@testable import vjot

final class FavouriteEngineTests: XCTestCase {
    
    var favouriteEngine: FavouriteEngine!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
            favouriteEngine = FavouriteEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        favouriteEngine = nil
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
    func test_processingCatFavourite() {
        
        let postExpectation = expectation(description: "CAT FAVOURITE: POSTED")
        let fetchExpectation = expectation(description: "CAT FAVOURITES: FETCHED")
        let fetchPostedExpectation = expectation(description: "CAT POSTED FAVOURITE: FETCHED")
        let deletePostedExpectation = expectation(description: "CAT POSTED FAVOURITE: DELETED")
        
        defer { waitForExpectations(timeout: 180) }
        
        let uuid = UUID()
        var id = Int()
        
        Task.init {
            let postStatus = try await favouriteEngine.postCat(
                imageId: "0XYvRd7oD",
                subId: uuid
            )
            id = postStatus.id!
            XCTAssertEqual(postStatus.message, "SUCCESS")
            postExpectation.fulfill()
            
            sleep(10)
            
            var favourites = try await favouriteEngine.fetchCats(
                imageId: "0XYvRd7oD",
                subId: uuid.uuidString
            )
            XCTAssertEqual(favourites.count, 1)
            fetchExpectation.fulfill()
            
            sleep(10)
            
            let favourite = try await favouriteEngine.fetchCat(
                favouriteId: id
            )
            XCTAssertEqual(favourite.imageId, "0XYvRd7oD")
            XCTAssertEqual(favourite.subId, uuid)
            fetchPostedExpectation.fulfill()

            sleep(10)

            let deleteStatus = try await favouriteEngine.deleteCat(
                favouriteId: id
            )
            XCTAssertEqual(deleteStatus.message, "SUCCESS")
            deletePostedExpectation.fulfill()
            
            sleep(10)
            
            favourites = try await favouriteEngine.fetchCats(
                imageId: "0XYvRd7oD",
                subId: uuid.uuidString
            )
            XCTAssertEqual(favourites.count, 0)
        }
    }
    
    @MainActor
    func test_processingDogFavourite() {
        
        let postExpectation = expectation(description: "DOG FAVOURITE: POSTED")
        let fetchExpectation = expectation(description: "DOG FAVOURITES: FETCHED")
        let fetchPostedExpectation = expectation(description: "DOG POSTED FAVOURITE: FETCHED")
        let deletePostedExpectation = expectation(description: "DOG POSTED FAVOURITE: DELETED")
        
        defer { waitForExpectations(timeout: 180) }
        
        let uuid = UUID()
        var id = Int()
        
        Task.init {
            let postStatus = try await favouriteEngine.postDog(
                imageId: "BJa4kxc4X",
                subId: uuid
            )
            id = postStatus.id!
            XCTAssertEqual(postStatus.message, "SUCCESS")
            postExpectation.fulfill()
            
            sleep(10)
            
            var favourites = try await favouriteEngine.fetchDogs(
                imageId: "BJa4kxc4X",
                subId: uuid.uuidString
            )
            XCTAssertEqual(favourites.count, 1)
            fetchExpectation.fulfill()
            
            sleep(10)
            
            let favourite = try await favouriteEngine.fetchDog(
                favouriteId: id
            )
            XCTAssertEqual(favourite.imageId, "BJa4kxc4X")
            XCTAssertEqual(favourite.subId, uuid)
            fetchPostedExpectation.fulfill()

            sleep(10)

            let deleteStatus = try await favouriteEngine.deleteDog(
                favouriteId: id
            )
            XCTAssertEqual(deleteStatus.message, "SUCCESS")
            deletePostedExpectation.fulfill()
            
            sleep(10)
            
            favourites = try await favouriteEngine.fetchDogs(
                imageId: "BJa4kxc4X",
                subId: uuid.uuidString
            )
            XCTAssertEqual(favourites.count, 0)
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
