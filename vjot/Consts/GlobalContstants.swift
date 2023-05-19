//
//  GlobalContstants.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import Foundation
import SwiftUI

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: JEWELS
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

enum Jewel: String {
    case theCatAPIKey
    case theDogAPIKey
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: GLOBAL
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

enum Species: String {
    case cat = "Cat"
    case dog = "Dog"
}

enum Sex: String {
    case male = "Male"
    case female = "Female"
}

// ----------------------------------------------------------------------------

extension Species: Codable & CaseIterable {}
extension Sex: Codable & CaseIterable {}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: ROLE
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

enum Role {
    case veterinarians
    case incidents
    case patients
    case clinic
}

enum Function {
    case create
    case update
}
