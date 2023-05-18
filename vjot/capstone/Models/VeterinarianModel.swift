//
//  VeterinarianModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct Veterinarian {
    let id: UUID

    let name: String
    var address: String?
    var postCode: String?
    var city: String?
    var country: String?
    var telephoneNumber: String?
    var emailAddress: String?
    
    var imageId: UUID?
    var incidentIds: [UUID]
    
    var catFavs: [String: Int]
    var dogFavs: [String: Int]
    var catVotes: [String: Int]
    var dogVotes: [String: Int]
}

// ----------------------------------------------------------------------------

extension Veterinarian: Codable & Identifiable & Hashable {}
