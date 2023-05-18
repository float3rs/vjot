//
//  VoteEngineTests.swift
//  Saridakis-vjotTests
//
//  Created by Nikolaos Saridakis on 30/4/23.
//

import XCTest
import SwiftUI

@testable import vjot

final class VoteEngineTests: XCTestCase {
    
    var voteEngine: VoteEngine!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
            voteEngine = VoteEngine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        voteEngine = nil
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
    func test_processingCatVote() {
        
        let postExpectation = expectation(description: "CAT VOTE: POSTED")
        let fetchExpectation = expectation(description: "CAT VOTES: FETCHED")
        let fetchPostedExpectation = expectation(description: "CAT POSTED VOTE: FETCHED")
        let updateExpectation = expectation(description: "CAT POSTED VOTE: UPDATED")
        let fetchUpdatedExpectation = expectation(description: "CAT UPDATED VOTE: FETCHED")
        let deleteUpdatedExpectation = expectation(description: "CAT UPDATED VOTE: DELETED")
        
        defer { waitForExpectations(timeout: 180) }
        
        let uuid = UUID()
        var id = Int()
        
        Task.init {
            let postStatus = try await voteEngine.postCat(
                imageId: "0XYvRd7oD",
                subId: uuid,
                value: 42
            )
            id = postStatus.id!
            XCTAssertEqual(postStatus.message, "SUCCESS")
            XCTAssertEqual(postStatus.value, 42)
            postExpectation.fulfill()
            
            sleep(10)
            
            var votes = try await voteEngine.fetchCats(
                subId: uuid.uuidString
            )
            XCTAssertEqual(votes.count, 1)
            fetchExpectation.fulfill()
            
            sleep(10)
            
            let postedVote = try await voteEngine.fetchCat(
                voteId: id
            )
            XCTAssertEqual(postedVote.imageId, "0XYvRd7oD")
            XCTAssertEqual(postedVote.value, 42)
            XCTAssertEqual(postedVote.subId, uuid)
            fetchPostedExpectation.fulfill()

            sleep(10)
            
            let updateStatus = try await voteEngine.postCat(
                imageId: "0XYvRd7oD",
                subId: uuid,
                value: 69
            )
            id = updateStatus.id!
            XCTAssertEqual(updateStatus.message, "SUCCESS")
            XCTAssertEqual(updateStatus.value, 69)
            updateExpectation.fulfill()
            
            sleep(10)
            
            let updatedVote = try await voteEngine.fetchCat(
                voteId: id
            )
            XCTAssertEqual(updatedVote.imageId, "0XYvRd7oD")
            XCTAssertEqual(updatedVote.value, 69)
            XCTAssertEqual(updatedVote.subId, uuid)
            fetchUpdatedExpectation.fulfill()

            sleep(10)

            let deleteStatus = try await voteEngine.deleteCat(
                voteId: id
            )
            XCTAssertEqual(deleteStatus.message, "SUCCESS")
            deleteUpdatedExpectation.fulfill()
            
            sleep(10)
            
            votes = try await voteEngine.fetchCats(
                subId: uuid.uuidString
            )
            XCTAssertEqual(votes.count, 0)
        }
    }
    
    @MainActor
    func test_processingDogVote() {
        
        let postExpectation = expectation(description: "DOG VOTE: POSTED")
        let fetchExpectation = expectation(description: "DOG VOTES: FETCHED")
        let fetchPostedExpectation = expectation(description: "DOG POSTED VOTE: FETCHED")
        let updateExpectation = expectation(description: "DOG POSTED VOTE: UPDATED")
        let fetchUpdatedExpectation = expectation(description: "DOG UPDATED VOTE: FETCHED")
        let deleteUpdatedExpectation = expectation(description: "DOG UPDATED VOTE: DELETED")
        
        defer { waitForExpectations(timeout: 180) }
        
        let uuid = UUID()
        var id = Int()
        
        Task.init {
            let postStatus = try await voteEngine.postDog(
                imageId: "BJa4kxc4X",
                subId: uuid,
                value: 42
            )
            id = postStatus.id!
            XCTAssertEqual(postStatus.message, "SUCCESS")
            XCTAssertEqual(postStatus.value, 42)
            postExpectation.fulfill()
            
            sleep(10)
            
            var votes = try await voteEngine.fetchDogs(
                subId: uuid.uuidString
            )
            XCTAssertEqual(votes.count, 1)
            fetchExpectation.fulfill()
            
            sleep(10)
            
            let postedVote = try await voteEngine.fetchDog(
                voteId: id
            )
            XCTAssertEqual(postedVote.imageId, "BJa4kxc4X")
            XCTAssertEqual(postedVote.value, 42)
            XCTAssertEqual(postedVote.subId, uuid)
            fetchPostedExpectation.fulfill()

            sleep(10)
            
            let updateStatus = try await voteEngine.postDog(
                imageId: "BJa4kxc4X",
                subId: uuid,
                value: 69
            )
            id = updateStatus.id!
            XCTAssertEqual(updateStatus.message, "SUCCESS")
            XCTAssertEqual(updateStatus.value, 69)
            updateExpectation.fulfill()
            
            sleep(10)
            
            let updatedVote = try await voteEngine.fetchDog(
                voteId: id
            )
            XCTAssertEqual(updatedVote.imageId, "BJa4kxc4X")
            XCTAssertEqual(updatedVote.value, 69)
            XCTAssertEqual(updatedVote.subId, uuid)
            fetchUpdatedExpectation.fulfill()

            sleep(10)

            let deleteStatus = try await voteEngine.deleteDog(
                voteId: id
            )
            XCTAssertEqual(deleteStatus.message, "SUCCESS")
            deleteUpdatedExpectation.fulfill()
            
            sleep(10)
            
            votes = try await voteEngine.fetchDogs(
                subId: uuid.uuidString
            )
            XCTAssertEqual(votes.count, 0)
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
