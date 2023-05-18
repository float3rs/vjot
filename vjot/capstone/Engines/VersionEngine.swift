//
//  VersionEngine.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import Foundation
@MainActor class VersionEngine: ObservableObject {
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: FETCHING
    // ------------------------------------------------------------------------
    
    func fetch(api forSpecies: ForSpecies) async throws -> APIVersion_ {
        
        switch forSpecies {
        case .forCats:
            
            let data = try await fetchAPIVersion_(apiEndpoint: .forCats)
            
            let foldedVersion_ = try decodeAPIVersion_(data: data)
            let version_ = try unfoldAPIVersion_(foldedAPIVersion_: foldedVersion_)
            
            return version_
            
        case .forDogs:
            
            let data = try await fetchAPIVersion_(apiEndpoint: .forDogs)
            
            let foldedVersion_ = try decodeAPIVersion_(data: data)
            let version_ = try unfoldAPIVersion_(foldedAPIVersion_: foldedVersion_)
            
            return version_
        }
    }
}
