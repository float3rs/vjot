//
//  CatInfoVersionView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import SwiftUI

struct CatInfoVersionView: View {
    
    @EnvironmentObject var versionEngine: VersionEngine
    @EnvironmentObject var router: Router
    
    @State var version: APIVersion_? = nil
    @State var noVersion: Bool = false
    @State var loaded: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        
        // --------------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        ZStack {
            if noVersion {
                
                // :::::::::::::
                // IF NO SOURCES
                // :::::::::::::
                
                VersionFallbackView(forSpecies: .forCats)
                
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
                            Text("The Cat API")
                                .foregroundColor(Color.primary)
                            Text("version")
                                .foregroundColor(Color.secondary)
                        }
                        .font(.title)
                        .padding()
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: VERSION
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        
                        if let version {
                            Text(version.version)
                                .font(.largeTitle)
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
                version = try await versionEngine.fetch(api: .forCats)
                if version == nil { noVersion.toggle() }
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

//struct CatInfoVersionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatInfoVersionView()
//    }
//}
