//
//  IncidentGig.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 7/4/23.
//

import Foundation
import SwiftUI
import AVKit
import PhotosUI

@MainActor final class IncidentGig: ObservableObject {
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @Published var initComplete: Bool = false
    
    @Published var incidents: [Incident] = []
    @Published var currentId: UUID? = nil
    
    @Published var searchTerm = String()
    @Published var searchDate = Date()
    
    @Published var audioSession: AVAudioSession!
    @Published var recording = false
    @Published var recorder: AVAudioRecorder!
    @Published var playing = false
    @Published var player: AVAudioPlayer!
    @Published var alert: Bool = false
    
    static let shared = IncidentGig()
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: INITIALIZATION
    // ------------------------------------------------------------------------
    
    init() {
        do {
            print("%%%%%%%%% REVIVING INCS %%")
            try load()
            
            self.audioSession = AVAudioSession.sharedInstance()
            try self.audioSession.setCategory(.playAndRecord)
            
        } catch _ {
            print("%% CLEAN SLATE FOR INCS %%")
            // print(error.localizedDescription)
        }
    }
    
    // ------------------------------------------------------------------------
    // //////////////////////////////////////////////// MARK: LOADING INCIDENTS
    // ------------------------------------------------------------------------
    
    func load() throws {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "incidents")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        origin = origin.appending(component: "incidents")
        origin = origin.appendingPathExtension("json")
        let incidentsData = try Data(contentsOf: origin)
        self.incidents = try decoder.decode([Incident].self, from: incidentsData)
        
