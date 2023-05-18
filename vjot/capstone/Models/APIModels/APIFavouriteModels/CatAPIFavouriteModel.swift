//
//  CatAPIFavouriteModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD FAVOURITE (CAT)

struct CatAPIFavourite {
    var id: Int
    var userId: String?
    var imageId: String
    var subId: UUID
    var createdAt: Date
    var image: CatAPIImage?
//    var image: CatAPIFavouriteImage?
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldCatAPIFavourite(foldedCatAPIFavourite: FoldedCatAPIFavourite) throws -> CatAPIFavourite {
    let id = foldedCatAPIFavourite.id
    
    var userId: String? = nil
    if let foldedCatAPIFavouriteUserId = foldedCatAPIFavourite.userId {
        userId = foldedCatAPIFavouriteUserId
    }
    
    let imageId = foldedCatAPIFavourite.imageId
    
    var subId: UUID = UUID()
    if let foldedCatAPIFavouriteSubId = UUID(uuidString: foldedCatAPIFavourite.subId) {
        subId = foldedCatAPIFavouriteSubId
    } else {
        // fatalError("ATTEMPTED TO UNFOLD INVALID UUID STRING")
        throw VJotError.id
    }
    
    let createdAt = foldedCatAPIFavourite.createdAt
    
    var image: CatAPIImage? = nil
    if let foldedCatAPIFavouriteImage = foldedCatAPIFavourite.image {
        image = try unfoldCatAPIImage(foldedCatAPIImage: foldedCatAPIFavouriteImage)
    }
    
//    var image: CatAPIFavouriteImage? = nil
//    if let foldedCatAPIFavouriteImage = foldedCatAPIFavourite.image {
//        image = unfoldCatAPIFavouriteImage(foldedCatAPIFavouriteImage: foldedCatAPIFavouriteImage)
//    }
    
    return CatAPIFavourite(
        id: id,
        userId: userId,
        imageId: imageId,
        subId: subId,
        createdAt: createdAt,
        image: image
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldCatAPIFavourites(foldedCatAPIFavourites: [FoldedCatAPIFavourite]) throws -> [CatAPIFavourite] {
    var catAPIFavourites: [CatAPIFavourite] = []
    
    try foldedCatAPIFavourites.forEach { foldedCatAPIFavourite in
        catAPIFavourites.append(try unfoldCatAPIFavourite(foldedCatAPIFavourite: foldedCatAPIFavourite))
    }
    
    return catAPIFavourites
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
