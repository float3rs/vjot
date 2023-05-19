//
//  IssuingOfThePassport.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct IssuingOfThePassport {
    
    struct AuthorisedVeterinarian {
        var name: String?
        var address: String?
        var postCode: String?
        var city: String?
        var country: String?
        var telephoneNumber: String?
        var emailAddress: String?
        var spNumber: String?
    }

    var authorisedVeterinarian: AuthorisedVeterinarian
    var dateOfIssuing: Date?
}

// ----------------------------------------------------------------------------

extension IssuingOfThePassport.AuthorisedVeterinarian: Codable & Hashable {}
extension IssuingOfThePassport: Codable & Hashable {}
