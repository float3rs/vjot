//
//  PatientGigView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 7/4/23.
//

import Foundation
import SwiftUI

@MainActor final class PatientGig: ObservableObject {
    
//    @EnvironmentObject var breedEngine: BreedEngine
    
    @Published var patients: [Patient] = []
    @Published var currentId: UUID? = nil
    @Published var searchTerm = String()
    @Published var initComplete: Bool = false
    
    static let shared = PatientGig()
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: INITIALIZATION
    // ------------------------------------------------------------------------
    
    init() {
        do {
            print("%%%%%%%%% REVIVING PATS %%")
            try load()
        } catch _ {
            print("%% CLEAN SLATE FOR PATS %%")
            // print(error.localizedDescription)
        }
    }
    
    // ------------------------------------------------------------------------
    // //////////////////////////////////////////////// MARK: LOADING PATIENTS
    // ------------------------------------------------------------------------
    
    func load() throws {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "patients")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        origin = origin.appending(component: "patients")
        origin = origin.appendingPathExtension("json")
        let patientsData = try Data(contentsOf: origin)
        self.patients = try decoder.decode([Patient].self, from: patientsData)
        
        origin = origin.deletingPathExtension()
        origin = origin.deletingLastPathComponent()
        origin = origin.appending(component: "currentId")
        origin = origin.appendingPathExtension("json")
        let currentIdData = try Data(contentsOf: origin)
        self.currentId = try decoder.decode(UUID.self, from: currentIdData)
    }
    
    // ------------------------------------------------------------------------
    // ////////////////////////////////////////////////// MARK: SAVING PATIENTS
    // ------------------------------------------------------------------------
    
    func save() throws {
        
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "patients")
        
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        destination = destination.appending(path: "patients")
        destination = destination.appendingPathExtension("json")
        let patientsData = try encoder.encode(self.patients)
        try patientsData.write(to: destination)
        
        destination = destination.deletingPathExtension()
        destination = destination.deletingLastPathComponent()
        destination = destination.appending(path: "currentId")
        destination = destination.appendingPathExtension("json")
        let currentPatData = try encoder.encode(self.currentId)
        try currentPatData.write(to: destination)
    }
    
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()()()() MARK: MANAGING IMAGES
    // ------------------------------------------------------------------------
    
    func load(imageId: UUID) throws -> UIImage? {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "patients")
        origin = origin.appending(component: "images")
        origin = origin.appending(path: imageId.uuidString)
        origin = origin.appendingPathExtension("jpg")
        let uiImageData = try Data(contentsOf: origin)
        let uiImage = UIImage(data: uiImageData)
        return uiImage
    }
    
    // ------------------------------------------------------------------------
    
    func save(uiImage: UIImage) throws -> UUID {
        
        let uuid = UUID()
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "patients")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        destination = destination.appending(component: "images")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        destination = destination.appending(path: uuid.uuidString)
        destination = destination.appendingPathExtension("jpg")
        let uiImageData = uiImage.jpegData(compressionQuality: 1.0)
        try uiImageData?.write(to: destination)
        
        return uuid
    }
    // ------------------------------------------------------------------------
    
    func delete(imageId: UUID) throws {
        
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        path = path.appending(component: "patients")
        path = path.appending(component: "images")
        path = path.appending(path: imageId.uuidString)
        path = path.appendingPathExtension("jpg")
        
        try FileManager.default.removeItem(atPath: path.relativePath)
    }
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: CURRENT
    // ------------------------------------------------------------------------
    
    func track(currentId: UUID) -> Patient? {
        return patients.first { $0.id == currentId }
    }
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: NAMING
    // ------------------------------------------------------------------------
    
    func designate(patient: Patient) -> String {
        if let name = patient.passport.descriptionOfAnimal.name {
            return name
        } else {
            return String(patient.id.uuidString.suffix(12))
        }
    }
 
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()() MARK: PROCESSING PATIENTS
    // ------------------------------------------------------------------------
    
    func create(patient: Patient) throws {
        patients.append(patient)
        try save()
    }
    
    func update(patient: Patient) throws {
        guard let index = patients.firstIndex(where: { $0.id == patient.id }) else { return }
        patients[index] = patient
        try save()
    }
    
    func delete(patient: Patient) throws {
        patients = patients.filter { $0.id != patient.id }
        if patient.id == currentId { currentId = nil }
        try save()
    }
    
    func delete(atOffsets indexSet: IndexSet) throws {
        indexSet.forEach { index in
            if patients[index].id == currentId { currentId = nil }
        }
        patients.remove(atOffsets: indexSet)
        try save()
    }
    
    // ------------------------------------------------------------------------
    
    func activate(patient: Patient) throws {
        currentId = patient.id
        try save()
    }
    
    func deactivate() throws {
        currentId = nil
        try save()
    }
    
    // ------------------------------------------------------------------------
    
    func set(uiImage: UIImage, toPatient patient: inout Patient) throws {
        let uuid = try save(uiImage: uiImage)
        patient.passport.descriptionOfAnimal.pictureId = uuid
        try update(patient: patient)
    }
    
    func get(ofPatient patient: Patient) throws -> UIImage? {
        if let uuid = patient.passport.descriptionOfAnimal.pictureId {
            let uiImage = try load(imageId: uuid)
            return uiImage
        }
        return nil
    }
    
    // ------------------------------------------------------------------------
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><> MARK: FINDERS
    // ------------------------------------------------------------------------
    
    func find(guardianId uuid: UUID) -> Guardian? {
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "guardians")
        origin = origin.appending(component: "guardians")
        origin = origin.appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: origin.relativePath) { return nil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let guardiansData = try Data(contentsOf: origin)
            let guardians = try decoder.decode([Guardian].self, from: guardiansData)
            guard let guardian = guardians.first(where: { $0.id == uuid }) else { return nil }
            return guardian
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // ------------------------------------------------------------------------
    
    func find(imageId uuid: UUID) -> URL? {
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "patients")
        origin = origin.appending(component: "images")
        origin = origin.appending(path: uuid.uuidString)
        origin = origin.appendingPathExtension("jpg")
        if !FileManager.default.fileExists(atPath: origin.relativePath) { return nil }
        return origin
    }
    
    // ------------------------------------------------------------------------
    // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX MARK: SEARCHERS
    // ------------------------------------------------------------------------
    
