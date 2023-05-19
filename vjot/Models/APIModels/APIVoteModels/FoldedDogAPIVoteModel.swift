//
//  FoldedDogAPIVoteModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-26.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: DOGS' VOTES (DECODING)

struct FoldedDogAPIVote {
    var id: Int
    var imageId: String
    var subId: String?                      // POSTMAN DOCUMENTATION SHOWS NULL
    var value: Int
    var createdAt: Date?                    // NOT PRESENT IN DOCUMENTATION
    var countryCode: String?                // NOT PRESENT IN DOCUMETNATION, RETURNS NULL
    var image: FoldedDogAPIImage?           // NOT PRESENT IN DOCUMENTATION
}

extension FoldedDogAPIVote: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case imageId = "image_id"
        case subId = "sub_id"
        case value
        case createdAt = "created_at"
        case countryCode = "country_code"
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&V")
            print("&V \(error.localizedDescription)")
            print("&V \(decoding)")
            print("&V")
            print()
        }
        
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIVote.id")
            throw(error)
        }
        do {
            imageId = try container.decode(String.self, forKey: .imageId)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIFavourite.imageId")
            throw(error)
        }
        do {
            subId = try container.decodeIfPresent(String.self, forKey: .subId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIFavourite.subId")
            throw(error)
        }
        do {
            value = try container.decode(Int.self, forKey: .value)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIVote.value")
            throw(error)
        }
        do {
            createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIFavourite.createdAt")
            throw(error)
        }
        do {
            image = try container.decodeIfPresent(FoldedDogAPIImage.self, forKey: .image) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIFavourite.image")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func decodeDogAPIVotes(data: Data) throws -> [FoldedDogAPIVote] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedDogAPIVotes = try decoder.decode([FoldedDogAPIVote].self, from: jsonData)
    return foldedDogAPIVotes
}

// ----------------------------------------------------------------------------

func decodeDogAPIIndividualVote(data: Data) throws -> FoldedDogAPIVote {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedDogAPIIndividualVote = try decoder.decode(FoldedDogAPIVote.self, from: jsonData)
    return foldedDogAPIIndividualVote
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
