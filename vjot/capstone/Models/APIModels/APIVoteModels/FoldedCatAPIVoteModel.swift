//
//  FoldedCatAPIVoteModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-26.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: CATS' VOTES (DECODING)

struct FoldedCatAPIVote {
    var id: Int
    var imageId: String
    var subId: String?                      // POSTMAN DOCUMENTATION SHOWS NULL
    var value: Int
    var createdAt: Date?                    // NOT PRESENT IN DOCUMENTATION
    var countryCode: String?               // NOT PRESENT IN DOCUMETNATION, RETURNS NULL
    var image: FoldedCatAPIImage?           // NOT PRESENT IN DOCUMENTATION
}

extension FoldedCatAPIVote: Decodable {
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
            report(error: error, decoding: "FoldedCatAPIVote.id")
            throw(error)
        }
        do {
            imageId = try container.decode(String.self, forKey: .imageId)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIFavourite.imageId")
            throw(error)
        }
        do {
            subId = try container.decodeIfPresent(String.self, forKey: .subId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIFavourite.subId")
            throw(error)
        }
        do {
            value = try container.decode(Int.self, forKey: .value)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIVote.value")
            throw(error)
        }
        do {
            createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIFavourite.createdAt")
            throw(error)
        }
        do {
            image = try container.decodeIfPresent(FoldedCatAPIImage.self, forKey: .image) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIFavourite.image")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func decodeCatAPIVotes(data: Data) throws -> [FoldedCatAPIVote] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedCatAPIVotes = try decoder.decode([FoldedCatAPIVote].self, from: jsonData)
    return foldedCatAPIVotes
}

// ----------------------------------------------------------------------------

func decodeCatAPIIndividualVote(data: Data) throws -> FoldedCatAPIVote {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedCatAPIIndividualVote = try decoder.decode(FoldedCatAPIVote.self, from: jsonData)
    return foldedCatAPIIndividualVote
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
