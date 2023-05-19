//
//  CommonFunctons.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

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

func fetchAPICategories(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forCategories,
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

// MARK: LOAD CATEGORIES

//enum APICategoriesDataSet: String {
//    case forCats = "cat_categories"
//    case forDogs = "dog_categories"
//}

func loadAPICategories(_ forSpecies: APICategoriesDataSet) throws -> Data {
//    let dataSet = forSpecies.rawValue
    
    guard let asset = NSDataAsset(name: forSpecies.rawValue) else {
        fatalError("Data Set Unreachable")
    }
    
    return asset.data
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
