//
//  DogAPIBreedModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: UNFOLD (DOGS)

struct DogAPIBreedWeight {
    var imperial: ClosedRange<Double>?
    var metric: ClosedRange<Double>?
}

struct DogAPIBreedHeight {
    var imperial: ClosedRange<Double>?
    var metric: ClosedRange<Double>?
}

struct DogAPIBreedAPIImage {
    var id: String
    var width: Int
    var height: Int
    var url: URL?
}

struct DogAPIBreed {
    
    var weight: DogAPIBreedWeight? // required
    var height: DogAPIBreedHeight? // required
    
    var id: Int // required
    
    var name: String // required
    var bredFor: [String]?
    var breedGroup: String?
    var lifeSpan: ClosedRange<Double>? // required
    var temperament: [String]?
    var origin: [String]?
    var referenceImageId: String? // required
    
    var image: DogAPIBreedAPIImage? // required             
    
    var countryCode: String?
    var description: String?
    var history: String?
}

// ----------------------------------------------------------------------------

extension DogAPIBreedWeight: Codable & Hashable {}
extension DogAPIBreedHeight: Codable & Hashable {}
extension DogAPIBreedAPIImage: Codable & Hashable {}
extension DogAPIBreed: Codable & Identifiable & Hashable {}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldDogAPIBreedWeight(foldedDogAPIBreedWeight: FoldedDogAPIBreedWeight) -> DogAPIBreedWeight {
    
    return DogAPIBreedWeight(
        imperial: getClosedRange(fromString: foldedDogAPIBreedWeight.imperial) ?? nil,
        metric: getClosedRange(fromString: foldedDogAPIBreedWeight.metric) ?? nil
    )
}

// ----------------------------------------------------------------------------

func unfoldDogAPIBreedHeight(foldedDogAPIBreedHeight: FoldedDogAPIBreedHeight) -> DogAPIBreedHeight {
    
    return DogAPIBreedHeight(
        imperial: getClosedRange(fromString: foldedDogAPIBreedHeight.imperial) ?? nil,
        metric: getClosedRange(fromString: foldedDogAPIBreedHeight.metric) ?? nil
    )
}

// ----------------------------------------------------------------------------

func unfoldDogAPIBreedAPIImage(foldedDogAPIBreedAPIImage: FoldedDogAPIBreedAPIImage) -> DogAPIBreedAPIImage {
    
    return DogAPIBreedAPIImage(
        id: foldedDogAPIBreedAPIImage.id,
        width: foldedDogAPIBreedAPIImage.width,
        height: foldedDogAPIBreedAPIImage.height,
        url: URL(string: foldedDogAPIBreedAPIImage.url)
    )
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func unfoldDogAPIBreed(foldedDogAPIBreed: FoldedDogAPIBreed) -> DogAPIBreed {
    
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
    
    var weight: DogAPIBreedWeight? = nil
    if let foldedDogAPIBreedWeight = foldedDogAPIBreed.weight {
        weight = unfoldDogAPIBreedWeight(foldedDogAPIBreedWeight: foldedDogAPIBreedWeight)
    }
    var height: DogAPIBreedHeight? = nil
    if let foldedDogAPIBreedHeight = foldedDogAPIBreed.height {
        height = unfoldDogAPIBreedHeight(foldedDogAPIBreedHeight: foldedDogAPIBreedHeight)
    }
    
    let id = foldedDogAPIBreed.id
    
    let name = foldedDogAPIBreed.name
    let bredFor = unfoldTo(array: foldedDogAPIBreed.bredFor)
    let breedGroup = foldedDogAPIBreed.breedGroup
    
    let lifeSpan = unfoldTo(closedRange: foldedDogAPIBreed.lifeSpan)
    
    let temperament = unfoldTo(array: foldedDogAPIBreed.temperament)
    let origin = unfoldTo(array: foldedDogAPIBreed.origin)
    
    let referenceImageId = foldedDogAPIBreed.referenceImageId
    
    var image: DogAPIBreedAPIImage? = nil
    if let foldedDogAPIBreedAPIImage = foldedDogAPIBreed.image {
        image = unfoldDogAPIBreedAPIImage(foldedDogAPIBreedAPIImage: foldedDogAPIBreedAPIImage)
    }
    
    let countryCode = foldedDogAPIBreed.countryCode
    let description = foldedDogAPIBreed.description
    let history = foldedDogAPIBreed.history
    
    // ------------------------------------------------------------------------
    
    return DogAPIBreed(
        weight: weight,
        height: height,
        id: id,
        name: name,
        bredFor: bredFor,
        breedGroup: breedGroup,
        lifeSpan: lifeSpan,
        temperament: temperament,
        origin: origin,
        referenceImageId: referenceImageId,
        image: image,
        countryCode: countryCode,
        description: description,
        history: history
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

func unfoldDogAPIBreeds(foldedDogAPIBreeds: [FoldedDogAPIBreed]) -> [DogAPIBreed] {
    var dogAPIBreeds: [DogAPIBreed] = []
    
    foldedDogAPIBreeds.forEach { foldedDogAPIBreed in
        dogAPIBreeds.append(unfoldDogAPIBreed(foldedDogAPIBreed: foldedDogAPIBreed))
    }
    
    return dogAPIBreeds
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: DOG BREEDS DICTIONARY [String:Int]

func generateDogAPIBreedsDict(dogAPIBreeds: [DogAPIBreed]) -> [String:Int] {
    var dogAPIBreedsDict: [String:Int] = [:]
    
    dogAPIBreeds.forEach { dogAPIBreed in
            dogAPIBreedsDict[dogAPIBreed.name] = dogAPIBreed.id
    }
    
    return dogAPIBreedsDict
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
