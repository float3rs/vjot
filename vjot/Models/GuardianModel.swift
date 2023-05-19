//
//  GuardianModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct Guardian {
    let id: UUID
    
    var name: String?
    var surname: String?
    var addres: String?
    var postCode: String?
    var city: String?
    var country: String?
    var telephoneNumber: String?
}

// ----------------------------------------------------------------------------

extension Guardian: Codable & Identifiable & Hashable {}