        origin = origin.deletingPathExtension()
        origin = origin.deletingLastPathComponent()
        origin = origin.appending(component: "currentId")
        origin = origin.appendingPathExtension("json")
        let currentIdData = try Data(contentsOf: origin)
        self.currentId = try decoder.decode(UUID.self, from: currentIdData)
    }
    
    // ------------------------------------------------------------------------
    // ///////////////////////////////////////////////// MARK: SAVING INCIDENTS
    // ------------------------------------------------------------------------
    
    func save() throws {
        
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "incidents")
        
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        destination = destination.appending(path: "incidents")
        destination = destination.appendingPathExtension("json")
        let incidentsData = try encoder.encode(self.incidents)
        try incidentsData.write(to: destination)
        
        destination = destination.deletingPathExtension()
        destination = destination.deletingLastPathComponent()
        destination = destination.appending(path: "currentId")
        destination = destination.appendingPathExtension("json")
        let currentIdData = try encoder.encode(self.currentId)
        try currentIdData.write(to: destination)
    }
    
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()()()()( MARK: MANAGING TEXTS
    // ------------------------------------------------------------------------
    
    func loadIdea(ideaId: UUID) throws -> (String?, String?) {

        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "incidents")
        origin = origin.appending(component: "ideas")
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§
        
        var originText = origin.appending(component: "texts")
        originText = originText.appending(path: ideaId.uuidString)
        originText = originText.appendingPathExtension("txt")
        let textData = try Data(contentsOf: originText)
        let text = String(data: textData, encoding: .utf8)
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§
        
        var originCost = origin.appending(component: "costs")
        originCost = originCost.appending(path: ideaId.uuidString)
        originCost = originCost.appendingPathExtension("txt")
        let costData = try Data(contentsOf: originCost)
        let cost = String(data: costData, encoding: .utf8)
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§
        
        return (text, cost)
    }
    
    // ------------------------------------------------------------------------
    
    func saveIdea(text: String, cost: String) throws -> UUID {

        let uuid = UUID()

        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "incidents")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }

        destination = destination.appending(component: "ideas")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§
        
        var destinationText = destination.appending(component: "texts")
        if !FileManager.default.fileExists(atPath: destinationText.relativePath) {
            try FileManager.default.createDirectory(at: destinationText, withIntermediateDirectories: false)
        }

        destinationText = destinationText.appending(path: uuid.uuidString)
        destinationText = destinationText.appendingPathExtension("txt")
        let textData = text.data(using: .utf8)
        try textData?.write(to: destinationText)
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§
        
        var destinationCost = destination.appending(component: "costs")
        if !FileManager.default.fileExists(atPath: destinationCost.relativePath) {
            try FileManager.default.createDirectory(at: destinationCost, withIntermediateDirectories: false)
        }

        destinationCost = destinationCost.appending(path: uuid.uuidString)
        destinationCost = destinationCost.appendingPathExtension("txt")
        let costData = cost.data(using: .utf8)
        try costData?.write(to: destinationCost)
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§

        return uuid
    }
    
    // ------------------------------------------------------------------------
    
    func deleteIdea(ideaId: UUID) throws {
        
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        path = path.appending(component: "incidents")
        path = path.appending(component: "ideas")
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§
        
        var pathText = path.appending(component: "texts")
        pathText = pathText.appending(path: ideaId.uuidString)
        pathText = pathText.appendingPathExtension("txt")
        
        try FileManager.default.removeItem(atPath: pathText.relativePath)
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§
        
        var pathCost = path.appending(component: "cossts")
        pathCost = pathCost.appending(path: ideaId.uuidString)
        pathCost = pathCost.appendingPathExtension("txt")
        
        try FileManager.default.removeItem(atPath: pathCost.relativePath)
        
        // |§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§|§
    }
    
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()()()() MARK: MANAGING IMAGES
    // ------------------------------------------------------------------------
    
    func loadSnap(snapId: UUID) throws -> UIImage? {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "incidents")
        origin = origin.appending(component: "snaps")
        origin = origin.appending(path: snapId.uuidString)
        origin = origin.appendingPathExtension("jpg")
        let uiImageData = try Data(contentsOf: origin)
        let uiImage = UIImage(data: uiImageData)
        return uiImage
    }
    
    // ------------------------------------------------------------------------
    
    func saveSnap(uiImage: UIImage) throws -> UUID {
        
        let uuid = UUID()
        
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "incidents")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        destination = destination.appending(component: "snaps")
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
    
    func deleteSnap(snapId: UUID) throws {
        
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        path = path.appending(component: "incidents")
        path = path.appending(component: "snaps")
        path = path.appending(path: snapId.uuidString)
        path = path.appendingPathExtension("jpg")
        
        try FileManager.default.removeItem(atPath: path.relativePath)
    }
    
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()( TAKING PHOTO
    // ------------------------------------------------------------------------
    
    
    
    // ------------------------------------------------------------------------
    // §§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ MARK: MANAGING AUDIO
    // ------------------------------------------------------------------------
    
    func writeTape(data: Data) throws -> UUID {
        
        let uuid = UUID()
        
        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "incidents")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }

        destination = destination.appending(component: "tapes")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }
        
        destination = destination.appending(path: uuid.uuidString)
        destination = destination.appendingPathExtension("m4a")
        
        try data.write(to: destination)
        return uuid
    }
    
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()() RECORDING
    // ------------------------------------------------------------------------
    
    func rec() throws -> UUID {

        let uuid = UUID()

        var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        destination = destination.appending(component: "incidents")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }

        destination = destination.appending(component: "tapes")
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
        }

        destination = destination.appending(path: uuid.uuidString)
        destination = destination.appendingPathExtension("m4a")
        
        self.recorder = try AVAudioRecorder(url: destination, settings: [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ])
        
        self.recorder.record()
        self.recording = true

        return uuid
    }
    
    // [][][][][][][][][][][][][][][][]
    // STOP RECORDING ][][][][][][][][]
    // [][][][][][][][][][][][][][][][]
    
    func recStop() {
        self.recorder.stop()
        self.recording = false
    }
    
    // ------------------------------------------------------------------------
    // |>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|>|> PLAYING
    // ------------------------------------------------------------------------
    
    func play(tapeId: UUID) throws {
        
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "incidents")
        origin = origin.appending(component: "tapes")
        origin = origin.appending(path: tapeId.uuidString)
        origin = origin.appendingPathExtension("m4a")
        
        self.player = try AVAudioPlayer(contentsOf: origin)
        
        self.player.play()
        self.playing = true
    }
    
    // [][][][][][][][][][][][][][][][]
    // STOP PLAYING ][][][][][][][][][]
    // [][][][][][][][][][][][][][][][]
    
    func playStop() {
        self.player.stop()
        self.playing = false
    }
    
    // ------------------------------------------------------------------------
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: CURRENT
    // ------------------------------------------------------------------------
    
    func track(currentId: UUID) -> Incident? {
        return incidents.first { $0.id == currentId }
    }
    
    // ------------------------------------------------------------------------
    // ()()()()()()()()()()()()()()()()()()()()()()( MARK: PROCESSING INCIDENTS
    // ------------------------------------------------------------------------
    
    func create(incident: Incident) throws {
        incidents.append(incident)
        try save()
    }
    
    func update(incident: Incident) throws {
        guard let index = incidents.firstIndex(where: { $0.id == incident.id }) else { return }
        incidents[index] = incident
        try save()
    }
    
    func delete(incident: Incident) throws {
        incidents = incidents.filter { $0.id != incident.id }
        if incident.id == currentId { currentId = nil }
        try save()
    }
    
    func delete(atOffsets indexSet: IndexSet) throws {
        indexSet.forEach { index in
            if incidents[index].id == currentId { currentId = nil }
        }
        incidents.remove(atOffsets: indexSet)
        try save()
    }
    
    // ------------------------------------------------------------------------
    
    func activate(incident: Incident) throws {
        currentId = incident.id
        try save()
    }
    
    func deactivate() throws {
        currentId = nil
        try save()
    }
    
    // ----------------------------------------------------
    // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{} IDEAS
    // ----------------------------------------------------
    
    func appendIdea(text: String, cost: String, toIncident incident: inout Incident) throws {
        let uuid = try saveIdea(text: text, cost: cost)
        let idea: Idea = Idea(id: uuid, date: Date())
        incident.ideas.append(idea)
        try update(incident: incident)
    }
    
    func removeIdea(atOffsets indexSet: IndexSet, forIncident incident: inout Incident) throws {
        indexSet.forEach { index in
            incident.ideas.remove(atOffsets: indexSet)
        }
        try update(incident: incident)
    }
    
    // ----------------------------------------------------
    // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{} SNAPS
    // ----------------------------------------------------
    
    func appendSnap(uiImage: UIImage, toIncident incident: inout Incident) throws {
        let uuid = try saveSnap(uiImage: uiImage)
        let snap: Snap = Snap(id: uuid, date: Date())
        incident.snaps.append(snap)
        try update(incident: incident)
    }
    
    func removeSnap(atOffsets indexSet: IndexSet, forIncident incident: inout Incident) throws {
        indexSet.forEach { index in
            incident.snaps.remove(atOffsets: indexSet)
        }
        try update(incident: incident)
    }
    
    func removeSnap(uuid: UUID, forIncident incident: inout Incident) throws {
        incident.snaps = incident.snaps.filter({$0.id != uuid})
        try update(incident: incident)
    }
    
    func removeSnap(url: URL, forIncident incident: inout Incident) throws {
        
        var uuidString = url.absoluteString
        
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        path = path.appending(component: "incidents")
        path = path.appending(component: "snaps")
        
        uuidString = uuidString.replacingOccurrences(of: path.absoluteString, with: "")
        uuidString = uuidString.replacingOccurrences(of: "/", with: "")
        uuidString = uuidString.replacingOccurrences(of: ".jpg", with: "")
        
        let snapId = UUID(uuidString: uuidString)
        if let snapId {
            try removeSnap(uuid: snapId, forIncident: &incident)
            try deleteSnap(snapId: snapId)
        }
    }
    
    // ----------------------------------------------------
    // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{} TAPES
    // ----------------------------------------------------

    func appendTape(tapeId: UUID, toIncident incident: inout Incident) throws {
        let tape: Tape = Tape(id: tapeId, date: Date())
        incident.tapes.append(tape)
        try update(incident: incident)
    }
    
    func removeTape(atOffsets indexSet: IndexSet, forIncident incident: inout Incident) throws {
        indexSet.forEach { index in
            incident.tapes.remove(atOffsets: indexSet)
        }
        try update(incident: incident)
    }
    
    // ------------------------------------------------------------------------
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><> MARK: FINDERS
    // ------------------------------------------------------------------------
    
    func find(patientId uuid: UUID) -> Patient? {
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "patients")
        origin = origin.appending(component: "patients")
        origin = origin.appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: origin.relativePath) { return nil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let patientsData = try Data(contentsOf: origin)
            let patients = try decoder.decode([Patient].self, from: patientsData)
            guard let patient = patients.first(where: { $0.id == uuid }) else { return nil }
            return patient
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // ========================================================================
    
    func find(ideaId uuid: UUID) -> (String?, String?) {
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "incidents")
        origin = origin.appending(component: "ideas")
        
        var textOrigin = origin.appending(component: "texts")
        textOrigin = textOrigin.appending(path: uuid.uuidString)
        textOrigin = textOrigin.appendingPathExtension("txt")
        var costOrigin = origin.appending(component: "costs")
        costOrigin = costOrigin.appending(path: uuid.uuidString)
        costOrigin = costOrigin.appendingPathExtension("txt")
        if !FileManager.default.fileExists(atPath: textOrigin.relativePath) { return (nil, nil) }
        if !FileManager.default.fileExists(atPath: costOrigin.relativePath) { return (nil, nil) }
        do {
            let textData = try Data(contentsOf: textOrigin)
            let costData = try Data(contentsOf: costOrigin)
            return (String(data: textData, encoding: .utf8),String(data: costData, encoding: .utf8))
        } catch let error {
            print(error.localizedDescription)
            return (nil, nil)
        }
    }
    
    func find(snapId uuid: UUID) -> URL? {
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "incidents")
        origin = origin.appending(component: "snaps")
        origin = origin.appending(path: uuid.uuidString)
        origin = origin.appendingPathExtension("jpg")
        if !FileManager.default.fileExists(atPath: origin.relativePath) { return nil }
        return origin
    }
    
    func find(tapeId uuid: UUID) -> URL? {
        var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        origin = origin.appending(component: "incidents")
        origin = origin.appending(component: "tapes")
        origin = origin.appending(path: uuid.uuidString)
        origin = origin.appendingPathExtension("m4a")
        if !FileManager.default.fileExists(atPath: origin.relativePath) { return nil }
        return origin
    }
    
    // ------------------------------------------------------------------------
    // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX MARK: SEARCHERS
    // ------------------------------------------------------------------------
    
    func search() -> [Incident] {
        return searchTerm.isEmpty ? incidents : incidents.filter({$0.description.lowercased().contains(searchTerm.lowercased())})
    }
    
    func search24h(day: Date) -> [Incident] {
        let yesterday = day.addingTimeInterval(-86400)
        let range = yesterday...day
        return incidents.filter({range.contains($0.date)})
    }
    
    // ------------------------------------------------------------------------
    // |||||||||||||||||||||||||||||||||||||||||||||| MARK: ASSIGNING INCIDENTS
    // ------------------------------------------------------------------------
    
    func assign(incident: Incident, to veterinarian: inout Veterinarian) throws {
        if veterinarian.incidentIds.contains(where: { $0 == incident.id }) { return }
        veterinarian.incidentIds.append(incident.id)
    }
    
    // ------------------------------------------------------------------------
    // ||||||||||||||||||||||||||||||||||||||||||||| MARK: SPECIFYING INCIDENTS
    // ------------------------------------------------------------------------
    
    func specific(veterinarian: Veterinarian) -> [Incident] {
        var incidents: [Incident] = []
        veterinarian.incidentIds.forEach { incidentId in
            if let trackedIncident = track(currentId: incidentId) {
                incidents.append(trackedIncident)
            }
        }
        return incidents
    }
    
    // ------------------------------------------------------------------------
    // ########################################################## MARK: TESTING
    // ------------------------------------------------------------------------
    
    static var inc0 = Incident(
        id: UUID(),
        description: "rabies vaccination",
        date: Date(),
        ideas: [],
        snaps: [],
        tapes: [],
        patientId: nil,
        emergency: false
    )
    
    // ------------------------------------------------------------------------
    
    static var inc1 = Incident(
        id: UUID(),
        description: "nephrectomy",
        date: Date(),
        ideas: [],
        snaps: [],
        tapes: [],
        patientId: nil,
        emergency: false
    )
    
    // ------------------------------------------------------------------------
    
    static var inc2 = Incident(
        id: UUID(),
        description: "acute poisoning",
        date: Date(timeIntervalSinceNow: -86400),
        ideas: [],
        snaps: [],
        tapes: [],
        patientId: nil,
        emergency: true
    )
    
    // ------------------------------------------------------------------------
    
    static var inc3 = Incident(
        id: UUID(),
        description: "femoral fracture",
        date: Date(timeIntervalSinceNow: -172800),
        ideas: [],
        snaps: [],
        tapes: [],
        patientId: nil,
        emergency: true
    )
    
    // ------------------------------------------------------------------------
    
    static var inc4 = Incident(
        id: UUID(),
        description: "blood analysis",
        date: Date(timeIntervalSinceNow: -259200),
        ideas: [],
        snaps: [],
        tapes: [],
        patientId: nil,
        emergency: false
    )
    
    // ------------------------------------------------------------------------
    
    static var incidents = [inc0, inc1, inc2]
}
