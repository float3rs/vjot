//
//  IncidentModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct Idea {
    let id: UUID
    let date: Date
}

struct Tape {
    let id: UUID
    let date: Date
    var playing: Bool = false
}

struct Snap {
    let id: UUID
    let date: Date
}

struct Incident {
    let id: UUID
    
    var description: String
    var date: Date
    var ideas: [Idea]
    var snaps: [Snap]
    var tapes: [Tape]
    var patientId: UUID?
    var emergency: Bool
}

// ----------------------------------------------------------------------------

extension Idea: Codable & Identifiable & Hashable {}
extension Tape: Codable & Identifiable & Hashable {}
extension Snap: Codable & Identifiable & Hashable {}
extension Incident: Codable & Identifiable & Hashable {}

