//
//  FoldedDogAPIBreedModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

// MARK: DOGS BREEDS (DECODING)
// Each breed has a unique *integer* which can be used to filter a Search.
// This breed.id is available by listing all the APIBreeds via https://api.thecatapi.com/v1/breeds

struct FoldedDogAPIBreedWeight {
    let imperial: String
    let metric: String
}

// ----------------------------------------------------------------------------

extension FoldedDogAPIBreedWeight: Decodable {
    enum CodingKeys: String, CodingKey {
        case imperial = "imperial"
        case metric = "metric"
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
            report(error: error, decoding: "foldedDogAPIBreedWeight.imperial")
            throw(error)
        }
        do {
            metric = try container.decode(String.self, forKey: .metric)
        } catch(let error) {
            report(error: error, decoding: "foldedDogAPIBreedWeight.metric")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------


struct FoldedDogAPIBreedHeight {
    var imperial: String
    var metric: String
}

// ----------------------------------------------------------------------------

extension FoldedDogAPIBreedHeight: Decodable {
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
            report(error: error, decoding: "foldedDogAPIBreedHeight.imperial")
            throw(error)
        }
        do {
            metric = try container.decode(String.self, forKey: .metric)
        } catch(let error) {
            report(error: error, decoding: "foldedDogAPIBreedHeight.metric")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedDogAPIBreedAPIImage {
    var id: String
    var width: Int
    var height: Int
    var url: String
}

// ----------------------------------------------------------------------------

extension FoldedDogAPIBreedAPIImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case url
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
            id = try container.decode(String.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "foldedDogAPIBreedAPIImage.id")
            throw(error)
        }
        do {
            width = try container.decode(Int.self, forKey: .width)
        } catch(let error) {
            report(error: error, decoding: "foldedDogAPIBreedAPIImage.width")
            throw(error)
        }
        do {
            height = try container.decode(Int.self, forKey: .height)
        } catch(let error) {
            report(error: error, decoding: "foldedDogAPIBreedAPIImage.height")
            throw(error)
        }
        do {
            url = try container.decode(String.self, forKey: .url)
        } catch(let error) {
            report(error: error, decoding: "foldedDogAPIBreedAPIImage.url")
            throw(error)
        }
    }
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

struct FoldedDogAPIBreed {
    
    var weight: FoldedDogAPIBreedWeight? // required
    var height: FoldedDogAPIBreedHeight? // required
    
    var id: Int // required
    var name: String // required
    
    var bredFor: String?                                    // MAY BE "" (id: 16, 238)
                                                // "Luring ducks into traps - \"tolling\"" (id: 145)
                                                // "Gundog, \"swamp-tromping\", Flushing, pointing, and retrieving water fowl & game birds" (id: 260)
    var breedGroup: String?                                 // MAY BE "" (id: 11)
    var lifeSpan: String? // required
    var temperament: String?
    var origin: String?                                     // MAY BE "" (id: 3, 7)
    var referenceImageId: String? // required
    
    var image: FoldedDogAPIBreedAPIImage? // required
    
    var countryCode: String?
    var description: String?
    var history: String?                                    // MAY BE "" (id: 7)
}

// ----------------------------------------------------------------------------

extension FoldedDogAPIBreed: Decodable {
    enum CodingKeys: String, CodingKey {
        case weight
        case height
        
        case id
        case name
        
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case lifeSpan = "life_span"
        case temperament
        case origin
        case referenceImageId = "reference_image_id"
        
        case image
        
        case countryCode = "country_code"
        case description
        case history
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
            weight = try container.decodeIfPresent(FoldedDogAPIBreedWeight.self, forKey: .weight) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.weight")
            throw error
        }
        do {
            height = try container.decodeIfPresent(FoldedDogAPIBreedHeight.self, forKey: .height) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.height")
            throw error
        }
        
        // --------------------------------------------------------------------
        // ////////////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.id")
            throw(error)
        }
        do {
            name = try container.decode(String.self, forKey: .name)
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.name")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        // ////////////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        do {
            bredFor = try container.decodeIfPresent(String.self, forKey: .bredFor) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.bredFor")
            throw(error)
        }
        do {
            breedGroup = try container.decodeIfPresent(String.self, forKey: .breedGroup) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.breedGroup")
            throw(error)
        }
        do {
            lifeSpan = try container.decodeIfPresent(String.self, forKey: .lifeSpan) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.lifeSpan")
            throw(error)
        }
        do {
            temperament = try container.decodeIfPresent(String.self, forKey: .temperament) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.temperament")
            throw(error)
        }
        do {
            origin = try container.decodeIfPresent(String.self, forKey: .origin) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.origin")
            throw(error)
        }
        do {
            referenceImageId = try container.decodeIfPresent(String.self, forKey: .referenceImageId) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.referenceImageId")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            image = try container.decodeIfPresent(FoldedDogAPIBreedAPIImage.self, forKey: .image) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.image")
            throw(error)
        }
        
        // --------------------------------------------------------------------
        
        do {
            countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.countryCode")
            throw(error)
        }
        do {
            description = try container.decodeIfPresent(String.self, forKey: .description) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.description")
            throw(error)
        }
        do {
            history = try container.decodeIfPresent(String.self, forKey: .history) ?? nil
        } catch(let error) {
            report(error: error, decoding: "FoldedDogAPIBreed.history")
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

func decodeDogAPIBreeds(data: Data) throws -> [FoldedDogAPIBreed] {
    let jsonData = data
    let decoder = JSONDecoder()
    
    let foldedDogAPIBreeds = try decoder.decode([FoldedDogAPIBreed].self, from: jsonData)
    return foldedDogAPIBreeds
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

//{"$schema": "http://json-schema.org/schema#", "type": "array", "items": {"type": "object", "properties": {"weight": {"type": "object", "properties": {"imperial": {"type": "string"}, "metric": {"type": "string"}}, "required": ["imperial", "metric"]}, "height": {"type": "object", "properties": {"imperial": {"type": "string"}, "metric": {"type": "string"}}, "required": ["imperial", "metric"]}, "id": {"type": "integer"}, "name": {"type": "string"}, "bred_for": {"type": "string"}, "breed_group": {"type": "string"}, "life_span": {"type": "string"}, "temperament": {"type": "string"}, "origin": {"type": "string"}, "reference_image_id": {"type": "string"}, "image": {"type": "object", "properties": {"id": {"type": "string"}, "width": {"type": "integer"}, "height": {"type": "integer"}, "url": {"type": "string"}}, "required": ["height", "id", "url", "width"]}, "country_code": {"type": "string"}, "description": {"type": "string"}, "history": {"type": "string"}}, "required": ["height", "id", "image", "life_span", "name", "reference_image_id", "weight"]}}
