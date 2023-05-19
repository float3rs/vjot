//
//  DetailsOfOwnershipModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct DetailsOfOwnership {
    
    struct Owner {
        var id: UUID
        var name: String?
        var surname: String?
        var addres: String?
        var postCode: String?
        var city: String?
        var country: String?
        var telephoneNumber: String?
    }
    
    var owners: [Owner]
}

// ----------------------------------------------------------------------------

extension DetailsOfOwnership.Owner: Codable & Identifiable & Hashable {}
extension DetailsOfOwnership: Codable & Hashable {}
