//
//  APIImageFunctions.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-27.
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

// MARK: UPLOAD IMAGE

//func convertFormField(named name: String, value: String, using boundary: String) -> String {
//  var fieldString = "--\(boundary)\r\n"
//  fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
//  fieldString += "\r\n"
//  fieldString += "\(value)\r\n"
//
//  return fieldString
//}

//func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
//  let data = NSMutableData()
//
//  data.appendString("--\(boundary)\r\n")
//  data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
//  data.appendString("Content-Type: \(mimeType)\r\n\r\n")
//  data.append(fileData)
//  data.appendString("\r\n")
//
//  return data as Data
//}

//extension NSMutableData {
//  func appendString(_ string: String) {
//    if let data = string.data(using: .utf8) {
//      self.append(data)
//    }
//  }
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func uploadAPIImage(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forImages,
    file: UIImage,
    subId: UUID?
) async throws -> Data {
    
    let uuid = UUID().uuidString
    let boundary = "Boundary-\(uuid)"
    
    var components = URLComponents()
    components.scheme = "https"
    components.path = "/" + apiVersion.rawValue + apiPath.rawValue + "upload/"
    
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
    
    // https://www.donnywals.com/uploading-images-and-forms-to-a-server-using-urlsession/
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    // ------------------------------------------------------------------------
    
    let httpBody = NSMutableData()
//    var httpBody = NSMutableData()
    
    if let subId = subId {
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        httpBody.append("Content-Disposition: form-data; name=\"sub_id\"\r\n".data(using: .utf8)!)
        httpBody.append("\r\n".data(using: .utf8)!)
        httpBody.append("\(subId.uuidString)\r\n".data(using: .utf8)!)
    }
    
    let imageData = file.jpegData(compressionQuality: 0.9)!
//    let imageData = file.pngData()!
//    let uiImage: UIImage = UIImage(data: imageData)               // CONVERT BACK
    
    httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)

    httpBody.append("Content-Disposition: form-data; name=\"file\"; filename=\"cat_photo.jpeg\"\r\n".data(using: .utf8)!)
    httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    httpBody.append(imageData)
    httpBody.append("\r\n".data(using: .utf8)!)
    
    httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
    
    // ------------------------------------------------------------------------
    
    urlRequest.httpBody = httpBody as Data

//    URLSession.shared.dataTask(with: request) { data, response, error in
//    }.resume()
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard (response as? HTTPURLResponse)?.statusCode == 201 else {                      // 201 Created
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard let error = err(statusCode: statusCode) else { fatalError("Fetching Data Error") }
        throw error
    }
    
    return data
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: DELETE UPLOADED IMAGE

func deleteAPIUploadedImage(
    apiEndpoint: APIEndPoint,
    apiVersion: APIVersion,
    apiPath: APIPath = .forImages,
    imageId: String
) async throws -> Data {
    
    var components = URLComponents()
    components.scheme = "https"
    
    components.path = "/" + apiVersion.rawValue + apiPath.rawValue
    components.path += imageId
    
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
    urlRequest.httpMethod = "DELETE"

    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard (response as? HTTPURLResponse)?.statusCode == 204 else {                      // 204 No Content
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard let error = err(statusCode: statusCode) else { fatalError("Fetching Data Error") }
        throw error
    }

    return data
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