//    func search() -> [Patient] {
//        return searchTerm.isEmpty ? patients :
//        patients.filter({ patient in
//            if let species = patient.passport.descriptionOfAnimal.species {
//               return species.rawValue.lowercased().contains(searchTerm.lowercased())
//            } else {
//                return false
//            }
//        })
//    }
    
    func search() -> [Patient] {
        return searchTerm.isEmpty ? patients :
        patients.filter({$0.id.uuidString.lowercased().contains(searchTerm.lowercased())})
    }
    
    // ------------------------------------------------------------------------
    // |||||||||||||||||||||||||||||||||||||||||||||| MARK: DELEGATING PATIENTS
    // ------------------------------------------------------------------------
    
    func assign(patient: Patient, to incident: inout Incident) throws {
        incident.patientId = patient.id
    }
    
    // ------------------------------------------------------------------------
    // ########################################################## MARK: TESTING
    // ------------------------------------------------------------------------
    
    static var pat0 = Patient(
        id: UUID(),
        passport: Patient.Passport(
            detailsOfOwnership: DetailsOfOwnership(
                owners: [
                    DetailsOfOwnership.Owner(
                        id: UUID(),
                        name: "Eleftheria",
                        surname: "Saridaki",
                        addres: "Papandreou Andrea 84",
                        postCode: "GR-731 34",
                        city: "Chania",
                        country: "Greece",
                        telephoneNumber: "+306984739314"
                    ),
                    DetailsOfOwnership.Owner(
                        id: UUID(),
                        name: "Michalis",
                        surname: "Saridakis",
                        addres: "Zymvrakakidon 42",
                        postCode: "GR-731 35",
                        city: "Chania",
                        country: "Greece",
                        telephoneNumber: "+306945858108"
                    )
                ]
            ),
            descriptionOfAnimal: DescriptionOfAnimal(
                pictureId: nil,
                name: "Tsonara",
                species: .cat,
                breed: "Abyssinian",
                sex: .female,
                dateOfBirth: Date(timeIntervalSinceReferenceDate: 243543643),
                colour: Color(red: 0.4, green: 0.2, blue: 0),
                notableOrDiscernableFeaturesOrCharacteristics: "Vel rerum saepe est consequuntur fugiat sed voluptatum atque."
            ),
            markingOfAnimal: MarkingOfAnimal(
                transponderAlphanumericCode: "cmJGZfru9BXMHKHcUqFLB8MJBCWYp7d8rxDk",
                dateOfApplicationOrReadingOfTheTransponder: Date(timeIntervalSinceReferenceDate: 243983643),
                locationOfTheTransponder: "Right Leg",
                tattooAlphanumericCode: nil,
                dateOfApplicationOrReadingOfTheTattoo: nil,
                locationOfTheTattoo: nil
            ),
            issuingOfThePassport: IssuingOfThePassport(
                authorisedVeterinarian: IssuingOfThePassport.AuthorisedVeterinarian(
                    name: "Eleftheria Saridaki",
                    address: "Papandreou Andrea 84",
                    postCode: "GR-731 34",
                    city: "Chania",
                    country: "Greece",
                    telephoneNumber: "+306984739314",
                    emailAddress: "elsaridak@gmail.com",
                    spNumber: "604"
                ),
                dateOfIssuing: Date(timeIntervalSinceReferenceDate: 246711333)
            ),
            vaccinationAgainstRabies: VaccinationAgainstRabies(
                vaccinations: [
                    VaccinationAgainstRabies.Vaccination(
                        id: UUID(),
                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(
                            id: UUID(),
                            manufacturer: "Mud",
                            nameOfVaccine: "Orb",
                            batchNumber: "9"
                        ),
                        vaccinationDate: Date(timeIntervalSinceReferenceDate: 246711333),
                        validFrom: Date(timeIntervalSinceReferenceDate: 246711333),
                        validUntil: Date(timeIntervalSinceReferenceDate: 246811333),
                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                            name: "Martha Saridaki",
                            address: "Garivaldi 98, GR-431 31, Karditsa,Greece",
                            telephoneNumber: "+306986158848",
                            spNumber: "606"
                        )
                    ),
                    VaccinationAgainstRabies.Vaccination(
                        id: UUID(),
                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(
                            id: UUID(),
                            manufacturer: "Waves",
                            nameOfVaccine: "Bronze",
                            batchNumber: "6"
                        ),
                        vaccinationDate: Date(timeIntervalSinceReferenceDate: 246311333),
                        validFrom: Date(timeIntervalSinceReferenceDate: 246713333),
                        validUntil: Date(timeIntervalSinceReferenceDate: 246814333),
                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                            name: "Nikos Saridakis",
                            address: "Iroon Politechniou 72B, GR-157 72, Zografos, Greece",
                            telephoneNumber: "+30948604489",
                            spNumber: "607"
                        )
                    )
                ]
            ),
            rabiesAntibodyTitrationTest: RabiesAntibodyTitrationTest(
                sampleCollectedOn: Date(),
                authorisedVeteriarian: RabiesAntibodyTitrationTest.AuthorisedVeterinarian(
                    name: "Eleftheria Saridaki",
                    address: "Andrea Papandreou 84, GR-73 134, Chania, Greece",
                    telephoneNumber: "+306984739314"
                ),
                date: Date(timeIntervalSinceReferenceDate: 256435333)
            ),
            antiEchinococcusTreatment: AntiEchinococcusTreatment(
                treatments: [
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Mud", productName: "Hog"),
                        date: Date(timeIntervalSinceReferenceDate: 256756643),
                        time: Date(timeIntervalSinceReferenceDate: 256753333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Martha Saridaki",
                            address: "Garivaldi 98, GR-431 31, Karditsa,Greece",
                            telephoneNumber: "+306986158848",
                            spNumber: "606"
                        )
                    ),
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Rdf", productName: "ekdoc"),
                        date: Date(timeIntervalSinceReferenceDate: 256711643),
                        time: Date(timeIntervalSinceReferenceDate: 256711333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Nikos Saridakis",
                            address: "Iroon Politechniou 72B, GR-157 72, Zografos, Greece",
                            telephoneNumber: "+30948604489",
                            spNumber: "607"
                        )
                    ),
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Thorn", productName: "Twist"),
                        date: Date(timeIntervalSinceReferenceDate: 256741643),
                        time: Date(timeIntervalSinceReferenceDate: 256741333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Michalis Saridakis",
                            address: "Zymvrakakidon 41, GR-731 35, Chania, Greece",
                            telephoneNumber: "+306945858108",
                            spNumber: "605"
                        )
                    )
                ]
            )
        ),
        notes: "Eum velit sunt et dolor nihil aut optio assumenda non modi eaque sed galisum internos et impedit quis qui nostrum impedit. "
    )
    
    // ------------------------------------------------------------------------
    
    static var pat1 = Patient(
        id: UUID(),
        passport: Patient.Passport(
            detailsOfOwnership: DetailsOfOwnership(
                owners: [
                    DetailsOfOwnership.Owner(
                        id: UUID(),
                        name: "Martha",
                        surname: "Saridaki",
                        addres: "Garivaldi 98",
                        postCode: "GR-431 31",
                        city: "Chania",
                        country: "Greece",
                        telephoneNumber: "+306986158848"
                    ),
                    DetailsOfOwnership.Owner(
                        id: UUID(),
                        name: "Nikos",
                        surname: "Saridakis",
                        addres: "Irron Politechniou 72B",
                        postCode: "GR-157 72",
                        city: "Chania",
                        country: "Greece",
                        telephoneNumber: "+306948604489"
                    )
                ]
            ),
            descriptionOfAnimal: DescriptionOfAnimal(
                pictureId: nil,
                name: "Fragkiskos",
                species: .cat,
                breed: "Australian Mist",
                sex: .male,
                dateOfBirth: Date(timeIntervalSinceReferenceDate: 356756643),
                colour: Color(red: 1, green: 1, blue: 1),
                notableOrDiscernableFeaturesOrCharacteristics: "Et totam autem hic."
            ),
            markingOfAnimal: MarkingOfAnimal(
                transponderAlphanumericCode: "vqAzTkNa47pDYQKUoJkeZCrKH2qtb9Ffo4xB",
                dateOfApplicationOrReadingOfTheTransponder: Date(timeIntervalSinceReferenceDate: 356798743),
                locationOfTheTransponder: "Left shoulder",
                tattooAlphanumericCode: nil,
                dateOfApplicationOrReadingOfTheTattoo: nil,
                locationOfTheTattoo: nil
            ),
            issuingOfThePassport: IssuingOfThePassport(
                authorisedVeterinarian: IssuingOfThePassport.AuthorisedVeterinarian(
                    name: "Michalis Saridakis",
                    address: "Zymvrakakidon 41",
                    postCode: "GR-731 35",
                    city: "Chania",
                    country: "Greece",
                    telephoneNumber: "+306945858108",
                    emailAddress: "vetmsaridakis@gmail.com",
                    spNumber: "605"
                ),
                dateOfIssuing: Date(timeIntervalSinceReferenceDate: 346711333)
            ),
            vaccinationAgainstRabies: VaccinationAgainstRabies(
                vaccinations: [
                    VaccinationAgainstRabies.Vaccination(
                        id: UUID(),
                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(
                            id: UUID(),
                            manufacturer: "Frost",
                            nameOfVaccine: "Tails",
                            batchNumber: "8"
                        ),
                        vaccinationDate: Date(timeIntervalSinceReferenceDate: 346711333),
                        validFrom: Date(timeIntervalSinceReferenceDate: 346711333),
                        validUntil: Date(timeIntervalSinceReferenceDate: 346811333),
                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                            name: "Nikos Saridakis",
                            address: "Iroon Politechniou 72B, GR-157 72, Zografos, Greece",
                            telephoneNumber: "+30948604489",
                            spNumber: "607"
                        )
                    ),
                    VaccinationAgainstRabies.Vaccination(
                        id: UUID(),
                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(
                            id: UUID(),
                            manufacturer: "Ozz",
                            nameOfVaccine: "Orb",
                            batchNumber: "1"
                        ),
                        vaccinationDate: Date(timeIntervalSinceReferenceDate: 346311333),
                        validFrom: Date(timeIntervalSinceReferenceDate: 346713333),
                        validUntil: Date(timeIntervalSinceReferenceDate: 346814333),
                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                            name: "Martha Saridaki",
                            address: "Garivaldi 98, GR-431 31, Karditsa,Greece",
                            telephoneNumber: "+306986158848",
                            spNumber: "606"
                        )
                    )
                ]
            ),
            rabiesAntibodyTitrationTest: RabiesAntibodyTitrationTest(
                sampleCollectedOn: Date(),
                authorisedVeteriarian: RabiesAntibodyTitrationTest.AuthorisedVeterinarian(
                    name: "Michalis Saridakis",
                    address: "Zymvrakakidon 41, GR-731 35, Chania, Greece",
                    telephoneNumber: "+306945858108"
                ),
                date: Date(timeIntervalSinceReferenceDate: 356435333)
            ),
            antiEchinococcusTreatment: AntiEchinococcusTreatment(
                treatments: [
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Liftoff", productName: "Wax"),
                        date: Date(timeIntervalSinceReferenceDate: 356711643),
                        time: Date(timeIntervalSinceReferenceDate: 356711333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Nikos Saridakis",
                            address: "Iroon Politechniou 72B, GR-157 72, Zografos, Greece",
                            telephoneNumber: "+30948604489",
                            spNumber: "607"
                        )
                    ),
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Feather", productName: "Deluge"),
                        date: Date(timeIntervalSinceReferenceDate: 356741643),
                        time: Date(timeIntervalSinceReferenceDate: 356741333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Michalis Saridakis",
                            address: "Zymvrakakidon 41, GR-731 35, Chania, Greece",
                            telephoneNumber: "+306945858108",
                            spNumber: "605"
                        )
                    ),
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Crimson", productName: "Chopsticks"),
                        date: Date(timeIntervalSinceReferenceDate: 356756643),
                        time: Date(timeIntervalSinceReferenceDate: 356753333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Nikos Saridakis",
                            address: "Iroon Politechniou 72B, GR-157 72, Zografos, Greece",
                            telephoneNumber: "+30948604489",
                            spNumber: "607"
                        )
                    )
                ]
            )
        ),
        notes: "Quo natus modi ut laboriosam sint est fugiat velit. Quo quia internos aut quia voluptas et aliquid officiis est autem voluptas qui corrupti quis ut harum dolorem est debitis unde. Et corporis molestias 33 repellendus dolorem ut nemo vero."
    )
    
    // ------------------------------------------------------------------------
    
    static var pat2 = Patient(
        id: UUID(),
        passport: Patient.Passport(
            detailsOfOwnership: DetailsOfOwnership(
                owners: [
                    DetailsOfOwnership.Owner(
                        id: UUID(),
                        name: "Michalis",
                        surname: "Saridakis",
                        addres: "Zymvrakakidon 42",
                        postCode: "GR-731 35",
                        city: "Chania",
                        country: "Greece",
                        telephoneNumber: "+306945858108"
                    ),
                    DetailsOfOwnership.Owner(
                        id: UUID(),
                        name: "Martha",
                        surname: "Saridaki",
                        addres: "Garivaldi 98",
                        postCode: "GR-431 31",
                        city: "Chania",
                        country: "Greece",
                        telephoneNumber: "+306986158848"
                    ),
                ]
            ),
            descriptionOfAnimal: DescriptionOfAnimal(
                pictureId: nil,
                name: "Skoros",
                species: .cat,
                breed: nil,
                sex: .male,
                dateOfBirth: Date(),
                colour: Color(red: 1, green: 1, blue: 1),
                notableOrDiscernableFeaturesOrCharacteristics: "Quo ratione galisum nam internos vero ea commodi placeat et voluptate ipsa et doloribus assumenda et illo quia sed quia excepturi."
            ),
            markingOfAnimal: MarkingOfAnimal(
                transponderAlphanumericCode: "hiAKZVK4BrWHYvXiu9Uwks2MmFntRiA4fjVd",
                dateOfApplicationOrReadingOfTheTransponder: Date(),
                locationOfTheTransponder: "Upper neck",
                tattooAlphanumericCode: nil,
                dateOfApplicationOrReadingOfTheTattoo: nil,
                locationOfTheTattoo: nil
            ),
            issuingOfThePassport: IssuingOfThePassport(
                authorisedVeterinarian: IssuingOfThePassport.AuthorisedVeterinarian(
                    name: "Martha Saridaki",
                    address: "Garivaldi 98",
                    postCode: "GR-431 31",
                    city: "Karditsa",
                    country: "Greece",
                    telephoneNumber: "+306986158848",
                    emailAddress: "marthasaridaki@gmail.com",
                    spNumber: "606"
                ),
                dateOfIssuing: Date(timeIntervalSinceReferenceDate: 546711333)
            ),
            vaccinationAgainstRabies: VaccinationAgainstRabies(
                vaccinations: [
                    VaccinationAgainstRabies.Vaccination(
                        id: UUID(),
                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(
                            id: UUID(),
                            manufacturer: "Caine",
                            nameOfVaccine: "Sanguine",
                            batchNumber: "3"
                        ),
                        vaccinationDate: Date(timeIntervalSinceReferenceDate: 546711333),
                        validFrom: Date(timeIntervalSinceReferenceDate: 546711333),
                        validUntil: Date(timeIntervalSinceReferenceDate: 546811333),
                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                            name: "Martha Saridaki",
                            address: "Garivaldi 98, GR-431 31, Karditsa,Greece",
                            telephoneNumber: "+306986158848",
                            spNumber: "606"
                        )
                    ),
                    VaccinationAgainstRabies.Vaccination(
                        id: UUID(),
                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(
                            id: UUID(),
                            manufacturer: "Fluff",
                            nameOfVaccine: "Snowflake",
                            batchNumber: "5"
                        ),
                        vaccinationDate: Date(timeIntervalSinceReferenceDate: 546311333),
                        validFrom: Date(timeIntervalSinceReferenceDate: 546713333),
                        validUntil: Date(timeIntervalSinceReferenceDate: 546814333),
                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                            name: "Nikos Saridakis",
                            address: "Iroon Politechniou 72B, GR-157 72, Zografos, Greece",
                            telephoneNumber: "+30948604489",
                            spNumber: "607"
                        )
                    )
                ]
            ),
            rabiesAntibodyTitrationTest: RabiesAntibodyTitrationTest(
                sampleCollectedOn: Date(),
                authorisedVeteriarian: RabiesAntibodyTitrationTest.AuthorisedVeterinarian(
                    name: "Eleftheria Saridaki",
                    address: "Andrea Papandreou 84, GR-73 134, Chania, Greece",
                    telephoneNumber: "+306984739314"
                ),
                date: Date(timeIntervalSinceReferenceDate: 556435333)
            ),
            antiEchinococcusTreatment: AntiEchinococcusTreatment(
                treatments: [
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Rdf", productName: "ekdoc"),
                        date: Date(timeIntervalSinceReferenceDate: 556711643),
                        time: Date(timeIntervalSinceReferenceDate: 556711333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Nikos Saridakis",
                            address: "Iroon Politechniou 72B, GR-157 72, Zografos, Greece",
                            telephoneNumber: "+30948604489",
                            spNumber: "607"
                        )
                    ),
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Thorn", productName: "Twist"),
                        date: Date(timeIntervalSinceReferenceDate: 556741643),
                        time: Date(timeIntervalSinceReferenceDate: 556741333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Michalis Saridakis",
                            address: "Zymvrakakidon 41, GR-731 35, Chania, Greece",
                            telephoneNumber: "+306945858108",
                            spNumber: "605"
                        )
                    ),
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Mud", productName: "Hog"),
                        date: Date(timeIntervalSinceReferenceDate: 556756643),
                        time: Date(timeIntervalSinceReferenceDate: 556753333),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Martha Saridaki",
                            address: "Garivaldi 98, GR-431 31, Karditsa,Greece",
                            telephoneNumber: "+306986158848",
                            spNumber: "606"
                        )
                    )
                ]
            )
        ),
        notes: "Pellentesque nec blandit erat. Praesent in nisl neque. Morbi eget tempor risus. Morbi placerat purus nulla, a sollicitudin ex molestie et. Cras congue, lorem at mollis mattis, ex velit rhoncus ex, quis dapibus magna tortor vel purus."
    )
    
    // ------------------------------------------------------------------------
    
    static var pat3 = Patient(
        id: UUID(),
        passport: Patient.Passport(
            detailsOfOwnership: DetailsOfOwnership(
                owners: [
                    DetailsOfOwnership.Owner(
                        id: UUID(),
                        name: "Eleftheria",
                        surname: "Saridaki",
                        addres: "Papandreou Andrea 84",
                        postCode: "GR-731 34",
                        city: "Chania",
                        country: "Greece",
                        telephoneNumber: "+306984739314"
                    ),
                    DetailsOfOwnership.Owner(
                        id: UUID(),
                        name: "Nikos",
                        surname: "Saridakis",
                        addres: "Iroon Politechniou 72B",
                        postCode: "GR-157 72",
                        city: "Zografos",
                        country: "Greece",
                        telephoneNumber: "+306948604489"
                    ),
                ]
            ),
            descriptionOfAnimal: DescriptionOfAnimal(
                pictureId: nil,
                name: "Chlapatsa",
                species: .cat,
                breed: "Arabian Mau",
                sex: .male,
                dateOfBirth: Date(),
                colour: Color(red: 0, green: 0, blue: 0),
                notableOrDiscernableFeaturesOrCharacteristics: "Ut consequatur rerum qui iusto officia et voluptate distinctio aut iste labore. "
            ),
            markingOfAnimal: MarkingOfAnimal(
                transponderAlphanumericCode: "nwGsiL9MWZvKKPGpCLTuEedqEcnZG2XdvmxY",
                dateOfApplicationOrReadingOfTheTransponder: Date(timeIntervalSinceReferenceDate: 456741643),
                locationOfTheTransponder: "Lower Back",
                tattooAlphanumericCode: "123456789",
                dateOfApplicationOrReadingOfTheTattoo: Date(timeIntervalSinceReferenceDate: 456711333),
                locationOfTheTattoo: "Neck"
            ),
            issuingOfThePassport: IssuingOfThePassport(
                authorisedVeterinarian: IssuingOfThePassport.AuthorisedVeterinarian(
                    name: "Michalis Saridakis",
                    address: "Zymvrakakidon 41",
                    postCode: "GR-731 35",
                    city: "Chania",
                    country: "Greece",
                    telephoneNumber: "+306945858108",
                    emailAddress: "vetmsaridakis@gmail.com",
                    spNumber: "605"
                ),
                dateOfIssuing: Date(timeIntervalSinceReferenceDate: 446711333)
            ),
            vaccinationAgainstRabies: VaccinationAgainstRabies(
                vaccinations: [
                    VaccinationAgainstRabies.Vaccination(
                        id: UUID(),
                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(
                            id: UUID(),
                            manufacturer: "Silver",
                            nameOfVaccine: "Anvil",
                            batchNumber: "2"
                        ),
                        vaccinationDate: Date(timeIntervalSinceReferenceDate: 446711333),
                        validFrom: Date(timeIntervalSinceReferenceDate: 446711333),
                        validUntil: Date(timeIntervalSinceReferenceDate: 446811333),
                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                            name: "Nikos Saridakis",
                            address: "Iroon Politechniou 72B, GR-157 72, Zografos, Greece",
                            telephoneNumber: "+30948604489",
                            spNumber: "607"
                        )
                    ),
                    VaccinationAgainstRabies.Vaccination(
                        id: UUID(),
                        rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(
                            id: UUID(),
                            manufacturer: "Change",
                            nameOfVaccine: "Sunburn",
                            batchNumber: "4"
                        ),
                        vaccinationDate: Date(timeIntervalSinceReferenceDate: 446311333),
                        validFrom: Date(timeIntervalSinceReferenceDate: 446713333),
                        validUntil: Date(timeIntervalSinceReferenceDate: 446814333),
                        authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian(
                            name: "Martha Saridaki",
                            address: "Garivaldi 98, GR-431 31, Karditsa,Greece",
                            telephoneNumber: "+306986158848",
                            spNumber: "606"
                        )
                    )
                ]
            ),
            rabiesAntibodyTitrationTest: RabiesAntibodyTitrationTest(
                sampleCollectedOn: Date(),
                authorisedVeteriarian: RabiesAntibodyTitrationTest.AuthorisedVeterinarian(
                    name: "Michalis Saridakis",
                    address: "Zymvrakakidon 41, GR-731 35, Chania, Greece",
                    telephoneNumber: "+306945858108"
                ),
                date: Date(timeIntervalSinceReferenceDate: 456435333)
            ),
            antiEchinococcusTreatment: AntiEchinococcusTreatment(
                treatments: [
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Thimble", productName: "Rampage"),
                        date: Date(timeIntervalSinceReferenceDate: 416455353),
                        time: Date(timeIntervalSinceReferenceDate: 416720000),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Michalis Saridakis",
                            address: "Zymvrakakidon 41, GR-731 35, Chania, Greece",
                            telephoneNumber: "+306945858108",
                            spNumber: "605"
                        )
                    ),
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Vacuum", productName: "Dragon"),
                        date: Date(timeIntervalSinceReferenceDate: 416720353),
                        time: Date(timeIntervalSinceReferenceDate: 416720200),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Martha Saridaki",
                            address: "Garivaldi 98, GR-431 31, Karditsa,Greece",
                            telephoneNumber: "+306986158848",
                            spNumber: "606"
                        )
                    ),
                    AntiEchinococcusTreatment.Treatment(
                        id: UUID(),
                        product: AntiEchinococcusTreatment.Treatment.Product(manufacturer: "Aqua", productName: "Mistress"),
                        date: Date(timeIntervalSinceReferenceDate: 416720353),
                        time: Date(timeIntervalSinceReferenceDate: 416720200),
                        authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian(
                            name: "Eleftheria Saridaki",
                            address: "Andrea Papandreou 84, GR-73 134, Chania, Greece",
                            telephoneNumber: "+306984739314",
                            spNumber: "604"
                        )
                    )
                ]
            )
        ),
        notes: "Lorem ipsum dolor sit amet. Non internos dolorem qui esse excepturi et ratione voluptatem sed voluptate fugit. Non minima tempora non repellendus obcaecati sed voluptas dolorum sed alias sunt et corporis rerum. Ad voluptatem maiores hic soluta optio qui vitae ipsa vel omnis perferendis aut reiciendis sunt. Aut galisum saepe aut suscipit officia sed neque provident."
    )
    
    // ------------------------------------------------------------------------
    
    static var patients = [pat0, pat1, pat2, pat3]
    
    // XxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx
    // XxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx
    // XxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx
    
    static var pat = Patient(
        id: UUID(),
        passport: Patient.Passport(
            detailsOfOwnership: DetailsOfOwnership(owners: [
                DetailsOfOwnership.Owner(id: UUID()),
                DetailsOfOwnership.Owner(id: UUID())
            ]),
            
            descriptionOfAnimal: DescriptionOfAnimal(),
            
            markingOfAnimal: MarkingOfAnimal(),
            
            issuingOfThePassport: IssuingOfThePassport(
                authorisedVeterinarian: IssuingOfThePassport.AuthorisedVeterinarian()
            ),
            
            vaccinationAgainstRabies: VaccinationAgainstRabies(vaccinations: [
                VaccinationAgainstRabies.Vaccination(
                    id: UUID(),
                    rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(),
                    authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian()
                ),
                VaccinationAgainstRabies.Vaccination(
                    id: UUID(),
                    rabiesVaccine: VaccinationAgainstRabies.Vaccination.Vaccine(),
                    authorisedVeterinarian: VaccinationAgainstRabies.Vaccination.AuthorisedVeterinarian()
                )
            ]),
            
            rabiesAntibodyTitrationTest: RabiesAntibodyTitrationTest(
                sampleCollectedOn: nil,
                authorisedVeteriarian: RabiesAntibodyTitrationTest.AuthorisedVeterinarian(),
                date: nil
            ),
            
            antiEchinococcusTreatment: AntiEchinococcusTreatment(treatments: [
                AntiEchinococcusTreatment.Treatment(
                    id: UUID(),
                    product: AntiEchinococcusTreatment.Treatment.Product(),
                    authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian()
                ),
                AntiEchinococcusTreatment.Treatment(
                    id: UUID(),
                    product: AntiEchinococcusTreatment.Treatment.Product(),
                    authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian()
                ),
                AntiEchinococcusTreatment.Treatment(
                    id: UUID(),
                    product: AntiEchinococcusTreatment.Treatment.Product(),
                    authorisedVeterianarian: AntiEchinococcusTreatment.Treatment.AuthorisedVeterinarian()
                )
            ])
        )
    )
}
