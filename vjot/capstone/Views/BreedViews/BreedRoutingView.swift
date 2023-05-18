//
//  BreedRoutingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import SwiftUI

struct BreedRoutingView: View {
    var breedSpecies: BreedSpecies
    
    var body: some View {
        switch breedSpecies {
        case .cats:
            CatBreedsView()
        case .dogs:
            DogBreedsView()
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct BreedRoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BreedRoutingView(breedSpecies: .cats)
//    }
//}
