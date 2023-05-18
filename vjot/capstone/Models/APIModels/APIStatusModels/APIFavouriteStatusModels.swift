//
//  APIFavouriteStatusModels.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct APIFavouritePostStatus {
    var message: String
    var id: Int?
}

// ----------------------------------------------------------------------------

struct APIFavouriteDeleteStatus {
    var message: String
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

extension APIFavouritePostStatus: Identifiable & Hashable & Decodable {}
extension APIFavouriteDeleteStatus: Decodable {}

func unfoldAPIFavouritePostStatus(foldedAPIFavouritePostStatus: FoldedAPIFavouritePostStatus) throws -> APIFavouritePostStatus {
    let message = foldedAPIFavouritePostStatus.message
    
    var id: Int? = nil
    if let foldedAPIFavouritePostStatusId = foldedAPIFavouritePostStatus.id {
        id = foldedAPIFavouritePostStatusId
    }
    
    return APIFavouritePostStatus(
        message: message,
        id: id
    )
}

// ----------------------------------------------------------------------------

func unfoldAPIFavouriteDeleteStatus(foldedAPIFavouriteDeleteStatus: FoldedAPIFavouriteDeleteStatus) throws -> APIFavouriteDeleteStatus {
    let message = foldedAPIFavouriteDeleteStatus.message
    
    return APIFavouriteDeleteStatus(message: message)
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

