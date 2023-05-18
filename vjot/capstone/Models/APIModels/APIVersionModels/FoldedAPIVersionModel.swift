//
//  FoldedAPIVersionModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedAPIVersion_ {
    var message: String
    var version: String
}

// ----------------------------------------------------------------------------

extension FoldedAPIVersion_: Decodable {}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func fetchAPIVersion_(
    apiEndpoint: APIEndPoint
) async throws -> Data {
    
    var urlString: String = ""
    urlString += apiEndpoint.rawValue
    
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

func decodeAPIVersion_(data: Data) throws -> FoldedAPIVersion_ {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedAPIVersion_ = try decoder.decode(FoldedAPIVersion_.self, from: jsonData)
    return foldedAPIVersion_
}
