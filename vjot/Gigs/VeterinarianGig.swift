//
//  VeterinarianGig.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 7/4/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor final class VeterinarianGig: ObservableObject {
    
    @Published var veterinarians: [Veterinarian] = []
    @Published var currentId: UUID? = nil
    @Published var searchTerm = String()
    @Published var initComplete: Bool = false
    
    static let shared = VeterinarianGig()
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: INITIALIZATION
    // ------------------------------------------------------------------------
    
    init() {
        do {
            print("%%%%%%%%% REVIVING VETS %%")
            try load()
        } catch _ {
            print("%% CLEAN SLATE FOR VETS %%")
            // print(error.localizedDescription)
        }
    }
    
    // ------------------------------------------------------------------------
    // //////////////////////////////////////////// MARK: LOADING VETERINARIANS
    // ------------------------------------------------------------------------
    
    func load() throws {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "veterinarians")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        origin = origin.appending(component: "veterinarians")
        origin = origin.appendingPathExtension("json")
        let veterinariansData = try Data(contentsOf: origin)
        self.veterinarians = try decoder.decode([Veterinarian].self, from: veterinariansData)
        
        origin = origin.deletingPathExtension()
        origin = origin.deletingLastPathComponent()
        origin = origin.appending(component: "currentId")
        origin = origin.appendingPathExtension("json")
        let currentIdData = try Data(contentsOf: origin)
        self.currentId = try decoder.decode(UUID.self, from: currentIdData)
    }

    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////// MARK: SAVING VETERINARIANS
    // ------------------------------------------------------------------------
    
    func save() throws {
        
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "veterinarians")
        
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        destination = destination.appending(path: "veterinarians")
        destination = destination.appendingPathExtension("json")
        let vetrinariansData = try encoder.encode(self.veterinarians)
        try vetrinariansData.write(to: destination)
        
        destination = destination.deletingPathExtension()
        destination = destination.deletingLastPathComponent()
        destination = destination.appending(path: "currentId")
        destination = destination.appendingPathExtension("json")
        let currentIdData = try encoder.encode(self.currentId)
        try currentIdData.write(to: destination)
    }

    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()()()() MARK: MANAGING IMAGES
    // ------------------------------------------------------------------------
    
    func load(imageId: UUID) throws -> UIImage? {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "veterinarians")
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
        destination = destination.appending(component: "veterinarians")
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
        path = path.appending(component: "veterinarians")
        path = path.appending(component: "images")
        path = path.appending(path: imageId.uuidString)
        path = path.appending(path: imageId.uuidString)
        path = path.appendingPathExtension("jpg")
        
        try FileManager.default.removeItem(atPath: path.relativePath)
    }
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: CURRENT
    // ------------------------------------------------------------------------
    
    func track(currentId: UUID) -> Veterinarian? {
        return veterinarians.first { $0.id == currentId }
    }
    
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()( MARK: PROCESSING VETERINARIANS
    // ------------------------------------------------------------------------
    
    func create(veterianarian: Veterinarian) throws {
        veterinarians.append(veterianarian)
        try save()
    }
    
    func update(veterinarian: Veterinarian) throws {
        guard let index = veterinarians.firstIndex(where: { $0.id == veterinarian.id }) else { return }
        veterinarians[index] = veterinarian
        try save()
    }
    
    func delete(veterinarian: Veterinarian) async throws {
        veterinarians = veterinarians.filter { $0.id != veterinarian.id }
        if veterinarian.id == currentId { currentId = nil }
        try save()
    }
    
    func delete(atOffsets indexSet: IndexSet) throws {
        indexSet.forEach { index in
            if veterinarians[index].id == currentId { currentId = nil }
        }
        veterinarians.remove(atOffsets: indexSet)
        try save()
    }
    
    // ------------------------------------------------------------------------
    
    func activate(veterinarian: Veterinarian) throws {
        currentId = veterinarian.id
        try save()
    }
    
    func deactivate(veterinarian: inout Veterinarian) throws {
        currentId = nil
        try save()
    }
    
    // ------------------------------------------------------------------------
    
    func set(uiImage: UIImage, toVeterinarian veterinarian: inout Veterinarian) throws {
        let uuid = try save(uiImage: uiImage)
        veterinarian.imageId = uuid
        try update(veterinarian: veterinarian)
    }
    
    func load(ofVeterinarian veterinarian: Veterinarian) throws -> UIImage? {
        if let uuid = veterinarian.imageId {
            let uiImage = try load(imageId: uuid)
            return uiImage
        }
        return nil
    }
    
    // ------------------------------------------------------------------------
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><> MARK: FINDERS
    // ------------------------------------------------------------------------
    
    func find(incidentId uuid: UUID) -> Incident? {
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "incidents")
        origin = origin.appending(component: "incidents")
        origin = origin.appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: origin.relativePath) { return nil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let incidentsData = try Data(contentsOf: origin)
            let incidents = try decoder.decode([Incident].self, from: incidentsData)
            guard let incident = incidents.first(where: { $0.id == uuid }) else { return nil }
            return incident
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // ------------------------------------------------------------------------
    
    func find(imageId uuid: UUID) -> URL? {
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "veterinarians")
        origin = origin.appending(component: "images")
        origin = origin.appending(path: uuid.uuidString)
        origin = origin.appendingPathExtension("jpg")
        if !FileManager.default.fileExists(atPath: origin.relativePath) { return nil }
        return origin
    }
    
    // ------------------------------------------------------------------------
    // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX MARK: SEARCHERS
    // ------------------------------------------------------------------------
    
    func search() -> [Veterinarian] {
        return searchTerm.isEmpty ? veterinarians : veterinarians.filter({$0.name.lowercased().contains(searchTerm.lowercased())})
    }
    
    // ------------------------------------------------------------------------
    // FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MARK: FAVS
    // ------------------------------------------------------------------------
    
    func cleanCat(imageId: String) throws {
        for var vet in veterinarians {
            vet.catFavs.removeValue(forKey: imageId)
            vet.catVotes.removeValue(forKey: imageId)
            try update(veterinarian: vet)
        }
    }
    
    func cleanDog(imageId: String) throws {
        for var vet in veterinarians {
            vet.dogFavs.removeValue(forKey: imageId)
            vet.dogVotes.removeValue(forKey: imageId)
            try update(veterinarian: vet)
        }
    }
    // ------------------------------------------------------------------------
    // ########################################################## MARK: TESTING
    // ------------------------------------------------------------------------
    
    static var vet0 = Veterinarian(
        id: UUID(),
        name: "Eleftheria Saridaki",
        address: "Papandreou Andrea 84",
        postCode: "GR-731 34",
        city: "Chania",
        country: "Greece",
        telephoneNumber: "+306984739314",
        emailAddress: "elsaridak@gmail.com",
        imageId: nil,
        incidentIds: [],
        catFavs: [:],
        dogFavs: [:],
        catVotes: [:],
        dogVotes: [:]
    )
    
    // ------------------------------------------------------------------------
    
    static var vet1 = Veterinarian(
        id: UUID(),
        name: "Michalis Saridakis",
        address: "Zymvrakakidon 41",
        postCode: "GR-731 35",
        city: "Chania",
        country: "Greece",
        telephoneNumber: "+306945858108",
        emailAddress: "vetmsaridakis@gmail.com",
        imageId: nil,
        incidentIds: [],
        catFavs: [:],
        dogFavs: [:],
        catVotes: [:],
        dogVotes: [:]
    )
    
    // ------------------------------------------------------------------------
    
    static var vet2 = Veterinarian(
        id: UUID(),
        name: "Martha Saridaki",
        address: "Garivaldi 98",
        postCode: "GR-431 31",
        city: "Karditsa",
        country: "Greece",
        telephoneNumber: "+306986158848",
        emailAddress: "marthasaridaki@gmail.com",
        imageId: nil,
        incidentIds: [],
        catFavs: [:],
        dogFavs: [:],
        catVotes: [:],
        dogVotes: [:]
    )
    
    // ------------------------------------------------------------------------
    
    static var vet3 = Veterinarian(
        id: UUID(),
        name: "Nikos Saridakis",
        address: "Iroon Politechniou 72B",
        postCode: "GR-157 72",
        city: "Zografos",
        country: "Greece",
        telephoneNumber: "+306948604489",
        emailAddress: "muscaevolitantes@gmail.com",
        imageId: nil,
        incidentIds: [],
        catFavs: [:],
        dogFavs: [:],
        catVotes: [:],
        dogVotes: [:]
    )
    
    static var veterinarians = [vet0, vet1, vet2, vet3]
}
