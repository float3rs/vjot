//
//  VoteCalloutView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct VoteCalloutView: View {
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
            
            VStack {
                VStack(spacing:0) {
                    Text("NO USER SESSION IS")
                    Text("CURRENTLY ACTIVE")
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

struct VoteCalloutView_Previews: PreviewProvider {
    static var previews: some View {
        VoteCalloutView()
    }
}
