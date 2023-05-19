//
//  HomeView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 19/4/23.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView {
            JotterView()
            
                .tabItem {
                    Label("jotter", systemImage: "cross")
                }
                .tag(0)
            
            ImageSpeciesView()
            
                .tabItem {
                    Label("images", systemImage: "photo.on.rectangle")
                }
                .tag(1)
            
            BreedSpeciesView()
            
                .tabItem {
                    Label("breeds", systemImage: "books.vertical")
                }
                .tag(2)
            
            InfoSpeciesView()
            
                .tabItem {
                    Label("sources", systemImage: "newspaper")
                }
                .tag(3)
            
            ClinicLandingView()
            
                .tabItem {
                    Label("clinic", systemImage: "cross.case")
                }
                .tag(4)
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
