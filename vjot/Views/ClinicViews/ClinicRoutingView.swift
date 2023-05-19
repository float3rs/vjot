//
//  ClinicRoutingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 26/4/23.
//

import SwiftUI

struct ClinicRoutingView: View {
    var role: Role
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    var body: some View {
        switch role {
        case .veterinarians:
            VeterinarianHomeView()
        case .incidents:
            IncidentHomeView(vetId: veterinarianGig.veterinarians.first == nil ? UUID() : veterinarianGig.veterinarians.first!.id)
        case .patients:
            PatientHomeView()
        case .clinic:
            AboutView()
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct ClinicRoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClinicRoutingView()
//    }
//}
