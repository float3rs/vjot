//
//  BreedEngine.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation
import SwiftUI

@MainActor class BreedEngine: ObservableObject {
    
    @Published var catBreeds: [CatAPIBreed] = [] {
        didSet {
            do {
                try save(.forCats)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    @Published var dogBreeds: [DogAPIBreed] = [] {
        didSet {
            do {
                try save(.forDogs)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var catSearchTerm = String()
    @Published var dogSearchTerm = String()
    
    @Published var dogGroupSearchTerm = String()
    @Published var catTraitSearchTerm = String()
    @Published var dogTraitSearchTerm = String()
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: INITIALIZATION
    // ------------------------------------------------------------------------
    
    init() {
        
        Task {
            do {
                print("[][][][][ LOADING BREEDS ][][]")
                try load(.forCats)
                try load(.forDogs)
            } catch _ {
                // print(error.localizedDescription)
                do {
                    print("[][][][] FETCHING BREEDS ][][]")
                    try await fetch(.forCats)
                    try await fetch(.forDogs)
                } catch _ {
                    // print(error.localizedDescription)
                    do {
                        print("[][][ FALLBACKING BREEDS ][][]")
                        try fallback(.forCats)
                        try fallback(.forDogs)
                    } catch _ {
                        // print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////////////// MARK: FETCHING
    // ------------------------------------------------------------------------
    
    func fetch(_ forSpecies: ForSpecies, limit: Int? = nil, page: Int? = nil) async throws {
        
        switch forSpecies {
        case .forCats:
            
            let foldedCatAPIBreedsData: Data = try await fetchAPIBreeds(
                apiEndpoint: .forCats,
                apiVersion: .v1,
                apiPath: .forBreeds,
                limit: limit,
                page: page
            )
            
            let foldedCatAPIBreeds = try decodeCatAPIBreeds(data: foldedCatAPIBreedsData)
            self.catBreeds = unfoldCatAPIBreeds(foldedCatAPIBreeds: foldedCatAPIBreeds)
            
        case .forDogs:
            
            let foldedDogAPIBreedsData: Data = try await fetchAPIBreeds(
                apiEndpoint: .forDogs,
                apiVersion: .v1,
                apiPath: .forBreeds,
                limit: limit,
                page: page
            )
            
            let foldedDogAPIBreeds = try decodeDogAPIBreeds(data: foldedDogAPIBreedsData)
            self.dogBreeds = unfoldDogAPIBreeds(foldedDogAPIBreeds: foldedDogAPIBreeds)
        }
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////// MARK: LOADING
    // ------------------------------------------------------------------------
    
    func load(_ forSpecies: ForSpecies) throws {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "breeds")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        switch forSpecies {
        case .forCats:
            
            origin = origin.appending(component: "catBreeds")
            origin = origin.appendingPathExtension("json")
            let catBreedsData = try Data(contentsOf: origin)
            self.catBreeds = try decoder.decode([CatAPIBreed].self, from: catBreedsData)
            
        case .forDogs:
            
            origin = origin.appending(component: "dogBreeds")
            origin = origin.appendingPathExtension("json")
            let dogBreedsData = try Data(contentsOf: origin)
            self.dogBreeds = try decoder.decode([DogAPIBreed].self, from: dogBreedsData)
        }
    }
    
    // ------------------------------------------------------------------------
    // /////////////////////////////////////////////////////// MARK: RETRIEVING
    // ------------------------------------------------------------------------
    
    func fallback(_ forSpecies: ForSpecies) throws {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        switch forSpecies {
        case .forCats:
            
            let location = Bundle.main.url(forResource: "catBreeds", withExtension: "json")
            guard let location else { return }
            let catBreedsData = try Data(contentsOf: location)
            self.catBreeds = try decoder.decode([CatAPIBreed].self, from: catBreedsData)
            
        case .forDogs:
            
            let location = Bundle.main.url(forResource: "dogBreeds", withExtension: "json")
            guard let location else { return }
            let dogBreedsData = try Data(contentsOf: location)
            self.dogBreeds = try decoder.decode([DogAPIBreed].self, from: dogBreedsData)
        }
    }
    
    // ------------------------------------------------------------------------
    // /////////////////////////////////////////////////////////// MARK: SAVING
    // ------------------------------------------------------------------------
    
    func save(_ forSpecies: ForSpecies) throws {
        
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "breeds")
        
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch forSpecies {
        case .forCats:
            
            destination = destination.appending(path: "catBreeds")
            destination = destination.appendingPathExtension("json")
            let catBreedsData = try encoder.encode(self.catBreeds)
            try catBreedsData.write(to: destination)
            
        case .forDogs:
            
            destination = destination.appending(path: "dogBreeds")
            destination = destination.appendingPathExtension("json")
            let dogBreedsData = try encoder.encode(self.dogBreeds)
            try dogBreedsData.write(to: destination)
            
        }
    }
    
    // ------------------------------------------------------------------------
    // /////////////////////////////////////////////////////// MARK: REFRESHING
    // ------------------------------------------------------------------------
    
    func refresh(_ forSpecies: ForSpecies) async throws {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        var location = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        location = location.appending(component: "breeds")
        
        switch forSpecies {
        case .forCats:
            
            try await fetch(.forCats)
            let catBreedsData = try encoder.encode(self.catBreeds)
            location = location.appending(path: "catBreeds")
            location = location.appendingPathExtension("json")
            try FileManager.default.removeItem(atPath: location.relativePath)
            try catBreedsData.write(to: location)
            
        case .forDogs:
            
            try await fetch(.forDogs)
            let dogBreedsData = try encoder.encode(self.dogBreeds)
            location = location.appending(path: "dogBreeds")
            location = location.appendingPathExtension("json")
            try FileManager.default.removeItem(atPath: location.relativePath)
            try dogBreedsData.write(to: location)
        }
    }
    
    // ------------------------------------------------------------------------
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< MARK: IMAGES
    // ------------------------------------------------------------------------
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> IMAGEID
    // ------------------------------------------------------------------------
    
    func locate3(_ forSpecies: ForSpecies, imageId: String, veterinarianId: UUID?) async throws -> (String?, URL?, Int?, Int?) {
        
        switch forSpecies {
        case .forCats:
            let data = try await fetchCatAPIIndividualImage(
                apiVersion: .v1,
                imageId: imageId,
                subId: veterinarianId?.uuidString,
                includeVote: false,
                includeFavourite: false
            )
            
            let foldedImage = try decodeCatAPIIndividualImage(data: data)
            let image = try unfoldCatAPIImage(foldedCatAPIImage: foldedImage)
            return (image.id, image.url, image.width, image.height)
            
        case .forDogs:
            let data = try await fetchDogAPIIndividualImage(
                apiVersion: .v1,
                imageId: imageId,
                subId: veterinarianId?.uuidString,
                includeVote: false,
                includeFavourite: false
            )
            
            let foldedImage = try decodeDogAPIIndividualImage(data: data)
            let image = try unfoldDogAPIImage(foldedDogAPIImage: foldedImage)
            return (image.id, image.url, image.width, image.height)
        }
    }
    
    // CATS [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][
    
    func locateCat(imageId: String, veterinarianId: UUID?) async throws -> CatAPIImage {
        let data = try await fetchCatAPIIndividualImage(
            apiVersion: .v1,
            imageId: imageId,
            subId: veterinarianId?.uuidString,
            includeVote: false,
            includeFavourite: false
        )
        
        let foldedImage = try decodeCatAPIIndividualImage(data: data)
        let image = try unfoldCatAPIImage(foldedCatAPIImage: foldedImage)
        
        return image
    }
    
    // DOGS [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][
    
    func locateDog(imageId: String, veterinarianId: UUID?) async throws -> DogAPIImage {
        let data = try await fetchDogAPIIndividualImage(
            apiVersion: .v1,
            imageId: imageId,
            subId: veterinarianId?.uuidString,
            includeVote: false,
            includeFavourite: false
        )
        
        let foldedImage = try decodeDogAPIIndividualImage(data: data)
        let image = try unfoldDogAPIImage(foldedDogAPIImage: foldedImage)
        
        return image
    }
    
    // ------------------------------------------------------------------------
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> BREEDID
    // ------------------------------------------------------------------------
    // CATS [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][
    // ------------------------------------------------------------------------
    
    func draw3Cat(breedId: String) async throws -> (String?, URL?, Int?, Int?) {
        
        let data = try await fetchCatAPIImages(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forImages,
            size: .full,
            mimeTypes: [.jpg],
            format: .json,
            order: nil,
            page: nil,
            limit: 1,
            categoryIds: nil,
            breedIds: [breedId],
            hasBreeds: true,
            includeBreeds: false,
            includeCategories: false
        )
        
        let foldedImages = try decodeCatAPIImages(data: data)
        let images = try unfoldCatAPIImages(foldedCatAPIImages: foldedImages)
        
        return (images[0].id, images[0].url, images[0].width, images[0].height)
    }
    
    // ========================================================================
    
    func drawCat(breedId: String) async throws -> CatAPIImage? {
        
        let data = try await fetchCatAPIImages(
            apiEndpoint: .forCats,
            apiVersion: .v1,
            apiPath: .forImages,
            size: .full,
            mimeTypes: [.jpg],
            format: .json,
            order: nil,
            page: nil,
            limit: 1,
            categoryIds: nil,
            breedIds: [breedId],
            hasBreeds: true,
            includeBreeds: false,
            includeCategories: false
        )
        
        let foldedImages = try decodeCatAPIImages(data: data)
        let images = try unfoldCatAPIImages(foldedCatAPIImages: foldedImages)
        
        return images.first
    }
    
    // ------------------------------------------------------------------------
    // DOGS [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][
    // ------------------------------------------------------------------------
    
    func draw3Dog(breedId: Int) async throws -> (String?, URL?, Int?, Int?) {
        
        let data = try await fetchDogAPIImages(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forImages,
            size: .full,
            mimeTypes: [.jpg],
            format: .json,
            order: nil,
            page: nil,
            limit: 1,
            categoryIds: nil,
            breedIds: [breedId],
            hasBreeds: true,
            includeBreeds: false,
            includeCategories: false
        )
        
        let foldedImages = try decodeDogAPIImages(data: data)
        let images = try unfoldDogAPIImages(foldedDogAPIImages: foldedImages)
        
        return (images[0].id, images[0].url, images[0].width, images[0].height)
    }
    
    // ========================================================================
    
    func drawDog(breedId: Int) async throws -> DogAPIImage? {
        
        let data = try await fetchDogAPIImages(
            apiEndpoint: .forDogs,
            apiVersion: .v1,
            apiPath: .forImages,
            size: .full,
            mimeTypes: [.jpg],
            format: .json,
            order: nil,
            page: nil,
            limit: 1,
            categoryIds: nil,
            breedIds: [breedId],
            hasBreeds: true,
            includeBreeds: false,
            includeCategories: false
        )
        
        let foldedImages = try decodeDogAPIImages(data: data)
        let images = try unfoldDogAPIImages(foldedDogAPIImages: foldedImages)
        
        return images.first
    }
    
    // ------------------------------------------------------------------------
    // (*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(* MARK: DICTIONARIES
    // ------------------------------------------------------------------------
    
    func catCorrelate() -> [String: String] {
        var dict: [String: String] = [:]
        catBreeds.forEach { breed in
            dict[breed.id] = breed.name
        }
        return dict
    }
    
    func dogCorrelate() -> [Int: String] {
        var dict: [Int: String] = [:]
        dogBreeds.forEach { breed in
            dict[breed.id] = breed.name
        }
        return dict
    }
    
    // ------------------------------------------------------------------------
    // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX MARK: SEARCHERS
    // ------------------------------------------------------------------------
    
    func searchCats() -> [CatAPIBreed] {
        return catSearchTerm.isEmpty ? catBreeds : catBreeds.filter({
            $0.name.lowercased().contains(catSearchTerm.lowercased())
        })
    }
    
    func searchDogs() -> [DogAPIBreed] {
        return dogSearchTerm.isEmpty ? dogBreeds : dogBreeds.filter({
            $0.name.lowercased().contains(dogSearchTerm.lowercased())
        })
    }
    
    // ////////////////////////////////////////////////////
    // /////////////////////////////////// DOG BREED GROUPS
    // ////////////////////////////////////////////////////
    
    func getDogGoups() -> [String] {
        var groups: Set<String> = []
        dogBreeds.forEach { breed in
            if let group = breed.breedGroup {
                if group != "" {
                    groups.insert(group)
                }
               
            }
        }
        return Array(groups)
    }
    
    // //////////////////////////////////////////////////////
    
    func searchDogGroups() -> [DogAPIBreed] {
        var grouppedDogBreeds: [DogAPIBreed] = []
        dogBreeds.forEach { breed in
            if let _ = breed.breedGroup {
                grouppedDogBreeds.append(breed)
            }
        }
        return dogGroupSearchTerm.isEmpty ? grouppedDogBreeds : grouppedDogBreeds.filter({
            $0.breedGroup!.lowercased().contains(dogGroupSearchTerm.lowercased())
        })
    }
    
    // ////////////////////////////////////////////////////
    // //////////////////////////////////// CAT TEMPERAMENT
    // ////////////////////////////////////////////////////
    
    func getCatTraits() -> [String] {
        var traits: Set<String> = []
        catBreeds.forEach { breed in
            if let temperament = breed.temperament {
                temperament.forEach { trait in
                    traits.insert(trait)
                }
            }
        }
        return Array(traits)
    }
    
    // //////////////////////////////////////////////////////
    
    func searchCatTraits() -> [CatAPIBreed] {
        var temperamentalCatBreeds: [CatAPIBreed] = []
        catBreeds.forEach { breed in
            if let _ = breed.temperament {
                temperamentalCatBreeds.append(breed)
            }
        }
        return catTraitSearchTerm.isEmpty ? temperamentalCatBreeds : temperamentalCatBreeds.filter({ breed in
            breed.temperament!.contains { trait in
                trait.lowercased().contains(catTraitSearchTerm.lowercased())
            }
        })
    }
    
    // ////////////////////////////////////////////////////
    // //////////////////////////////////// DOG TEMPERAMENT
    // ////////////////////////////////////////////////////
    
    func getDogTraits() -> [String] {
        var traits: Set<String> = []
        dogBreeds.forEach { breed in
            if let temperament = breed.temperament {
                temperament.forEach { trait in
                    traits.insert(trait)
                }
            }
        }
        return Array(traits)
    }
    
    // //////////////////////////////////////////////////////
    
    func searchDogTraits() -> [DogAPIBreed] {
        var temperamentalDogBreeds: [DogAPIBreed] = []
        dogBreeds.forEach { breed in
            if let _ = breed.temperament {
                temperamentalDogBreeds.append(breed)
            }
        }
        return dogTraitSearchTerm.isEmpty ? temperamentalDogBreeds : temperamentalDogBreeds.filter({ breed in
            breed.temperament!.contains { trait in
                trait.lowercased().contains(dogTraitSearchTerm.lowercased())
            }
        })
    }
}
