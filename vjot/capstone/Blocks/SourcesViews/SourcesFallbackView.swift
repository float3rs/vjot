//
//  SourcesFallbackView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import SwiftUI

struct SourcesFallbackView: View {
    var forSpecies: ForSpecies
    
    var body: some View {
        
        VStack {
            
            // ()()()()()()()
            // SPACER )()()()
            // ()()()()()()()
            
            Spacer()
            
            Image("sources")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.secondary)
                .frame(width: 100, height: 100)
                .padding()
            
            VStack(spacing: 0) {
                Text("no sources are currently available".uppercased())
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

//struct SourcesFallbackView_Previews: PreviewProvider {
//    static var previews: some View {
//        SourcesFallbackView()
//    }
//}
