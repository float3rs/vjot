//
//  VersionFallbackView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import SwiftUI

struct VersionFallbackView: View {
    var forSpecies: ForSpecies
    
    var body: some View {
        VStack {
            
            // ()()()()()()()
            // SPACER )()()()
            // ()()()()()()()
            
            Spacer()
            
            Image("world")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.secondary)
                .frame(width: 100, height: 100)
                .padding()
            
            VStack(spacing: 0) {
                Text("version is currently unavailable".uppercased())
                switch forSpecies {
                case .forCats:
                    Text("for the the cat api".uppercased())
                case .forDogs:
                    Text("for the the dog api".uppercased())
                }
            }
            .foregroundColor(Color.secondary)
            .padding()
            
            // ()()()()()()()
            // SPACER )()()()
            // ()()()()()()()
            
            Spacer()
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct VersionFallbackView_Previews: PreviewProvider {
//    static var previews: some View {
//        VersionFallbackView()
//    }
//}
