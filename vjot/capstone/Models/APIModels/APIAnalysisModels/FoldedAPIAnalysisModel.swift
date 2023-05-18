//
//  FoldedAPIAnalysisModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedAPIAnalysisLabelInstanceBoundingBox {
    var width: Double
    var height: Double
    var left: Double
    var top: Double
}

extension FoldedAPIAnalysisLabelInstanceBoundingBox: Decodable {
    enum CodingKeys: String, CodingKey {
        case width = "Width"
        case height = "Height"
        case left = "Left"
        case top = "Top"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&A")
            print("&A \(error.localizedDescription)")
            print("&A \(decoding)")
            print("&A")
            print()
        }
        
        do {
            width = try container.decode(Double.self, forKey: .width)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabelInstantBoundingBox.width")
            throw(error)
        }
        do {
            height = try container.decode(Double.self, forKey: .height)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabelInstantBoundingBox.height")
            throw(error)
        }
        do {
            left = try container.decode(Double.self, forKey: .left)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabelInstantBoundingBox.left")
            throw(error)
        }
        do {
            top = try container.decode(Double.self, forKey: .top)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabelInstantBoundingBox.top")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------

struct FoldedAPIAnalysisLabelInstance {
    var boundingBox: FoldedAPIAnalysisLabelInstanceBoundingBox
    var confidence: Double
}

extension FoldedAPIAnalysisLabelInstance: Decodable {
    enum CodingKeys: String, CodingKey {
        case boundingBox = "BoundingBox"
        case confidence = "Confidence"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&A")
            print("&A \(error.localizedDescription)")
            print("&A \(decoding)")
            print("&A")
            print()
        }
        
        do {
            boundingBox = try container.decode(FoldedAPIAnalysisLabelInstanceBoundingBox.self, forKey: .boundingBox)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabelInstant.boundingBox")
            throw(error)
        }
        do {
            confidence = try container.decode(Double.self, forKey: .confidence)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabelInstant.confidence")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------

struct FoldedAPIAnalysisLabelParent {
    var name: String
}

extension FoldedAPIAnalysisLabelParent: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&A")
            print("&A \(error.localizedDescription)")
            print("&A \(decoding)")
            print("&A")
            print()
        }
        
        do {
            name = try container.decode(String.self, forKey: .name)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabelParent.name")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------

struct FoldedAPIAnalysisLabel {
    var name: String
    var confidence: Double
    var instances: [FoldedAPIAnalysisLabelInstance]?       // NONE FOR CATS
    var parents: [FoldedAPIAnalysisLabelParent]?          // NONE FOR CATS
}

extension FoldedAPIAnalysisLabel: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case confidence = "Confidence"
        case instances = "Instances"
        case parents = "Parents"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&A")
            print("&A \(error.localizedDescription)")
            print("&A \(decoding)")
            print("&A")
            print()
        }
        
        do {
            name = try container.decode(String.self, forKey: .name)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabel.name")
            throw(error)
        }
        do {
            confidence = try container.decode(Double.self, forKey: .confidence)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabel.confidence")
            throw(error)
        }
        do {
            instances = try container.decodeIfPresent([FoldedAPIAnalysisLabelInstance].self, forKey: .instances) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabel.instances")
            throw(error)
        }
        do {
            parents = try container.decodeIfPresent([FoldedAPIAnalysisLabelParent].self, forKey: .parents)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysisLabel.parents")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------

struct FoldedAPIAnalysis {
    var labels: [FoldedAPIAnalysisLabel]
    var moderationLabels: [FoldedAPIAnalysisLabel]
    var vendor: String?
    var approved: Int?                                      // IN SPEC NOT IN RESPONSES
    var rejected: Int?                                      // IN SPEC NOT IN RESPONSES
    var imageId: String?                                    // IN RESPONSES NOT IN SPEC
    var createdAt: Date                                     // IN RESPONSES NOT IN SPEC
}

extension FoldedAPIAnalysis: Decodable {
    enum CodingKeys: String, CodingKey {
        case labels
        case moderationLabels = "moderation_labels"
        case vendor
        case approved
        case rejected
        case imageId = "image_id"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&A")
            print("&A \(error.localizedDescription)")
            print("&A \(decoding)")
            print("&A")
            print()
        }
        
        do {
            labels = try container.decode([FoldedAPIAnalysisLabel].self, forKey: .labels)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysis.labels")
            throw(error)
        }
        do {
            moderationLabels = try container.decode([FoldedAPIAnalysisLabel].self, forKey: .moderationLabels)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysis.moderationLabels")
            throw(error)
        }
        do {
            vendor = try container.decodeIfPresent(String.self, forKey: .vendor) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysis.vendor")
            throw(error)
        }
        do {
            approved = try container.decodeIfPresent(Int.self, forKey: .approved) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysis.approved")
            throw(error)
        }
        do {
            rejected = try container.decodeIfPresent(Int.self, forKey: .rejected) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysis.rejected")
            throw(error)
        }
        do {
            imageId = try container.decodeIfPresent(String.self, forKey: .imageId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysis.imageId")
            throw(error)
        }
        do {
            createdAt = try container.decode(Date.self, forKey: .createdAt)
        } catch(let error) {
            report(error: error, decoding: "FoldedAPIAnalysis.createdAt")
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
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

//enum APIEndPoint: String {
//    case forCats = "https://api.thecatapi.com/"
//    case forDogs = "https://api.thedogapi.com/"
//}

//enum APIVersion: String {
//    case v1 = "v1/"
//}

//enum APIPath: String {
//    case forImages = "images/"
//    case forBreeds = "breeds/"
//    case forFavourites = "favourites/"
//    case forVotes = "votes/"
//    case forCategories = "categories/"
//    case forSources = "sources/"
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: FETCH ANALYSIS

func fetchAPIAnalyses(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forImages,
    imageId: String
) async throws -> Data {
    
    var urlString: String = ""
    urlString += apiEndpoint.rawValue
    urlString += apiVersion.rawValue
    urlString += apiPath.rawValue
    
    urlString += imageId
    
    urlString += "/"
    urlString += "analysis"
    
    // ------------------------------------------------------------------------
    
    print(urlString)
    guard let url = URL(string: urlString) else {
        fatalError("URL Unreachable")
    }
         
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard let error = err(statusCode: statusCode) else { fatalError("Fetching Data Error: \(urlString)") }
        throw error
    }
    
    return data
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

func decodeAPIAnalyses(data: Data) throws -> [FoldedAPIAnalysis] {
    let jsonData = data
    let decoder = JSONDecoder()
   
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })

    let foldedAPIAnalyses = try decoder.decode([FoldedAPIAnalysis].self, from: jsonData)
    return foldedAPIAnalyses
}
