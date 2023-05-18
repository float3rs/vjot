//
//  FoldedAPIImageUploadStatusModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-27.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedAPIImageUploadStatus {
    var id: String
    var url: String
    var subId: String?                  // OPTIONAL IN RESPONSES, NOT IN DOCUMENTATION
    var width: Int?                     // APPEARS IN RESPONSES, NOT IN DOCUMENTATION
    var height: Int?                    // APPEARS IN RESPONSES, NOT IN DOCUMENTATION
    var originalFilename: String?           // APPEARS IN RESPONSES, NOT IN DOCUMENTATION
    var pending: Int
    var approved: Int
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

extension FoldedAPIImageUploadStatus: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case subId = "sub_id"
        case width
        case height
        case originalFilename = "original_filename"
        case pending
        case approved
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&US")
            print("&US \(error.localizedDescription)")
            print("&US \(decoding)")
            print("&US")
            print()
        }
        
        do {
            id = try container.decode(String.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIImageUploadStatus.id")
            throw(error)
        }
        do {
            url = try container.decode(String.self, forKey: .url)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIImageUploadStatus.url")
            throw(error)
        }
        do {
            subId = try container.decodeIfPresent(String.self, forKey: .subId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIImageUploadStatus.subId")
            throw(error)
        }
        do {
            width = try container.decodeIfPresent(Int.self, forKey: .width) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIImageUploadStatus.width")
            throw(error)
        }
        do {
            height = try container.decodeIfPresent(Int.self, forKey: .height) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIImageUploadStatus.height")
            throw(error)
        }
        do {
            originalFilename = try container.decodeIfPresent(String.self, forKey: .originalFilename) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIImageUploadStatus.originalFilename")
            throw(error)
        }
        do {
            pending = try container.decode(Int.self, forKey: .pending)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIImageUploadStatus.pending")
            throw(error)
        }
        do {
            approved = try container.decode(Int.self, forKey: .approved)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIImageUploadStatus.approved")
            throw(error)
        }
    }
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

func decodeAPIImageUploadStatus(data: Data) throws -> FoldedAPIImageUploadStatus {
    let jsonData = data
    let decoder = JSONDecoder()
    
//    decoder.dateDecodingStrategy = .custom({ decoder in
//        let container = try decoder.singleValueContainer()
//        let string = try container.decode(String.self)
//        let ISO8601dateFormatter = ISO8601DateFormatter()
//        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        return ISO8601dateFormatter.date(from: string)!
//    })
    
    let foldedAPIUploadStatus = try decoder.decode(FoldedAPIImageUploadStatus.self, from: jsonData)
    return foldedAPIUploadStatus
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
