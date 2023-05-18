//
//  Bootstrapper.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 11/4/23.
//

import SwiftUI

struct Bootstrapper: View {
    
    @EnvironmentObject var guardianGig: GuardianGig
    @EnvironmentObject var patientGig: PatientGig
    @EnvironmentObject var incidentGig: IncidentGig
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    @AppStorage("bootstrapped") var bootstrapped: Bool = true
    
    var body: some View {
        
        if (
            guardianGig.initComplete == false ||
            patientGig.initComplete == false ||
            incidentGig.initComplete == false ||
            veterinarianGig.initComplete == false
        ) {
            VStack(alignment: .leading) {
                VStack {
                    Text("development mode")
                        .font(.title)
                        .padding()
                }
                if guardianGig.initComplete == false {
                    HStack(alignment: .center) {
                        ProgressView()
                            .padding(.horizontal)
                        Text("bootstraping Guardians")
                    }
                    .padding(.horizontal)
                }
                if patientGig.initComplete == false {
                    HStack(alignment: .center) {
                        ProgressView()
                            .padding(.horizontal)
                        Text("bootstraping Patients")
                    }
                    .padding(.horizontal)
                }
                if incidentGig.initComplete == false {
                    HStack(alignment: .center) {
                        ProgressView()
                            .padding(.horizontal)
                        Text("bootstraping Incidents")
                    }
                    .padding(.horizontal)
                }
                if veterinarianGig.initComplete == false {
                    HStack(alignment: .center) {
                        ProgressView()
                            .padding(.horizontal)
                        Text("bootstraping Veterinarians")
                    }
                    .padding(.horizontal)
                }
            }
            .task {
                guaBootstrap()
                patBootstrap()
                incBootstrap()
                vetBootstrap()
            }
        }
        
        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        if (
            guardianGig.initComplete == true &&
            patientGig.initComplete == true &&
            incidentGig.initComplete == true &&
            veterinarianGig.initComplete == true
        ) {
            Launcher()
                .task {
                    bootstrap()
                }
        }
    }
    
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: GUARDIANS
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
    
