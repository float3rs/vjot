//
//  DogBreedImagesView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 15/4/23.
//

import SwiftUI

struct DogBreedImagesView: View {
    var dogBreed: DogAPIBreed
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var favouriteEngine: FavouriteEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var image: DogAPIImage? = nil
    
    @State var faved: Bool = false
    @State var favouriteId: Int? = nil
    @State var postFavResponse: APIFavouritePostStatus? = nil
    @State var deleteFavResponse: APIFavouriteDeleteStatus? = nil
    
    @State var imageSaved: Bool = false
    @State var imageSavedOnce: Bool = false
    @State var image3: (id: String?, url: URL?, width: Int?, height: Int?) = (nil, nil, nil, nil)
    @State var analyses: [APIAnalysis] = []
    @State var analysisIsPresented: Bool = false
    @State var analysed: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        VStack {
            VStack {
                List {
                    VStack {
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][ MARK: BREED
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        
                        HStack(alignment: .center) {
                            Text(dogBreed.name)
                                .foregroundColor(Color.primary)
                        }
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][ MARK: IMAGE
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        
                        if let image {
                            
                            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            
                            DogSectionView(image: image, uploaded: false)
                            
                            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .listRowInsets(EdgeInsets())
                .scrollContentBackground(.hidden)
                .edgesIgnoringSafeArea(.horizontal)
                
                // ------------------------------------------------------------
                // MODIFIERS //////////////////////////////////////////////////
                // ------------------------------------------------------------
                // {@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}
                // {@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{ MARK: REFRESH
                // {@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}{@}
                
                .refreshable {
                    Task {
                        do {
                            try await image = breedEngine.drawDog(breedId: dogBreed.id)
                            imageSavedOnce = false
                        } catch {
                            print(error.localizedDescription)
                            // VJotError ////////////////////////////
                            vjotError = VJotError.error(error)
                            vjotErrorThrown.toggle()
                        }
                    }
                }
                
                // //////////
                // SPACER ///
                // //////////
                
                Spacer()
            }
            
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: BACKGROUND
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            
            .frame(maxWidth: .infinity)
            .background {
                
                if let image {
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    
                    AsyncImage(url: image.url) { phase in
                        switch phase {
                            
                            // ------------
                            // EMPTY //////
                            // ------------
                            
                        case .empty:
                            EmptyView()
                            
                            // ------------
                            // SUCCESS ////
                            // ------------
                            
                        case .success(let returnedImage):
                            returnedImage
                                .resizable()
                                .overlay(.thinMaterial)
                                .aspectRatio(contentMode: .fill)
                                .brightness(colorScheme == .light ? 0.1 : -0.1)
                            
                            // ------------
                            // FAILURE ////
                            // ------------
                            
                        case .failure:
                            Color.clear
                            
                            // ------------
                            // DEFAULT ////
                            // ------------
                            
                        default:
                            fatalError()
                        }
                    }
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    
                }
            }
            
            // ^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%
            // ^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^% MARK: TOOLBAR
            // ^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%^%
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !router.pathBre.isEmpty {
                            router.pathBre.removeLast()
                        }
                    } label: {
                        Label("BACK TO DOGS", systemImage: "books.vertical")
                    }
                }
            }
            
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: PURE MAGIC
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
            
            .task {
                do {
                    try await image = breedEngine.drawDog(breedId: dogBreed.id)
                } catch let error {
                    print(error.localizedDescription)
                    // VJotError ////////////////////////////////
                    vjotError = VJotError.error(error)
                    vjotErrorThrown.toggle()
                }
            }
            
            // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
            // [][][][][][][][][][][][][][][][][][][][][][][] MARK: ERROR ALERT
            // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
            
            .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
                Button("OK", role: .cancel) {}
            } message: { error in
                if let failureReason = error.failureReason {
                    Text(failureReason)
                }
            }
            
            // ----------------------------------------------------------------
            // FOOTER /////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            Spacer()
            
            // %$%$%$%$%$%$%$%$%$%$%$%$
            // GUIDLINES %$%$%$%$%$%$%$
            // %$%$%$%$%$%$%$%$%$%$%$%$
            
            RefreshFooterView()
            
            // %$%$%$%$%$%$%$%$%$%$%$%$
            // CURRENT USER? %$%$%$%$%$
            // %$%$%$%$%$%$%$%$%$%$%$%$
            
            WarningVetFooterView()
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogBreedImagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogBreedImagesView(dogBreed: DogAPIBreed(id: 1, name: "Affenpinscher", referenceImageId: "BJa4kxc4X"))
//    }
//}
