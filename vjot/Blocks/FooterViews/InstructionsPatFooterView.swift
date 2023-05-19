//
//  InstructionsPatFooterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 29/4/23.
//

import SwiftUI

struct InstructionsPatFooterView: View {
    
    @EnvironmentObject var patientGig: PatientGig
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                Text("Swipe right to recuperate given patient")
                Image(systemName: "arrowtriangle.right")
                Spacer()
                Spacer()
            }
            .foregroundColor(patientGig.currentId == nil ? Color.accentColor : Color.secondary)
            .font(.subheadline)
            HStack {
                Spacer()
                Spacer()
                Image(systemName: "arrowtriangle.left")
                Text("Swipe left to release arranged patient")
                Spacer()
            }
            .foregroundColor(Color.secondary)
            .font(.subheadline)
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct InstructionsPatFooterView_Previews: PreviewProvider {
//    static var previews: some View {
//        InstructionsPatFooterView()
//    }
//}
