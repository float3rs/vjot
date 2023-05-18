//
//  IncidentHomeView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 25/4/23.
//

import SwiftUI

struct IncidentHomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var router: Router
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var incidentGig: IncidentGig
    @EnvironmentObject var patientGig: PatientGig
    
    @State private var goCreate: Bool = false
    @State private var goneIncident: Incident? = nil
    
    @State var date: Date = Date()
    @State var goDate: Bool = false
    @State var vetId: UUID
    @State var goVet: Bool = false
    
    
    @State var goPatients: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    var body: some View {
        ZStack {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            if incidentGig.incidents.isEmpty {
                
                NavigationLink {
                    JotterView()
                } label: {
                    VStack {
                        // ()()()()()()()
                        // SPACER )()()()
                        // ()()()()()()()
                        
                        Spacer()
                        
                        Image("box")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.secondary)
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        VStack(spacing: -5) {
                            Text("NO MEDICAL INCIDENTS")
                            Text("YET OCCURRED")
                        }
                        .foregroundColor(Color.secondary)
                        
                        
                        // ()()()()()()()
                        // SPACER )()()()
                        // ()()()()()()()
                        
                        Spacer()
                    }
                }
                
            } else {
                
                VStack {
                    VStack(spacing: 2) {
                        
                        // \/\/\/\/\/
                        // 24H BUTTON
                        // \/\/\/\/\/
                        
                        HStack(spacing: 5) {
                            Spacer()
                            // [-][-][-][-][-][-][-][-][-][-]
                            // IF GODATE == TRUE [-][-][-][-]
                            // DISPLAY 24H INCIDENTS -][-][-]
                            // [-][-][-][-][-][-][-][-][-][-]
                            
                            if goDate {
                                DatePicker(selection: $date, displayedComponents: [.date]) {}
                            }
                            
                            Button {
                                goDate.toggle()
                            } label: {
                                Image(systemName: "calendar")
                                    .foregroundColor(goDate ? Color.green : Color.primary)
                                    .font(.title3)
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        // \/\/\/\/\/
                        // VET BUTTON
                        // \/\/\/\/\/
                        
                        if veterinarianGig.track(currentId: vetId) != nil {
                            HStack(spacing: 5) {
                                Spacer()
                                // [-][-][-][-][-][-][-][-][-][-]
                                // IF GODATE == TRUE [-][-][-][-]
                                // DISPLAY 24H INCIDENTS -][-][-]
                                // [-][-][-][-][-][-][-][-][-][-]
                                
                                if goVet {
                                    Picker("veterinarian", selection: $vetId) {
                                        ForEach(veterinarianGig.veterinarians) { vet in
                                            Text(vet.name).tag(vet.id)
                                        }
                                    }
                                    .buttonStyle(.bordered)
                                }
                                
                                Button {
                                    goVet.toggle()
                                } label: {
                                    Image(systemName: "stethoscope")
                                        .foregroundColor(goVet ? Color.green : Color.primary)
                                        .font(.subheadline)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .padding()
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: LIST
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    
                    // UGLY WORKAROUND HACK TO FIX CONTENT BACKGROUND BUG
                    // CONTENT BACKFOUND IS VISIBLE WHEN NO INCIDENTS :(
                    
                    if !produceResults().isEmpty {
                        List {
                            ForEach(produceResults()) {incident in
                                NavigationLink(value: incident) {
                                    if let currentInc = incidentGig.track(currentId: incident.id) {
                                        if incident.id == incidentGig.currentId {
                                            
                                            // <|><|><|><|><|><
                                            // ACTIVE INC ><|><
                                            // <|><|><|><|><|><
                                            
                                            HStack {
                                                Image(systemName: currentInc.emergency ? "exclamationmark.triangle.fill" : "cross.fill")
                                                    .foregroundColor(currentInc.emergency ? Color.red : Color.accentColor)
                                                Spacer()
                                                // VStack(alignment: .trailing, spacing: 0) {
                                                VStack(alignment: .trailing, spacing: -4) {
                                                    Text(incident.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                                        .foregroundColor(Color.accentColor)
//                                                        .monospaced()
//                                                        .kerning(-1)
//                                                        .fontWeight(.ultraLight)
                                                    // VStack(alignment: .trailing, spacing: -4) {
                                                    HStack(alignment: .center, spacing: 0) {
                                                        if !incident.description.isEmpty {
                                                            Text(incident.description.uppercased())
                                                                .font(.caption2)
                                                                .foregroundColor(Color.accentColor)
                                                            if let cost = calculateCost(incident: incident) {
                                                                Text(" (\(cost))")
                                                                    .font(.caption2)
                                                                    .foregroundColor(Color.accentColor)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        } else {
                                            
                                            // <|><|><|><|><|><
                                            // INACTIVE INCS ><
                                            // <|><|><|><|><|><
                                            
                                            HStack {
                                                Image(systemName: currentInc.emergency ? "exclamationmark.triangle.fill" : "cross")
                                                    .foregroundColor(currentInc.emergency ? Color.red : Color.primary)
                                                Spacer()
                                                // VStack(alignment: .trailing, spacing: 0) {
                                                VStack(alignment: .trailing, spacing: -4) {
                                                    Text(incident.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                                        .foregroundColor(Color.primary)
//                                                        .monospaced()
//                                                        .kerning(-1)
//                                                        .fontWeight(.ultraLight)
                                                    // VStack(alignment: .trailing, spacing: -4) {
                                                    HStack(alignment: .center, spacing: 0) {
                                                        if !incident.description.isEmpty {
                                                            Text(incident.description.uppercased())
                                                                .font(.caption2)
                                                                .foregroundColor(Color.secondary)
                                                            if let cost = calculateCost(incident: incident) {
                                                                Text(" (\(cost))")
                                                                    .font(.caption2)
                                                                    .foregroundColor(Color.secondary)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                    } else {
                                        
                                        // <|><|><|><|><|><
                                        // INACTIVE INCS ><
                                        // <|><|><|><|><|><
                                        
                                        HStack {
                                            Image(systemName: incident.emergency ? "exclamationmark.triangle.fill" : "cross")
                                                .foregroundColor(incident.emergency ? Color.red : Color.primary)
                                            Spacer()
                                            // VStack(alignment: .trailing, spacing: 0) {
                                            VStack(alignment: .trailing, spacing: -4) {
                                                Text(incident.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                                    .foregroundColor(Color.primary)
//                                                    .monospaced()
//                                                    .kerning(-1)
//                                                    .fontWeight(.ultraLight)
                                                // VStack(alignment: .trailing, spacing: -4) {
                                                HStack(alignment: .center, spacing: 0) {
                                                    if !incident.description.isEmpty {
                                                        Text(incident.description.uppercased())
                                                            .font(.caption2)
                                                            .foregroundColor(Color.secondary)
                                                        if let cost = calculateCost(incident: incident) {
                                                            Text(" (\(cost))")
                                                                .font(.caption2)
                                                                .foregroundColor(Color.secondary)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                // LIST MODIFIERS |||||||||||||||||||||||||||||||||||||
                                // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                // {-}{-}{-}{-}{-}{-}{-}{
                                // SWIPES -}{-}{-}{-}{-}{
                                // {-}{-}{-}{-}{-}{-}{-}{
                                // -> ///////////////////
                                
                                
                                .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                                    Button {
                                        do {
                                            try incidentGig.activate(incident: incident)
                                        } catch let error {
                                            print(error.localizedDescription)
                                            // VJotError ////////////////////////////////
                                            vjotError = VJotError.error(error)
                                            vjotErrorThrown.toggle()
                                        }
                                    } label: {
                                        Label("ACTIVATE", systemImage: "checkmark")
                                    }
                                    .tint(Color.accentColor)
                                    
                                    Button(action: {
                                        goPatients = true
                                        goneIncident = incident
                                    }, label: {
                                        Label("UPDATE", systemImage: "stethoscope")
                                    })
                                    .tint(Color.green)
                                })
                                
                                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: PATIENTS
                                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                                
                                .sheet(isPresented: $goPatients) {
                                    JotterPatientView(goPatient: $goPatients, incident: $goneIncident)
                                    
                                }
                            }
                            
                            // {-}{-}{-}{-}{-}{
                            // DELETE -}{-}{-}{
                            // {-}{-}{-}{-}{-}{
                            // <- /////////////
                            
                            .onDelete { indexSet in
                                do {
                                    try incidentGig.delete(atOffsets: indexSet)
                                } catch let error {
                                    print(error.localizedDescription)
                                    // VJotError ////////////////////////////////
                                    vjotError = VJotError.error(error)
                                    vjotErrorThrown.toggle()
                                }
                            }
                        }
                        
                        // {-}{-}{-}{-}{-}{
                        // BACKGROUND -}{-}
                        // {-}{-}{-}{-}{-}{
                        
                        .scrollContentBackground(.hidden)
                    } else {
                        Color.clear
                    }
                    
                    
                    // ------------------------------------------------------------
                    // FOOTER /////////////////////////////////////////////////////
                    // ------------------------------------------------------------
                    
                    VStack(alignment: .center) {
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        // [*][*][*][*][*][*][*][*][*][*][*][*][ MARK: INSTRUCTIONS
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        
                        
                        InstructionsIncFooterView()
                        Divider()
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: STATUS
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                        
                        switch incidentGig.currentId {
                            
                            // ::::::::::::::::::::::
                            // NOONE CURRENT ::::::::
                            // ::::::::::::::::::::::
                            
                        case nil:
                            HStack {
                                Spacer()
                                Rectangle()
                                    .foregroundColor(
                                        Color(uiColor: UIColor.systemBackground)
                                    )
                                    .aspectRatio(
                                        32/9,
                                        contentMode: .fit
                                    )
                                    .overlay {
                                        Image("stethoscope!")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(Color.red)
                                            .scaledToFill()
                                            .clipped()
                                            .scaleEffect(0.2)
                                        
                                    }
                                    .clipShape(Rectangle())
                                Spacer()
                            }
                            .padding(.vertical, -2.5)
                            
                            // ::::::::::::::::::::::
                            // ANYONE CURRENT :::::::
                            // ::::::::::::::::::::::
                            
                        default:
                            VStack(spacing: -5) {
                                Text("current incident:")
                                if let currentId = incidentGig.currentId {
                                    if let currentInc = incidentGig.track(currentId: currentId) {
                                        VStack(spacing: -8) {
                                            Text(currentInc.date.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                                .foregroundColor(Color.accentColor)
//                                            if !currentInc.description.isEmpty {
//                                                Text(currentInc.description)
//                                                    .foregroundColor(Color.accentColor)
//                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        
        // ----------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////
        // ----------------------------------------------------------------
        // ~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§
        // ~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~ MARK: NAVIGATION
        // ~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§~§
        
//        .navigationTitle("cases")
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(false)
        .navigationSplitViewStyle(.automatic)
        .navigationDestination(for: Incident.self) { incident in
            JotterView(function: .update, incident: incident)
        }
        
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/ MARK: TOOLBAR
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                NavigationLink {
                    JotterView(function: .create, incident: nil)
                } label: {
                    Label("CREATE", systemImage: "plus")
                }
            }
        }
        
        // \/\/\/\/\/\/\/\/\/\/\/\/
        // IF NO USER AVAILABLE \/\
        // \/\/\/\/\/\/\/\/\/\/\/\/
        
        .onAppear {
            if incidentGig.incidents == [] { goCreate = true }
        }
        
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: BACKGROUND
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        
        .background {
            if let currentId = incidentGig.currentId {
                if let currentInc = incidentGig.track(currentId: currentId) {
                    if !currentInc.snaps.isEmpty {
                        AsyncImage(url: incidentGig.find(snapId: currentInc.snaps[0].id)) { phase in
                            switch phase {
                                
                                // ------------
                                // EMPTY //////
                                // ------------
                                
                            case .empty:
                                EmptyView()
                                
                                // ------------
                                // SUCCESS ////
                                // ------------
                                
                            case .success(let returnedImage):
                                returnedImage
                                    .resizable()
                                    .overlay(.thinMaterial)
                                    .aspectRatio(contentMode: .fill)
                                    .brightness(colorScheme == .light ? 0.1 : -0.1)
                                
                                // ------------
                                // FAILURE ////
                                // ------------
                                
                            case .failure:
                                Color.clear
                                
                                // ------------
                                // DEFAULT ////
                                // ------------
                                
                            default:
                                fatalError()
                            }
                        }
                    }
                }
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
    
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    // [][][][][][][][][][][][][][][][][][][][][][] MARK: COMBINING FILTERS
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    
    func produceResults() -> [Incident] {
        
        let totalIncidents = incidentGig.incidents
        var filteredIncidents: [Incident] = []
        
        // --------------------------------------------------------------------
        
        if goDate && !goVet {
            
            filteredIncidents = totalIncidents.filter({(date.addingTimeInterval(-43200)...date.addingTimeInterval(43200)).contains($0.date)})
            return filteredIncidents
        }
        
        // --------------------------------------------------------------------
        
        if !goDate && goVet {
            
//            if let vetId {
                if let vet = veterinarianGig.track(currentId: vetId) {
                    vet.incidentIds.forEach { incidentId in
                        if let trackedIncident = incidentGig.track(currentId: incidentId) {
                            filteredIncidents.append(trackedIncident)
                        }
                    }
                    return filteredIncidents
                }
//            }
        }
        
        // --------------------------------------------------------------------
        
        if goDate && goVet {
            
            filteredIncidents = totalIncidents
            
//            if let vetId {
                if let vet = veterinarianGig.track(currentId: vetId) {
                    filteredIncidents = []
                    vet.incidentIds.forEach { incidentId in
                        if let trackedIncident = incidentGig.track(currentId: incidentId) {
                            filteredIncidents.append(trackedIncident)
                        }
                    }
//                }
            }
            
            filteredIncidents = filteredIncidents.filter({(date.addingTimeInterval(-43200)...date.addingTimeInterval(43200)).contains($0.date)})
            
            return filteredIncidents
        }
        
        // --------------------------------------------------------------------
        
        return totalIncidents
                                         
    }
    
    // {-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-
    // USE COST TYPE COMFORTING TO PROTOCOL CURRENCY FORMATTABLE -}{-
    // TO PROUCE CURRENCY STRING }{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-
    // {-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-}{-
    
    func calculateCost(incident: Incident) -> String? {
        var costSum = Decimal()
        
        incident.ideas.forEach { idea in
            if let costString = incidentGig.find(ideaId: idea.id).1 {
                let dec = Decimal(string: costString, locale: .current)
                costSum += dec ?? 0
            }
        }
        if costSum == 0 {
            return nil
        } else {
             let cost = Cost(costSum)
             return cost.string
//            let cost = "\(costSum)€‎"
//            return cost
        }
    }
}
