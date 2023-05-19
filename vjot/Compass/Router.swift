//
//  Router.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 8/4/23.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    @Published var pathIma = NavigationPath()
    @Published var pathBre = NavigationPath()
    @Published var pathInf = NavigationPath()
    @Published var pathVet = NavigationPath()
    @Published var pathInc = NavigationPath()
    @Published var pathCli = NavigationPath()
    @Published var pathJot = NavigationPath()
    
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: BREEDS
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

enum BreedSpecies {
    case cats
    case dogs
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: CATEGORIES
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

enum CategorySpecies {
    case cats
    case dogs
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: IMAGES
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

enum ImageSpecies {
    case cats
    case dogs
}

enum ImageProcess {
    case search
    case find
    case upload
    case fav
    case vote
    case delete
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: INFO
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]

enum InfoSpecies {
    case cats
    case dogs
}

enum InfoProcess {
    case sources
    case version
}
