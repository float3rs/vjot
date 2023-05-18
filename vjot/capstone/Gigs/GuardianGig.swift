//
//  GuardianGig.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 7/4/23.
//

import Foundation

@MainActor final class GuardianGig: ObservableObject {
    
    @Published var guardians: [Guardian] = []
    @Published var currentId: UUID? = nil
    @Published var initComplete: Bool = false
    
    static let shared = GuardianGig()
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: INITIALIZATION
    // ------------------------------------------------------------------------
    
    init() {
        do {
            print("%%%%%%%%% REVIVING GUAS %%")
            try load()
        } catch _ {
            print("%% CLEAN SLATE FOR GUAS %%")
            // print(error.localizedDescription)
        }
    }
    
    // ------------------------------------------------------------------------
    // //////////////////////////////////////////////// MARK: LOADING GUARDIANS
    // ------------------------------------------------------------------------
    
    func load() throws {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "guardians")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        origin = origin.appending(component: "guardians")
        origin = origin.appendingPathExtension("json")
        let guardiansData = try Data(contentsOf: origin)
        self.guardians = try decoder.decode([Guardian].self, from: guardiansData)
        
        origin = origin.deletingPathExtension()
        origin = origin.deletingLastPathComponent()
        origin = origin.appending(component: "currentId")
        origin = origin.appendingPathExtension("json")
        let currentIdData = try Data(contentsOf: origin)
        self.currentId = try decoder.decode(UUID.self, from: currentIdData)
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////// MARK: SAVING GUARDIANS
    // ------------------------------------------------------------------------
    
    func save() throws {
        
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "guardians")
        
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        destination = destination.appending(path: "guardians")
        destination = destination.appendingPathExtension("json")
        let guardiansData = try encoder.encode(self.guardians)
        try guardiansData.write(to: destination)
        
        destination = destination.deletingPathExtension()
        destination = destination.deletingLastPathComponent()
        destination = destination.appending(path: "currentId")
        destination = destination.appendingPathExtension("json")
        let currentGuaData = try encoder.encode(self.currentId)
        try currentGuaData.write(to: destination)
    }
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: CURRENT
    // ------------------------------------------------------------------------
    
    func track(currentId: UUID) -> Guardian? {
        return guardians.first { $0.id == currentId }
    }
    
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()( MARK: PROCESSING GUARDIANS
    // ------------------------------------------------------------------------
    
    func create(guardian: Guardian) throws {
        guardians.append(guardian)
        try save()
    }
    
    func update(guardian: Guardian) throws {
        guard let index = guardians.firstIndex(where: { $0.id == guardian.id }) else { return }
        guardians[index] = guardian
        try save()
    }
    
    func delete(guardian: Guardian) throws {
        guardians = guardians.filter { $0.id != guardian.id }
        if guardian.id == currentId { currentId = nil }
        try save()
    }
    
    func delete(atOffsets indexSet: IndexSet) throws {
        indexSet.forEach { index in
            if guardians[index].id == currentId { currentId = nil }
        }
        guardians.remove(atOffsets: indexSet)
        try save()
    }
    
    func activate(guardian: Guardian) throws {
        currentId = guardian.id
        try save()
    }
    
    func deactivate() throws {
        currentId = nil
        try save()
    }
    
    // ------------------------------------------------------------------------
    // ########################################################## MARK: TESTING
    // ------------------------------------------------------------------------
    
    static let gua0 = Guardian(
        id: UUID(),
        name: "Olivia",
        surname: "Emma",
        addres: "Patriarchou Gerasimou 20",
        postCode: "GR-731 31",
        city: "Chania",
        country: "Greece",
        telephoneNumber: "+302821095480"
    )
    
    // ------------------------------------------------------------------------
    
    static let gua1 = Guardian(
        id: UUID(),
        name: "Charlotte",
        surname: "Amelia",
        addres: "Zimverakakidon 41",
        postCode: "GR-731 35",
        city: "Chania",
        country: "Greece",
        telephoneNumber: "+302821097183"
    )
    
    // ------------------------------------------------------------------------
    
    static let gua2 = Guardian(
        id: UUID(),
        name: "Ava",
        surname: "Sophia",
        addres: "Papandreou Andrea 84",
        postCode: "GR-731 34",
        city: "Chania",
        country: "Greece",
        telephoneNumber: "+302821060460"
    )
    
    // ------------------------------------------------------------------------
    
    static let gua3 = Guardian(
        id: UUID(),
        name: "Liam",
        surname: "Noah",
        addres: "Selinou 109",
        postCode: "GR-731 31",
        city: "Chania",
        country: "Greece",
        telephoneNumber: "+302821097540"
    )
    
    // ------------------------------------------------------------------------
    
    static let gua4 = Guardian(
        id: UUID(),
        name: "Oliver",
        surname: "Elijah",
        addres: "Nik. Skoula 53-57",
        postCode: "GR-731 34",
        city: "Chania",
        country: "Greece",
        telephoneNumber: "+302821095480"
    )
    
    // ------------------------------------------------------------------------
    
    static let gua5 = Guardian(
        id: UUID(),
        name: "James",
        surname: "William",
        addres: "Dragoumi 11-5",
        postCode: "GR-731 32",
        city: "Chania",
        country: "Greece",
        telephoneNumber: "+302821097540"
    )
    
    // ------------------------------------------------------------------------
    
    static var guardians = [gua0, gua1, gua2, gua3, gua4, gua5]
}

