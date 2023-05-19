//
//  FavCalloutView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct FavCalloutView: View {
    var body: some View {
        VStack {
            
            // ()()()()()()()
            // SPACER )()()()
            // ()()()()()()()
            
            Spacer()
            
            Image("invisible")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.secondary)
                .frame(width: 100, height: 100)
                .padding()
            
            // ()()()()()()()
            // SPACER )()()()
            // ()()()()()()()
            
            
            VStack(spacing:0) {
                Text("NO USER SESSION IS")
                Text("CURRENTLY ACTIVE")
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

struct FavCalloutView_Previews: PreviewProvider {
    static var previews: some View {
        FavCalloutView()
    }
}
