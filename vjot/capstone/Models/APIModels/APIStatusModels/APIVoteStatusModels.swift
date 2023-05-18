//
//  APIVoteStatusModels.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-26.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct APIVotePostStatus {
    var message: String
    var id: Int?
    var imageId: String?
    var subId: UUID?
    var value: Int?
}

// ----------------------------------------------------------------------------

struct APIVoteDeleteStatus {
    var message: String
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

extension APIVotePostStatus: Identifiable & Hashable & Decodable {}
extension APIVoteDeleteStatus: Decodable {}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldAPIVotePostStatus(foldedAPIVotePostStatus: FoldedAPIVotePostStatus) throws -> APIVotePostStatus {
    let message = foldedAPIVotePostStatus.message
    
    var id: Int? = nil
    if let foldedAPIVotePostStatusId = foldedAPIVotePostStatus.id {
        id = foldedAPIVotePostStatusId
    }
    
    var imageId: String? = nil
    if let foldedAPIVotePostStatusImageId = foldedAPIVotePostStatus.imageId {
        imageId = foldedAPIVotePostStatusImageId
    }
    
    var subId: UUID = UUID()
    if let foldedAPIVotePostStatusSubId = foldedAPIVotePostStatus.subId {
        if let uuid = UUID(uuidString: foldedAPIVotePostStatusSubId) {
            subId = uuid
        } else {
            // fatalError("ATTEMPTED TO UNFOLD INVALID UUID STRING")
            throw VJotError.id
        }
    }
    
    var value: Int? = nil
    if let foldedAPIVotePostStatusValue = foldedAPIVotePostStatus.value {
        value = foldedAPIVotePostStatusValue
    }
    
    return APIVotePostStatus(
        message: message,
        id: id,
        imageId: imageId,
        subId: subId,
        value: value
    )
}

// ----------------------------------------------------------------------------

func unfoldAPIVoteDeleteStatus(foldedAPIVoteDeleteStatus: FoldedAPIVoteDeleteStatus) throws -> APIVoteDeleteStatus {
    let message = foldedAPIVoteDeleteStatus.message
    
    return APIVoteDeleteStatus(message: message)
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------




