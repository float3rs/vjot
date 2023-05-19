//
//  JotterPatientView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 28/4/23.
//

import SwiftUI

struct JotterPatientView: View {
    
    @EnvironmentObject var incidentGig: IncidentGig
    @EnvironmentObject var patientGig: PatientGig
    
    @Binding var goPatient: Bool
    @Binding var incident: Incident?
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                // \/\/\/\/\/\/
                // TITLE \/\/\/
                // \/\/\/\/\/\/
                
                VStack(spacing: -10) {
                    Text("associate")
                        .foregroundColor(Color.secondary)
                    Text("patient")
                        .foregroundColor(Color.primary)
                }
                .font(.title)
                
                if patientGig.patients.isEmpty {
                    
                    VStack {
                        // ()()()()()()()
                        // SPACER )()()()
                        // ()()()()()()()
                        
                        Spacer()
                        
                        Image("ball")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.secondary)
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        VStack(spacing: -5) {
                            Text("NO COMPANION ANIMALS")
                            Text("DESIGNATED YET")
                        }
                        .foregroundColor(Color.secondary)
                        
                        
                        // ()()()()()()()
                        // SPACER )()()()
                        // ()()()()()()()
                        
                        Spacer()
                    }
                    
                } else {
                    
                    List {
                        ForEach(patientGig.patients) {patient in
                            
                            // [][][][][][][]
                            // ROW [][][][][]
                            // [][][][][][][]
                            
                            VStack {
                                
                                if let incident {
                                    if let patientId = incident.patientId {
                                        HStack {
                                            Image(systemName: "pawprint.circle")
                                            Text(patientGig.designate(patient: patient))
                                                .padding(.horizontal)
                                        }
                                        .foregroundColor(patientId == patient.id ? Color.accentColor : Color.secondary)
                                    } else {
                                        HStack {
                                            Image(systemName: "pawprint.circle")
                                            Text(patientGig.designate(patient: patient))
                                                .padding(.horizontal)
                                        }
                                        .foregroundColor(Color.primary)
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: "pawprint.circle.fill")
                                        Text(patientGig.designate(patient: patient))
                                            .padding(.horizontal)
                                    }
                                    .foregroundColor(Color.primary)
                                }
                            }
                            
                            // [][][][][][][]
                            // SWIPE <- ][][]
                            // [][][][][][][]
                            
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    incident?.patientId = patient.id
                                    do {
                                        if incident != nil {
                                            try incidentGig.update(incident: incident!)
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                        // VJotError ////////////////////////////////
                                        vjotError = VJotError.error(error)
                                        vjotErrorThrown.toggle()
                                    }
                                } label: {
                                    Image(systemName: "cross.case")
                                }
                                .tint(Color.accentColor)
                            }
                            
                            // [][][][][][][]
                            // SWIPE -> ][][]
                            // [][][][][][][]
                            
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    incident?.patientId = nil
                                    do {
                                        if incident != nil {
                                            try incidentGig.update(incident: incident!)
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                        // VJotError ////////////////////////////////
                                        vjotError = VJotError.error(error)
                                        vjotErrorThrown.toggle()
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .tint(Color.red)
                            }
                        }
                    }
                }
                
                // \/\/\/\/\/\/
                // SPACER /\/\/
                // \/\/\/\/\/\/
                
                Spacer()
                
                // \/\/\/\/\/\/
                // FOOTER /\/\/
                // \/\/\/\/\/\/
                
                if let incident {
                    VStack(spacing: 0) {
                        Text("FOR INCIDENT")
                            .foregroundColor(Color.accentColor)
                            .font(.caption)
                        VStack(spacing: -8) {
                            Text(incident.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                .foregroundColor(Color.primary)
                                .kerning(-1)
                                .fontWeight(.regular)
                                .font(.body)
                            Text(incident.description)
                                .foregroundColor(Color.secondary)
                                .font(.title2)
                                .fontWeight(.light)
                        }
                    }
                    .padding()
                }
            }
            
            // <|><|><|><|><|><|><|><|>
            // DISMISS BUTTON <|><|><|>
            // <|><|><|><|><|><|><|><|>
            
            VStack {
                HStack {
                    
                    // {-}{-}{-}{-}{-}{
                    // HSPACER }{-}{-}{
                    // {-}{-}{-}{-}{-}{
                    
                    Spacer()
                    
                    // {-}{-}{-}{-}{-}{
                    // BUTTON -}{-}{-}{
                    // {-}{-}{-}{-}{-}{
                    
                    Button {
                        goPatient.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .padding()
                    }
                }
                
                // {-}{-}{-}{
                // VSPACER }{
                // {-}{-}{-}{
                
                Spacer()
            }
        }
        
        // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
        // [][][][][][][][][][][][][][][][][][][][][][][][][] MARK: ERROR ALERT
        // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
        
        .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            if let failureReason = error.failureReason {
                Text(failureReason)
            }
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct JotterPatientView_Previews: PreviewProvider {
//    static var previews: some View {
//        JotterPatientView()
//    }
//}
