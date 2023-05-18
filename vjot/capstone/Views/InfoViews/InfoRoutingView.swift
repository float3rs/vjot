//
//  InfoRoutingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 24/4/23.
//

import SwiftUI

struct InfoRoutingView: View {
    var infoSpecies: InfoSpecies
    
    var body: some View {
        switch infoSpecies {
        case .cats:
            CatInfoHomeView()
        case .dogs:
            DogInfoHomeView()
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct InfoRoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoRoutingView()
//    }
//}
