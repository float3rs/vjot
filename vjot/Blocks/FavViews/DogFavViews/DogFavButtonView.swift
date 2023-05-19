//
//  DogFavButtonView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import SwiftUI

struct DogFavButtonView: View {
    var image: DogAPIImage
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var favouriteEngine: FavouriteEngine

    @State var faved: Bool = false
    @State var favouriteId: Int? = nil
    
    @State var postFavResponse: APIFavouritePostStatus? = nil
    @State var deleteFavResponse: APIFavouriteDeleteStatus? = nil
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    var body: some View {
        ZStack {
            if let currentId = veterinarianGig.currentId {
                if var currentVet = veterinarianGig.track(currentId: currentId) {
                    
                    // ^%^%^%^%^%^%^%^%
                    // IF SIGNED IN %^%
                    // ENABLE FAV %^%^%
                    // ^%^%^%^%^%^%^%^%
                    
                    if faved {
                        
                        // ::::::::::::::::::::::
                        // IF ALREADY FAVED :::::
                        // ::::::::::::::::::::::
                        
                        Button {
                            Task {
                                do {
                                    
                                    // XXXXXXXXXXXXXXXXXXXX
                                    // DELETE FAV XXXXXXXXX
                                    // XXXXXXXXXXXXXXXXXXXX
                                    
                                    if favouriteId != nil {
                                        deleteFavResponse = try await favouriteEngine.deleteDog(
                                            favouriteId: favouriteId!
                                        )
                                        
                                        // <><><><><><><><><><><><><>
                                        // REVERT TO NON FAVED <><><>
                                        // <><><><><><><><><><><><><>
                                        
                                        if deleteFavResponse != nil {
                                            
                                            // ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
                                            // UPDATE VET'S POINTERS ~-~-~-~-~-
                                            // SO THAT THE NEXT TIME ~-~-~-~-~-
                                            // THE ICON WILL INDICATE ~-~-~-~-~
                                            // THAT THE IMAGE ISN'T FAVED ~-~-~
                                            // ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
                                            
                                            currentVet.dogFavs.removeValue(forKey: image.id)
                                            try veterinarianGig.update(veterinarian: currentVet)
                                            
                                            // ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
                                            // KEEP THE FAV ID FOR ~-~-~-~-~-~-
                                            // IF USER CHOOSES TO FAV ~-~-~-~-~
                                            // ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
                                            
                                            faved.toggle()
                                            favouriteId = nil
                                        }
                                    }
                                } catch let error {
                                    print(error.localizedDescription)
                                    // VJotError ////////////////////
                                    vjotError = VJotError.error(error)
                                    vjotErrorThrown.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color.red)
                                .font(.title3)
                        }
                        .buttonStyle(.bordered)
                        
                    } else {
                        
                        // ::::::::::::::::::::::
                        // IF NOT FAVED :::::::::
                        // ::::::::::::::::::::::
                        
                        Button {
                            Task {
                                do {
                                    
                                    // OOOOOOOOOOOOOOOOOOOO
                                    // POST FAV OOOOOOOOOOO
                                    // OOOOOOOOOOOOOOOOOOOO
                                    
                                    postFavResponse = try await favouriteEngine.postDog(
                                        imageId: image.id,
                                        subId: currentId
                                    )
                                    
                                    // <|><|><|><|><|><|><|><|><|><|>
                                    // CONVERT TO FAVED ><|><|><|><|>
                                    // <|><|><|><|><|><|><|><|><|><|>
                                    
                                    if let postFavResponse {
                                        
                                        // ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
                                        // UPDATE VET'S CAT FAV IDS ~-~-~-~-~-~
                                        // SO THAT THE NEXT TIME ~-~-~-~-~-~-~-
                                        // THE ICON WILL INDICATE ~-~-~-~-~-~-~
                                        // THAT THE IMAGE WAS FAVED ~-~-~-~~-~-
                                        // ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
                                        
                                        currentVet.dogFavs[image.id] = postFavResponse.id
                                        try veterinarianGig.update(veterinarian: currentVet)
                                        
                                        // ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
                                        // KEEP THE FAV ID FOR ~-~-~-~-~-~-~-~-
                                        // IF USER CHOOSES TO UNFAV ~-~-~-~-~-~
                                        // ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
                                        
                                        favouriteId = postFavResponse.id
                                        faved.toggle()
                                    }
                                } catch let error {
                                    print(error.localizedDescription)
                                    // VJotError ////////////////////
                                    vjotError = VJotError.error(error)
                                    vjotErrorThrown.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "heart")
                                .foregroundColor(Color.primary)
                                .font(.title3)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
            } else {
                
                // ^%^%^%^%^%^%^%^%
                // IF SIGNED OUT ^%
                // DISABLE FAV ^%^%
                // ^%^%^%^%^%^%^%^%
                
                Button {
                    
                } label: {
                    Image(systemName: "heart.slash")
                        .foregroundColor(Color.secondary)
                        .font(.title3)
                }
                .buttonStyle(.bordered)
                .disabled(true)
            }
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)( MARK: ON APPEAR
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // \/\/\/\/\/\/\/\/\/\
        // ALREADY FAVED? /\/\
        // \/\/\/\/\/\/\/\/\/\
        
        .onAppear {
            if let currentId = veterinarianGig.currentId {
                if let currentVet = veterinarianGig.track(currentId:currentId) {
                    if let favId = currentVet.dogFavs[image.id] {
                        faved = true
                        favouriteId = favId
                    } else {
                        faved = false
                        favouriteId = nil
                    }
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)( MARK: ON CHANGE
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // \/\/\/\/\/\/\/\/\/\
        // ALREADY FAVED? /\/\
        // \/\/\/\/\/\/\/\/\/\
        
        .onChange(of: image, perform: { newValue in
            if let currentId = veterinarianGig.currentId {
                if let currentVet = veterinarianGig.track(currentId:currentId) {
                    if let favId = currentVet.dogFavs[newValue.id] {
                        faved = true
                        favouriteId = favId
                    } else {
                        faved = false
                        favouriteId = nil
                    }
                }
            }
        })
        
        // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
        // [][][][][][][][][][][][][][][][][][][][][][][][][] MARK: ERROR ALERT
        // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
        
        .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            if let failureReason = error.failureReason {
                Text(failureReason)
            }
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogFavView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogFavButtonView()
//    }
//}
