//
//  VaccinationAgainstRabiesModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct VaccinationAgainstRabies {
    
    struct Vaccination {
        var id: UUID
        
        struct AuthorisedVeterinarian {
            var name: String?
            var address: String?
            var telephoneNumber: String?
            var spNumber: String?
        }
        
        struct Vaccine {
            var id: UUID?
            var manufacturer: String?
            var nameOfVaccine: String?
            var batchNumber: String?
        }
        
        var rabiesVaccine: Vaccine
        var vaccinationDate: Date?
        var validFrom: Date?
        var validUntil: Date?                                 // as per datasheet
        var authorisedVeterinarian: AuthorisedVeterinarian
    }
    
    var vaccinations: [Vaccination]
}

// ----------------------------------------------------------------------------

extension VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian: Codable & Hashable {}
extension VaccinationAgainstRabies.Vaccination.Vaccine: Codable & Identifiable & Hashable {}
extension VaccinationAgainstRabies.Vaccination: Codable & Identifiable & Hashable {}
extension VaccinationAgainstRabies: Codable & Hashable {}


