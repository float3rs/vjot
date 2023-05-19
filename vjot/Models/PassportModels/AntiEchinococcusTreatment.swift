//
//  AntiEchinococcusTreatment.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct AntiEchinococcusTreatment {
    
    struct Treatment {
        var id: UUID
        
        struct AuthorisedVeterinarian {
            var name: String?
            var address: String?
            var telephoneNumber: String?
            var spNumber: String?
        }
        
        struct Product {
            var manufacturer: String?
            var productName: String?
        }
        
        var product: Product
        var date: Date?
        var time: Date?
        var authorisedVeterianarian: AuthorisedVeterinarian
    }
    
    var treatments: [Treatment]
}

// ----------------------------------------------------------------------------

extension AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian: Codable & Hashable {}
extension AntiEchinococcusTreatment.Treatment.Product: Codable & Hashable {}
extension AntiEchinococcusTreatment.Treatment: Codable & Identifiable & Hashable {}
extension AntiEchinococcusTreatment: Codable & Hashable{}
