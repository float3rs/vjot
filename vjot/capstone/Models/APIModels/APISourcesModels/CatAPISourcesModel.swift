//
//  CatAPISourcesModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD SOURCES (CAT)

struct CatAPISource {
    var id: Int
    var name: String
    var url: URL?
    var breedId: String?
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

func unfoldCatAPISource(foldedCatAPISource: FoldedCatAPISource) throws -> CatAPISource {
    
    let id = foldedCatAPISource.id
    let name = foldedCatAPISource.name
    let url = URL(string: foldedCatAPISource.url)
    
    var breedId: String? = nil
    if let foldedCatAPISourceBreedId = foldedCatAPISource.breedId {
        breedId = foldedCatAPISourceBreedId
    }
    
    return CatAPISource(
        id: id,
        name: name,
        url: url,
        breedId: breedId
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldCatAPISources(foldedCatAPISources: [FoldedCatAPISource]) throws -> [CatAPISource] {
    var catAPISources: [CatAPISource] = []
    
    try foldedCatAPISources.forEach({ foldedCatAPISource in
        catAPISources.append(try unfoldCatAPISource(foldedCatAPISource: foldedCatAPISource))
    })
    
    return catAPISources
}
