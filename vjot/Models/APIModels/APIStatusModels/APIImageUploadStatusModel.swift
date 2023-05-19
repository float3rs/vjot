//
//  APIUploadStatusModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-27.
//

import Foundation
import SwiftUI

struct APIImageUploadStatus {
    var id: String
    var url: URL
    var subId: UUID?
    var width: Int?
    var height: Int?
    var originalFilename: String?
    var pending: Bool
    var approved: Bool
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldAPIImageUploadStatus(foldedAPIImageUploadStatus: FoldedAPIImageUploadStatus) throws -> APIImageUploadStatus {
    
    func unfoldTo(bool foldedInt: Int?) -> Bool? {
        if let foldedInt = foldedInt {
            return (foldedInt == 0) ? false : true
        }
        return nil
    }
    
    let id = foldedAPIImageUploadStatus.id
    let url = URL(string: foldedAPIImageUploadStatus.url)!
    
    var subId: UUID = UUID()
    if let foldedAPIUploadStatusSubId = foldedAPIImageUploadStatus.subId {
        if let uuid = UUID(uuidString: foldedAPIUploadStatusSubId) {
            subId = uuid
        } else {
            // fatalError("ATTEMPTED TO UNFOLD INVALID UUID STRING")
            throw VJotError.id
        }
    }
    
    var width: Int? = nil
    if let foldedAPIUploadStatusWidth = foldedAPIImageUploadStatus.width {
        width = foldedAPIUploadStatusWidth
    }
    var height: Int? = nil
    if let foldedAPIUploadStatusHeight = foldedAPIImageUploadStatus.height {
        height = foldedAPIUploadStatusHeight
    }
    
    var originalFilename: String? = nil
    if let foldedAPIUploadStatusOriginalFilename = foldedAPIImageUploadStatus.originalFilename {
        originalFilename = foldedAPIUploadStatusOriginalFilename
    }
    
    let pending: Bool = (foldedAPIImageUploadStatus.pending == 0) ? false : true
    let approved: Bool = (foldedAPIImageUploadStatus.approved == 0) ? false : true
    
    return APIImageUploadStatus(
        id: id,
        url: url,
        subId: subId,
        width: width,
        height: height,
        originalFilename: originalFilename,
        pending: pending,
        approved: approved
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
