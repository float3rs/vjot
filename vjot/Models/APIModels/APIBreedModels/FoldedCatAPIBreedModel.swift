//
//  FoldedCatAPIBreedModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: CATS BREEDS (DECODING)
// Each breed has a unique *4 character* id which can be used to filter a Search.
// This breed.id is available by listing all the APIBreeds via https://api.thecatapi.com/v1/breeds

struct FoldedCatAPIBreedWeight {
    var imperial: String
    var metric: String
}

// ----------------------------------------------------------------------------

extension FoldedCatAPIBreedWeight: Decodable {
    enum CodingKeys: String, CodingKey {
        case imperial
        case metric
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print("&")
            print("& \(error.localizedDescription)")
            print("& \(decoding)")
            print("&")
            print()
        }
        
        do {
            imperial = try container.decode(String.self, forKey: .imperial)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreedWeight.imperial")
            throw error
        }
        do {
            metric = try container.decode(String.self, forKey: .metric)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreedWeight.metric")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedCatAPIBreed {
    
    var weight: FoldedCatAPIBreedWeight? // required
    
    var id: String // required
    var name: String // required
    
    var cfaUrl: String?
    var vetstreetUrl: String?
    var vcahospitalsUrl: String?                    // "" (id: "amau")
    var temperament: String? // required
    var origin: String? // required
    var countryCodes: String? // required
    var countryCode: String? // required
    var description: String? // required
    var lifeSpan: String? // required
    
    var indoor: Int? // required
    var lap: Int?
    
    var altNames: String?                           // ""
    
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
    var experimental: Int? // required
    var hairless: Int? // required
    var natural: Int? // required
    var rare: Int? // required
    var rex: Int? // required
    var suppressedTail: Int? // required
    var shortLegs: Int? // required
    
    var wikipediaUrl: String?
    
    var hypoallergenic: Int? // required
    
    var referenceImageId: String?
    
    var catFriendly: Int?
    var bidability: Int?
}

// ----------------------------------------------------------------------------

extension FoldedCatAPIBreed: Decodable {
    enum CodingKeys: String, CodingKey {
        case weight
        
        case id
        case name
        
        case cfaUrl = "cfa_url"
        case vetstreetUrl = "vetstreet_url"
        case vcahospitalsUrl = "vcahospital_url"
        case temperament
        case origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case description
        case lifeSpan = "life_span"
        
        case indoor
        case lap
        
        case altNames = "alt_names"
        
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation
        case experimental
        case hairless
        case natural
        case rare
        case rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        
        case wikipediaUrl = "wikipedia_url"
        
        case hypoallergenic
        
        case referenceImageId = "reference_image_id"
        
        case catFriendly = "cat_friendly"
        case bidability
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func report(error: Error, decoding: String) -> Void {
            print()
            print(">")
            print("> \(error.localizedDescription)")
            print("> \(decoding)")
            print(">")
            print()
        }
        
        do {
            weight = try container.decodeIfPresent(FoldedCatAPIBreedWeight.self, forKey: .weight) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.weight")
            throw error
        }
        
