//
//  WarningIncFooterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 25/4/23.
//

import SwiftUI

struct WarningIncFooterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var incidentGig: IncidentGig
    
    var body: some View {
        if incidentGig.currentId == nil {
            
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
                        Image("stethoscope!")
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
    
//struct WarningIncFooterView_Previews: PreviewProvider {
//    static var previews: some View {
//        WarningIncFooterView()
//    }
//}
