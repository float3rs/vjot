//
//  APIConstants.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: API
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

enum APIEndPoint: String {
    case forCats = "https://api.thecatapi.com/"
    case forDogs = "https://api.thedogapi.com/"
}

enum APIVersion: String {
    case v1 = "v1/"
}

enum APIPath: String {
    case forImages = "images/"
    case forBreeds = "breeds/"
    case forFavourites = "favourites/"
    case forVotes = "votes/"
    case forCategories = "categories/"
    case forSources = "sources/"
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

enum APIBreedsDataSet: String {
    case forCats = "cat_breeds"
    case forDogs = "dog_breeds"
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

enum APICategoriesDataSet: String {
    case forCats = "cat_categories"
    case forDogs = "dog_categories"
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

enum APISize: String, Hashable {
    case thumbnail = "thumbnail"
    case small = "small"
    case medium = "medium"
    case full = "full"
}

enum APIMimeType: String {
    case gif = "gif"
    case jpg = "jpg"
    case png = "png"
}

enum APIFormat: String {
    case json = "json"
    case scr = "src"
}

enum APIOrder: String {
    case random = "RANDOM"
    case ascending = "ASC"
    case descending = "DESC"
}

extension APISize: CaseIterable {}
extension APIMimeType: CaseIterable {}
extension APIOrder: CaseIterable {}


// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------
