//
//  CapstoneView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 2023-03-25.
//

import SwiftUI

struct CapstoneView: View {
    @State var debug: Bool = true                   //  TRUE: DEVELOPEMENT MODE
                                                    // FALSE: PRODUCTION   MODE
    @StateObject var router = Router()
    @StateObject var breedEngine = BreedEngine()
    @StateObject var categoryEngine = CategoryEngine()
    @StateObject var imageEngine = ImageEngine()
    @StateObject var analysisEngine = AnalysisEngine()
    @StateObject var favouriteEngine = FavouriteEngine()
    @StateObject var voteEngine = VoteEngine()
    @StateObject var sourcesEngine = SourcesEngine()
    @StateObject var versionEngine = VersionEngine()
    @StateObject var veterinarianGig = VeterinarianGig()
    @StateObject var incidentGig = IncidentGig()
    @StateObject var patientGig = PatientGig()
    @StateObject var guardianGig = GuardianGig()
    
    var body: some View {
        Primer(debug: $debug)
            .environmentObject(router)
            .environmentObject(breedEngine)
            .environmentObject(categoryEngine)
            .environmentObject(imageEngine)
            .environmentObject(analysisEngine)
            .environmentObject(favouriteEngine)
            .environmentObject(voteEngine)
            .environmentObject(sourcesEngine)
            .environmentObject(versionEngine)
            .environmentObject(veterinarianGig)
            .environmentObject(incidentGig)
            .environmentObject(patientGig)
            .environmentObject(guardianGig)
    }
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: PRIME
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][

struct Primer: View {
    @Binding var debug: Bool
    
    var body: some View {
        switch debug {
        case true:
            Prelauncher()
        case false:
            Launcher()
        }
    }
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][] MARK: PRELAUNCH
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][

struct Prelauncher: View {
    
    @EnvironmentObject var guardianGig: GuardianGig
    @EnvironmentObject var patientGig: PatientGig
    @EnvironmentObject var incidentGig: IncidentGig
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine
    @EnvironmentObject var imageEngine: ImageEngine
    @EnvironmentObject var analysisEngine: AnalysisEngine
    @EnvironmentObject var favouriteEngine: FavouriteEngine
    @EnvironmentObject var voteEngine: FavouriteEngine
    @EnvironmentObject var sourcesEngine: SourcesEngine
    @EnvironmentObject var versionEngine: VersionEngine
    
    @State var state: Int = 0
    
    // ////////////////////////////////
    // STATE 0: PREFLIGHT /////////////
    // STATE 1: GO ABORT //////////////
    // STATE 2: GO BOOTSTRAP //////////
    // STAGE 3: GP LAUNCH /////////////
    // ////////////////////////////////
    
    var body: some View {
        
        switch state {
        case 1:
            CapstoneView()
        case 2:
            Bootstrapper()
        case 3:
            Launcher()
        default:
            VStack {
                Text("development mode")
                    .font(.title)
                    .padding()
                Button("WIPE") { wipe(); state = 1}
                    .padding()
                Button("BOOTSTRAP") { state = 2 }
                    .padding()
                Button("LAUNCH") { state = 3 }
                    .padding()
            }
            .onAppear { printPath() }
        }
    }
    
    func printPath() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("PATH: \(path)")
    }
    
    func wipe() {
        guardianGig.guardians = []
        guardianGig.currentId = nil
        patientGig.patients = []
        patientGig.currentId = nil
        incidentGig.incidents = []
        incidentGig.currentId = nil
        veterinarianGig.veterinarians = []
        veterinarianGig.currentId = nil
        
        breedEngine.catBreeds = []
        breedEngine.dogBreeds = []
        categoryEngine.catCategories = []
        categoryEngine.dogCategories = []
        analysisEngine.analyses = []
        favouriteEngine.catFavourites = []
        favouriteEngine.dogFavourites = []
        
        let directory =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            for item in contents {
                try FileManager.default.removeItem(at: item)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][ MARK: LAUNCH
// [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][[][

struct Launcher: View {
    
    @EnvironmentObject var router: Router
    
    var body: some View {
            HomeView()
        }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CapstoneView_Previews: PreviewProvider {
//    static var previews: some View {
//        CapstoneView()
//    }
//}
