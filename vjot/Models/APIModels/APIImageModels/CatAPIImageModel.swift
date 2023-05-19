//
//  CatAPIImageModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD (CAT IMAGES)

struct CatAPIImage {
    var id: String
    var url: URL?
    var width: Int?
    var height: Int?
    
    var breeds: [CatAPIBreed]?
    var categories: [CatAPICategory]?
    
    var mimeType: String?
    var breedIds: [String]?                                   // [Int] for DOGS
    
    var subId: UUID?
    var createdAt: Date?
    var originalFilename: String?
}

extension CatAPIImage: Equatable {
    static func == (lhs: CatAPIImage, rhs: CatAPIImage) -> Bool {
        lhs.id == rhs.id
    }
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldCatAPIImage(foldedCatAPIImage: FoldedCatAPIImage) throws -> CatAPIImage {
    
    func unfoldTo(array foldedString: String?) -> [String]? {
        if let foldedString = foldedString {
            return foldedString.components(separatedBy: ", ")
        }
        return nil
    }
    
    let id = foldedCatAPIImage.id
    let url = URL(string: foldedCatAPIImage.url)
    
    var width: Int? = nil
    if let foldedCatAPIImageWidth = foldedCatAPIImage.width {
        width = foldedCatAPIImageWidth
    }
    var height: Int? = nil
    if let foldedCatAPIImageHeight = foldedCatAPIImage.height {
        height = foldedCatAPIImageHeight
    }
    
    // ------------------------------------------------------------------------
    
    var breeds: [CatAPIBreed]? = nil
    if let foldedCatAPIImageBreeds = foldedCatAPIImage.breeds {
        breeds = unfoldCatAPIBreeds(foldedCatAPIBreeds: foldedCatAPIImageBreeds)
    }
    var categories: [CatAPICategory]? = nil
    if let foldedCatAPIImageCategories = foldedCatAPIImage.categories {
        categories = unfoldCatAPICategories(foldedCatAPICategories: foldedCatAPIImageCategories)
    }
    
    // ------------------------------------------------------------------------
    
    var mimeType: String? = nil
    if let foldedCatAPIImageMimeType = foldedCatAPIImage.mimeType {
        mimeType = foldedCatAPIImageMimeType
    }
    
    let breedIds = unfoldTo(array: foldedCatAPIImage.breedIds)
    
    var subId: UUID? = nil
    if let foldedCatAPIImageSubId = foldedCatAPIImage.subId {
        if let uuid = UUID(uuidString: foldedCatAPIImageSubId) {
            subId = uuid
        } else {
            // fatalError("ATTEMPTED TO UNFOLD INVALID UUID STRING")
            throw VJotError.id
        }
    }
    
    var createdAt: Date? = nil
    if let foldedCatAPIImageCreatedAt = foldedCatAPIImage.createdAt {
        createdAt = foldedCatAPIImageCreatedAt
    }
    
    var originalFilename: String? = nil
    if let foldedCatAPIImageOriginalFilename = foldedCatAPIImage.originalFilename {
        originalFilename = foldedCatAPIImageOriginalFilename
    }
    
    return CatAPIImage(
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

func unfoldCatAPIImages(foldedCatAPIImages: [FoldedCatAPIImage]) throws -> [CatAPIImage] {
    var catAPIImages: [CatAPIImage] = []
    
    try foldedCatAPIImages.forEach { foldedCatAPIImage in
        catAPIImages.append(try unfoldCatAPIImage(foldedCatAPIImage: foldedCatAPIImage))
    }
        
    return catAPIImages
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
