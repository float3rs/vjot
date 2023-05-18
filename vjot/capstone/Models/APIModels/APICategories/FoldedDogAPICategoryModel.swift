//
//  FoldedDogAPICategoryModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: DOGS' CATEGORIES (DECODING)
// The IDs of the categories to filter the images.

struct FoldedDogAPICategory {
    var id: Int
    var name: String
}

// ----------------------------------------------------------------------------

extension FoldedDogAPICategory: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&C")
            print("&C \(error.localizedDescription)")
            print("&C \(decoding)")
            print("&C")
            print()
        }
        
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPICategory.id")
            throw error
        }
        do {
            name = try container.decode(String.self, forKey: .name)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPICategory.name")
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

// MARK: FETCH CATEGORIES

//func fetchAPICategories(
//    apiEndpoint: APIEndPoint,
//    apiVersion: APIVersion,
//    apiPath: APIPath = .forCategories,
//    limit: Int?,
//    page: Int?
//) async throws -> Data {
//
//    var urlString: String = ""
//    urlString += apiEndpoint.rawValue
//    urlString += apiVersion.rawValue
//    urlString += apiPath.rawValue
//
//    urlString += "?"
//    urlString += "limit="
//    if let limit = limit {
//        urlString += String(limit)
//    }
//
//    urlString += "&"
//    urlString += "page="
//    if let page = page {
//        urlString += String(page)
//    }
//
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

func decodeDogAPICategories(data: Data) throws -> [FoldedDogAPICategory] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedDogAPIBreeds = try decoder.decode([FoldedDogAPICategory].self, from: jsonData)
    return foldedDogAPIBreeds
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

// MARK: LOAD CATEGORIES

//enum APICategoriesDataSet: String {
//    case forCats = "cat_categories"
//    case forDogs = "dog_categories"
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

//func loadAPICategories(_ forSpecies: APICategoriesDataSet) throws -> Data {
//
//    guard let asset = NSDataAsset(name: forSpecies.rawValue) else {
//        fatalError("Data Set Unreachable")
//    }
//
//    return asset.data
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

// DOGs APICategories:

//    []

