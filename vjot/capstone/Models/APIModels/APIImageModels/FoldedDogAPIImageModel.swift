//
//  FoldedDogAPIImageModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: DOGS' IMAGES (DECODING)
// Each contains the url for the image file, along with its width, height and breed information (if available),
// any favourite or vote you create would also be returned.
// TODO: Favourites & Votes

struct FoldedDogAPIImage {
    var id: String
    var url: String
    var width: Int?
    var height: Int?
    
    var breeds: [FoldedDogAPIBreed]?
    var categories: [FoldedDogAPICategory]?    // SHOWN IN /images/search SPEC, NOT IN RESPONSES
    
    var mimeType: String?       // SHOWN IN /images/image_id SPEC, NOT IN RESPONSES
    var breedIds: String?       // SHOWN IN /images/image_id SPEC, NOT IN RESPONSES
    
//    var entities: [String]?           // UPLOAD SPEC (NOT USED)
//    var animals: [String]?            // UPLOAD SPEC (NOT USED)
    
    var subId: String?                  // UPLOAD SPEC AND RESPONSES - MAY BE NULL
    var createdAt: Date?                // UPLOAD RESPONSES, NOT IN SPEC
    var originalFilename: String?        // UPLOAD RESPONSES, NOT IS SPEC
}

// ----------------------------------------------------------------------------

