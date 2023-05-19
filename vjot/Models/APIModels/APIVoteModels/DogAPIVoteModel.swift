//
//  DogAPIVoteModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-26.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD VOTE (CAT)

struct DogAPIVote {
    var id: Int
    var imageId: String
    var subId: UUID?
    var value: Int
    var createdAt: Date?
    var countryCode: String?
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

func unfoldDogAPIVote(foldedDogAPIVote: FoldedDogAPIVote) throws -> DogAPIVote {
    let id = foldedDogAPIVote.id
    let imageId = foldedDogAPIVote.imageId
    
    var subId: UUID? = nil
    if let foldedDogAPIVoteSubId = foldedDogAPIVote.subId {
        if let uuid = UUID(uuidString: foldedDogAPIVoteSubId) {
            subId = uuid
        } else {
        // fatalError("ATTEMPTED TO UNFOLD INVALID UUID STRING")
        throw VJotError.id
        }
    }
    
    let value = foldedDogAPIVote.value
    
    var createdAt: Date? = nil
    if let foldedDogAPIVoteCreatedAt = foldedDogAPIVote.createdAt {
        createdAt = foldedDogAPIVoteCreatedAt
    }
    var countryCode: String? = nil
    if let foldedDogAPIVoteCountryCode = foldedDogAPIVote.countryCode {
        countryCode = foldedDogAPIVoteCountryCode
    }
    
    var image: DogAPIImage? = nil
    if let foldedDogAPIVoteImage = foldedDogAPIVote.image {
        image = try unfoldDogAPIImage(foldedDogAPIImage: foldedDogAPIVoteImage)
    }
    
    return DogAPIVote(
        id: id,
        imageId: imageId,
        subId: subId,
        value: value,
        createdAt: createdAt,
        countryCode: countryCode,
        image: image
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldDogAPIVotes(foldedDogAPIVotes: [FoldedDogAPIVote]) throws -> [DogAPIVote] {
    var dogAPIVotes: [DogAPIVote] = []
    
    try foldedDogAPIVotes.forEach { foldedDogAPIVote in
        dogAPIVotes.append( try unfoldDogAPIVote(foldedDogAPIVote: foldedDogAPIVote))
    }
    
    return dogAPIVotes
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
