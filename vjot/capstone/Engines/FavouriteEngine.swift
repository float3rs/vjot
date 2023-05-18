//
//  FavouriteEngine.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 18/4/23.
//

import Foundation

@MainActor class FavouriteEngine: ObservableObject {
    
    @Published var catFavourites: [Int] = []
    @Published var dogFavourites: [Int] = []
    
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
    
    func fetchCats(imageId: String?, subId: String?) async throws -> [CatAPIFavourite] {
        
        var data = try await fetchAPIFavourites(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forFavourites,
            attachImage: nil,
            imageId: imageId,
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
            
            // %%%%%%%%%%%%%%
            // CASE 73051 %%%
            // %%%%%%%%%%%%%%
            
            let    sanitizedString: String = string.replacingOccurrences(of: #","image":{}"#, with: "")
            if let sanitizedData =  sanitizedString.data(using: .utf8) {
                            data =  sanitizedData
            }
        }
        
        let foldedFavourites = try decodeCatAPIFavourites(data: data)
        let favoutites = try unfoldCatAPIFavourites(foldedCatAPIFavourites: foldedFavourites)
        
        return favoutites
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func fetchDogs(imageId: String?, subId: String?) async throws -> [DogAPIFavourite] {
        
        var data = try await fetchAPIFavourites(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forFavourites,
            attachImage: nil,
            imageId: imageId,
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
            
            // %%%%%%%%%%%%%%
            // CASE 73051 %%%
            // %%%%%%%%%%%%%%
            
            let    sanitizedString: String = string.replacingOccurrences(of: #","image":{}"#, with: "")
            if let sanitizedData =  sanitizedString.data(using: .utf8) {
                            data =  sanitizedData
            }
        }
        
        
        let foldedFavourites = try decodeDogAPIFavourites(data: data)
        let favoutites = try unfoldDogAPIFavourites(foldedDogAPIFavourites: foldedFavourites)
        
        return favoutites
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////// MARK: FETCHING INDIVIDUAL
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func fetchCat(favouriteId: Int) async throws -> CatAPIFavourite {
        
        var data = try await fetchAPIIndividualFavourite(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forFavourites,
            favouriteId: favouriteId
        )
        
        // ::::::::::::::::::
        // SANITIZE JSON ::::
        // ::::::::::::::::::
        
        let string = String(decoding: data, as: UTF8.self)
        if  string.contains(#""image":{}"#) {
            
            // %%%%%%%%%%%%%%
            // CASE 73051 %%%
            // %%%%%%%%%%%%%%
            
            let    sanitizedString: String = string.replacingOccurrences(of: #","image":{}"#, with: "")
            if let sanitizedData =  sanitizedString.data(using: .utf8) {
                            data =  sanitizedData
            }
        }
    
        let foldedFavourite = try decodeCatAPIIndividualFavourite(data: data)
        let favourite = try unfoldCatAPIFavourite(foldedCatAPIFavourite: foldedFavourite)
        
        return favourite
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func fetchDog(favouriteId: Int) async throws -> DogAPIFavourite {
        
        var data = try await fetchAPIIndividualFavourite(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forFavourites,
            favouriteId: favouriteId
        )
        
        // {
        //     "id":73051,
        //     "user_id":"bwdm35",
        //     "image_id":"03LaPbfH6",
        //     "sub_id":"5E010003-0D56-4357-A2C9-4B9389CAF202",
        //     "created_at":"2023-04-21T11:58:19.000Z",
        //     "image":
        //     {
        //                  <- WTF
        //     }
        // }
        
        // ::::::::::::::::::
        // SANITIZE JSON ::::
        // ::::::::::::::::::
        
        let string = String(decoding: data, as: UTF8.self)
        if  string.contains(#""image":{}"#) {
            
            // %%%%%%%%%%%%%%
            // CASE 73051 %%%
            // %%%%%%%%%%%%%%
            
            let    sanitizedString: String = string.replacingOccurrences(of: #","image":{}"#, with: "")
            if let sanitizedData =  sanitizedString.data(using: .utf8) {
                            data =  sanitizedData
            }
        }
        
        let foldedFavourite = try decodeDogAPIIndividualFavourite(data: data)
        let favourite = try unfoldDogAPIFavourite(foldedDogAPIFavourite: foldedFavourite)
        
        return favourite
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////// MARK: POSTING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func postCat(imageId: String, subId: UUID) async throws -> APIFavouritePostStatus {
        let data = try await postAPIFavourite(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            imageId: imageId,
            subId: subId.uuidString
        )
        
        let responce = try JSONDecoder().decode(APIFavouritePostStatus.self, from: data)
        return responce
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func postDog(imageId: String, subId: UUID) async throws -> APIFavouritePostStatus {
        let data = try await postAPIFavourite(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            imageId: imageId,
            subId: subId.uuidString
        )
        
        let responce = try JSONDecoder().decode(APIFavouritePostStatus.self, from: data)
        return responce
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: DELETING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func deleteCat(favouriteId: Int) async throws -> APIFavouriteDeleteStatus {
        let data = try await deleteAPIFavourite(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            favouriteId: favouriteId
        )
        
        let responce = try JSONDecoder().decode(APIFavouriteDeleteStatus.self, from: data)
        return responce
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func deleteDog(favouriteId: Int) async throws -> APIFavouriteDeleteStatus {
        let data = try await deleteAPIFavourite(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            favouriteId: favouriteId
        )
        
        let responce = try JSONDecoder().decode(APIFavouriteDeleteStatus.self, from: data)
        return responce
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: GROUPING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func dictCats(favourites: [CatAPIFavourite]) -> [UUID: [CatAPIFavourite]] {
        let subIds: [UUID] = favourites.map { favourite in
            return favourite.subId
        }
        var dict: [UUID: [CatAPIFavourite]] = [:]
        subIds.forEach { subId in
            let subFavs = favourites.filter { favourite in
                favourite.subId == subId
            }
            dict[subId] = subFavs
        }
        return dict
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func dictDogs(favourites: [DogAPIFavourite]) -> [UUID: [DogAPIFavourite]] {
        let subIds: [UUID] = favourites.map { favourite in
            return favourite.subId
        }
        var dict: [UUID: [DogAPIFavourite]] = [:]
        subIds.forEach { subId in
            let subFavs = favourites.filter { favourite in
                favourite.subId == subId
            }
            dict[subId] = subFavs
        }
        return dict
    }
}
