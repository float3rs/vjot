//
//  PatientModel.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 5/4/23.
//

import Foundation

struct Patient {
    let id: UUID
    
    struct Passport {
        var detailsOfOwnership: DetailsOfOwnership
        var descriptionOfAnimal: DescriptionOfAnimal
        var markingOfAnimal: MarkingOfAnimal
        var issuingOfThePassport: IssuingOfThePassport
        var vaccinationAgainstRabies: VaccinationAgainstRabies
        var rabiesAntibodyTitrationTest: RabiesAntibodyTitrationTest
        var antiEchinococcusTreatment: AntiEchinococcusTreatment
    }
    
    var passport: Passport
    var guardianId: UUID?
    var notes: String?
}

// ----------------------------------------------------------------------------

extension Patient.Passport: Codable & Hashable {}
extension Patient: Codable & Identifiable & Hashable {}
