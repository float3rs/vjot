//
//  APIBreedFunctions.swift
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

// MARK: FETCH BREEDS

func fetchAPIBreeds(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forBreeds,
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
//        throw VJotError.url(string: urlString)
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

// MARK: LOAD BREEDS

//enum APIBreedsDataSet: String {
//    case forCats = "cat_breeds"
//    case forDogs = "dog_breeds"
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func loadAPIBreeds(_ forSpecies: APIBreedsDataSet) throws -> Data {
//    let dataSet = forSpecies.rawValue
    
    guard let asset = NSDataAsset(name: forSpecies.rawValue) else {
        fatalError("Data Set Unreachable")
    }
    
    return asset.data
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

// MARK: REGEX

func getClosedRange(fromString string: String) -> ClosedRange<Double>? {
//func getClosedRange(fromString string: String) -> ClosedRange<Int>? {
    
//    print()
//    print("+")
//    print("+ RegEx Input: \(string)")
    
    let regex2 = /(\-?\d*\.?\d+)\b.+\b(\-?\d*\.?\d+)/
    
    if let match2 = string.firstMatch(of: regex2) {
        
        let matchedSubstring_lower = match2.1
        let matchedSubstring_upper = match2.2
        
        guard let matchedDouble_lower = Double(matchedSubstring_lower) else {
            fatalError("Substring -> Double Failed (RegEx Lower)")
        }
        
        guard let matchedDouble_upper = Double(matchedSubstring_upper) else {
            fatalError("Substring -> Double Failed (RegEx Upper)")
        }
        
//        print("+ RegEx Output: \(ClosedRange(uncheckedBounds: (lower: matchedDouble_lower, upper: matchedDouble_upper)))")
//        print("+")
//        print()
        
        return ClosedRange(uncheckedBounds: (
            lower: matchedDouble_lower,
            upper: matchedDouble_upper
        ))
    }
    
    // ------------------------------------------------------------------------
    
    let regex1 = /\b(\-?\d*\.?\d+)\b/
    
    if let match1 = string.firstMatch(of: regex1) {
        
        let matchedSubstring = match1.1
        guard let matchedDouble = Double(matchedSubstring) else {
            fatalError("Substring -> Double Failed (RegEx1)")
        }
        
//        print("+ RegEx Output: \(ClosedRange(uncheckedBounds: (lower: matchedDouble, upper: matchedDouble)))")
//        print("+")
//        print()
    
        return ClosedRange(uncheckedBounds: (
            lower: matchedDouble,
            upper: matchedDouble
        ))
        

    }
    
//    print("+ no RegEx Output")
//    print("+")
//    print()
    
    return nil
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

// MARK: BOOLEAN

func getBool(fromInt int: Int) -> Bool {
    
    if (int == 0) {
        return false
    }
    
    return true
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: ARRAY

func getArray(fromString string: String) -> [String] {
    return string.components(separatedBy: ", ")
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
