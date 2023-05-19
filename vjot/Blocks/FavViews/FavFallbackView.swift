//
//  FavFallbackView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct FavFallbackView: View {
    var forSpecies: ForSpecies
    var forCurrent: Bool
    
    var body: some View {
        VStack {
            
            // ()()()()()()()
            // SPACER )()()()
            // ()()()()()()()
            
            Spacer()
            
            Image("heartSketch")
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
                            Text("current user has".uppercased())
                            Text("no cats faved yes".uppercased())
                        }
                    case false:
                        VStack(spacing: 0) {
                            Text("no user has any".uppercased())
                            Text("cats faved yet".uppercased())
                        }
                    }
                case .forDogs:
                    switch forCurrent {
                    case true:
                        VStack(spacing: 0) {
                            Text("current user has".uppercased())
                            Text("no dogs faved yes".uppercased())
                        }
                    case false:
                        VStack(spacing: 0) {
                            Text("no user has any".uppercased())
                            Text("dogs faved yet".uppercased())
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

struct FavFallbackView_Previews: PreviewProvider {
    static var previews: some View {
        FavFallbackView(
            forSpecies: .forCats,
            forCurrent: false
        )
    }
}
