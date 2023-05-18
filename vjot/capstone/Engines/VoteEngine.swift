//
//  VoteEngine.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import Foundation

@MainActor class VoteEngine: ObservableObject {
    
    @Published var catVotes: [Int] = []
    @Published var dogVotes: [Int] = []
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: INITIALIZATION
    // ------------------------------------------------------------------------
    
    init() {
        
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: FETCHING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func fetchCats(subId: String?) async throws -> [CatAPIVote] {
        
        var data = try await fetchAPIVotes(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forVotes,
            attachImage: true,      // dO NOT TOUCH
            subId: subId,
            page: nil,
            limit: nil,
            order: nil
        )
        
        // ::::::::::::::::::
        // SANITIZE JSON ::::
        // ::::::::::::::::::
        
        let string = String(decoding: data, as: UTF8.self)
        if  string.contains(#""image":{}"#) {
            
            // %%%%%%%%%%%%%%%%%%%%%%%%
            // CASE FAV 73051 %%%%%%%%%
            // %%%%%%%%%%%%%%%%%%%%%%%%
            
            let    sanitizedString: String = string.replacingOccurrences(of: #","image":{}"#, with: "")
            if let sanitizedData =  sanitizedString.data(using: .utf8) {
                            data =  sanitizedData
            }
        }
        
        let foldedVotes = try decodeCatAPIVotes(data: data)
        let votes = try unfoldCatAPIVotes(foldedCatAPIVotes: foldedVotes)
        
        return votes
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func fetchDogs(subId: String?) async throws -> [DogAPIVote] {
        
        var data = try await fetchAPIVotes(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forVotes,
            attachImage: true,      // dO NOT TOUCH!
            subId: subId,
            page: nil,
            limit: nil,
            order: nil
        )
        
        // ::::::::::::::::::
        // SANITIZE JSON ::::
        // ::::::::::::::::::
        
        let string = String(decoding: data, as: UTF8.self)
        if  string.contains(#""image":{}"#) {
            
            // %%%%%%%%%%%%%%%%%%%%%%%%
            // CASE FAV 73051 %%%%%%%%%
            // %%%%%%%%%%%%%%%%%%%%%%%%
            
            let    sanitizedString: String = string.replacingOccurrences(of: #","image":{}"#, with: "")
            if let sanitizedData =  sanitizedString.data(using: .utf8) {
                            data =  sanitizedData
            }
        }
        
        let foldedVotes = try decodeDogAPIVotes(data: data)
        let votes = try unfoldDogAPIVotes(foldedDogAPIVotes: foldedVotes)
        
        return votes
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////// MARK: FETCHING INDIVIDUAL
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func fetchCat(voteId: Int) async throws -> CatAPIVote {
        
        var data = try await fetchAPIIndividualVote(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forVotes,
            voteId: voteId
        )
        
        // ::::::::::::::::::
        // SANITIZE JSON ::::
        // ::::::::::::::::::
        
        let string = String(decoding: data, as: UTF8.self)
        if  string.contains(#""image":{}"#) {
            
            // %%%%%%%%%%%%%%%%%%%%%%%%
            // CASE FAV 73051 %%%%%%%%%
            // %%%%%%%%%%%%%%%%%%%%%%%%
            
            let    sanitizedString: String = string.replacingOccurrences(of: #","image":{}"#, with: "")
            if let sanitizedData =  sanitizedString.data(using: .utf8) {
                            data =  sanitizedData
            }
        }
        
        let foldedVote = try decodeCatAPIIndividualVote(data: data)
        let vote = try unfoldCatAPIVote(foldedCatAPIVote: foldedVote)
        
        return vote
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func fetchDog(voteId: Int) async throws -> DogAPIVote {
        
        var data = try await fetchAPIIndividualVote(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forVotes,
            voteId: voteId
        )
        
        // ::::::::::::::::::
        // SANITIZE JSON ::::
        // ::::::::::::::::::
        
        let string = String(decoding: data, as: UTF8.self)
        if  string.contains(#""image":{}"#) {
            
            // %%%%%%%%%%%%%%%%%%%%%%%%
            // CASE FAV 73051 %%%%%%%%%
            // %%%%%%%%%%%%%%%%%%%%%%%%
            
            let    sanitizedString: String = string.replacingOccurrences(of: #","image":{}"#, with: "")
            if let sanitizedData =  sanitizedString.data(using: .utf8) {
                            data =  sanitizedData
            }
        }
        
        let foldedVote = try decodeDogAPIIndividualVote(data: data)
        let vote = try unfoldDogAPIVote(foldedDogAPIVote: foldedVote)
        
        return vote
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////// MARK: POSTING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func postCat(imageId: String, subId: UUID, value: Int) async throws -> APIVotePostStatus {
        let data = try await postAPIVote(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forVotes,
            imageId: imageId,
            subId: subId.uuidString,
            value: value
        )
        
        let foldedStatus = try JSONDecoder().decode(FoldedAPIVotePostStatus.self, from: data)
        let status = try unfoldAPIVotePostStatus(foldedAPIVotePostStatus: foldedStatus)
        
        return status
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func postDog(imageId: String, subId: UUID, value: Int) async throws -> APIVotePostStatus {
        let data = try await postAPIVote(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forVotes,
            imageId: imageId,
            subId: subId.uuidString,
            value: value
        )
        
        let foldedStatus = try JSONDecoder().decode(FoldedAPIVotePostStatus.self, from: data)
        let status = try unfoldAPIVotePostStatus(foldedAPIVotePostStatus: foldedStatus)
        
        return status
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: DELETING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func deleteCat(voteId: Int) async throws -> APIVoteDeleteStatus {
        let data = try await deleteAPIVote(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forVotes,
            voteId: voteId
        )
        
        let foldedStatus = try JSONDecoder().decode(FoldedAPIVoteDeleteStatus.self, from: data)
        let status = try unfoldAPIVoteDeleteStatus(foldedAPIVoteDeleteStatus: foldedStatus)
        
        return status
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func deleteDog(voteId: Int) async throws -> APIVoteDeleteStatus {
        let data = try await deleteAPIVote(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forVotes,
            voteId: voteId
        )
        
        let foldedStatus = try JSONDecoder().decode(FoldedAPIVoteDeleteStatus.self, from: data)
        let status = try unfoldAPIVoteDeleteStatus(foldedAPIVoteDeleteStatus: foldedStatus)
        
        return status
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: GROUPING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func dictCats(votes: [CatAPIVote]) -> [UUID: [CatAPIVote]] {
        let subIds: [UUID] = votes.map { vote in
            if let subId = vote.subId {
                return subId
            }
            return UUID()
        }
        var dict: [UUID: [CatAPIVote]] = [:]
        subIds.forEach { subId in
            let subVotes = votes.filter { vote in
                vote.subId == subId
            }
            dict[subId] = subVotes
        }
        return dict
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func dictDogs(votes: [DogAPIVote]) -> [UUID: [DogAPIVote]] {
        let subIds: [UUID] = votes.map { vote in
            if let subId = vote.subId {
                return subId
            }
            return UUID()
        }
        var dict: [UUID: [DogAPIVote]] = [:]
        subIds.forEach { subId in
            let subVotes = votes.filter { vote in
                vote.subId == subId
            }
            dict[subId] = subVotes
        }
        return dict
    }
}