        // --------------------------------------------------------------------
        // ////////////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        do {
            id = try container.decode(String.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.id")
            throw(error)
        }
        do {
            name = try container.decode(String.self, forKey: .name)
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.name")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        // ////////////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        do {
            cfaUrl = try container.decodeIfPresent(String.self, forKey: .cfaUrl) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.cfaUrl")
            throw(error)
        }
        do {
            vetstreetUrl = try container.decodeIfPresent(String.self, forKey: .vetstreetUrl) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.vetstreetUrl")
            throw(error)
        }
        do {
            vcahospitalsUrl = try container.decodeIfPresent(String.self, forKey: .vcahospitalsUrl) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.vcahospitalsUrl")
            throw(error)
        }
        do {
            temperament = try container.decodeIfPresent(String.self, forKey: .temperament) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.temperament")
            throw(error)
        }
        do {
            origin = try container.decodeIfPresent(String.self, forKey: .origin) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.origin")
            throw(error)
        }
        do {
            countryCodes = try container.decodeIfPresent(String.self, forKey: .countryCodes) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.countryCodes")
            throw(error)
        }
        do {
            countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.countryCode")
            throw(error)
        }
        do {
            description = try container.decodeIfPresent(String.self, forKey: .description) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.description")
            throw(error)
        }
        do {
            lifeSpan = try container.decodeIfPresent(String.self, forKey: .lifeSpan) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.lifeSpan")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            indoor = try container.decodeIfPresent(Int.self, forKey: .indoor) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.indoor")
            throw(error)
        }
        do {
            lap = try container.decodeIfPresent(Int.self, forKey: .lap) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.lap")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            altNames = try container.decodeIfPresent(String.self, forKey: .altNames) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.altNames")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            adaptability = try container.decodeIfPresent(Int.self, forKey: .adaptability) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.adaptability")
            throw(error)
        }
        do {
            affectionLevel = try container.decodeIfPresent(Int.self, forKey: .affectionLevel) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.affectionLevel")
            throw(error)
        }
        do {
            childFriendly = try container.decodeIfPresent(Int.self, forKey: .childFriendly) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.childFriendly")
            throw(error)
        }
        do {
            dogFriendly = try container.decodeIfPresent(Int.self, forKey: .dogFriendly) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.dogFriendly")
            throw(error)
        }
        do {
            energyLevel = try container.decodeIfPresent(Int.self, forKey: .energyLevel) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.energyLevel")
            throw(error)
        }
        do {
            grooming = try container.decodeIfPresent(Int.self, forKey: .grooming) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.grooming")
            throw(error)
        }
        do {
            healthIssues = try container.decodeIfPresent(Int.self, forKey: .healthIssues) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.healthIssues")
            throw(error)
        }
        do {
            intelligence = try container.decodeIfPresent(Int.self, forKey: .intelligence) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.intelligence")
            throw(error)
        }
        do {
            sheddingLevel = try container.decodeIfPresent(Int.self, forKey: .sheddingLevel) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.sheddingLevel")
            throw(error)
        }
        do {
            socialNeeds = try container.decodeIfPresent(Int.self, forKey: .socialNeeds) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.socialNeeds")
            throw(error)
        }
        do {
            strangerFriendly = try container.decodeIfPresent(Int.self, forKey: .strangerFriendly) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.strangerFriendly")
            throw(error)
        }
        do {
            vocalisation = try container.decodeIfPresent(Int.self, forKey: .vocalisation) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.vocalisation")
            throw(error)
        }
        do {
            experimental = try container.decodeIfPresent(Int.self, forKey: .experimental) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.experimental")
            throw(error)
        }
        do {
            hairless = try container.decodeIfPresent(Int.self, forKey: .hairless) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.hairless")
            throw(error)
        }
        do {
            natural = try container.decodeIfPresent(Int.self, forKey: .natural) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.natural")
            throw(error)
        }
        do {
            rare = try container.decodeIfPresent(Int.self, forKey: .rare) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.rare")
            throw(error)
        }
        do {
            rex = try container.decodeIfPresent(Int.self, forKey: .rex) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.rex")
            throw(error)
        }
        do {
            suppressedTail = try container.decodeIfPresent(Int.self, forKey: .suppressedTail) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.suppressedTail")
            throw(error)
        }
        do {
            shortLegs = try container.decodeIfPresent(Int.self, forKey: .shortLegs) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.shortLegs")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            wikipediaUrl = try container.decodeIfPresent(String.self, forKey: .wikipediaUrl) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.wikipediaUrl")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            hypoallergenic = try container.decodeIfPresent(Int.self, forKey: .hypoallergenic) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.hypoallergenic")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            referenceImageId = try container.decodeIfPresent(String.self, forKey: .referenceImageId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.referenceImageId")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            catFriendly = try container.decodeIfPresent(Int.self, forKey: .catFriendly) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.catFriendly")
            throw(error)
        }
        do {
            bidability = try container.decodeIfPresent(Int.self, forKey: .bidability) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedCatAPIBreed.bidability")
            throw(error)
        }
    }
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
// ----------------------------------------------------------------------------

