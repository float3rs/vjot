//
//  CommonFunctions.swift
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

// MARK: FETCH FAVOURITES

func fetchAPIFavourites(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forFavourites,
    attachImage: Bool?,
    imageId: String?,
    subId: String?,
    page: Int?,
    limit: Int?,
    order: APIOrder?
) async throws -> Data {
    
    var urlString: String = ""
    urlString += apiEndpoint.rawValue
    urlString += apiVersion.rawValue
    urlString += apiPath.rawValue
    
    urlString += "?"
    urlString += "attach_image="
    if let attachImage = attachImage {
        urlString += attachImage ? "1" : "0"
    }
    
    urlString += "&"
    urlString += "image_id="
    if let imageId = imageId {
        urlString += imageId
    }
    
    urlString += "&"
    urlString += "sub_id="
    if let subId = subId {
        urlString += subId
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
    urlString += "order="
    if let order = order {
        urlString += order.rawValue
    }
    
    // ------------------------------------------------------------------------
    urlString += "&"
    urlString += "api_key="
    
    switch apiEndpoint {
    case .forCats:
        urlString += recover(jewel: .theCatAPIKey)
    case .forDogs:
        urlString += recover(jewel: .theDogAPIKey)
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

// MARK: FETCH INDIVIDUAL FAVOURITE

func fetchAPIIndividualFavourite(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forFavourites,
    favouriteId: Int
) async throws -> Data {
    
    var urlString: String = ""
    urlString += apiEndpoint.rawValue
    urlString += apiVersion.rawValue
    urlString += apiPath.rawValue
    
    urlString += String(favouriteId)
    
    // ------------------------------------------------------------------------
    urlString += "?"
    urlString += "api_key="
    
    switch apiEndpoint {
    case .forCats:
        urlString += recover(jewel: .theCatAPIKey)
    case .forDogs:
        urlString += recover(jewel: .theDogAPIKey)
    }
    // ------------------------------------------------------------------------
    
    guard let url = URL(string: urlString) else {
        fatalError("URL Unreachable")
    }
         
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        let statusCode = (response as! HTTPURLResponse).statusCode
        // 404: INVALID FAVOURITE ID
        if statusCode == 404 { throw VJotError.id }
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

// MARK: POST FAVOURITE

func postAPIFavourite(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forFavourites,
    imageId: String,
    subId: String
) async throws -> Data {
    
    var components = URLComponents()
    components.scheme = "https"
    components.path = "/" + apiVersion.rawValue + apiPath.rawValue
    
    switch apiEndpoint {
    case .forCats:
        components.host = "api.thecatapi.com"
        components.queryItems = [
            URLQueryItem(
                name: "api_key",
                value: recover(jewel: .theCatAPIKey)
            )
        ]
    case .forDogs:
        components.host = "api.thedogapi.com"
        components.queryItems = [
            URLQueryItem(
                name: "api_key",
                value: recover(jewel: .theDogAPIKey)
            )
        ]
    }

    // https://advswift.com/api/devs?skill=swift
    var urlRequest = URLRequest(url: components.url!)
    
    // Configure request authentication
    // request.setValue("authToken", forHTTPHeaderField: "Authorization")
    
    // For POST requests with a JSON body, set the Content-Type header
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Serialize HTTP Body data as JSON
    let body = ["image_id": imageId, "sub_id": subId]
    let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])

    // Change the URLRequest to a POST request
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = bodyData
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard let error = err(statusCode: statusCode) else { fatalError("Fetching Data Error") }
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

// MARK: DELETE FAVOURITE

func deleteAPIFavourite(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forFavourites,
    favouriteId: Int
) async throws -> Data {
    
    var components = URLComponents()
    components.scheme = "https"
    
    components.path = "/" + apiVersion.rawValue + apiPath.rawValue
    components.path += String(favouriteId)
    
    switch apiEndpoint {
    case .forCats:
        components.host = "api.thecatapi.com"
        components.queryItems = [
            URLQueryItem(
                name: "api_key",
                value: recover(jewel: .theCatAPIKey)
            )
        ]
    case .forDogs:
        components.host = "api.thedogapi.com"
        components.queryItems = [
            URLQueryItem(
                name: "api_key",
                value: recover(jewel: .theDogAPIKey)
            )
        ]
    }

    // https://advswift.com/api/devs?skill=swift
    var urlRequest = URLRequest(url: components.url!)

    // Configure request authentication
    // request.setValue("authToken", forHTTPHeaderField: "Authorization")
    // For POST requests with a JSON body, set the Content-Type header
    // urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    // Serialize HTTP Body data as JSON
    // let body: [String:String] = [:]
    // let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])

    // Change the URLRequest to a POST request
    urlRequest.httpMethod = "DELETE"
    // urlRequest.httpBody = bodyData

    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard let error = err(statusCode: statusCode) else { fatalError("Fetching Data Error") }
        throw error
    }

    return data
}

// ----------------------------------------------------------------------------
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// ----------------------------------------------------------------------------
