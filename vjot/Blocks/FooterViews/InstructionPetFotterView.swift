//
//  InstructionPetFotterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 28/4/23.
//

import SwiftUI

struct InstructionPetFotterView: View {
    @EnvironmentObject var incidentGig: IncidentGig
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                Text("Swipe right to select current patient")
                Image(systemName: "arrowtriangle.right")
                Spacer()
                Spacer()
            }
            .foregroundColor(incidentGig.currentId == nil ? Color.accentColor : Color.secondary)
            .font(.subheadline)
            HStack {
                Spacer()
                Spacer()
                Image(systemName: "arrowtriangle.left")
                Text("Swipe left to remove cured patient")
                Spacer()
            }
            .foregroundColor(Color.secondary)
            .font(.subheadline)
        }
    }
}

//struct InstructionPetFotterView_Previews: PreviewProvider {
//    static var previews: some View {
//        InstructionPetFotterView()
//    }
//}
