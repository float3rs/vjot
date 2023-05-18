//
//  VeterinarianRoutingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 7/4/23.
//

import SwiftUI

struct VeterinarianRoutingView: View {
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    var body: some View {
        
        if veterinarianGig.veterinarians.isEmpty {
            VeterinarianOnboardingView(onboardingIsPresented: Binding.constant(true))
                .transition(.opacity)
        } else {
            VeterinarianHomeView()
                .transition(.opacity)
        }
    }
}

// ------------------------------------------------------------------------
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARK: PREVIEW
// ------------------------------------------------------------------------
//struct VeterinarianRoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        VeterinarianRoutingView()
//            .environmentObject(VeterinarianSession())
//    }
//}
