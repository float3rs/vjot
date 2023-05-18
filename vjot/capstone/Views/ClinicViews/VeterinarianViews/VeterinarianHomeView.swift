//
//  VeterinarianHomeView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 8/4/23.
//

import SwiftUI

struct VeterinarianHomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var router: Router
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @State private var goOnboard: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ZStack {
            
            if veterinarianGig.veterinarians.isEmpty {
                
                VStack {
                    
                    // ()()()()()()()
                    // SPACER )()()()
                    // ()()()()()()()
                    
                    Spacer()
                    
                    Image("hammock")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.secondary)
                        .frame(width: 100, height: 100)
                        .scaleEffect(2.5)
                        .padding()
                        .onTapGesture {
                            goOnboard.toggle()
                        }
                    
                    VStack(spacing: -5) {
                        Text("NO VETERINARIANS")
                        Text("YET ONBOARD")
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
                        ForEach(veterinarianGig.search()) { veterinarian in
                            NavigationLink(value: veterinarian) {
                                if veterinarian.id == veterinarianGig.currentId {
                                    
                                    // <|><|><|><|><|><
                                    // ACTIVE VET ><|><
                                    // <|><|><|><|><|><
                                    
                                    
                                    Image(systemName: "person.fill.checkmark")
                                        .foregroundColor(Color.accentColor)
                                    Text(veterinarian.name)
                                        .foregroundColor(Color.accentColor)
                                        .padding(.horizontal)
                                } else {
                                    
                                    // <|><|><|><|><|><
                                    // INACTIVE VETS ><
                                    // <|><|><|><|><|><
                                    
                                    Image(systemName: "person.fill.xmark")
                                        .foregroundColor(Color.primary)
                                    Text(veterinarian.name)
                                        .foregroundColor(Color.primary)
                                        .padding(.horizontal)
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
                                        try veterinarianGig.activate(veterinarian: veterinarian)
                                    } catch let error {
                                        print(error.localizedDescription)
                                        // VJotError ////////////////////////////////
                                        vjotError = VJotError.error(error)
                                        vjotErrorThrown.toggle()
                                    }
                                } label: {
                                    Label("activate", systemImage: "person.fill.checkmark")
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
                                try veterinarianGig.delete(atOffsets: indexSet)
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
                    
                    .searchable(text: $veterinarianGig.searchTerm)
                    
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
                        
                        
                        InstructionsVetFooterView()
                        Divider()
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: STATUS
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                        
                        switch veterinarianGig.currentId {
                            
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
                                        64/9,
                                        contentMode: .fit
                                    )
                                    .overlay {
                                        Image("hammock")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(Color.red)
                                            .scaledToFill()
                                            .clipped()
                                            .scaleEffect(0.5)
                                        
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
                                Text("current user:")
                                if let currentId = veterinarianGig.currentId {
                                    if let currentVet = veterinarianGig.track(currentId: currentId) {
                                        Text(currentVet.name)
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
        
//        .navigationTitle("vets")
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(false)
        .navigationSplitViewStyle(.automatic)
        .navigationDestination(for: Veterinarian.self) { veterinarian in
            VeterinarianAccountView(veterinarian: veterinarian)
        }
        
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/ MARK: TOOLBAR
        // {/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{/}{
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                Button {
                    goOnboard.toggle()
                } label: {
                    Label("ONBOARD", systemImage: "plus")
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: OBOARDING
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
        
        .sheet(isPresented: $goOnboard) {
            VeterinarianOnboardingView(onboardingIsPresented: $goOnboard)
        }
        
        // \/\/\/\/\/\/\/\/\/\/\/\/
        // IF NO USER AVAILABLE \/\
        // \/\/\/\/\/\/\/\/\/\/\/\/
        
//        .onAppear {
//            if veterinarianGig.veterinarians == [] { goOnboard = true }
//        }
        
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: BACKGROUND
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        
        .background {
            if !veterinarianGig.search().isEmpty {
                
                // UGLY WORKAROUND HACK TO FIX CONTENT BACKGROUND BUG
                // CONTENT BACKFOUND IS VISIBLE WHEN NO VETERINARIANS :(
                
                if let currentId = veterinarianGig.currentId {
                    if let currentVet = veterinarianGig.track(currentId: currentId) {
                        if let imageId = currentVet.imageId {
                            AsyncImage(url: veterinarianGig.find(imageId: imageId)) { phase in
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
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct VeterinarianHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            VeterinarianHomeView()
//                .environmentObject(VeterinarianGig())
//        }
//    }
//}
