//
//  WarningVetFooterView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct WarningVetFooterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    var body: some View {
        if veterinarianGig.currentId == nil {
            
            // {!}{!}{!}{!}{!}{!
            // SIGNED OUT }{!}{!
            // {!}{!}{!}{!}{!}{!
            
            HStack {
                Rectangle()
                    .foregroundColor(
                        Color(uiColor: UIColor.systemBackground)
                    )
                    .brightness((colorScheme == .light) ? -0.1 : +0.1)
                    .aspectRatio(
                        64/9,
                        contentMode: .fit
                    )
                    .overlay {
                        Image("hammock")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.secondary)
                            .scaledToFill()
                            .clipped()
                            .scaleEffect(0.5)
                        
                    }
                    .clipShape(Rectangle())
            }
            
//            VStack(alignment: .leading) {
//                HStack {
//                    Spacer()
//                    Text("no veterinarian is currently signed in")
//                        .foregroundColor(Color.secondary)
//                    Spacer()
//                }
//                HStack {
//                    Spacer()
//                    Text("voting and favoring functionality disabled")
//                        .foregroundColor(Color.secondary)
//                    Spacer()
//                }
//                .font(.subheadline)
//                .padding()
//                .background(
//                    Color(UIColor.systemBackground)
//                        .brightness((colorScheme == .light) ? -0.1 : +0.1)
//                )
//                .font(.subheadline)
//                .padding()
//                .background(
//                    Color(UIColor.systemBackground)
//                        .brightness((colorScheme == .light) ? -0.1 : +0.1)
//                )
//            }
                
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct WarningFooterView_Previews: PreviewProvider {
//    static var previews: some View {
//        WarningVetFooterView()
//    }
//}
