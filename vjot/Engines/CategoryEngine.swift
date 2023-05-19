//
//  CategoryEngine.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 7/4/23.
//

import Foundation
import SwiftUI

@MainActor class CategoryEngine: ObservableObject {
    
    @Published var catCategories: [CatAPICategory] = [] {
        didSet {
            do {
                try save(.forCats)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    @Published var dogCategories: [DogAPICategory] = [] {
        didSet {
            do {
                try save(.forDogs)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: INITIALIZATION
    // ------------------------------------------------------------------------
    
    init() {
        
        Task {
            do {
                print("[][][][ LOADING CATEGORIES ][]")
                try load(.forCats)
                try load(.forDogs)
            } catch _ {
                // print(error.localizedDescription)
                do {
                    print("[][][] FETCHING CATEGORIES ][]")
                    try await fetch(.forCats)
                    try await fetch(.forDogs)
                } catch _ {
                    // print(error.localizedDescription)
                    do {
                        print("[][ FALLBACKING CATEGORIES ][]")
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
            
            let foldedCatAPICategoriesData: Data = try await fetchAPICategories(
                apiEndpoint: .forCats,
                apiVersion: .v1,
                apiPath: .forCategories,
                limit: limit,
                page: page
            )
            
            let foldedCatAPICategories = try decodeCatAPICategories(data: foldedCatAPICategoriesData)
            self.catCategories = unfoldCatAPICategories(foldedCatAPICategories: foldedCatAPICategories)
            
        case .forDogs:
            
            let foldedDogAPICategoriesData: Data = try await fetchAPICategories(
                apiEndpoint: .forDogs,
                apiVersion: .v1,
                apiPath: .forCategories,
                limit: limit,
                page: page
            )
            
            let foldedDogAPICategories = try decodeDogAPICategories(data: foldedDogAPICategoriesData)
            self.dogCategories = unfoldDogAPICategories(foldedDogAPICategories: foldedDogAPICategories)
        }
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////////////////// MARK: LOADING
    // ------------------------------------------------------------------------
    
    func load(_ forSpecies: ForSpecies) throws {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "categories")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        switch forSpecies {
        case .forCats:
            
            origin = origin.appending(component: "catCategories")
            origin = origin.appendingPathExtension("json")
            let catCategoriesData = try Data(contentsOf: origin)
            self.catCategories = try decoder.decode([CatAPICategory].self, from: catCategoriesData)
            
        case .forDogs:
            
            origin = origin.appending(component: "dogCategories")
            origin = origin.appendingPathExtension("json")
            let dogCategoriesData = try Data(contentsOf: origin)
            self.dogCategories = try decoder.decode([DogAPICategory].self, from: dogCategoriesData)
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
            
            let location = Bundle.main.url(forResource: "catCategories", withExtension: "json")
            guard let location else { return }
            let catCategoriesData = try Data(contentsOf: location)
            self.catCategories = try decoder.decode([CatAPICategory].self, from: catCategoriesData)
            
        case .forDogs:
            
            let location = Bundle.main.url(forResource: "dogCategories", withExtension: "json")
            guard let location else { return }
            let dogCategoriesData = try Data(contentsOf: location)
            self.dogCategories = try decoder.decode([DogAPICategory].self, from: dogCategoriesData)
        }
    }
        
    // ------------------------------------------------------------------------
    // /////////////////////////////////////////////////////////// MARK: SAVING
    // ------------------------------------------------------------------------
    
    func save(_ forSpecies: ForSpecies) throws {
        
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "categories")
        
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch forSpecies {
        case .forCats:
            
            destination = destination.appending(path: "catCategories")
            destination = destination.appendingPathExtension("json")
            let catCategoriesData = try encoder.encode(self.catCategories)
            try catCategoriesData.write(to: destination)
            
        case .forDogs:
            
            destination = destination.appending(path: "dogCategories")
            destination = destination.appendingPathExtension("json")
            let dogCategoriesData = try encoder.encode(self.dogCategories)
            try dogCategoriesData.write(to: destination)
            
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
        location = location.appending(component: "categories")
        
        switch forSpecies {
        case .forCats:
            
            try await fetch(.forCats)
            let catCategoriesData = try encoder.encode(self.catCategories)
            location = location.appending(path: "catCategories")
            location = location.appendingPathExtension("json")
            try FileManager.default.removeItem(atPath: location.relativePath)
            try catCategoriesData.write(to: location)
            
        case .forDogs:
            
            try await fetch(.forDogs)
            let dogCategoriesData = try encoder.encode(self.dogCategories)
            location = location.appending(path: "dogCategories")
            location = location.appendingPathExtension("json")
            try FileManager.default.removeItem(atPath: location.relativePath)
            try dogCategoriesData.write(to: location)
        }
    }
    
    // ------------------------------------------------------------------------
    // (*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(*)(* MARK: DICTIONARIES
    // ------------------------------------------------------------------------
    
    func catCorrelate() -> [Int: String] {
        var dict: [Int: String] = [:]
        catCategories.forEach { category in
            dict[category.id] = category.name
        }
        return dict
    }
    
    func dogCorrelate() -> [Int: String] {
        var dict: [Int: String] = [:]
        dogCategories.forEach { category in
            dict[category.id] = category.name
        }
        return dict
    }
}

