//
//  DogImageFavRouting.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 20/4/23.
//

import SwiftUI

struct DogImageFavRoutingView: View {
    var count: Int
    
    var body: some View {
        
        switch count {
        case 1:
            DogImageFavView()
        case 2:
            DogImageFavXView()
        case 3:
            DogImageFavFindView()
        default:
            self
        }
    }
}

//struct DogImageFavRouting_Previews: PreviewProvider {
//    static var previews: some View {
//        DogImageFavRouting()
//    }
//}