    func guaBootstrap() {
        print("/> BOOTSTRAPING GUAS")
        do {
            guardianGig.guardians = []
            try guardianGig.deactivate()
            try guardianGig.create(guardian: GuardianGig.gua0)
            try guardianGig.create(guardian: GuardianGig.gua1)
            try guardianGig.create(guardian: GuardianGig.gua2)
            try guardianGig.create(guardian: GuardianGig.gua3)
            try guardianGig.create(guardian: GuardianGig.gua4)
            try guardianGig.create(guardian: GuardianGig.gua5)
            // AGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAG
            try guardianGig.activate(guardian: GuardianGig.gua1)
            // AGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAGAG
            guardianGig.initComplete = true
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: PATIENTS
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
    
    func patBootstrap() {
        print("/> BOOTSTRAPING PATS")
        do {
            patientGig.patients = []
            try patientGig.create(patient: PatientGig.pat0)
            try patientGig.create(patient: PatientGig.pat1)
            try patientGig.create(patient: PatientGig.pat2)
            try patientGig.create(patient: PatientGig.pat3)
        } catch let error {
            print(error.localizedDescription)
        }
        do {
            var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            origin = origin.appending(component: "bootstrap")
            origin = origin.appending(component: "patients")
            let _ = try FileManager.default.contentsOfDirectory(atPath: origin.relativePath)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var origin0 = origin.appending(path: "pat0")
            origin0 = origin0.appendingPathExtension("jpg")
            let uiImageData0 = try Data(contentsOf: origin0)
            let uiImage0 = UIImage(data: uiImageData0)!
            try patientGig.set(uiImage: uiImage0, toPatient: &PatientGig.pat0)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var origin1 = origin.appending(path: "pat1")
            origin1 = origin1.appendingPathExtension("jpg")
            let uiImageData1 = try Data(contentsOf: origin1)
            let uiImage1 = UIImage(data: uiImageData1)!
            try patientGig.set(uiImage: uiImage1, toPatient: &PatientGig.pat1)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var origin2 = origin.appending(path: "pat2")
            origin2 = origin2.appendingPathExtension("jpg")
            let uiImageData2 = try Data(contentsOf: origin2)
            let uiImage2 = UIImage(data: uiImageData2)!
            try patientGig.set(uiImage: uiImage2, toPatient: &PatientGig.pat2)

            var origin3 = origin.appending(path: "pat3")
            origin3 = origin3.appendingPathExtension("jpg")
            let uiImageData3 = try Data(contentsOf: origin3)
            let uiImage3 = UIImage(data: uiImageData3)!
            try patientGig.set(uiImage: uiImage3, toPatient: &PatientGig.pat3)

            
            // ~#~#~#~#~#~#~#~#~#~#~#
            //~#~#~#~ CURRENT PATIENT
            // ~#~#~#~#~#~#~#~#~#~#~#
            
            try patientGig.activate(patient: PatientGig.pat0)
            try patientGig.save()
            
            patientGig.initComplete = true
            print("/>       LOADED PATS")
        } catch _ {
            // print(error.localizedDescription)
            Task {
                do {
                    
                    var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    destination = destination.appending(component: "bootstrap")
                    if !FileManager.default.fileExists(atPath: destination.relativePath) {
                        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
                    }
                    destination = destination.appending(component: "patients")
                    if !FileManager.default.fileExists(atPath: destination.relativePath) {
                        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
                    }
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url0 = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/pat0.jpg")!
                    let urlRequest0 = URLRequest(url: url0)
                    let (data0, _ ) = try await URLSession.shared.data(for: urlRequest0)
                    let uiImage0 = UIImage(data: data0)!
                    try patientGig.set(uiImage: uiImage0, toPatient: &PatientGig.pat0)
                    var destination0 = destination.appending(path: "pat0")
                    destination0 = destination0.appendingPathExtension("jpg")
                    try data0.write(to: destination0)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url1 = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/pat1.jpg")!
                    let urlRequest1 = URLRequest(url: url1)
                    let (data1, _ ) = try await URLSession.shared.data(for: urlRequest1)
                    let uiImage1 = UIImage(data: data1)!
                    try patientGig.set(uiImage: uiImage1, toPatient: &PatientGig.pat1)
                    var destination1 = destination.appending(path: "pat1")
                    destination1 = destination1.appendingPathExtension("jpg")
                    try data1.write(to: destination1)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url2 = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/pat2.jpg")!
                    let urlRequest2 = URLRequest(url: url2)
                    let (data2, _ ) = try await URLSession.shared.data(for: urlRequest2)
                    let uiImage2 = UIImage(data: data2)!
                    try patientGig.set(uiImage: uiImage2, toPatient: &PatientGig.pat2)
                    var destination2 = destination.appending(path: "pat2")
                    destination2 = destination2.appendingPathExtension("jpg")
                    try data2.write(to: destination2)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url3 = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/pat3.jpg")!
                    let urlRequest3 = URLRequest(url: url3)
                    let (data3, _ ) = try await URLSession.shared.data(for: urlRequest3)
                    let uiImage3 = UIImage(data: data3)!
                    try patientGig.set(uiImage: uiImage3, toPatient: &PatientGig.pat3)
                    var destination3 = destination.appending(path: "pat3")
                    destination3 = destination3.appendingPathExtension("jpg")
                    try data3.write(to: destination3)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    // ~#~#~#~#~#~#~#~
                    // CURRENT PATIENT
                    // ~#~#~#~#~#~#~#~
                    
                    try patientGig.activate(patient: PatientGig.pat0)
                    
                    patientGig.initComplete = true
                    print("/>      FETCHED PATS")
                } catch _ {
                    // print(error.localizedDescription)
                    do {
                        
                        // ~#~#~#~#~#~#~#~
                        // CURRENT PATIENT
                        // ~#~#~#~#~#~#~#~
                        
                        try patientGig.activate(patient: PatientGig.pat0)
                        
                        patientGig.initComplete = true
                        print("/>   FALLBACKED PATS")
                    } catch _ {
                        // print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: INCIDENTS
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
    
    func incBootstrap() {
        print("/> BOOTSTRAPING INCS")
        do {
            incidentGig.incidents = []
            try incidentGig.create(incident: IncidentGig.inc0)
            try incidentGig.create(incident: IncidentGig.inc1)
            try incidentGig.create(incident: IncidentGig.inc2)
            try incidentGig.create(incident: IncidentGig.inc3)
            try incidentGig.create(incident: IncidentGig.inc4)
        } catch let error {
            print(error.localizedDescription)
        }
        do {
            
            // \/\/\/\/\/\/\/
            // \/\/\/\/ IDEAS
            // \/\/\/\/\/\/\/
            
            var ideaOrigin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            ideaOrigin = ideaOrigin.appending(component: "bootstrap")
            ideaOrigin = ideaOrigin.appending(component: "incidents")
            ideaOrigin = ideaOrigin.appending(component: "ideas")
            _ = try FileManager.default.contentsOfDirectory(atPath: ideaOrigin.relativePath)
            
            let ideaTextsOrigin = ideaOrigin.appending(component: "texts")
            let ideaCostsOrigin = ideaOrigin.appending(component: "costs")

            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++

            var ideaTextsOrigin0a = ideaTextsOrigin.appending(path: "inc0a")
            ideaTextsOrigin0a = ideaTextsOrigin0a.appendingPathExtension("txt")
            let textData0a = try Data(contentsOf: ideaTextsOrigin0a)
            let text0a = String(data: textData0a, encoding: .utf8)!
            var ideaCostsOrigin0a = ideaCostsOrigin.appending(path: "inc0a")
            ideaCostsOrigin0a = ideaCostsOrigin0a.appendingPathExtension("txt")
            let costData0a = try Data(contentsOf: ideaCostsOrigin0a)
            let cost0a = String(data: costData0a, encoding: .utf8)!
            try incidentGig.appendIdea(text: text0a, cost: cost0a, toIncident: &IncidentGig.inc0)
            
            var ideaTextsOrigin0b = ideaTextsOrigin.appending(path: "inc0b")
            ideaTextsOrigin0b = ideaTextsOrigin0b.appendingPathExtension("txt")
            let textData0b = try Data(contentsOf: ideaTextsOrigin0b)
            let text0b = String(data: textData0b, encoding: .utf8)!
            var ideaCostsOrigin0b = ideaCostsOrigin.appending(path: "inc0b")
            ideaCostsOrigin0b = ideaCostsOrigin0b.appendingPathExtension("txt")
            let costData0b = try Data(contentsOf: ideaCostsOrigin0b)
            let cost0b = String(data: costData0b, encoding: .utf8)!
            try incidentGig.appendIdea(text: text0b, cost: cost0b, toIncident: &IncidentGig.inc0)
            
            var ideaTextsOrigin0c = ideaTextsOrigin.appending(path: "inc0c")
            ideaTextsOrigin0c = ideaTextsOrigin0c.appendingPathExtension("txt")
            let textData0c = try Data(contentsOf: ideaTextsOrigin0c)
            let text0c = String(data: textData0c, encoding: .utf8)!
            var ideaCostsOrigin0c = ideaCostsOrigin.appending(path: "inc0c")
            ideaCostsOrigin0c = ideaCostsOrigin0c.appendingPathExtension("txt")
            let costData0c = try Data(contentsOf: ideaCostsOrigin0c)
            let cost0c = String(data: costData0c, encoding: .utf8)!
            try incidentGig.appendIdea(text: text0c, cost: cost0c, toIncident: &IncidentGig.inc0)

            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var ideaTextsOrigin1a = ideaTextsOrigin.appending(path: "inc1a")
            ideaTextsOrigin1a = ideaTextsOrigin1a.appendingPathExtension("txt")
            let textData1a = try Data(contentsOf: ideaTextsOrigin1a)
            let text1a = String(data: textData1a, encoding: .utf8)!
            var ideaCostsOrigin1a = ideaCostsOrigin.appending(path: "inc1a")
            ideaCostsOrigin1a = ideaCostsOrigin1a.appendingPathExtension("txt")
            let costData1a = try Data(contentsOf: ideaCostsOrigin1a)
            let cost1a = String(data: costData1a, encoding: .utf8)!
            try incidentGig.appendIdea(text: text1a, cost: cost1a, toIncident: &IncidentGig.inc1)
            
            var ideaTextsOrigin1b = ideaTextsOrigin.appending(path: "inc1b")
            ideaTextsOrigin1b = ideaTextsOrigin1b.appendingPathExtension("txt")
            let textData1b = try Data(contentsOf: ideaTextsOrigin1b)
            let text1b = String(data: textData1b, encoding: .utf8)!
            var ideaCostsOrigin1b = ideaCostsOrigin.appending(path: "inc1b")
            ideaCostsOrigin1b = ideaCostsOrigin1b.appendingPathExtension("txt")
            let costData1b = try Data(contentsOf: ideaCostsOrigin1b)
            let cost1b = String(data: costData1b, encoding: .utf8)!
            try incidentGig.appendIdea(text: text1b, cost: cost1b, toIncident: &IncidentGig.inc1)

            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var ideaTextsOrigin2a = ideaTextsOrigin.appending(path: "inc2a")
            ideaTextsOrigin2a = ideaTextsOrigin2a.appendingPathExtension("txt")
            let textData2a = try Data(contentsOf: ideaTextsOrigin2a)
            let text2a = String(data: textData2a, encoding: .utf8)!
            var ideaCostsOrigin2a = ideaCostsOrigin.appending(path: "inc2a")
            ideaCostsOrigin2a = ideaCostsOrigin2a.appendingPathExtension("txt")
            let costData2a = try Data(contentsOf: ideaCostsOrigin2a)
            let cost2a = String(data: costData2a, encoding: .utf8)!
            try incidentGig.appendIdea(text: text2a, cost: cost2a, toIncident: &IncidentGig.inc2)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++

            var ideaTextsOrigin3a = ideaTextsOrigin.appending(path: "inc3a")
            ideaTextsOrigin3a = ideaTextsOrigin3a.appendingPathExtension("txt")
            let textData3a = try Data(contentsOf: ideaTextsOrigin3a)
            let text3a = String(data: textData3a, encoding: .utf8)!
            var ideaCostsOrigin3a = ideaCostsOrigin.appending(path: "inc3a")
            ideaCostsOrigin3a = ideaCostsOrigin3a.appendingPathExtension("txt")
            let costData3a = try Data(contentsOf: ideaCostsOrigin3a)
            let cost3a = String(data: costData3a, encoding: .utf8)!
            try incidentGig.appendIdea(text: text3a, cost: cost3a, toIncident: &IncidentGig.inc3)
            
            var ideaTextsOrigin3b = ideaTextsOrigin.appending(path: "inc3b")
            ideaTextsOrigin3b = ideaTextsOrigin3b.appendingPathExtension("txt")
            let textData3b = try Data(contentsOf: ideaTextsOrigin3b)
            let text3b = String(data: textData3b, encoding: .utf8)!
            var ideaCostsOrigin3b = ideaCostsOrigin.appending(path: "inc3b")
            ideaCostsOrigin3b = ideaCostsOrigin3b.appendingPathExtension("txt")
            let costData3b = try Data(contentsOf: ideaCostsOrigin3b)
            let cost3b = String(data: costData3b, encoding: .utf8)!
            try incidentGig.appendIdea(text: text3b, cost: cost3b, toIncident: &IncidentGig.inc3)
            
            var ideaTextsOrigin3c = ideaTextsOrigin.appending(path: "inc3c")
            ideaTextsOrigin3c = ideaTextsOrigin3c.appendingPathExtension("txt")
            let textData3c = try Data(contentsOf: ideaTextsOrigin3c)
            let text3c = String(data: textData3c, encoding: .utf8)!
            var ideaCostsOrigin3c = ideaCostsOrigin.appending(path: "inc3c")
            ideaCostsOrigin3c = ideaCostsOrigin3c.appendingPathExtension("txt")
            let costData3c = try Data(contentsOf: ideaCostsOrigin3c)
            let cost3c = String(data: costData3c, encoding: .utf8)!
            try incidentGig.appendIdea(text: text3c, cost: cost3c, toIncident: &IncidentGig.inc3)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var ideaTextsOrigin4a = ideaTextsOrigin.appending(path: "inc4a")
            ideaTextsOrigin4a = ideaTextsOrigin4a.appendingPathExtension("txt")
            let textData4a = try Data(contentsOf: ideaTextsOrigin4a)
            let text4a = String(data: textData4a, encoding: .utf8)!
            var ideaCostsOrigin4a = ideaCostsOrigin.appending(path: "inc4a")
            ideaCostsOrigin4a = ideaCostsOrigin4a.appendingPathExtension("txt")
            let costData4a = try Data(contentsOf: ideaCostsOrigin4a)
            let cost4a = String(data: costData4a, encoding: .utf8)!
            try incidentGig.appendIdea(text: text4a, cost: cost4a, toIncident: &IncidentGig.inc4)
            
            var ideaTextsOrigin4b = ideaTextsOrigin.appending(path: "inc4b")
            ideaTextsOrigin4b = ideaTextsOrigin4b.appendingPathExtension("txt")
            let textData4b = try Data(contentsOf: ideaTextsOrigin4b)
            let text4b = String(data: textData4b, encoding: .utf8)!
            var ideaCostsOrigin4b = ideaCostsOrigin.appending(path: "inc4b")
            ideaCostsOrigin4b = ideaCostsOrigin4b.appendingPathExtension("txt")
            let costData4b = try Data(contentsOf: ideaCostsOrigin4b)
            let cost4b = String(data: costData4b, encoding: .utf8)!
            try incidentGig.appendIdea(text: text4b, cost: cost4b, toIncident: &IncidentGig.inc4)


            // \/\/\/\/\/\/\/
            // \/\/\/\/ SNAPS
            // \/\/\/\/\/\/\/

            var snapOrigin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            snapOrigin = snapOrigin.appending(component: "bootstrap")
            snapOrigin = snapOrigin.appending(component: "incidents")
            snapOrigin = snapOrigin.appending(component: "snaps")
            _ = try FileManager.default.contentsOfDirectory(atPath: snapOrigin.relativePath)

            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var snapOrigin0a = snapOrigin.appending(path: "inc0a")
            snapOrigin0a = snapOrigin0a.appendingPathExtension("jpg")
            let uiImageData0a = try Data(contentsOf: snapOrigin0a)
            let uiImage0a = UIImage(data: uiImageData0a)!
            try incidentGig.appendSnap(uiImage: uiImage0a, toIncident: &IncidentGig.inc0)

            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var snapOrigin1a = snapOrigin.appending(path: "inc1a")
            snapOrigin1a = snapOrigin1a.appendingPathExtension("jpg")
            let uiImageData1a = try Data(contentsOf: snapOrigin1a)
            let uiImage1a = UIImage(data: uiImageData1a)!
            try incidentGig.appendSnap(uiImage: uiImage1a, toIncident: &IncidentGig.inc1)
            
//            var snapOrigin1b = snapOrigin.appending(path: "inc1b")
//            snapOrigin1b = snapOrigin1b.appendingPathExtension("jpg")
//            let uiImageData1b = try Data(contentsOf: snapOrigin1b)
//            let uiImage1b = UIImage(data: uiImageData1b)!
//            try incidentGig.appendSnap(uiImage: uiImage1b, toIncident: &IncidentGig.inc1)
//
//            var snapOrigin1c = snapOrigin.appending(path: "inc1c")
//            snapOrigin1c = snapOrigin1c.appendingPathExtension("jpg")
//            let uiImageData1c = try Data(contentsOf: snapOrigin1c)
//            let uiImage1c = UIImage(data: uiImageData1c)!
//            try incidentGig.appendSnap(uiImage: uiImage1c, toIncident: &IncidentGig.inc1)
            
            var snapOrigin1d = snapOrigin.appending(path: "inc1d")
            snapOrigin1d = snapOrigin1d.appendingPathExtension("jpg")
            let uiImageData1d = try Data(contentsOf: snapOrigin1d)
            let uiImage1d = UIImage(data: uiImageData1d)!
            try incidentGig.appendSnap(uiImage: uiImage1d, toIncident: &IncidentGig.inc1)
            
            var snapOrigin1e = snapOrigin.appending(path: "inc1e")
            snapOrigin1e = snapOrigin1e.appendingPathExtension("jpg")
            let uiImageData1e = try Data(contentsOf: snapOrigin1e)
            let uiImage1e = UIImage(data: uiImageData1e)!
            try incidentGig.appendSnap(uiImage: uiImage1e, toIncident: &IncidentGig.inc1)
            
//            var snapOrigin1f = snapOrigin.appending(path: "inc1f")
//            snapOrigin1f = snapOrigin1f.appendingPathExtension("jpg")
//            let uiImageData1f = try Data(contentsOf: snapOrigin1f)
//            let uiImage1f = UIImage(data: uiImageData1f)!
//            try incidentGig.appendSnap(uiImage: uiImage1f, toIncident: &IncidentGig.inc1)
//
//            var snapOrigin1g = snapOrigin.appending(path: "inc1g")
//            snapOrigin1g = snapOrigin1g.appendingPathExtension("jpg")
//            let uiImageData1g = try Data(contentsOf: snapOrigin1g)
//            let uiImage1g = UIImage(data: uiImageData1g)!
//            try incidentGig.appendSnap(uiImage: uiImage1g, toIncident: &IncidentGig.inc1)

            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var snapOrigin2a = snapOrigin.appending(path: "inc2a")
            snapOrigin2a = snapOrigin2a.appendingPathExtension("jpg")
            let uiImageData2a = try Data(contentsOf: snapOrigin2a)
            let uiImage2a = UIImage(data: uiImageData2a)!
            try incidentGig.appendSnap(uiImage: uiImage2a, toIncident: &IncidentGig.inc2)
            
            var snapOrigin2b = snapOrigin.appending(path: "inc2b")
            snapOrigin2b = snapOrigin2b.appendingPathExtension("jpg")
            let uiImageData2b = try Data(contentsOf: snapOrigin2b)
            let uiImage2b = UIImage(data: uiImageData2b)!
            try incidentGig.appendSnap(uiImage: uiImage2b, toIncident: &IncidentGig.inc2)
            
            var snapOrigin2c = snapOrigin.appending(path: "inc2c")
            snapOrigin2c = snapOrigin2c.appendingPathExtension("jpg")
            let uiImageData2c = try Data(contentsOf: snapOrigin2c)
            let uiImage2c = UIImage(data: uiImageData2c)!
            try incidentGig.appendSnap(uiImage: uiImage2c, toIncident: &IncidentGig.inc2)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var snapOrigin3a = snapOrigin.appending(path: "inc3a")
            snapOrigin3a = snapOrigin3a.appendingPathExtension("jpg")
            let uiImageData3a = try Data(contentsOf: snapOrigin3a)
            let uiImage3a = UIImage(data: uiImageData3a)!
            try incidentGig.appendSnap(uiImage: uiImage3a, toIncident: &IncidentGig.inc3)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var snapOrigin4a = snapOrigin.appending(path: "inc4a")
            snapOrigin4a = snapOrigin4a.appendingPathExtension("jpg")
            let uiImageData4a = try Data(contentsOf: snapOrigin4a)
            let uiImage4a = UIImage(data: uiImageData4a)!
            try incidentGig.appendSnap(uiImage: uiImage4a, toIncident: &IncidentGig.inc4)
            
            var snapOrigin4b = snapOrigin.appending(path: "inc4b")
            snapOrigin4b = snapOrigin4b.appendingPathExtension("jpg")
            let uiImageData4b = try Data(contentsOf: snapOrigin4b)
            let uiImage4b = UIImage(data: uiImageData4b)!
            try incidentGig.appendSnap(uiImage: uiImage4b, toIncident: &IncidentGig.inc4)

            // \/\/\/\/\/\/\/
            // \/\/\/\/ TAPES
            // \/\/\/\/\/\/\/

            var tapeOrigin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            tapeOrigin = tapeOrigin.appending(component: "bootstrap")
            tapeOrigin = tapeOrigin.appending(component: "incidents")
            tapeOrigin = tapeOrigin.appending(component: "tapes")
            _ = try FileManager.default.contentsOfDirectory(atPath: tapeOrigin.relativePath)

            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var tapeOrigin0a = tapeOrigin.appending(path: "inc0a")
            tapeOrigin0a = tapeOrigin0a.appendingPathExtension("m4a")
            let tapeData0a = try Data(contentsOf: tapeOrigin0a)
            let tapeUUID0a = try incidentGig.writeTape(data: tapeData0a)
            try incidentGig.appendTape(tapeId: tapeUUID0a, toIncident: &IncidentGig.inc0)
            
            var tapeOrigin0b = tapeOrigin.appending(path: "inc0b")
            tapeOrigin0b = tapeOrigin0b.appendingPathExtension("m4a")
            let tapeData0b = try Data(contentsOf: tapeOrigin0b)
            let tapeUUID0b = try incidentGig.writeTape(data: tapeData0b)
            try incidentGig.appendTape(tapeId: tapeUUID0b, toIncident: &IncidentGig.inc0)
            
            var tapeOrigin0c = tapeOrigin.appending(path: "inc0c")
            tapeOrigin0c = tapeOrigin0c.appendingPathExtension("m4a")
            let tapeData0c = try Data(contentsOf: tapeOrigin0c)
            let tapeUUID0c = try incidentGig.writeTape(data: tapeData0c)
            try incidentGig.appendTape(tapeId: tapeUUID0c, toIncident: &IncidentGig.inc0)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var tapeOrigin1a = tapeOrigin.appending(path: "inc1a")
            tapeOrigin1a = tapeOrigin1a.appendingPathExtension("m4a")
            let tapeData1a = try Data(contentsOf: tapeOrigin1a)
            let tapeUUID1a = try incidentGig.writeTape(data: tapeData1a)
            try incidentGig.appendTape(tapeId: tapeUUID1a, toIncident: &IncidentGig.inc1)
            
            var tapeOrigin1b = tapeOrigin.appending(path: "inc1b")
            tapeOrigin1b = tapeOrigin1b.appendingPathExtension("m4a")
            let tapeData1b = try Data(contentsOf: tapeOrigin1b)
            let tapeUUID1b = try incidentGig.writeTape(data: tapeData1b)
            try incidentGig.appendTape(tapeId: tapeUUID1b, toIncident: &IncidentGig.inc1)
            
            var tapeOrigin1c = tapeOrigin.appending(path: "inc1c")
            tapeOrigin1c = tapeOrigin1c.appendingPathExtension("m4a")
            let tapeData1c = try Data(contentsOf: tapeOrigin1c)
            let tapeUUID1c = try incidentGig.writeTape(data: tapeData1c)
            try incidentGig.appendTape(tapeId: tapeUUID1c, toIncident: &IncidentGig.inc1)
            
            var tapeOrigin1d = tapeOrigin.appending(path: "inc1d")
            tapeOrigin1d = tapeOrigin1d.appendingPathExtension("m4a")
            let tapeData1d = try Data(contentsOf: tapeOrigin1d)
            let tapeUUID1d = try incidentGig.writeTape(data: tapeData1d)
            try incidentGig.appendTape(tapeId: tapeUUID1d, toIncident: &IncidentGig.inc1)

            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var tapeOrigin2a = tapeOrigin.appending(path: "inc2a")
            tapeOrigin2a = tapeOrigin2a.appendingPathExtension("m4a")
            let tapeData2a = try Data(contentsOf: tapeOrigin2a)
            let tapeUUID2a = try incidentGig.writeTape(data: tapeData2a)
            try incidentGig.appendTape(tapeId: tapeUUID2a, toIncident: &IncidentGig.inc2)
            
            var tapeOrigin2b = tapeOrigin.appending(path: "inc2b")
            tapeOrigin2b = tapeOrigin2b.appendingPathExtension("m4a")
            let tapeData2b = try Data(contentsOf: tapeOrigin2b)
            let tapeUUID2b = try incidentGig.writeTape(data: tapeData2b)
            try incidentGig.appendTape(tapeId: tapeUUID2b, toIncident: &IncidentGig.inc1)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var tapeOrigin3a = tapeOrigin.appending(path: "inc3a")
            tapeOrigin3a = tapeOrigin3a.appendingPathExtension("m4a")
            let tapeData3a = try Data(contentsOf: tapeOrigin3a)
            let tapeUUID3a = try incidentGig.writeTape(data: tapeData3a)
            try incidentGig.appendTape(tapeId: tapeUUID3a, toIncident: &IncidentGig.inc3)
            
            var tapeOrigin3b = tapeOrigin.appending(path: "inc3b")
            tapeOrigin3b = tapeOrigin3b.appendingPathExtension("m4a")
            let tapeData3b = try Data(contentsOf: tapeOrigin3b)
            let tapeUUID3b = try incidentGig.writeTape(data: tapeData3b)
            try incidentGig.appendTape(tapeId: tapeUUID3b, toIncident: &IncidentGig.inc3)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var tapeOrigin4a = tapeOrigin.appending(path: "inc4a")
            tapeOrigin4a = tapeOrigin4a.appendingPathExtension("m4a")
            let tapeData4a = try Data(contentsOf: tapeOrigin4a)
            let tapeUUID4a = try incidentGig.writeTape(data: tapeData4a)
            try incidentGig.appendTape(tapeId: tapeUUID4a, toIncident: &IncidentGig.inc4)
            
            var tapeOrigin4b = tapeOrigin.appending(path: "inc4b")
            tapeOrigin4b = tapeOrigin4b.appendingPathExtension("m4a")
            let tapeData4b = try Data(contentsOf: tapeOrigin4b)
            let tapeUUID4b = try incidentGig.writeTape(data: tapeData4b)
            try incidentGig.appendTape(tapeId: tapeUUID4b, toIncident: &IncidentGig.inc4)
            
            var tapeOrigin4c = tapeOrigin.appending(path: "inc4c")
            tapeOrigin4c = tapeOrigin4c.appendingPathExtension("m4a")
            let tapeData4c = try Data(contentsOf: tapeOrigin4c)
            let tapeUUID4c = try incidentGig.writeTape(data: tapeData4c)
            try incidentGig.appendTape(tapeId: tapeUUID4c, toIncident: &IncidentGig.inc4)
            
            // ~#~#~#~#~#~#~#~#
            // CURRENT INCIDENT
            // ~#~#~#~#~#~#~#~#
            
            try incidentGig.activate(incident: IncidentGig.inc1)
            try incidentGig.save()
            
            incidentGig.initComplete = true
            print("/>       LOADED INCS")
        } catch _ {
//             print(error.localizedDescription)
            Task {
                do {
                    
                    var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    destination = destination.appending(component: "bootstrap")
                    if !FileManager.default.fileExists(atPath: destination.relativePath) {
                        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
                    }
                    destination = destination.appending(component: "incidents")
                    if !FileManager.default.fileExists(atPath: destination.relativePath) {
                        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
                    }
                    
                    // \/\/\/\/\/\/\/
                    // \/\/\/\/ IDEAS
                    // \/\/\/\/\/\/\/
                    
                    let destinationIdeas = destination.appending(component: "ideas")
                    if !FileManager.default.fileExists(atPath: destinationIdeas.relativePath) {
                        try FileManager.default.createDirectory(at: destinationIdeas, withIntermediateDirectories: false)
                    }
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let destinationIdeasTexts = destinationIdeas.appending(component: "texts")
                    if !FileManager.default.fileExists(atPath: destinationIdeasTexts.relativePath) {
                        try FileManager.default.createDirectory(at: destinationIdeasTexts, withIntermediateDirectories: false)
                    }
                    let destinationIdeasCosts = destinationIdeas.appending(component: "costs")
                    if !FileManager.default.fileExists(atPath: destinationIdeasCosts.relativePath) {
                        try FileManager.default.createDirectory(at: destinationIdeasCosts, withIntermediateDirectories: false)
                    }
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let text0a = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas tellus rutrum tellus pellentesque eu tincidunt. Vitae nunc sed velit dignissim sodales ut eu."
                    let cost0a = "64.00"
                    try incidentGig.appendIdea(text: text0a, cost: cost0a, toIncident: &IncidentGig.inc0)
                    var destinationIdeasTexts0a = destinationIdeasTexts.appending(path: "inc0a")
                    destinationIdeasTexts0a = destinationIdeasTexts0a.appendingPathExtension("txt")
                    let textDataTexts0a = text0a.data(using: .utf8)
                    try textDataTexts0a?.write(to: destinationIdeasTexts0a)
                    var destinationIdeasCosts0a = destinationIdeasCosts.appending(path: "inc0a")
                    destinationIdeasCosts0a = destinationIdeasCosts0a.appendingPathExtension("txt")
                    let textDataCosts0a = cost0a.data(using: .utf8)
                    try textDataCosts0a?.write(to: destinationIdeasCosts0a)
                    
                    let text0b = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                    let cost0b = "32.00"
                    try incidentGig.appendIdea(text: text0b, cost: cost0b, toIncident: &IncidentGig.inc0)
                    var destinationIdeasTexts0b = destinationIdeasTexts.appending(path: "inc0b")
                    destinationIdeasTexts0b = destinationIdeasTexts0b.appendingPathExtension("txt")
                    let textDataTexts0b = text0b.data(using: .utf8)
                    try textDataTexts0b?.write(to: destinationIdeasTexts0b)
                    var destinationIdeasCosts0b = destinationIdeasCosts.appending(path: "inc0b")
                    destinationIdeasCosts0b = destinationIdeasCosts0b.appendingPathExtension("txt")
                    let textDataCosts0b = cost0b.data(using: .utf8)
                    try textDataCosts0b?.write(to: destinationIdeasCosts0b)
                    
                    let text0c = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut lectus arcu bibendum at varius vel pharetra vel."
                    let cost0c = "48.00"
                    try incidentGig.appendIdea(text: text0c, cost: cost0c, toIncident: &IncidentGig.inc0)
                    var destinationIdeasTexts0c = destinationIdeasTexts.appending(path: "inc0c")
                    destinationIdeasTexts0c = destinationIdeasTexts0c.appendingPathExtension("txt")
                    let textDataTexts0c = text0c.data(using: .utf8)
                    try textDataTexts0c?.write(to: destinationIdeasTexts0c)
                    var destinationIdeasCosts0c = destinationIdeasCosts.appending(path: "inc0c")
                    destinationIdeasCosts0c = destinationIdeasCosts0c.appendingPathExtension("txt")
                    let textDataCosts0c = cost0c.data(using: .utf8)
                    try textDataCosts0c?.write(to: destinationIdeasCosts0c)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let text1a = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                    let cost1a = "16.00"
                    try incidentGig.appendIdea(text: text1a, cost: cost1a, toIncident: &IncidentGig.inc1)
                    var destinationIdeasTexts1a = destinationIdeasTexts.appending(path: "inc1a")
                    destinationIdeasTexts1a = destinationIdeasTexts1a.appendingPathExtension("txt")
                    let textDataTexts1a = text1a.data(using: .utf8)
                    try textDataTexts1a?.write(to: destinationIdeasTexts1a)
                    var destinationIdeasCosts1a = destinationIdeasCosts.appending(path: "inc1a")
                    destinationIdeasCosts1a = destinationIdeasCosts1a.appendingPathExtension("txt")
                    let textDataCosts1a = cost1a.data(using: .utf8)
                    try textDataCosts1a?.write(to: destinationIdeasCosts1a)
                    
                    let text1b = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis commodo odio aenean sed adipiscing diam. Ultrices mi tempus imperdiet nulla."
                    let cost1b = "56.00"
                    try incidentGig.appendIdea(text: text1b, cost: cost1b, toIncident: &IncidentGig.inc1)
                    var destinationIdeasTexts1b = destinationIdeasTexts.appending(path: "inc1b")
                    destinationIdeasTexts1b = destinationIdeasTexts1b.appendingPathExtension("txt")
                    let textDataTexts1b = text1b.data(using: .utf8)
                    try textDataTexts1b?.write(to: destinationIdeasTexts1b)
                    var destinationIdeasCosts1b = destinationIdeasCosts.appending(path: "inc1b")
                    destinationIdeasCosts1b = destinationIdeasCosts1b.appendingPathExtension("txt")
                    let textDataCosts1b = cost0b.data(using: .utf8)
                    try textDataCosts1b?.write(to: destinationIdeasCosts1b)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let text2a = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Rhoncus aenean vel elit scelerisque mauris."
                    let cost2a = "72.00"
                    try incidentGig.appendIdea(text: text2a, cost: cost2a, toIncident: &IncidentGig.inc2)
                    var destinationIdeasTexts2a = destinationIdeasTexts.appending(path: "inc2a")
                    destinationIdeasTexts2a = destinationIdeasTexts2a.appendingPathExtension("txt")
                    let textDataTexts2a = text2a.data(using: .utf8)
                    try textDataTexts2a?.write(to: destinationIdeasTexts2a)
                    var destinationIdeasCosts2a = destinationIdeasCosts.appending(path: "inc2a")
                    destinationIdeasCosts2a = destinationIdeasCosts2a.appendingPathExtension("txt")
                    let textDataCosts2a = cost2a.data(using: .utf8)
                    try textDataCosts2a?.write(to: destinationIdeasCosts2a)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let text3a = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas tellus rutrum tellus pellentesque eu tincidunt. Vitae nunc sed velit dignissim sodales ut eu."
                    let cost3a = "24.00"
                    try incidentGig.appendIdea(text: text3a, cost: cost3a, toIncident: &IncidentGig.inc3)
                    var destinationIdeasTexts3a = destinationIdeasTexts.appending(path: "inc3a")
                    destinationIdeasTexts3a = destinationIdeasTexts3a.appendingPathExtension("txt")
                    let textDataTexts3a = text3a.data(using: .utf8)
                    try textDataTexts3a?.write(to: destinationIdeasTexts3a)
                    var destinationIdeasCosts3a = destinationIdeasCosts.appending(path: "inc3a")
                    destinationIdeasCosts3a = destinationIdeasCosts3a.appendingPathExtension("txt")
                    let textDataCosts3a = cost3a.data(using: .utf8)
                    try textDataCosts3a?.write(to: destinationIdeasCosts3a)
                    
                    let text3b = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                    let cost3b = "32.00"
                    try incidentGig.appendIdea(text: text3b, cost: cost3b, toIncident: &IncidentGig.inc3)
                    var destinationIdeasTexts3b = destinationIdeasTexts.appending(path: "inc3b")
                    destinationIdeasTexts3b = destinationIdeasTexts3b.appendingPathExtension("txt")
                    let textDataTexts3b = text3b.data(using: .utf8)
                    try textDataTexts3b?.write(to: destinationIdeasTexts3b)
                    var destinationIdeasCosts3b = destinationIdeasCosts.appending(path: "inc3b")
                    destinationIdeasCosts3b = destinationIdeasCosts3b.appendingPathExtension("txt")
                    let textDataCosts3b = cost3b.data(using: .utf8)
                    try textDataCosts3b?.write(to: destinationIdeasCosts3b)
                    
                    let text3c = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut lectus arcu bibendum at varius vel pharetra vel."
                    let cost3c = "40.00"
                    try incidentGig.appendIdea(text: text3c, cost: cost3c, toIncident: &IncidentGig.inc3)
                    var destinationIdeasTexts3c = destinationIdeasTexts.appending(path: "inc3c")
                    destinationIdeasTexts3c = destinationIdeasTexts3c.appendingPathExtension("txt")
                    let textDataTexts3c = text3c.data(using: .utf8)
                    try textDataTexts3c?.write(to: destinationIdeasTexts3c)
                    var destinationIdeasCosts3c = destinationIdeasCosts.appending(path: "inc3c")
                    destinationIdeasCosts3c = destinationIdeasCosts3c.appendingPathExtension("txt")
                    let textDataCosts3c = cost3c.data(using: .utf8)
                    try textDataCosts3c?.write(to: destinationIdeasCosts3c)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let text4a = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                    let cost4a = "32.00"
                    try incidentGig.appendIdea(text: text4a, cost: cost4a, toIncident: &IncidentGig.inc4)
                    var destinationIdeasTexts4a = destinationIdeasTexts.appending(path: "inc4a")
                    destinationIdeasTexts4a = destinationIdeasTexts4a.appendingPathExtension("txt")
                    let textDataTexts4a = text4a.data(using: .utf8)
                    try textDataTexts4a?.write(to: destinationIdeasTexts4a)
                    var destinationIdeasCosts4a = destinationIdeasCosts.appending(path: "inc4a")
                    destinationIdeasCosts4a = destinationIdeasCosts4a.appendingPathExtension("txt")
                    let textDataCosts4a = cost4a.data(using: .utf8)
                    try textDataCosts4a?.write(to: destinationIdeasCosts4a)
                    
                    let text4b = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed odio morbi quis commodo odio aenean sed adipiscing diam. Ultrices mi tempus imperdiet nulla."
                    let cost4b = "64.00"
                    try incidentGig.appendIdea(text: text4b, cost: cost4b, toIncident: &IncidentGig.inc4)
                    var destinationIdeasTexts4b = destinationIdeasTexts.appending(path: "inc4b")
                    destinationIdeasTexts4b = destinationIdeasTexts4b.appendingPathExtension("txt")
                    let textDataTexts4b = text4b.data(using: .utf8)
                    try textDataTexts4b?.write(to: destinationIdeasTexts4b)
                    var destinationIdeasCosts4b = destinationIdeasCosts.appending(path: "inc4b")
                    destinationIdeasCosts4b = destinationIdeasCosts4b.appendingPathExtension("txt")
                    let textDataCosts4b = cost4b.data(using: .utf8)
                    try textDataCosts4b?.write(to: destinationIdeasCosts4b)
                    
                    // \/\/\/\/\/\/\/
                    // \/\/\/\/ SNAPS
                    // \/\/\/\/\/\/\/
                    
                    let destinationSnaps = destination.appending(component: "snaps")
                    if !FileManager.default.fileExists(atPath: destinationSnaps.relativePath) {
                        try FileManager.default.createDirectory(at: destinationSnaps, withIntermediateDirectories: false)
                    }
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url0a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc0a.jpg")!
                    let urlRequest0a = URLRequest(url: url0a)
                    let (data0a, _ ) = try await URLSession.shared.data(for: urlRequest0a)
                    let uiImage0a = UIImage(data: data0a)!
                    try incidentGig.appendSnap(uiImage: uiImage0a, toIncident: &IncidentGig.inc0)
                    var destinationSnaps0a = destinationSnaps.appending(path: "inc0a")
                    destinationSnaps0a = destinationSnaps0a.appendingPathExtension("jpg")
                    try data0a.write(to: destinationSnaps0a)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url1a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1a.jpg")!
                    let urlRequest1a = URLRequest(url: url1a)
                    let (data1a, _ ) = try await URLSession.shared.data(for: urlRequest1a)
                    let uiImage1a = UIImage(data: data1a)!
                    try incidentGig.appendSnap(uiImage: uiImage1a, toIncident: &IncidentGig.inc1)
                    var destinationSnaps1a = destinationSnaps.appending(path: "inc1a")
                    destinationSnaps1a = destinationSnaps1a.appendingPathExtension("jpg")
                    try data1a.write(to: destinationSnaps1a)

//                    let url1b = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1b.jpg")!
//                    let urlRequest1b = URLRequest(url: url1b)
//                    let (data1b, _ ) = try await URLSession.shared.data(for: urlRequest1b)
//                    let uiImage1b = UIImage(data: data1b)!
//                    try incidentGig.appendSnap(uiImage: uiImage1b, toIncident: &IncidentGig.inc1)
//                    var destinationSnaps1b = destinationSnaps.appending(path: "inc1b")
//                    destinationSnaps1b = destinationSnaps1b.appendingPathExtension("jpg")
//                    try data1b.write(to: destinationSnaps1b)
//
//                    let url1c = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1c.jpg")!
//                    let urlRequest1c = URLRequest(url: url1c)
//                    let (data1c, _ ) = try await URLSession.shared.data(for: urlRequest1c)
//                    let uiImage1c = UIImage(data: data1c)!
//                    try incidentGig.appendSnap(uiImage: uiImage1c, toIncident: &IncidentGig.inc1)
//                    var destinationSnaps1c = destinationSnaps.appending(path: "inc1c")
//                    destinationSnaps1c = destinationSnaps1c.appendingPathExtension("jpg")
//                    try data1c.write(to: destinationSnaps1c)
                    
                    let url1d = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1d.jpg")!
                    let urlRequest1d = URLRequest(url: url1d)
                    let (data1d, _ ) = try await URLSession.shared.data(for: urlRequest1d)
                    let uiImage1d = UIImage(data: data1d)!
                    try incidentGig.appendSnap(uiImage: uiImage1d, toIncident: &IncidentGig.inc1)
                    var destinationSnaps1d = destinationSnaps.appending(path: "inc1d")
                    destinationSnaps1d = destinationSnaps1d.appendingPathExtension("jpg")
                    try data1d.write(to: destinationSnaps1d)

                    let url1e = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1e.jpg")!
                    let urlRequest1e = URLRequest(url: url1e)
                    let (data1e, _ ) = try await URLSession.shared.data(for: urlRequest1e)
                    let uiImage1e = UIImage(data: data1e)!
                    try incidentGig.appendSnap(uiImage: uiImage1e, toIncident: &IncidentGig.inc1)
                    var destinationSnaps1e = destinationSnaps.appending(path: "inc1e")
                    destinationSnaps1e = destinationSnaps1e.appendingPathExtension("jpg")
                    try data1e.write(to: destinationSnaps1e)

//                    let url1f = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1f.jpg")!
//                    let urlRequest1f = URLRequest(url: url1f)
//                    let (data1f, _ ) = try await URLSession.shared.data(for: urlRequest1f)
//                    let uiImage1f = UIImage(data: data1f)!
//                    try incidentGig.appendSnap(uiImage: uiImage1f, toIncident: &IncidentGig.inc1)
//                    var destinationSnaps1f = destinationSnaps.appending(path: "inc1f")
//                    destinationSnaps1f = destinationSnaps1f.appendingPathExtension("jpg")
//                    try data1f.write(to: destinationSnaps1f)
//
//                    let url1g = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1g.jpg")!
//                    let urlRequest1g = URLRequest(url: url1g)
//                    let (data1g, _ ) = try await URLSession.shared.data(for: urlRequest1g)
//                    let uiImage1g = UIImage(data: data1g)!
//                    try incidentGig.appendSnap(uiImage: uiImage1g, toIncident: &IncidentGig.inc1)
//                    var destinationSnaps1g = destinationSnaps.appending(path: "inc1g")
//                    destinationSnaps1g = destinationSnaps1g.appendingPathExtension("jpg")
//                    try data1g.write(to: destinationSnaps1g)

                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url2a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc2a.jpg")!
                    let urlRequest2a = URLRequest(url: url2a)
                    let (data2a, _ ) = try await URLSession.shared.data(for: urlRequest2a)
                    let uiImage2a = UIImage(data: data2a)!
                    try incidentGig.appendSnap(uiImage: uiImage2a, toIncident: &IncidentGig.inc2)
                    var destinationSnaps2a = destinationSnaps.appending(path: "inc2a")
                    destinationSnaps2a = destinationSnaps2a.appendingPathExtension("jpg")
                    try data2a.write(to: destinationSnaps2a)
                    
                    let url2b = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc2b.jpg")!
                    let urlRequest2b = URLRequest(url: url2b)
                    let (data2b, _ ) = try await URLSession.shared.data(for: urlRequest2b)
                    let uiImage2b = UIImage(data: data2b)!
                    try incidentGig.appendSnap(uiImage: uiImage2b, toIncident: &IncidentGig.inc2)
                    var destinationSnaps2b = destinationSnaps.appending(path: "inc2b")
                    destinationSnaps2b = destinationSnaps2b.appendingPathExtension("jpg")
                    try data2b.write(to: destinationSnaps2b)
                    
                    let url2c = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc2c.jpg")!
                    let urlRequest2c = URLRequest(url: url2c)
                    let (data2c, _ ) = try await URLSession.shared.data(for: urlRequest2c)
                    let uiImage2c = UIImage(data: data2c)!
                    try incidentGig.appendSnap(uiImage: uiImage2c, toIncident: &IncidentGig.inc2)
                    var destinationSnaps2c = destinationSnaps.appending(path: "inc2c")
                    destinationSnaps2c = destinationSnaps2c.appendingPathExtension("jpg")
                    try data2c.write(to: destinationSnaps2c)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url3a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc3a.jpg")!
                    let urlRequest3a = URLRequest(url: url3a)
                    let (data3a, _ ) = try await URLSession.shared.data(for: urlRequest3a)
                    let uiImage3a = UIImage(data: data3a)!
                    try incidentGig.appendSnap(uiImage: uiImage3a, toIncident: &IncidentGig.inc3)
                    var destinationSnaps3a = destinationSnaps.appending(path: "inc3a")
                    destinationSnaps3a = destinationSnaps3a.appendingPathExtension("jpg")
                    try data3a.write(to: destinationSnaps3a)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url4a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc4a.jpg")!
                    let urlRequest4a = URLRequest(url: url4a)
                    let (data4a, _ ) = try await URLSession.shared.data(for: urlRequest4a)
                    let uiImage4a = UIImage(data: data4a)!
                    try incidentGig.appendSnap(uiImage: uiImage4a, toIncident: &IncidentGig.inc4)
                    var destinationSnaps4a = destinationSnaps.appending(path: "inc4a")
                    destinationSnaps4a = destinationSnaps4a.appendingPathExtension("jpg")
                    try data4a.write(to: destinationSnaps4a)
                    
                    let url4b = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc4b.jpg")!
                    let urlRequest4b = URLRequest(url: url4b)
                    let (data4b, _ ) = try await URLSession.shared.data(for: urlRequest4b)
                    let uiImage4b = UIImage(data: data4b)!
                    try incidentGig.appendSnap(uiImage: uiImage4b, toIncident: &IncidentGig.inc4)
                    var destinationSnaps4b = destinationSnaps.appending(path: "inc4b")
                    destinationSnaps4b = destinationSnaps4b.appendingPathExtension("jpg")
                    try data4b.write(to: destinationSnaps4b)
                    
                    // \/\/\/\/\/\/\/
                    // \/\/\/\/ TAPES
                    // \/\/\/\/\/\/\/
                    
                    let destinationTapes = destination.appending(component: "tapes")
                    if !FileManager.default.fileExists(atPath: destinationTapes.relativePath) {
                        try FileManager.default.createDirectory(at: destinationTapes, withIntermediateDirectories: false)
                    }
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let tapeUrl0a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc0a.m4a")!
                    let tapeUrlRequest0a = URLRequest(url: tapeUrl0a)
                    let (tapeData0a, _ ) = try await URLSession.shared.data(for: tapeUrlRequest0a)
                    let tapeUUID0a = try incidentGig.writeTape(data: tapeData0a)
                    try incidentGig.appendTape(tapeId: tapeUUID0a, toIncident: &IncidentGig.inc0)
                    var destinationTapes0a = destinationTapes.appending(path: "inc0a")
                    destinationTapes0a = destinationTapes0a.appendingPathExtension("m4a")
                    try tapeData0a.write(to: destinationTapes0a)
                    
                    let tapeUrl0b = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc0b.m4a")!
                    let tapeUrlRequest0b = URLRequest(url: tapeUrl0b)
                    let (tapeData0b, _ ) = try await URLSession.shared.data(for: tapeUrlRequest0b)
                    let tapeUUID0b = try incidentGig.writeTape(data: tapeData0b)
                    try incidentGig.appendTape(tapeId: tapeUUID0b, toIncident: &IncidentGig.inc0)
                    var destinationTapes0b = destinationTapes.appending(path: "inc0b")
                    destinationTapes0b = destinationTapes0b.appendingPathExtension("m4a")
                    try tapeData0b.write(to: destinationTapes0b)
                    
                    let tapeUrl0c = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc0c.m4a")!
                    let tapeUrlRequest0c = URLRequest(url: tapeUrl0c)
                    let (tapeData0c, _ ) = try await URLSession.shared.data(for: tapeUrlRequest0c)
                    let tapeUUID0c = try incidentGig.writeTape(data: tapeData0c)
                    try incidentGig.appendTape(tapeId: tapeUUID0c, toIncident: &IncidentGig.inc0)
                    var destinationTapes0c = destinationTapes.appending(path: "inc0c")
                    destinationTapes0c = destinationTapes0c.appendingPathExtension("m4a")
                    try tapeData0c.write(to: destinationTapes0c)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let tapeUrl1a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1a.m4a")!
                    let tapeUrlRequest1a = URLRequest(url: tapeUrl1a)
                    let (tapeData1a, _ ) = try await URLSession.shared.data(for: tapeUrlRequest1a)
                    let tapeUUID1a = try incidentGig.writeTape(data: tapeData1a)
                    try incidentGig.appendTape(tapeId: tapeUUID1a, toIncident: &IncidentGig.inc1)
                    var destinationTapes1a = destinationTapes.appending(path: "inc1a")
                    destinationTapes1a = destinationTapes1a.appendingPathExtension("m4a")
                    try tapeData1a.write(to: destinationTapes1a)
                    
                    let tapeUrl1b = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1b.m4a")!
                    let tapeUrlRequest1b = URLRequest(url: tapeUrl1b)
                    let (tapeData1b, _ ) = try await URLSession.shared.data(for: tapeUrlRequest1b)
                    let tapeUUID1b = try incidentGig.writeTape(data: tapeData1b)
                    try incidentGig.appendTape(tapeId: tapeUUID1b, toIncident: &IncidentGig.inc1)
                    var destinationTapes1b = destinationTapes.appending(path: "inc1b")
                    destinationTapes1b = destinationTapes1b.appendingPathExtension("m4a")
                    try tapeData1b.write(to: destinationTapes1b)
                    
                    let tapeUrl1c = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1c.m4a")!
                    let tapeUrlRequest1c = URLRequest(url: tapeUrl1c)
                    let (tapeData1c, _ ) = try await URLSession.shared.data(for: tapeUrlRequest1c)
                    let tapeUUID1c = try incidentGig.writeTape(data: tapeData1c)
                    try incidentGig.appendTape(tapeId: tapeUUID1c, toIncident: &IncidentGig.inc1)
                    var destinationTapes1c = destinationTapes.appending(path: "inc1c")
                    destinationTapes1c = destinationTapes1c.appendingPathExtension("m4a")
                    try tapeData1c.write(to: destinationTapes1c)
                    
                    let tapeUrl1d = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc1d.m4a")!
                    let tapeUrlRequest1d = URLRequest(url: tapeUrl1d)
                    let (tapeData1d, _ ) = try await URLSession.shared.data(for: tapeUrlRequest1d)
                    let tapeUUID1d = try incidentGig.writeTape(data: tapeData1d)
                    try incidentGig.appendTape(tapeId: tapeUUID1d, toIncident: &IncidentGig.inc1)
                    var destinationTapes1d = destinationTapes.appending(path: "inc1d")
                    destinationTapes1d = destinationTapes1d.appendingPathExtension("m4a")
                    try tapeData1d.write(to: destinationTapes1d)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let tapeUrl2a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc2a.m4a")!
                    let tapeUrlRequest2a = URLRequest(url: tapeUrl2a)
                    let (tapeData2a, _ ) = try await URLSession.shared.data(for: tapeUrlRequest2a)
                    let tapeUUID2a = try incidentGig.writeTape(data: tapeData2a)
                    try incidentGig.appendTape(tapeId: tapeUUID2a, toIncident: &IncidentGig.inc2)
                    var destinationTapes2a = destinationTapes.appending(path: "inc2a")
                    destinationTapes2a = destinationTapes2a.appendingPathExtension("m4a")
                    try tapeData2a.write(to: destinationTapes2a)
                    
                    let tapeUrl2b = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc2b.m4a")!
                    let tapeUrlRequest2b = URLRequest(url: tapeUrl2b)
                    let (tapeData2b, _ ) = try await URLSession.shared.data(for: tapeUrlRequest2b)
                    let tapeUUID2b = try incidentGig.writeTape(data: tapeData2b)
                    try incidentGig.appendTape(tapeId: tapeUUID2b, toIncident: &IncidentGig.inc2)
                    var destinationTapes2b = destinationTapes.appending(path: "inc2b")
                    destinationTapes2b = destinationTapes2b.appendingPathExtension("m4a")
                    try tapeData2b.write(to: destinationTapes2b)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let tapeUrl3a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc3a.m4a")!
                    let tapeUrlRequest3a = URLRequest(url: tapeUrl3a)
                    let (tapeData3a, _ ) = try await URLSession.shared.data(for: tapeUrlRequest3a)
                    let tapeUUID3a = try incidentGig.writeTape(data: tapeData3a)
                    try incidentGig.appendTape(tapeId: tapeUUID3a, toIncident: &IncidentGig.inc3)
                    var destinationTapes3a = destinationTapes.appending(path: "inc3a")
                    destinationTapes3a = destinationTapes3a.appendingPathExtension("m4a")
                    try tapeData3a.write(to: destinationTapes3a)
                    
                    let tapeUrl3b = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc3b.m4a")!
                    let tapeUrlRequest3b = URLRequest(url: tapeUrl3b)
                    let (tapeData3b, _ ) = try await URLSession.shared.data(for: tapeUrlRequest3b)
                    let tapeUUID3b = try incidentGig.writeTape(data: tapeData3b)
                    try incidentGig.appendTape(tapeId: tapeUUID3b, toIncident: &IncidentGig.inc3)
                    var destinationTapes3b = destinationTapes.appending(path: "inc3b")
                    destinationTapes3b = destinationTapes3b.appendingPathExtension("m4a")
                    try tapeData3b.write(to: destinationTapes3b)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let tapeUrl4a = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc4a.m4a")!
                    let tapeUrlRequest4a = URLRequest(url: tapeUrl4a)
                    let (tapeData4a, _ ) = try await URLSession.shared.data(for: tapeUrlRequest4a)
                    let tapeUUID4a = try incidentGig.writeTape(data: tapeData4a)
                    try incidentGig.appendTape(tapeId: tapeUUID4a, toIncident: &IncidentGig.inc4)
                    var destinationTapes4a = destinationTapes.appending(path: "inc4a")
                    destinationTapes4a = destinationTapes4a.appendingPathExtension("m4a")
                    try tapeData4a.write(to: destinationTapes4a)
                    
                    let tapeUrl4b = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc4b.m4a")!
                    let tapeUrlRequest4b = URLRequest(url: tapeUrl4b)
                    let (tapeData4b, _ ) = try await URLSession.shared.data(for: tapeUrlRequest4b)
                    let tapeUUID4b = try incidentGig.writeTape(data: tapeData4b)
                    try incidentGig.appendTape(tapeId: tapeUUID4b, toIncident: &IncidentGig.inc4)
                    var destinationTapes4b = destinationTapes.appending(path: "inc4b")
                    destinationTapes4b = destinationTapes4b.appendingPathExtension("m4a")
                    try tapeData4b.write(to: destinationTapes4b)
                    
                    let tapeUrl4c = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/inc4c.m4a")!
                    let tapeUrlRequest4c = URLRequest(url: tapeUrl4c)
                    let (tapeData4c, _ ) = try await URLSession.shared.data(for: tapeUrlRequest4c)
                    let tapeUUID4c = try incidentGig.writeTape(data: tapeData4c)
                    try incidentGig.appendTape(tapeId: tapeUUID4c, toIncident: &IncidentGig.inc1)
                    var destinationTapes4c = destinationTapes.appending(path: "inc4c")
                    destinationTapes4c = destinationTapes4c.appendingPathExtension("m4a")
                    try tapeData4c.write(to: destinationTapes4c)
                   
                    // ~#~#~#~#~#~#~#~#
                    // CURRENT INCIDENT
                    // ~#~#~#~#~#~#~#~#
                    
                    try incidentGig.activate(incident: IncidentGig.inc1)
                    
                    incidentGig.initComplete = true
                    print("/>      FETCHED INCS")
                } catch _ {
//                     print(error.localizedDescription)
                    do {
                        
                        // ~#~#~#~#~#~#~#~#
                        // CURRENT INCIDENT
                        // ~#~#~#~#~#~#~#~#
                        
                        try incidentGig.activate(incident: IncidentGig.inc1)
                        
                        incidentGig.initComplete = true
                        print("/>   FALLBACKED INCS")
                    } catch _ {
                        // print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
    // [][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: VETERINARIANS
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
    
    func vetBootstrap() {
        print("/> BOOTSTRAPING VETS")
        do {
            veterinarianGig.veterinarians = []
            try veterinarianGig.create(veterianarian: VeterinarianGig.vet0)
            try veterinarianGig.create(veterianarian: VeterinarianGig.vet1)
            try veterinarianGig.create(veterianarian: VeterinarianGig.vet2)
            try veterinarianGig.create(veterianarian: VeterinarianGig.vet3)
        } catch let error {
            print(error.localizedDescription)
        }
        do {
            var origin = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            origin = origin.appending(component: "bootstrap")
            origin = origin.appending(component: "veterinarians")
            let _ = try FileManager.default.contentsOfDirectory(atPath: origin.relativePath)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var origin0 = origin.appending(path: "vet0")
            origin0 = origin0.appendingPathExtension("jpg")
            let uiImageData0 = try Data(contentsOf: origin0)
            let uiImage0 = UIImage(data: uiImageData0)!
            try veterinarianGig.set(uiImage: uiImage0, toVeterinarian: &VeterinarianGig.vet0)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var origin1 = origin.appending(path: "vet1")
            origin1 = origin1.appendingPathExtension("jpg")
            let uiImageData1 = try Data(contentsOf: origin1)
            let uiImage1 = UIImage(data: uiImageData1)!
            try veterinarianGig.set(uiImage: uiImage1, toVeterinarian: &VeterinarianGig.vet1)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var origin2 = origin.appending(path: "vet2")
            origin2 = origin2.appendingPathExtension("jpg")
            let uiImageData2 = try Data(contentsOf: origin2)
            let uiImage2 = UIImage(data: uiImageData2)!
            try veterinarianGig.set(uiImage: uiImage2, toVeterinarian: &VeterinarianGig.vet2)
            
            // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            var origin3 = origin.appending(path: "vet3")
            origin3 = origin3.appendingPathExtension("jpg")
            let uiImageData3 = try Data(contentsOf: origin3)
            let uiImage3 = UIImage(data: uiImageData3)!
            try veterinarianGig.set(uiImage: uiImage3, toVeterinarian: &VeterinarianGig.vet3)
            
            // ~#~#~#~#~#~
            // CURRENT VET
            // ~#~#~#~#~#~
            
            try veterinarianGig.activate(veterinarian: VeterinarianGig.vet2)
           
            try veterinarianGig.save()
            veterinarianGig.initComplete = true
            print("/>       LOADED VETS")
        } catch _ {
            // print(error.localizedDescription)
            Task {
                do {
                    
                    var destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    destination = destination.appending(component: "bootstrap")
                    if !FileManager.default.fileExists(atPath: destination.relativePath) {
                        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
                    }
                    destination = destination.appending(component: "veterinarians")
                    if !FileManager.default.fileExists(atPath: destination.relativePath) {
                        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: false)
                    }
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url0 = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/vet0.jpg")!
                    let urlRequest0 = URLRequest(url: url0)
                    let (data0, _ ) = try await URLSession.shared.data(for: urlRequest0)
                    let uiImage0 = UIImage(data: data0)!
                    try veterinarianGig.set(uiImage: uiImage0, toVeterinarian: &VeterinarianGig.vet0)
                    var destination0 = destination.appending(path: "vet0")
                    destination0 = destination0.appendingPathExtension("jpg")
                    try data0.write(to: destination0)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url1 = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/vet1.jpg")!
                    let urlRequest1 = URLRequest(url: url1)
                    let (data1, _ ) = try await URLSession.shared.data(for: urlRequest1)
                    let uiImage1 = UIImage(data: data1)!
                    try veterinarianGig.set(uiImage: uiImage1, toVeterinarian: &VeterinarianGig.vet1)
                    var destination1 = destination.appending(path: "vet1")
                    destination1 = destination1.appendingPathExtension("jpg")
                    try data1.write(to: destination1)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url2 = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/vet2.jpg")!
                    let urlRequest2 = URLRequest(url: url2)
                    let (data2, _ ) = try await URLSession.shared.data(for: urlRequest2)
                    let uiImage2 = UIImage(data: data2)!
                    try veterinarianGig.set(uiImage: uiImage2, toVeterinarian: &VeterinarianGig.vet2)
                    var destination2 = destination.appending(path: "vet2")
                    destination2 = destination2.appendingPathExtension("jpg")
                    try data2.write(to: destination2)
                    
                    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    
                    let url3 = URL(string: "https://nikos.web.runbox.net/bootcamp/capstone/vet3.jpg")!
                    let urlRequest3 = URLRequest(url: url3)
                    let (data3, _ ) = try await URLSession.shared.data(for: urlRequest3)
                    let uiImage3 = UIImage(data: data3)!
                    try veterinarianGig.set(uiImage: uiImage3, toVeterinarian: &VeterinarianGig.vet3)
                    var destination3 = destination.appending(path: "vet3")
                    destination3 = destination2.appendingPathExtension("jpg")
                    try data2.write(to: destination3)
                    
                    // ~#~#~#~#~#~
                    // CURRENT VET
                    // ~#~#~#~#~#~
                    
                    try veterinarianGig.activate(veterinarian: VeterinarianGig.vet2)
                    
                    veterinarianGig.initComplete = true
                    print("/>      FETCHED VETS")
                } catch _ {
                    // print(error.localizedDescription)
                    do {
                        
                        // ~#~#~#~#~#~
                        // CURRENT VET
                        // ~#~#~#~#~#~
                        
                        try veterinarianGig.activate(veterinarian: VeterinarianGig.vet2)

                        veterinarianGig.initComplete = true
                        print("/>   FALLBACKED VETS")
                    } catch _ {
                        // print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> MARK: SETUP
    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    
    func bootstrap() {
        // print("> EXCECUTING SETUP")
        patientGig.patients[0].guardianId = guardianGig.guardians[0].id
        patientGig.patients[1].guardianId = guardianGig.guardians[1].id
        patientGig.patients[2].guardianId = guardianGig.guardians[2].id
        incidentGig.incidents[0].patientId = patientGig.patients[0].id
        incidentGig.incidents[1].patientId = patientGig.patients[1].id
        incidentGig.incidents[2].patientId = patientGig.patients[2].id
        veterinarianGig.veterinarians[0].incidentIds = [
            incidentGig.incidents[0].id,
            incidentGig.incidents[1].id
        ]
        veterinarianGig.veterinarians[1].incidentIds = [
            incidentGig.incidents[1].id,
            incidentGig.incidents[2].id
        ]
        veterinarianGig.veterinarians[2].incidentIds = [
            incidentGig.incidents[2].id,
            incidentGig.incidents[0].id
        ]
        do {
            try guardianGig.save()
            try patientGig.save()
            try incidentGig.save()
            try veterinarianGig.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}


// ############################################################################
// ############################################################################
// ############################################################################

//struct Bootstrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        Bootstrapper()
//            .environmentObject(GuardianGig())
//            .environmentObject(PatientGig())
//            .environmentObject(IncidentGig())
//            .environmentObject(VeterinarianGig())
//    }
//}
