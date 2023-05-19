//
//  SourcesEngine.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import Foundation

@MainActor class SourcesEngine: ObservableObject {
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: FETCHING
    // ------------------------------------------------------------------------
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ CATS
    // ------------------------------------------------------------------------
    
    func fetchCats(count: Int?) async throws -> [CatAPISource] {
        
        let data = try await fetchCatAPISources(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forSources,
            limit: count,
            page: nil
        )
        
        let foldedSources = try decodeCatAPISources(data: data)
        let sources = try unfoldCatAPISources(foldedCatAPISources: foldedSources)
        
        return sources
    }
}
