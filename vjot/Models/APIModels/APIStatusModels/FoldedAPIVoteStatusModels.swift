//
//  FoldedAPIVoteStatusModels.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-26.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedAPIVotePostStatus {
    var message: String
    var id: Int?
    var imageId: String?
    var subId: String?
    var value: Int?
}

// ----------------------------------------------------------------------------

struct FoldedAPIVoteDeleteStatus {
    var message: String
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

extension FoldedAPIVotePostStatus: Decodable {
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
        do {
            imageId = try container.decodeIfPresent(String.self, forKey: .imageId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIFavouriteResponse.imageId")
            throw(error)
        }
        do {
            subId = try container.decodeIfPresent(String.self, forKey: .subId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIFavouriteResponse.subId")
            throw(error)
        }
        do {
            value = try container.decodeIfPresent(Int.self, forKey: .value) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIFavouriteResponse.value")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------

extension FoldedAPIVoteDeleteStatus: Decodable {
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

func decodeAPIVotePostStatus(data: Data) throws -> FoldedAPIVotePostStatus {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedAPIStatus = try decoder.decode(FoldedAPIVotePostStatus.self, from: jsonData)
    return foldedAPIStatus
}

// ----------------------------------------------------------------------------

func decodeAPIVoteDeleteStatus(data: Data) throws -> FoldedAPIVoteDeleteStatus {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedAPIStatus = try decoder.decode(FoldedAPIVoteDeleteStatus.self, from: jsonData)
    return foldedAPIStatus
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
