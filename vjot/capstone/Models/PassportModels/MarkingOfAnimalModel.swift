//
//  MarkingOfAnimalModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct MarkingOfAnimal {
    var transponderAlphanumericCode: String?
    var dateOfApplicationOrReadingOfTheTransponder: Date?
    var locationOfTheTransponder: String?
    var tattooAlphanumericCode: String?
    var dateOfApplicationOrReadingOfTheTattoo: Date?
    var locationOfTheTattoo: String?

    // The marking must be verified
    // before any new entry is made
    // on this passport
}

// ----------------------------------------------------------------------------

extension MarkingOfAnimal: Codable & Hashable {}
