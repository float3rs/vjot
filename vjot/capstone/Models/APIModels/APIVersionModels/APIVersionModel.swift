//
//  APIVersionModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD Version

struct APIVersion_ {
    var message: String
    var version: String
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

func unfoldAPIVersion_(foldedAPIVersion_: FoldedAPIVersion_) throws -> APIVersion_ {
    
    let message = foldedAPIVersion_.message
    let version = foldedAPIVersion_.version
    
    return APIVersion_(
        message: message,
        version: version
    )
}