extension FoldedDogAPIImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case width
        case height
        
        case breeds
        case categories
        
        case mimeType = "mime_type"
        case breedIds = "breed_ids"
        
        case subId = "sub_id"
        case createdAt = "created_at"
        case originalFilename = "original_filename"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&I")
            print("&I \(error.localizedDescription)")
            print("&I \(decoding)")
            print("&I")
            print()
        }
        
        do {
            id = try container.decode(String.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.id")
            throw(error)
        }
        do {
            url = try container.decode(String.self, forKey: .url)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.id")
            throw(error)
        }
        do {
            width = try container.decodeIfPresent(Int.self, forKey: .width) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.id")
            throw(error)
        }
        do {
            height = try container.decodeIfPresent(Int.self, forKey: .height) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.id")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            breeds = try container.decodeIfPresent([FoldedDogAPIBreed].self, forKey: .breeds) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.breeds")
            throw error
        }
        do {
            categories = try container.decodeIfPresent([FoldedDogAPICategory].self, forKey: .categories) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.categories")
            throw error
        }
        
        // --------------------------------------------------------------------
        
        do {
            mimeType = try container.decodeIfPresent(String.self, forKey: .mimeType) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.mimeType")
            throw error
        }
        do {
            breedIds = try container.decodeIfPresent(String.self, forKey: .breedIds) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.categories")
            throw error
        }
        
        // --------------------------------------------------------------------
        // UPLOAD -------------------------------------------------------------
        
        do {
            subId = try container.decodeIfPresent(String.self, forKey: .subId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.subId")
            throw error
        }
        do {
            createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.createdAt")
            throw error
        }
        do {
            originalFilename = try container.decodeIfPresent(String.self, forKey: .originalFilename) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIImage.originalFilename")
            throw error
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

//enum APISize: String {
//    case small = "small"
//    case medium = "med"
//    case full = "full"
//}

//enum APIMimeType: String {
//    case gif = "gif"
//    case jpg = "jpg"
//    case png = "png"
//}

//enum APIFormat: String {
//    case json = "json"
//    case scr = "src"
//}

//enum APIOrder: String {
//    case random = "RANDOM"
//    case ascending = "ASC"
//    case descending = "DESC"
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func fetchDogAPIImages(
    apiEndpoint: APIEndPoint = .forDogs,
    apiVersion: APIVersion,
    apiPath: APIPath = .forImages,
    size: APISize? = .medium,
    mimeTypes: [APIMimeType]? = [.jpg, .gif, .png],
    format: APIFormat? = .json,
    order: APIOrder? = .random,
    page: Int? = 0,                                         // Only used when order is ASC or DESC
    limit: Int? = 1,
    categoryIds: [Int]? = [],
    breedIds: [Int]? = [],                                  // [String] for CATS
    hasBreeds: Bool? = false,
    includeBreeds: Bool? = true,
    includeCategories: Bool? = true
) async throws -> Data {
    
    var urlString: String = ""
    urlString += apiEndpoint.rawValue
    urlString += apiVersion.rawValue
    urlString += apiPath.rawValue
    urlString += "search"
    
    urlString += "?"
    urlString += "size="
    if let size = size {
        urlString += size.rawValue
    }
    urlString += "&"
    urlString += "mime_types="
    if let mimeTypes = mimeTypes {
        mimeTypes.forEach { mimeType in
            urlString += mimeType.rawValue
            if mimeTypes.last != mimeType {
                urlString += ","
            }
        }
    }
    urlString += "&"
    urlString += "format="
    if let format = format {
        urlString += format.rawValue
    }
    urlString += "&"
    urlString += "order="
    if let order = order {
        urlString += order.rawValue
    }
    urlString += "&"
    urlString += "page="
    if let page = page {
        urlString += String(page)
    }
    urlString += "&"
    urlString += "limit="
    if let limit = limit {
        urlString += String(limit)
    }
    urlString += "&"
    urlString += "category_ids="
    if let categoryIds = categoryIds {
        categoryIds.forEach { categoryId in
            urlString += String(categoryId)
            if categoryIds.last != categoryId {
                urlString += ","
            }
        }
    }
    urlString += "&"
    urlString += "breed_ids="
    if let breedIds = breedIds {
        breedIds.forEach { breedId in
            urlString += String(breedId)
            if breedIds.last != breedId {
                urlString += ","
            }
        }
    }
    urlString += "&"
    urlString += "has_breeds="
    if let hasBreeds = hasBreeds {
        urlString += hasBreeds ? "1" : "0"
    }
    urlString += "&"
    urlString += "include_breeds="
    if let includeBreeds = includeBreeds {
        urlString += includeBreeds ? "1" : "0"
    }
    urlString += "&"
    urlString += "include_categories="
    if let includeCategories = includeCategories {
        urlString += includeCategories ? "1" : "0"
    }
    
    // ------------------------------------------------------------------------
    urlString += "&"
    urlString += "api_key="
    urlString += recover(jewel: .theDogAPIKey)
    // ------------------------------------------------------------------------
    
    guard let url = URL(string: urlString) else {
        fatalError("URL Unreachable: \(urlString)")
    }
         
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        let statusCode = (response as! HTTPURLResponse).statusCode
        // 400: INVALID IMAGE ID
        if statusCode == 400 { throw VJotError.id }
        // VJotError //////////////////////////////////////////////////////////
        guard let error = err(statusCode: statusCode) else { fatalError("Fetching Data Error: \(urlString)") }
        throw error
    }
    
    return data
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func decodeDogAPIImages(data: Data) throws -> [FoldedDogAPIImage] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedDogAPIImages = try decoder.decode([FoldedDogAPIImage].self, from: jsonData)
    return foldedDogAPIImages
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

func fetchDogAPIIndividualImage(
    apiEndpoint: APIEndPoint = .forDogs,
    apiVersion: APIVersion,
    apiPath: APIPath = .forImages,
    imageId: String,
    subId: String?,
    size: APISize? = .medium,
    includeVote: Bool?,
    includeFavourite: Bool?
) async throws -> Data {
    
    var urlString: String = ""
    urlString += apiEndpoint.rawValue
    urlString += apiVersion.rawValue
    urlString += apiPath.rawValue
    urlString += imageId
    
    urlString += "?"
    urlString += "sub_id="
    if let subId = subId {
        urlString += subId
    }
    urlString += "&"
    urlString += "size="
    if let size = size {
        urlString += size.rawValue
    }
    urlString += "&"
    urlString += "include_vote="
    if let includeVote = includeVote {
        urlString += includeVote ? "1" : "0"
    }
    urlString += "&"
    urlString += "include_favourite="
    if let includeFavourite = includeFavourite {
        urlString += includeFavourite ? "1" : "0"
    }
    
    // ------------------------------------------------------------------------
    urlString += "&"
    urlString += "api_key="
    urlString += recover(jewel: .theDogAPIKey)
    // ------------------------------------------------------------------------
    
    guard let url = URL(string: urlString) else {
        print("URL Unreachable: \(urlString)")
        return Data()
    }
    
    print(urlString)
         
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        let statusCode = (response as! HTTPURLResponse).statusCode
        // 400: INVALID IMAGE ID
        if statusCode == 400 { throw VJotError.id }
        // VJotError //////////////////////////////////////////////////////////
        guard let error = err(statusCode: statusCode) else { fatalError("Fetching Data Error: \(urlString)") }
        throw error
    }
    
    return data
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func decodeDogAPIIndividualImage(data: Data) throws -> FoldedDogAPIImage {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedDogAPIIndividualImage = try decoder.decode(FoldedDogAPIImage.self, from: jsonData)
    return foldedDogAPIIndividualImage
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

func fetchDogAPIUploadedImages(
    apiEndpoint: APIEndPoint = .forDogs,
    apiVersion: APIVersion,
    apiPath: APIPath = .forImages,
    limit: Int? = 1,
    page: Int? = 1,                                            // Only used when order is ASC or DESC
    order: APIOrder? = .random,
    subId: String? = "",
    breedIds: [Int]? = [],                                      // [String] for CATS
    categoryIds: [Int]? = [],
    format: APIFormat? = .json,
    originalFilename: String? = ""
) async throws -> Data {
    
    var urlString: String = ""
    urlString += apiEndpoint.rawValue
    urlString += apiVersion.rawValue
    urlString += apiPath.rawValue
    
    urlString += "?"
    urlString += "limit="
    if let limit = limit {
        urlString += String(limit)
    }
    urlString += "&"
    urlString += "page="
    if let page = page {
        urlString += String(page)
    }
    urlString += "&"
    urlString += "order="
    if let order = order {
        urlString += order.rawValue
    }
    urlString += "&"
    urlString += "sub_id="
    if let subId = subId {
        urlString += subId
    }
    urlString += "&"
    urlString += "breed_ids="
    if let breedIds = breedIds {
        breedIds.forEach { breedId in
            urlString += String(breedId)
            if breedIds.last != breedId {
                urlString += ","
            }
        }
    }
    urlString += "&"
    urlString += "category_ids="
    if let categoryIds = categoryIds {
        categoryIds.forEach { categoryId in
            urlString += String(categoryId)
            if categoryIds.last != categoryId {
                urlString += ","
            }
        }
    }
    urlString += "&"
    urlString += "format="
    if let format = format {
        urlString += format.rawValue
    }
    urlString += "&"
    urlString += "original_filename="
    if let originalFilename = originalFilename {
        urlString += originalFilename
    }
    
    // ------------------------------------------------------------------------
    urlString += "&"
    urlString += "api_key="
    urlString += recover(jewel: .theDogAPIKey)
    // ------------------------------------------------------------------------
    
    guard let url = URL(string: urlString) else {
        fatalError("URL Unreachable: \(urlString)")
    }
         
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        let statusCode = (response as! HTTPURLResponse).statusCode
        // VJotError //////////////////////////////////////////////////////////
        guard let error = err(statusCode: statusCode) else { fatalError("Fetching Data Error: \(urlString)") }
        throw error
    }
    
    return data
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func decodeDogAPIUploadedImages(data: Data) throws -> [FoldedDogAPIImage] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedDogAPIUploadedImages = try decoder.decode([FoldedDogAPIImage].self, from: jsonData)
    return foldedDogAPIUploadedImages
}
