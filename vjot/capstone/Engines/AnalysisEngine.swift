//
//  AnalysisEngine.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 17/4/23.
//

import Foundation
import SwiftUI

@MainActor class AnalysisEngine: ObservableObject {
    
    @Published var analyses: [APIAnalysis] = []
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: INITIALIZATION
    // ------------------------------------------------------------------------
    
    init() {
        
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: FETCHING
    // ------------------------------------------------------------------------
    
    func fetch(_ forSpecies: ForSpecies, imageId: String) async throws {
        
        switch forSpecies {
        case .forCats:
            
            let foldedAPIAnalysesData: Data = try await fetchAPIAnalyses(
                apiEndpoint: .forCats,
                apiVersion: .v1,
                apiPath: .forImages,
                imageId: imageId
            )
            
            let foldedAPIAnalyses = try decodeAPIAnalyses(data: foldedAPIAnalysesData)
            self.analyses = unfoldAPIAnalyses(foldedAPIAnalyses: foldedAPIAnalyses)
            
        case .forDogs:
            
            let foldedAPIAnalysesData: Data = try await fetchAPIAnalyses(
                apiEndpoint: .forDogs,
                apiVersion: .v1,
                apiPath: .forImages,
                imageId: imageId
            )
            
            let foldedAPIAnalyses = try decodeAPIAnalyses(data: foldedAPIAnalysesData)
            self.analyses = unfoldAPIAnalyses(foldedAPIAnalyses: foldedAPIAnalyses)
        }
    }
}