// MARK: FETCH BREEDS

//func fetchAPIBreeds(
//    apiEndpoint: APIEndPoint,
//    apiVersion: APIVersion,
//    apiPath: APIPath = .forBreeds,
//    limit: Int?,
//    page: Int?
//) async throws -> Data {
//
//    var urlString: String = ""
//    urlString += apiEndpoint.rawValue
//    urlString += apiVersion.rawValue
//    urlString += apiPath.rawValue
//
//    urlString += "?"
//    urlString += "limit="
//    if let limit = limit {
//        urlString += String(limit)
//    }
//
//    urlString += "&"
//    urlString += "page="
//    if let page = page {
//        urlString += String(page)
//    }
//
//    // ------------------------------------------------------------------------
//
//    guard let url = URL(string: urlString) else {
//        fatalError("URL Unreachable")
//    }
//
//    let urlRequest = URLRequest(url: url)
//    let (data, response) = try await URLSession.shared.data(for: urlRequest)
//
//    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//        fatalError("Fetching Data Error")
//    }
//
//    return data
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

func decodeCatAPIBreeds(data: Data) throws -> [FoldedCatAPIBreed] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedCatAPIBreeds = try decoder.decode([FoldedCatAPIBreed].self, from: jsonData)
    return foldedCatAPIBreeds
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

// MARK: LOAD BREEDS

//enum APIBreedsDataSet: String {
//    case forCats = "cat_breeds"
//    case forDogs = "dog_breeds"
//}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

//func loadAPIBreeds(_ forSpecies: APIBreedsDataSet) throws -> Data {
//
//    guard let asset = NSDataAsset(name: forSpecies.rawValue) else {
//        fatalError("Data Set Unreachable")
//    }
//
//    return asset.data
//}

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

// GenSON is a powerful, user-friendly JSON Schema generator built in Python.
// https://github.com/wolverdude/GenSON

//{"$schema": "http://json-schema.org/schema#", "type": "array", "items": {"type": "object", "properties": {"weight": {"type": "object", "properties": {"imperial": {"type": "string"}, "metric": {"type": "string"}}, "required": ["imperial", "metric"]}, "id": {"type": "string"}, "name": {"type": "string"}, "cfa_url": {"type": "string"}, "vetstreet_url": {"type": "string"}, "vcahospitals_url": {"type": "string"}, "temperament": {"type": "string"}, "origin": {"type": "string"}, "country_codes": {"type": "string"}, "country_code": {"type": "string"}, "description": {"type": "string"}, "life_span": {"type": "string"}, "indoor": {"type": "integer"}, "lap": {"type": "integer"}, "alt_names": {"type": "string"}, "adaptability": {"type": "integer"}, "affection_level": {"type": "integer"}, "child_friendly": {"type": "integer"}, "dog_friendly": {"type": "integer"}, "energy_level": {"type": "integer"}, "grooming": {"type": "integer"}, "health_issues": {"type": "integer"}, "intelligence": {"type": "integer"}, "shedding_level": {"type": "integer"}, "social_needs": {"type": "integer"}, "stranger_friendly": {"type": "integer"}, "vocalisation": {"type": "integer"}, "experimental": {"type": "integer"}, "hairless": {"type": "integer"}, "natural": {"type": "integer"}, "rare": {"type": "integer"}, "rex": {"type": "integer"}, "suppressed_tail": {"type": "integer"}, "short_legs": {"type": "integer"}, "wikipedia_url": {"type": "string"}, "hypoallergenic": {"type": "integer"}, "reference_image_id": {"type": "string"}, "cat_friendly": {"type": "integer"}, "bidability": {"type": "integer"}}, "required": ["adaptability", "affection_level", "child_friendly", "country_code", "country_codes", "description", "dog_friendly", "energy_level", "experimental", "grooming", "hairless", "health_issues", "hypoallergenic", "id", "indoor", "intelligence", "life_span", "name", "natural", "origin", "rare", "rex", "shedding_level", "short_legs", "social_needs", "stranger_friendly", "suppressed_tail", "temperament", "vocalisation", "weight"]}}
