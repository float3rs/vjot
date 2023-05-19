//
//  CatAPIBreedModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD (CATS)

struct CatAPIBreedWeight {
    var imperial: ClosedRange<Double>?
    var metric: ClosedRange<Double>?
}

struct CatAPIBreed {
    
    var weight: CatAPIBreedWeight? // required
    
    var id: String // required
    
    var name: String // required
    var cfaUrl: URL?
    var vetstreetUrl: URL?
    var vcahospitalsUrl: URL?
    var temperament: [String]? // required
    var origin: [String]? // required
    var countryCodes: [String]? // required
    var countryCode: String? // required
    var description: String? // required
    var lifeSpan: ClosedRange<Double>? // required
    
    var indoor: Bool? // required
    var lap: Bool?
    
    var altNames: [String]?
    
    var adaptability: Int? // required
    var affectionLevel: Int? // required
    var childFriendly: Int? // required
    var dogFriendly: Int? // required
    var energyLevel: Int? // required
    var grooming: Int? // required
    var healthIssues: Int? // required
    var intelligence: Int? // required
    var sheddingLevel: Int? // required
    var socialNeeds: Int? // required
    var strangerFriendly: Int? // required
    var vocalisation: Int? // required
    var experimental: Bool? // required
    var hairless: Bool? // required
    var natural: Bool? // required
    var rare: Bool? // required
    var rex: Bool? // required
    var suppressedTail: Bool? // required
    var shortLegs: Bool? // required
    
    var wikipediaUrl: URL?
    
    var hypoallergenic: Bool? // required
    
    var referenceImageId: String?
    
    var catFriendly: Int?
    var bidability: Int?
}

// ----------------------------------------------------------------------------

extension CatAPIBreedWeight: Codable & Hashable {}
extension CatAPIBreed: Codable & Identifiable & Hashable {}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldCatAPIBreedWeight(foldedCatAPIBreedWeight: FoldedCatAPIBreedWeight) -> CatAPIBreedWeight {
    
