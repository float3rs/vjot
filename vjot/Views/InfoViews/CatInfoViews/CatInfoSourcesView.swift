//
//  CatInfoSourcesView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct CatInfoSourcesView: View {
    
    @EnvironmentObject var sourcesEngine: SourcesEngine
    @EnvironmentObject var router: Router
    
    @State var sources: [CatAPISource] = []
    @State var noSources: Bool = false
    @State var loaded: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        
        // --------------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        ZStack {
            if noSources {
                
                // :::::::::::::
                // IF NO SOURCES
                // :::::::::::::
                
                SourcesFallbackView(forSpecies: .forCats)
                
            } else {
                
                // :::::::::::::
                // IF OK SOURCES
                // :::::::::::::
                
                if !loaded {
                    
                    // -?-?-?-?-?-?-?-?-?-?-?-?
                    // LOADING TAKES A WHILE -?
                    // -?-?-?-?-?-?-?-?-?-?-?-?
                    
                    if !loaded {
                        Image("catFunny")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.secondary)
                            .frame(maxWidth: 200, maxHeight: 200)
                    }
                    
                } else {
                    ScrollView {
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: TITLE
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        
                        VStack(spacing: -10) {
                            Text("cat")
                                .foregroundColor(Color.secondary)
                            Text("sources")
                                .foregroundColor(Color.primary)
                        }
                        .font(.title)
                        .padding()
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: LIST
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        
                        
                        VStack(alignment: .vjotSourcesH) {
                            
                            // #|#|#|#|
                            // LOOP  #|
                            // #|#|#|#|
                            
                            ForEach(sources, id: \.id) { source in
                                
                                // ?&?&?&?&?&?&?&?&?&?&?&?&?&?&?&?&?
                                // ?&?&?&?&?&?&?&?&?&? MARK: DETAILS
                                // ?&?&?&?&?&?&?&?&?&?&?&?&?&?&?&?&?
                                
                                VStack(alignment: .vjotSourcesH) {
                                    
                                    // \/\/\/\/\/\/\/
                                    // ID \/\/\/\/\/\
                                    // \/\/\/\/\/\/\/
                                    
                                    HStack {
                                        Text("id:")
                                            .foregroundColor(Color.secondary)
                                        Text(String(source.id))
                                            .foregroundColor(Color.primary)
                                            .alignmentGuide(.vjotSourcesH) { $0[.leading] }
                                    }
                                    
                                    // \/\/\/\/\/\/\/
                                    // NAME /\/\/\/\/
                                    // \/\/\/\/\/\/\/
                                    
                                    HStack {
                                        Text("name:")
                                            .foregroundColor(Color.secondary)
                                        Text(source.name)
                                            .foregroundColor(Color.primary)
                                            .alignmentGuide(.vjotSourcesH) { $0[.leading] }
                                    }
                                    
                                    // \/\/\/\/\/\/\/
                                    // URL \/\/\/\/\/
                                    // \/\/\/\/\/\/\/
                                    
                                    if let url = source.url {
                                        HStack {
                                            Text("url:")
                                                .foregroundColor(Color.secondary)
                                            Text(url.absoluteString)
                                                .foregroundColor(Color.primary)
                                                .alignmentGuide(.vjotSourcesH) { $0[.leading] }
                                        }
                                    }
                                    
                                    // \/\/\/\/\/\/\/
                                    // BREED \/\/\/\/
                                    // \/\/\/\/\/\/\/
                                    
                                    if let breedId = source.breedId {
                                        HStack {
                                            Text("breed:")
                                                .foregroundColor(Color.secondary)
                                            Text(breedId)
                                                .foregroundColor(Color.primary)
                                                .alignmentGuide(.vjotSourcesH) { $0[.leading] }
                                        }
                                    }
                                    
                                    // ?&?&?&?&?&?&?&?&?&?&?&?&?&?&?&?&?
                                    // ?&?&?&?&?&?&?&?&?&? MARK: DIVIDER
                                    // ?&?&?&?&?&?&?&?&?&?&?&?&?&?&?&?&?
                                    
                                    HStack {
                                        Divider()
                                            .alignmentGuide(.vjotSourcesH) { $0[.leading] }
                                            .hidden()
                                    }
                                    .padding(.top)
                                }
                                .font(.caption2)
                            }
                        }
                        
                    }
                }
            }
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)( MARK: TOOLBAR
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !router.pathInf.isEmpty {
                        
                        // <+><+><+><+><+><+><+><+><+
                        // PATH FOR IMAGES TAB ><+><+
                        // <+><+><+><+><+><+><+><+><+
                    
                        router.pathInf.removeLast()
                    }
                } label: {
                    Label("BACK TO CATS", systemImage: "gearshape.2")
                }
            }
        }
        
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(# MARK: ERROR ALERT
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#
        
        .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            // Text(error.recoverySuggestion ?? "Try again later.")
            if let failureReason = error.failureReason {
                Text(failureReason)
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: FETCH FAVOURITES
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .task {
            do {
                sources = try await sourcesEngine.fetchCats(count: nil)
                if sources.isEmpty { noSources.toggle() }
                loaded = true
            } catch {
                print(error.localizedDescription)
                // VJotError ////////////////////
                vjotError = VJotError.error(error)
                vjotErrorThrown.toggle()
            }
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatImageInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageInfoView()
//    }
//}
