//
//  InstructionsVetFooterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import SwiftUI

struct InstructionsVetFooterView: View {
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                Text("Swipe right to activate clinical session")
                Image(systemName: "arrowtriangle.right")
                Spacer()
                Spacer()
            }
            .foregroundColor(veterinarianGig.currentId == nil ? Color.accentColor : Color.secondary)
            .font(.subheadline)
            HStack {
                Spacer()
                Spacer()
                Image(systemName: "arrowtriangle.left")
                Text("Swipe left to relieve fellow colleague")
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

//struct InstructionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        InstructionsVetFooterView()
//    }
//}
