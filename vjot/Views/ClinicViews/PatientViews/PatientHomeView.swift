//
//  PatientHomeView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 27/4/23.
//

import SwiftUI

struct PatientHomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var router: Router
    @EnvironmentObject var patientGig: PatientGig
    
    @State private var goCreate: Bool = false
    @State private var goUpdate: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ZStack {
            
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
                        .onTapGesture {
                            goCreate.toggle()
                        }
                    
                    VStack(spacing: -5) {
                        Text("NO COMPANION ANIMALS")
                        Text("YET DESIGNATED")
                    }
                    .foregroundColor(Color.secondary)
                    
                    
                    // ()()()()()()()
                    // SPACER )()()()
                    // ()()()()()()()
                    
                    Spacer()
                }
                
            } else {
                
                // ----------------------------------------------------------------
                // CONTENT ////////////////////////////////////////////////////////
                // ----------------------------------------------------------------
                
                VStack {
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: LIST
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    
                    List {
                        ForEach(patientGig.search()) { patient in
                            HStack {
                                if patient.id == patientGig.currentId {
                                    
                                    // <|><|><|><|><|><
                                    // ACTIVE VET ><|><
                                    // <|><|><|><|><|><
                                    
                                    NavigationLink {
                                        PatientUpdateView(patient: patient, goUpdate: Binding.constant(true))
                                    } label: {
                                        Image(systemName: "pawprint.circle.fill")
                                            .foregroundColor(Color.accentColor)
                                        if let name = patient.passport.descriptionOfAnimal.name {
                                            Text(name)
                                                .foregroundColor(Color.accentColor)
                                                .padding(.horizontal)
                                        } else {
                                            Spacer()
                                            Text(String(patient.id.uuidString.suffix(12)))
                                                .foregroundColor(Color.accentColor)
                                                .padding(.horizontal)
                                        }
                                    }
                                    
                                } else {
                                    
                                    // <|><|><|><|><|><
                                    // INACTIVE VETS ><
                                    // <|><|><|><|><|><
                                    
                                    NavigationLink {
                                        PatientUpdateView(patient: patient, goUpdate: Binding.constant(true))
                                    } label: {
                                        Image(systemName: "pawprint.circle")
                                            .foregroundColor(Color.primary)
                                        Text(patientGig.designate(patient: patient))
                                            .foregroundColor(Color.primary)
                                            .padding(.horizontal)
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
                            
                            
                            .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                Button {
                                    do {
                                        try patientGig.activate(patient: patient)
                                    } catch let error {
                                        print(error.localizedDescription)
                                        // VJotError ////////////////////////////////
                                        vjotError = VJotError.error(error)
                                        vjotErrorThrown.toggle()
                                    }
                                } label: {
                                    Label("ACTIVATE", systemImage: "pawprint.circle.fill")
                                }
                                .tint(Color.accentColor)
                            })
                        }
                        
                        // {-}{-}{-}{-}{-}{
                        // DELETE -}{-}{-}{
                        // {-}{-}{-}{-}{-}{
                        // <- /////////////
                        
                        .onDelete { indexSet in
                            do {
                                try patientGig.delete(atOffsets: indexSet)
                            } catch let error {
                                print(error.localizedDescription)
                                // VJotError ////////////////////////////////
                                vjotError = VJotError.error(error)
                                vjotErrorThrown.toggle()
                            }
                        }
                    }
                    
                    // {-}{-}{-}{-}{-}{-}{-}{-}
                    // SEARCHABLE }{-}{-}{-}{-}
                    // {-}{-}{-}{-}{-}{-}{-}{-}
                    
                    .searchable(
                        text: $patientGig.searchTerm,
                        prompt: "Search by Id"
                    )
                    
                    // {-}{-}{-}{-}{-}{
                    // BACKGROUND -}{-}
                    // {-}{-}{-}{-}{-}{
                    
                    .scrollContentBackground(.hidden)
                    
                    // ------------------------------------------------------------
                    // FOOTER /////////////////////////////////////////////////////
                    // ------------------------------------------------------------
                    
                    VStack(alignment: .center) {
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        // [*][*][*][*][*][*][*][*][*][*][*][*][ MARK: INSTRUCTIONS
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        
                        InstructionsPatFooterView()
                        Divider()
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: STATUS
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                        
                        switch patientGig.currentId {
                            
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
                                        Image("ball")
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
                                Text("current patient:")
                                if let currentId = patientGig.currentId {
                                    if let currentPat = patientGig.track(currentId: currentId) {
                                        Text(patientGig.designate(patient: currentPat))
                                            .foregroundColor(Color.accentColor)
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
        
//        .navigationTitle("pets")
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(false)
        .navigationSplitViewStyle(.automatic)
        
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/ MARK: TOOLBAR
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                Button {
                    goCreate.toggle()
                } label: {
                    Label("ONBOARD", systemImage: "plus")
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: OBOARDING
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
        
        .sheet(isPresented: $goCreate) {
            PatientCreateView(goCreate: $goCreate)
        }
        
        // \/\/\/\/\/\/\/\/\/\/\/\/
        // IF NO USER AVAILABLE \/\
        // \/\/\/\/\/\/\/\/\/\/\/\/
        
//        .onAppear {
//            if patientGig.patients == [] { goCreate = true }
//        }
        
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: BACKGROUND
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        
        .background {
            if !patientGig.search().isEmpty {
                
                // UGLY WORKAROUND HACK TO FIX CONTENT BACKGROUND BUG
                // CONTENT BACKFOUND IS VISIBLE WHEN NO PATIENTS :(
                
                if let currentId = patientGig.currentId {
                    if let currentPat = patientGig.track(currentId: currentId) {
                        if let imageId = currentPat.passport.descriptionOfAnimal.pictureId {
                            AsyncImage(url: patientGig.find(imageId: imageId)) { phase in
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
    
    func produceIdentifier(patient: Patient) -> String {
        if let name = patient.passport.descriptionOfAnimal.name { return name }
        return String()
    }
}


// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct PatientHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientHomeView()
//    }
//}

