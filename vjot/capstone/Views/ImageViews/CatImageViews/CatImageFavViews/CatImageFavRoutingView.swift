//
//  CatImageFavRouting.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 20/4/23.
//

import SwiftUI

struct CatImageFavRoutingView: View {
    var count: Int
    
    var body: some View {
        
        switch count {
        case 1:
            CatImageFavView()
        case 2:
            CatImageFavXView()
        case 3:
            CatImageFavFindView()
        default:
            self
        }
    }
}

//struct CatImageFavRouting_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageFavRouting()
//    }
//}
