//
//  FoldedCatAPISourcesModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedCatAPISource {
    var id: Int
    var name: String
    var url: String
    var breedId: String?
}

// ----------------------------------------------------------------------------

extension FoldedCatAPISource: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case breedId = "breed_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&S")
            print("&S \(error.localizedDescription)")
            print("&S \(decoding)")
            print("&S")
            print()
        }
        
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPISource.id")
            throw error
        }
        do {
            name = try container.decode(String.self, forKey: .name)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPISource.name")
            throw(error)
        }
        do {
            url = try container.decode(String.self, forKey: .url)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPISource.url")
            throw(error)
        }
        do {
            breedId = try container.decodeIfPresent(String.self, forKey: .breedId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPISource.breedId")
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

func fetchCatAPISources(
    apiEndpoint: APIEndPoint = .forCats,
    apiVersion: APIVersion,
    apiPath: APIPath = .forSources,
    limit: Int?,
    page: Int?
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
    
    // ------------------------------------------------------------------------
    urlString += "&"
    urlString += "api_key="
    urlString += recover(jewel: .theCatAPIKey)
    // ------------------------------------------------------------------------
    
    guard let url = URL(string: urlString) else {
        fatalError("URL Unreachable: \(urlString)")
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

func decodeCatAPISources(data: Data) throws -> [FoldedCatAPISource] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedCatAPISources = try decoder.decode([FoldedCatAPISource].self, from: jsonData)
    return foldedCatAPISources
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

// CAT's APISources:

//[
//    {
//        "id": 1,
//        "name": "Wikipedia",
//        "url": "https://en.wikipedia.org",
//        "breed_id": null
//    },
//    {
//        "id": 2,
//        "name": "VCA Hospitals",
//        "url": "https://vcahospitals.com",
//        "breed_id": null
//    },
//    {
//        "id": 3,
//        "name": "VetStreet",
//        "url": "http://www.vetstreet.com",
//        "breed_id": null
//    },
//    {
//        "id": 4,
//        "name": "PetHelpful",
//        "url": "https://pethelpful.com/",
//        "breed_id": null
//    },
//    {
//        "id": 5,
//        "name": "Bengal cat club",
//        "url": "https://bengalcatclub.com",
//        "breed_id": "beng"
//    },
//    {
//        "id": 6,
//        "name": "Pet MD",
//        "url": "https://www.petmd.com",
//        "breed_id": null
//    },
//    {
//        "id": 7,
//        "name": "PETAZI",
//        "url": "https://petazi.com",
//        "breed_id": null
//    },
//    {
//        "id": 8,
//        "name": "CatTime",
//        "url": "https://cattime.com",
//        "breed_id": null
//    },
//    {
//        "id": 10,
//        "name": "The Governing Council of the Cat Fancy",
//        "url": "https://www.gccfcats.org",
//        "breed_id": null
//    },
//    {
//        "id": 12,
//        "name": "Hillspet",
//        "url": "https://www.hillspet.com.au",
//        "breed_id": null
//    }
//]