    return CatAPIBreedWeight(
        imperial: getClosedRange(fromString: foldedCatAPIBreedWeight.imperial) ?? nil,
        metric: getClosedRange(fromString: foldedCatAPIBreedWeight.metric) ?? nil
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldCatAPIBreed(foldedCatAPIBreed: FoldedCatAPIBreed) -> CatAPIBreed {
    
    func unfoldTo(url foldedString: String?) -> URL? {
        if let foldedString = foldedString {
            return URL(string: foldedString)
        }
        return nil
    }
    
    func unfoldTo(array foldedString: String?) -> [String]? {
        if let foldedString = foldedString {
            return foldedString.components(separatedBy: ", ")
        }
        return nil
    }
    
    func unfoldTo(bool foldedInt: Int?) -> Bool? {
        if let foldedInt = foldedInt {
            return (foldedInt == 0) ? false : true
        }
        return nil
    }
    
    func unfoldTo(closedRange foldedString: String?) -> ClosedRange<Double>? {
        if let foldedString = foldedString {
            return getClosedRange(fromString: foldedString)
        }
        return nil
    }
    
    // ------------------------------------------------------------------------
    
    var weight: CatAPIBreedWeight? = nil
    if let foldedCatAPIBreedWeight = foldedCatAPIBreed.weight {
        weight = unfoldCatAPIBreedWeight(foldedCatAPIBreedWeight: foldedCatAPIBreedWeight)
    }
    
    let id = foldedCatAPIBreed.id
    
    let name = foldedCatAPIBreed.name
    
    let cfaUrl = unfoldTo(url: foldedCatAPIBreed.cfaUrl)
    let vetstreetUrl = unfoldTo(url: foldedCatAPIBreed.vetstreetUrl)
    let vcahospitalsUrl = unfoldTo(url: foldedCatAPIBreed.vcahospitalsUrl)
    
    let temperament = unfoldTo(array: foldedCatAPIBreed.temperament)
    let origin = unfoldTo(array: foldedCatAPIBreed.origin)
    let countryCodes = unfoldTo(array: foldedCatAPIBreed.countryCodes)
    
    let countryCode = foldedCatAPIBreed.countryCode
    let description = foldedCatAPIBreed.description
    
    let lifeSpan = unfoldTo(closedRange: foldedCatAPIBreed.lifeSpan)
    
    let indoor = unfoldTo(bool: foldedCatAPIBreed.indoor)
    let lap = unfoldTo(bool: foldedCatAPIBreed.lap)
    
    let altNames = unfoldTo(array: foldedCatAPIBreed.altNames)
    
    let adaptability = foldedCatAPIBreed.adaptability
    let affectionLevel = foldedCatAPIBreed.affectionLevel
    let childFriendly = foldedCatAPIBreed.childFriendly
    let dogFriendly = foldedCatAPIBreed.dogFriendly
    let energyLevel = foldedCatAPIBreed.energyLevel
    let grooming = foldedCatAPIBreed.grooming
    let healthIssues = foldedCatAPIBreed.healthIssues
    let intelligence = foldedCatAPIBreed.intelligence
    let sheddingLevel = foldedCatAPIBreed.sheddingLevel
    let socialNeeds = foldedCatAPIBreed.socialNeeds
    let strangerFriendly = foldedCatAPIBreed.strangerFriendly
    let vocalisation = foldedCatAPIBreed.vocalisation
        
    let experimental = unfoldTo(bool: foldedCatAPIBreed.experimental)
    let hairless = unfoldTo(bool: foldedCatAPIBreed.hairless)
    let natural = unfoldTo(bool: foldedCatAPIBreed.natural)
    let rare = unfoldTo(bool: foldedCatAPIBreed.rare)
    let rex = unfoldTo(bool: foldedCatAPIBreed.rex)
    let suppressedTail = unfoldTo(bool: foldedCatAPIBreed.suppressedTail)
    let shortLegs = unfoldTo(bool: foldedCatAPIBreed.shortLegs)

    let wikipediaUrl = unfoldTo(url: foldedCatAPIBreed.wikipediaUrl)

    let hypoallergenic = unfoldTo(bool: foldedCatAPIBreed.hypoallergenic)

    let referenceImageId = foldedCatAPIBreed.referenceImageId

    let catFriendly = foldedCatAPIBreed.catFriendly
    let bidability = foldedCatAPIBreed.bidability
    
    // ------------------------------------------------------------------------
    
    return CatAPIBreed(
        weight: weight,
        id: id,
        name: name,
        cfaUrl: cfaUrl,
        vetstreetUrl: vetstreetUrl,
        vcahospitalsUrl: vcahospitalsUrl,
        temperament: temperament,
        origin: origin,
        countryCodes: countryCodes,
        countryCode: countryCode,
        description: description,
        lifeSpan: lifeSpan,
        indoor: indoor,
        lap: lap,
        altNames: altNames,
        adaptability: adaptability,
        affectionLevel: affectionLevel,
        childFriendly: childFriendly,
        dogFriendly: dogFriendly,
        energyLevel: energyLevel,
        grooming: grooming,
        healthIssues: healthIssues,
        intelligence: intelligence,
        sheddingLevel: sheddingLevel,
        socialNeeds: socialNeeds,
        strangerFriendly: strangerFriendly,
        vocalisation: vocalisation,
        experimental: experimental,
        hairless: hairless,
        natural: natural,
        rare: rare,
        rex: rex,
        suppressedTail: suppressedTail,
        shortLegs: shortLegs,
        wikipediaUrl: wikipediaUrl,
        hypoallergenic: hypoallergenic,
        referenceImageId: referenceImageId,
        catFriendly: catFriendly,
        bidability: bidability
    )
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

func unfoldCatAPIBreeds(foldedCatAPIBreeds: [FoldedCatAPIBreed]) -> [CatAPIBreed] {
    var CatAPIBreeds: [CatAPIBreed] = []
    
    foldedCatAPIBreeds.forEach { foldedCatAPIBreed in
        CatAPIBreeds.append(unfoldCatAPIBreed(foldedCatAPIBreed: foldedCatAPIBreed))
    }
    
    return CatAPIBreeds
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: CAT BREEDS DICTIONARY [String:String]

func generateCatAPIBreedsDict(catAPIBreeds: [CatAPIBreed]) -> [String:String] {
    var catAPIBreedsDict: [String:String] = [:]
    
    catAPIBreeds.forEach { catAPIBreed in
        catAPIBreedsDict[catAPIBreed.name] = catAPIBreed.id
    }
    
    return catAPIBreedsDict
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
