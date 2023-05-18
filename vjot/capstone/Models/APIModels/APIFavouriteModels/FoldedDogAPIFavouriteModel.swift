//
//  FoldedDogAPIFavouriteModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: DOGS'S FAVOURITES (DECODING)

struct FoldedDogAPIFavourite {
    var id: Int
    var userId: String?         // NOT PRESENT IN DOCUMENTATION
    var imageId: String
    var subId: String
    var createdAt: Date
    var image: FoldedDogAPIImage?
}

extension FoldedDogAPIFavourite: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case imageId = "image_id"
        case subId = "sub_id"
        case createdAt = "created_at"
        case image
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&F")
            print("&F \(error.localizedDescription)")
            print("&F \(decoding)")
            print("&F")
            print()
        }
        
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIFavourite.id")
            throw(error)
        }
        do {
            userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIFavourite.userId")
            throw(error)
        }
        do {
            imageId = try container.decode(String.self, forKey: .imageId)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIFavourite.imageId")
            throw(error)
        }
        do {
            subId = try container.decode(String.self, forKey: .subId)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIFavourite.subId")
            throw(error)
        }
        do {
            createdAt = try container.decode(Date.self, forKey: .createdAt)
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

// MARK: FETCH FAVOURITES

//func fetchAPIFavourites(
//    apiEndpoint: APIEndPoint,
//    apiVersion: APIVersion,
//    apiPath: APIPath = .forFavourites,
//    attachImage: Bool?,
//    imageId: String?,
//    subId: String?,
//    page: Int?,
//    limit: Int?,
//    order: APIOrder?
//) async throws -> Data {
//
//    var urlString: String = ""
//    urlString += apiEndpoint.rawValue
//    urlString += apiVersion.rawValue
//    urlString += apiPath.rawValue
//
//    urlString += "?"
//    urlString += "attach_image="
//    if let attachImage = attachImage {
//        urlString += attachImage ? "1" : "0"
//    }
//
//    urlString += "&"
//    urlString += "image_id="
//    if let imageId = imageId {
//        urlString += imageId
//    }
//
//    urlString += "&"
//    urlString += "sub_id="
//    if let subId = subId {
//        urlString += subId
//    }
//
//    urlString += "&"
//    urlString += "page="
//    if let page = page {
//        urlString += String(page)
//    }
//
//    urlString += "&"
//    urlString += "limit="
//    if let limit = limit {
//        urlString += String(limit)
//    }
//
//    urlString += "&"
//    urlString += "order="
//    if let order = order {
//        urlString += order.rawValue
//    }
//
//    // ------------------------------------------------------------------------
//    urlString += "&"
//    urlString += "api_key="
//
//    switch apiEndpoint {
//    case .forCats:
//        urlString += "live_8OXY9Gcr0pgpPaJSMW4Iy41evMRDri6vN9UJIJBibFoJIVnwXKcuIy3V6osFDp7v"
//    case .forDogs:
//        urlString += "live_2IWXSet4cLcgldhM79UsfRiUOpd2JUO2f7lWr1EAJYMDXlfWSJFUgGmykdg5lTb2"
//    }
//    // ------------------------------------------------------------------------
//
//
//    guard let url = URL(string: urlString) else {
//        fatalError("URL Unreachable")
//    }
//
//    let urlRequest = URLRequest(url: url)
//    let (data, response) = try await URLSession.shared.data(for: urlRequest)
//
//    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//        fatalError("Fetching Data Error")
//    }
//
//    return data
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: FETCH INDIVIDUAL FAVOURITE

//func fetchAPIIndividualFavourite(
//    apiEndpoint: APIEndPoint,
//    apiVersion: APIVersion,
//    apiPath: APIPath = .forFavourites,
//    favouriteId: Int
//) async throws -> Data {
//
//    var urlString: String = ""
//    urlString += apiEndpoint.rawValue
//    urlString += apiVersion.rawValue
//    urlString += apiPath.rawValue
//
//    urlString += String(favouriteId)
//
//    // ------------------------------------------------------------------------
//    urlString += "?"
//    urlString += "api_key="
//
//    switch apiEndpoint {
//    case .forCats:
//        urlString += "live_8OXY9Gcr0pgpPaJSMW4Iy41evMRDri6vN9UJIJBibFoJIVnwXKcuIy3V6osFDp7v"
//    case .forDogs:
//        urlString += "live_2IWXSet4cLcgldhM79UsfRiUOpd2JUO2f7lWr1EAJYMDXlfWSJFUgGmykdg5lTb2"
//    }
//    // ------------------------------------------------------------------------
//
//    guard let url = URL(string: urlString) else {
//        fatalError("URL Unreachable")
//    }
//
//    let urlRequest = URLRequest(url: url)
//    let (data, response) = try await URLSession.shared.data(for: urlRequest)
//
//    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//        fatalError("Fetching Data Error")
//    }
//
//    return data
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func decodeDogAPIFavourites(data: Data) throws -> [FoldedDogAPIFavourite] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedDogAPIFavourites = try decoder.decode([FoldedDogAPIFavourite].self, from: jsonData)
    return foldedDogAPIFavourites
}

// ----------------------------------------------------------------------------

func decodeDogAPIIndividualFavourite(data: Data) throws -> FoldedDogAPIFavourite {
    let jsonData = data
    let decoder = JSONDecoder()
    
    decoder.dateDecodingStrategy = .custom({ decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let ISO8601dateFormatter = ISO8601DateFormatter()
        ISO8601dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return ISO8601dateFormatter.date(from: string)!
    })
    
    let foldedDogAPIIndividualFavourite = try decoder.decode(FoldedDogAPIFavourite.self, from: jsonData)
    return foldedDogAPIIndividualFavourite
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






