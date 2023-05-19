//
//  RabiesAntibodyTitrationTest.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct RabiesAntibodyTitrationTest {
    
    struct AuthorisedVeterinarian {
        var name: String?
        var address: String?
        var telephoneNumber: String?
    }
    
    var sampleCollectedOn: Date?                            // at least 30 days after rabies vaccination
    var authorisedVeteriarian: AuthorisedVeterinarian
    var date: Date?
}

// ----------------------------------------------------------------------------

extension RabiesAntibodyTitrationTest.AuthorisedVeterinarian: Codable & Hashable {}
extension RabiesAntibodyTitrationTest: Codable & Hashable {}

