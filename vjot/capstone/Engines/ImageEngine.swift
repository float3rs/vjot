//
//  ImageEngine.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 6/4/23.
//

import Foundation
import SwiftUI

@MainActor class ImageEngine: ObservableObject {
    
    @Published var catBreedIds: [String] = []
    @Published var dogBreedIds: [Int] = []
    @Published var catCategoryIds: [Int] = []
    @Published var dogCategoryIds: [Int] = []
    @Published var uploadedCatBreedIds: [String] = []
    @Published var uploadedDogBreedIds: [Int] = []
    @Published var uploadedCatCategoryIds: [Int] = []
    @Published var uploadedDogCategoryIds: [Int] = []
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: FETCHING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func fetchCats(
        typesShown: Bool,
        type: APIMimeType,
        size: APISize,
        count: Int,
        mixedExcluded: Bool
    ) async throws -> [CatAPIImage] {
        
        var mimeTypes: [APIMimeType] = []
        if typesShown {
            mimeTypes.append(type)
        } else {
            mimeTypes = [.jpg, .png]
        }
        
        var hasBreeds = false
        if mixedExcluded || !catBreedIds.isEmpty {
            hasBreeds = true
        }
        
        let data = try await fetchCatAPIImages(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forImages,
            size: size,
            mimeTypes: mimeTypes,
            format: .json,
            order: .random,
            page: 0,
            limit: count,
            categoryIds: catCategoryIds,
            breedIds: catBreedIds,
            hasBreeds: hasBreeds,
            includeBreeds: true,
            includeCategories: true
        )
        
        let foldedImages = try decodeCatAPIImages(data: data)
        let images = try unfoldCatAPIImages(foldedCatAPIImages: foldedImages)
        return images
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func fetchDogs(
        typesShown: Bool,
        type: APIMimeType,
        size: APISize,
        count: Int,
        mixedExcluded: Bool
    ) async throws -> [DogAPIImage] {
        
        var mimeTypes: [APIMimeType] = []
        if typesShown {
            mimeTypes.append(type)
        } else {
            mimeTypes = [.jpg, .png]
        }
        
        var hasBreeds = false
        if mixedExcluded || !dogBreedIds.isEmpty {
            hasBreeds = true
        }
        
        let data = try await fetchDogAPIImages(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forImages,
            size: size,
            mimeTypes: mimeTypes,
            format: .json,
            order: .random,
            page: 0,
            limit: count,
            categoryIds: dogCategoryIds,
            breedIds: dogBreedIds,
            hasBreeds: hasBreeds,
            includeBreeds: true,
            includeCategories: true
        )
        
        let foldedImages = try decodeDogAPIImages(data: data)
        let images = try unfoldDogAPIImages(foldedDogAPIImages: foldedImages)
        return images
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////// MARK: FETCHING INDIVIDUAL
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func fetchCat(
        imageId: String,
        subId: String?,
        size: APISize?
    ) async throws -> CatAPIImage {
        
        let data = try await fetchCatAPIIndividualImage(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forImages,
            imageId: imageId,
            subId: subId,
            size: size,
            includeVote: true,
            includeFavourite: true
        )
        
        let foldedImage = try decodeCatAPIIndividualImage(data: data)
        let image = try unfoldCatAPIImage(foldedCatAPIImage: foldedImage)
        return image
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func fetchDog(
        imageId: String,
        subId: String?,
        size: APISize?
    ) async throws -> DogAPIImage {
        
        let data = try await fetchDogAPIIndividualImage(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forImages,
            imageId: imageId,
            subId: subId,
            size: size,
            includeVote: true,
            includeFavourite: true
        )
        
        let foldedImage = try decodeDogAPIIndividualImage(data: data)
        let image = try unfoldDogAPIImage(foldedDogAPIImage: foldedImage)
        return image
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////// MARK: FETCHING INDIVIDUAL
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func fetchUploadedCats(
        limit: Int,
        subId: String,
        originalFilename: String
    ) async throws -> [CatAPIImage] {
        
        let data = try await fetchCatAPIUploadedImages(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forImages,
            limit: limit,
            page: nil,
            order: nil,
            subId: subId,
            breedIds: uploadedCatBreedIds,
            categoryIds: uploadedCatCategoryIds,
            format: .json,
            originalFilename: originalFilename
        )
        
        let foldedUploadedImages = try decodeCatAPIUploadedImages(data: data)
        let uploadedImages = try unfoldCatAPIImages(foldedCatAPIImages: foldedUploadedImages)
        return uploadedImages
    }
    
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ DOGS
    // ------------------------------------------------------------------------
    
    func fetchUploadedDogs(
        limit: Int,
        subId: String,
        originalFilename: String
    ) async throws -> [DogAPIImage] {
        
        let data = try await fetchDogAPIUploadedImages(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forImages,
            limit: limit,
            page: nil,
            order: nil,
            subId: subId,
            breedIds: uploadedDogBreedIds,
            categoryIds: uploadedDogCategoryIds,
            format: .json,
            originalFilename: originalFilename
        )
        
        let foldedUploadedImages = try decodeDogAPIUploadedImages(data: data)
        let uploadedImages = try unfoldDogAPIImages(foldedDogAPIImages: foldedUploadedImages)
        return uploadedImages
    }
    
    // ------------------------------------------------------------------------
    // //////////////////////////////////////////////////////// MARK: UPLOADING
    // ------------------------------------------------------------------------
    
    func upload(_ forSpecies: ForSpecies, file: UIImage, subId: UUID?) async throws -> APIImageUploadStatus {
         
        switch forSpecies {
        case .forCats:
            
            let data = try await uploadAPIImage(
                apiEndpoint: .forCats,
                apiVersion: .v1,
                apiPath: .forImages,
                file: file,
                subId: subId
            )
            
            let foldedUploadStatus = try decodeAPIImageUploadStatus(data: data)
            let uploadStatus = try unfoldAPIImageUploadStatus(foldedAPIImageUploadStatus: foldedUploadStatus)
            
            return uploadStatus
            
        case .forDogs:
            
            let data = try await uploadAPIImage(
                apiEndpoint: .forDogs,
                apiVersion: .v1,
                apiPath: .forImages,
                file: file,
                subId: subId
            )
            
            let foldedUploadStatus = try decodeAPIImageUploadStatus(data: data)
            let uploadStatus = try unfoldAPIImageUploadStatus(foldedAPIImageUploadStatus: foldedUploadStatus)
            
            return uploadStatus
        }
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: DELETING
    // ------------------------------------------------------------------------
    
    func delete(_ forSpecies: ForSpecies, imageId: String) async throws {
        
        switch forSpecies {
        case .forCats:
            
            _ = try await deleteAPIUploadedImage(
                apiEndpoint: .forCats,
                apiVersion: .v1,
                imageId: imageId
            )
            
        case .forDogs:
            
            _ = try await deleteAPIUploadedImage(
                apiEndpoint: .forDogs,
                apiVersion: .v1,
                imageId: imageId
            )
        }
    }
}

