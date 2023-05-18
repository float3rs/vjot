//
//  WarningPatFotterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 28/4/23.
//

import SwiftUI

struct WarningPatFotterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var patientGig: PatientGig
    
    var body: some View {
        if patientGig.currentId == nil {
            // {!}{!}{!}{!}{!}{!}{!}{!}
            // USELECTED INCIDENT !}{!}{
            // {!}{!}{!}{!}{!}{!}{!}{!}
            
            HStack {
                Rectangle()
                    .foregroundColor(
                        Color(uiColor: UIColor.systemBackground)
                    )
                    .brightness((colorScheme == .light) ? -0.1 : +0.1)
                    .aspectRatio(
                        32/9,
                        contentMode: .fit
                    )
                    .overlay {
                        Image("ball")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.secondary)
                            .scaledToFill()
                            .clipped()
                            .scaleEffect(0.2)
                        
                    }
                    .clipShape(Rectangle())
            }
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct WarningPatFotterView_Previews: PreviewProvider {
//    static var previews: some View {
//        WarningPatFotterView()
//    }
//}
