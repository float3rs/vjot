//
//  CatAPIVoteModel.swift
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

struct CatAPIVote {
    var id: Int
    var imageId: String
    var subId: UUID?
    var value: Int
    var createdAt: Date?
    var countryCode: String?
    var image: CatAPIImage?
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

func unfoldCatAPIVote(foldedCatAPIVote: FoldedCatAPIVote) throws -> CatAPIVote {
    let id = foldedCatAPIVote.id
    let imageId = foldedCatAPIVote.imageId
    
    var subId: UUID? = nil
    if let foldedCatAPIVoteSubId = foldedCatAPIVote.subId {
        if let uuid = UUID(uuidString: foldedCatAPIVoteSubId) {
            subId = uuid
        } else {
            // fatalError("ATTEMPTED TO UNFOLD INVALID UUID STRING")
            throw VJotError.id
        }
    }
    
    let value = foldedCatAPIVote.value
    
    var createdAt: Date? = nil
    if let foldedCatAPIVoteCreatedAt = foldedCatAPIVote.createdAt {
        createdAt = foldedCatAPIVoteCreatedAt
    }
    var countryCode: String? = nil
    if let foldedCatAPIVoteCountryCode = foldedCatAPIVote.countryCode {
        countryCode = foldedCatAPIVoteCountryCode
    }
    
    var image: CatAPIImage? = nil
    if let foldedCatAPIVoteImage = foldedCatAPIVote.image {
        image = try unfoldCatAPIImage(foldedCatAPIImage: foldedCatAPIVoteImage)
    }
    
    return CatAPIVote(
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

func unfoldCatAPIVotes(foldedCatAPIVotes: [FoldedCatAPIVote]) throws -> [CatAPIVote] {
    var catAPIVotes: [CatAPIVote] = []
    
    try foldedCatAPIVotes.forEach { foldedCatAPIVote in
        catAPIVotes.append(try unfoldCatAPIVote(foldedCatAPIVote: foldedCatAPIVote))
    }
    
    return catAPIVotes
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
