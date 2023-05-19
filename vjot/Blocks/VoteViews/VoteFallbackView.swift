//
//  VoteFallbackView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct VoteFallbackView: View {
    var forSpecies: ForSpecies
    var forCurrent: Bool
    
    var body: some View {
        VStack {
            
            // ()()()()()()()
            // SPACER )()()()
            // ()()()()()()()
            
            Spacer()
            
            Image("voteSketch")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.secondary)
                .frame(width: 100, height: 100)
                .padding()
            
            VStack {
                switch forSpecies {
                case .forCats:
                    switch forCurrent {
                    case true:
                        VStack(spacing: 0) {
                            Text("current user hasn't".uppercased())
                            Text("for any cat yet".uppercased())
                        }
                    case false:
                        VStack(spacing: 0) {
                            Text("no user has voted".uppercased())
                            Text("for any cats yet".uppercased())
                        }
                    }
                case .forDogs:
                    switch forCurrent {
                    case true:
                        VStack(spacing: 0) {
                            Text("current user hasn't".uppercased())
                            Text("for any dog yet".uppercased())
                        }
                    case false:
                        VStack(spacing: 0) {
                            Text("no user has voted".uppercased())
                            Text("for any dogs yet".uppercased())
                        }
                    }
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

struct VoteFallbackView_Previews: PreviewProvider {
    static var previews: some View {
        VoteFallbackView(
            forSpecies: .forCats,
            forCurrent: false
        )
    }
}
