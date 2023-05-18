//
//  DogAPIImageModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD (DOG IMAGES)

struct DogAPIImage {
    var id: String
    var url: URL?
    var width: Int?
    var height: Int?
    
    var breeds: [DogAPIBreed]?
    var categories: [DogAPICategory]?
    
    var mimeType: String?
    var breedIds: [Int]?                                   // [String] for CATS
    
    var subId: UUID?
    var createdAt: Date?
    var originalFilename: String?
}

extension DogAPIImage: Equatable {
    static func == (lhs: DogAPIImage, rhs: DogAPIImage) -> Bool {
        lhs.id == rhs.id
    }
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldDogAPIImage(foldedDogAPIImage: FoldedDogAPIImage) throws -> DogAPIImage {
    
    func unfoldTo(array foldedString: String?) -> [String]? {
        if let foldedString = foldedString {
            return foldedString.components(separatedBy: ", ")
        }
        return nil
    }
    
    let id = foldedDogAPIImage.id
    let url = URL(string: foldedDogAPIImage.url)
    
    var width: Int? = nil
    if let foldedDogAPIImageWidth = foldedDogAPIImage.width {
        width = foldedDogAPIImageWidth
    }
    var height: Int? = nil
    if let foldedDogAPIImageHeight = foldedDogAPIImage.height {
        height = foldedDogAPIImageHeight
    }
    
    // ------------------------------------------------------------------------
    
    var breeds: [DogAPIBreed]? = nil
    if let foldedDogAPIImageBreeds = foldedDogAPIImage.breeds {
        breeds = unfoldDogAPIBreeds(foldedDogAPIBreeds: foldedDogAPIImageBreeds)
    }
    var categories: [DogAPICategory]? = nil
    if let foldedDogAPIImageCategories = foldedDogAPIImage.categories {
        categories = unfoldDogAPICategories(foldedDogAPICategories: foldedDogAPIImageCategories)
    }
    
    // ------------------------------------------------------------------------
    
    var mimeType: String? = nil
    if let foldedDogAPIImageMimeType = foldedDogAPIImage.mimeType {
        mimeType = foldedDogAPIImageMimeType
    }
    
    let strAPIBreedIds: [String]? = unfoldTo(array: foldedDogAPIImage.breedIds)
    var breedIds: [Int]?
    if let strAPIBreedIds = strAPIBreedIds {
        strAPIBreedIds.forEach({ strAPIBreedId in
            if let breedInt = Int(strAPIBreedId) {
                breedIds?.append(breedInt)
            }
        })
    }
    
    var subId: UUID? = nil
    if let foldedDogAPIImageSubId = foldedDogAPIImage.subId {
        if let uuid = UUID(uuidString: foldedDogAPIImageSubId) {
            subId = uuid
        } else {
            // fatalError("ATTEMPTED TO UNFOLD INVALID UUID STRING")
            throw VJotError.id
        }
    }
    
    var createdAt: Date? = nil
    if let foldedDogAPIImageCreatedAt = foldedDogAPIImage.createdAt {
        createdAt = foldedDogAPIImageCreatedAt
    }
    
    var originalFilename: String? = nil
    if let foldedDogAPIImageOriginalFilename = foldedDogAPIImage.originalFilename {
        originalFilename = foldedDogAPIImageOriginalFilename
    }
    
    return DogAPIImage(
        id: id,
        url: url,
        width: width,
        height: height,
        breeds: breeds,
        categories: categories,
        mimeType: mimeType,
        breedIds: breedIds,
        subId: subId,
        createdAt: createdAt,
        originalFilename: originalFilename
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldDogAPIImages(foldedDogAPIImages: [FoldedDogAPIImage]) throws -> [DogAPIImage] {
    var dogAPIImages: [DogAPIImage] = []
    
    try foldedDogAPIImages.forEach { foldedDogAPIImage in
        dogAPIImages.append(try unfoldDogAPIImage(foldedDogAPIImage: foldedDogAPIImage))
    }
        
    return dogAPIImages
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
