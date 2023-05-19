//
//  BreedSpeciesView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import SwiftUI

struct BreedSpeciesView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var breedEngine: BreedEngine
    
    var body: some View {
        NavigationStack(path: $router.pathBre) {
            BreedSpeciesListView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct BreedSpeciesListView: View {
    var body: some View {
        List {
            NavigationLink(value: BreedSpecies.cats) {
                BreedSpeciesListElementView(species: .cats)
                    .foregroundColor(Color.primary)
            }
            NavigationLink(value: BreedSpecies.dogs) {
                BreedSpeciesListElementView(species: .dogs)
                    .foregroundColor(Color.primary)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationDestination(for: BreedSpecies.self) { breedSpecies in
            BreedRoutingView(breedSpecies: breedSpecies)
        }
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{} MARK: ELEMENT
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct BreedSpeciesListElementView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var species: BreedSpecies
    
    var body: some View {
        switch verticalSizeClass {
            
            // ::::::::::::::
            // LANDSCAPE ::::
            // ::::::::::::::
            
        case .compact:
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor.systemBackground))
                .aspectRatio(
                    ((1 + sqrt(5)) / 2) * 3,
                    contentMode: .fit
                )
                .background(Color.primary)
                .overlay {
                    GeometryReader { proxy in
                        HStack {
                            getImage(for: species)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .background()
                            Image("bookz2")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(1.3)
                                .clipped()
                                .background()
                        }
                        .frame(width: proxy.size.width * ((1 + sqrt(5)) / 2) * 0.975)   // φ
                    }
                }
                .clipShape(Rectangle())
            
            // ::::::::::::::
            // PORTRAIT :::::
            // ::::::::::::::
            
        default:
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor.systemBackground))
                .aspectRatio(
                    ((1 + sqrt(5)) / 2) * 2,
                    contentMode: .fit
                )
                .background(Color.primary)
                .overlay {
                    HStack {
                        Spacer()
                        getImage(for: species)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .clipped()
                            .background()
                        Image("bookz2")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.3)
                            .clipped()
                            .background()
                        
                    }
                }
                .clipShape(Rectangle())
        }
    }
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
    
    func getImage(for species: BreedSpecies) -> Image {
        switch species {
        case .cats:
            return Image("origamiCat")
        case .dogs:
            return Image("origamiDog")
        }
    }
}


// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct BreedSpeciesView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            BreedSpeciesView()
//                .environmentObject(BreedEngine())
//        }
//    }
//}
