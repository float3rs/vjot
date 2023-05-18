//
//  ImageRoutingView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 17/4/23.
//

import SwiftUI

struct ImageRoutingView: View {
    var imageSpecies: ImageSpecies
    
    var body: some View {
        switch imageSpecies {
        case .cats:
            CatImageHomeView()
        case .dogs:
            DogImageHomeView()
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct ImageRoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageRoutingView(imageSpecies: .cats)
//    }
//}
