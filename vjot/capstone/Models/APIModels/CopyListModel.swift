//
//  CopyListModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import Foundation
import SwiftUI

//            dog_names.json: https://copylists.com/downloads/names/dogs/dog_names.json
//            cat_names.json: https://copylists.com/downloads/names/cats/cat_names.json
//           boys_names.json: https://copylists.com/downloads/names/boys/boys_names.json
//          girls_names.json: https://copylists.com/downloads/names/girls/girls_names.json
// gender-neutral_names.json: https://copylists.com/downloads/names/gender-neutral/gender-neutral_names.json
//
// https://copylists.com/name-lists/
// Copyright © 2023 CopyLists.com

struct CopyListEntry {
    var element: String
}

extension CopyListEntry: Decodable {
    enum CodingKeys: String, CodingKey {
        case element = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        element = try container.decode(String.self, forKey: .element)
    }
}

// ----------------------------------------------------------------------------

typealias CopyList = [CopyListEntry]

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

enum CopyListDataSet: String {
    case forCatsNames = "cat_names"
    case forDogsNames = "dog_names"
    case forGenderNeutralNames = "gender-neutral_names"
    case forBoysNames = "boys_names"
    case forGirlNames = "girls_names"
}

func getCopyList(dataSet: CopyListDataSet) throws -> CopyList {
    guard let asset = NSDataAsset(name: dataSet.rawValue) else {
        return []
    }
    
    let json = asset.data
    let decoder = JSONDecoder()
    
    let copyList = try decoder.decode(CopyList.self, from: json)

    return copyList
}

// ----------------------------------------------------------------------------
// ////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------------------------------------

enum CopyListWebAddress: String {
    case forCatsNames = "https://copylists.com/downloads/names/cats/cat_names.json"
    case forDogsNames = "https://copylists.com/downloads/names/dogs/dog_names.json"
    case forGenderNeutralNames = "https://copylists.com/downloads/names/gender-neutral/gender-neutral_names.json"
    case forBoysNames = "https://copylists.com/downloads/names/boys/boys_names.json"
    case forGirlNames = "https://copylists.com/downloads/names/girls/girls_names.json"
}

func getCopyList(webAddress: CopyListWebAddress) async throws -> CopyList {

    guard let url = URL(string: webAddress.rawValue) else {
        fatalError("CopyList URL Unreachable")
    }
         
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        fatalError("Fetching CopyList Data Error")
    }

    let decoder = JSONDecoder()
    let copyList = try decoder.decode(CopyList.self, from: data)
    
    return copyList
}
