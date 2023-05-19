//
//  FoldedAPIFanouriteStatusModels.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedAPIFavouritePostStatus {
    var message: String
    var id: Int?
}

// ----------------------------------------------------------------------------

struct FoldedAPIFavouriteDeleteStatus {
    var message: String
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

extension FoldedAPIFavouritePostStatus: Decodable {
    enum CodingKeys: String, CodingKey {
        case message
        case id
        case imageId = "image_id"
        case subId = "sub_id"
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&FR")
            print("&FR \(error.localizedDescription)")
            print("&FR \(decoding)")
            print("&FR")
            print()
        }
        
        do {
            message = try container.decode(String.self, forKey: .message)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIFavouriteResponse.message")
            throw(error)
        }
        do {
            id = try container.decodeIfPresent(Int.self, forKey: .id) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIFavouriteResponse.id")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------

extension FoldedAPIFavouriteDeleteStatus: Decodable {
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&FR")
            print("&FR \(error.localizedDescription)")
            print("&FR \(decoding)")
            print("&FR")
            print()
        }
        
        do {
            message = try container.decode(String.self, forKey: .message)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIFavouriteResponse.message")
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

func decodeAPIFavouritePostStatus(data: Data) throws -> FoldedAPIFavouritePostStatus {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedAPIStatus = try decoder.decode(FoldedAPIFavouritePostStatus.self, from: jsonData)
    return foldedAPIStatus
}

// ----------------------------------------------------------------------------

func decodeAPIFavouriteDeleteStatus(data: Data) throws -> FoldedAPIFavouriteDeleteStatus {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedAPIStatus = try decoder.decode(FoldedAPIFavouriteDeleteStatus.self, from: jsonData)
    return foldedAPIStatus
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

