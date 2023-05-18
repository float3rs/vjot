//
//  InstructionsIncFooterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 25/4/23.
//

import SwiftUI

struct InstructionsIncFooterView: View {
    
    @EnvironmentObject var incidentGig: IncidentGig
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                Text("Swipe right to select current incident")
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
                Text("Swipe left to remove settled incident")
                Spacer()
            }
            .foregroundColor(Color.secondary)
            .font(.subheadline)
        }
    }
}

//struct InstructionsIncView_Previews: PreviewProvider {
//    static var previews: some View {
//        InstructionsIncFooterView()
//    }
//}
