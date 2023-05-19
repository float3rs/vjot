//
//  DogAPIFavouriteModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD FAVOURITE (Dog)

struct DogAPIFavourite {
    var id: Int
    var userId: String?
    var imageId: String
    var subId: UUID
    var createdAt: Date
    var image: DogAPIImage?
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

func unfoldDogAPIFavourite(foldedDogAPIFavourite: FoldedDogAPIFavourite) throws -> DogAPIFavourite {
    let id = foldedDogAPIFavourite.id
    
    var userId: String? = nil
    if let foldedDogAPIFavouriteUserId = foldedDogAPIFavourite.userId {
        userId = foldedDogAPIFavouriteUserId
    }
    
    let imageId = foldedDogAPIFavourite.imageId
    
    var subId: UUID = UUID()
    if let foldedDogAPIFavouriteSubId = UUID(uuidString: foldedDogAPIFavourite.subId) {
        subId = foldedDogAPIFavouriteSubId
    } else {
        // fatalError("ATTEMPTED TO UNFOLD INVALID UUID STRING")
        throw VJotError.id
    }
    
    let createdAt = foldedDogAPIFavourite.createdAt
    
    var image: DogAPIImage? = nil
    if let foldedDogAPIFavouriteImage = foldedDogAPIFavourite.image {
        image = try unfoldDogAPIImage(foldedDogAPIImage: foldedDogAPIFavouriteImage)
    }
    
    return DogAPIFavourite(
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

func unfoldDogAPIFavourites(foldedDogAPIFavourites: [FoldedDogAPIFavourite]) throws -> [DogAPIFavourite] {
    var dogAPIFavourites: [DogAPIFavourite] = []
    
    try foldedDogAPIFavourites.forEach { foldedDogAPIFavourite in
        dogAPIFavourites.append(try unfoldDogAPIFavourite(foldedDogAPIFavourite: foldedDogAPIFavourite))
    }
    
    return dogAPIFavourites
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
