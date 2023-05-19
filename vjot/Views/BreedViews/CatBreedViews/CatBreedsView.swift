//
//  CatBreedsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import SwiftUI

struct CatBreedsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        CatBreedsListView()
            .navigationBarTitleDisplayMode(.inline)
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct CatBreedsListView: View {
    
    @EnvironmentObject var breedEngine: BreedEngine
    @State var searchState: Int = 0
    
    // searchState: 0 <- Search by Breed
    // searchState: 2 <- Search by Trait
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        VStack {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            Picker("", selection: $searchState) {
                Text("Search by Breed")
                    .tag(0)
                Text("Search by Trait")
                    .tag(2)
            }
            
            List {
                
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                // <|><|><|><|><|><|><|><|><|><|><|><|><| MARK: SEARCH BY BREED
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                
                if searchState == 0 {
                    ForEach(breedEngine.searchCats()) { catBreed in
                        NavigationLink(value: catBreed) {
                            CatBreedsListElementView(catBreed: catBreed)
                        }
                    }
                }
                
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                // <|><|><|><|><|><|><|><|><|><|><|><|><| MARK: SEARCH BY TRAIT
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                
                if searchState == 2 {
                    ForEach(breedEngine.searchCatTraits()) { catBreed in
                        NavigationLink(value: catBreed) {
                            CatBreedsListElementView(catBreed: catBreed)
                        }
                    }
                }
            }
            .listStyle(.inset)
            .navigationDestination(for: CatAPIBreed.self) { catBreed in
                CatBreedView(catBreed: catBreed)
            }
            
            // ----------------------------------------------------------------
            // MODIFIERS //////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            // {-}{-}{-}{-}{-}{-}{-}{-}
            // SEARCHABLE }{-}{-}{-}{-}
            // {-}{-}{-}{-}{-}{-}{-}{-}
            
            .searchable(
                text: produceText(),
                prompt: producePrompt()
            )
            
            // {-}{-}{-}{-}{-}{-}{-}{-}
            // SUGGESTIONS {-}{-}{-}{-}
            // {-}{-}{-}{-}{-}{-}{-}{-}
            
            .searchSuggestions {
                
                // /\/\//\/\/\/\/\/\/\/
                // BY TRAIT /\/\/\/\/\/
                // /\/\//\/\/\/\/\/\/\/
                
                if searchState == 2 {
                    if breedEngine.catTraitSearchTerm.isEmpty {
                        ForEach(breedEngine.getCatTraits(), id: \.self) { suggestion in
                            Text(suggestion)
                                .searchCompletion(suggestion)
                        }
                    }
                }
            }
            
            // {-}{-}{-}{-}{-}{-}{-}{-}
            // TOOLBAR }{-}{-}{-}{-}{-}
            // {-}{-}{-}{-}{-}{-}{-}{-}
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            do {
                                try await breedEngine.refresh(.forCats)
                            } catch let error {
                                print(error.localizedDescription)
                                // VJotError ////////////////////////////////
                                vjotError = VJotError.error(error)
                                vjotErrorThrown.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(180))
                    }
                }
            }
            
            // [][][[][][][][][][][][][][][][][][][][][][][
            // //////////////////////////////// ERROR ALERT
            // [][][[][][][][][][][][][][][][][][][][][][][
            
            .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
                Button("OK", role: .cancel) {}
            } message: { error in
                // Text(error.recoverySuggestion ?? "Try again later.")
                if let failureReason = error.failureReason {
                    Text(failureReason)
                }
            }
        }
    }
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
    
    func produceText() -> Binding<String> {
        switch searchState {
        case 0:
            return $breedEngine.catSearchTerm
        default:
            return $breedEngine.catTraitSearchTerm
        }
    }
    
    func producePrompt() -> String {
        switch searchState {
        case 0:
            return "Search by Breed"
        default:
            return "Search by Trait"
        }
    }
}


// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{} MARK: ELEMENT
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct CatBreedsListElementView: View {
    var catBreed: CatAPIBreed
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @State var image: (id: String?, url: URL?, width: Int?, height: Int?) = (nil, nil, nil, nil)
    
    @State var vjotErrorThrown: Bool = false
    @State var vjotError: VJotError? = nil
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        
        // ----------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////
        // ----------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: IMAGE SECTION
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
        
        AsyncImage(url: image.url) { phase in
            switch phase {
                
                // ------------
                // EMPTY //////
                // ------------
                
            case .empty:
                HStack {
                    Spacer()
                    Text(catBreed.name)
                        .foregroundColor(Color.secondary)
                        .padding(.horizontal)
                }
                
                // ------------
                // SUCCESS ////
                // ------------
                
            case .success(let returnedImage):
                Rectangle()
                    .foregroundColor(Color(uiColor: UIColor.systemBackground))
                    .cornerRadius(15)
                    .aspectRatio(
                        calculateRatio(width: image.width, height: image.height),
                        contentMode: .fit
                    )
                    .overlay {
                        returnedImage
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .cornerRadius(15)
                    }
                    .clipShape(Rectangle())
                
                // ------------
                // FAILURE ////
                // ------------
                
            case .failure(_):
                Rectangle()
                    .aspectRatio(
//                        verticalSizeClass == .regular ? ((1 + sqrt(5)) / 2) : (1 + sqrt(5)),    // φ
                        1,
                        contentMode: .fit
                    )
                    .overlay {
                        Image("sloth")
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .background()
                    }
                    .clipShape(Rectangle())
                
                // ------------
                // DEFAULT ////
                // ------------
                
            default:
                fatalError()
            }
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: ERROR ALERT
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            if let recoverySuggestion = error.recoverySuggestion {
                Text(recoverySuggestion)
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: PURE MAGIC
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .task {
            if let imageId = catBreed.referenceImageId {
                do {
                    image = try await breedEngine.locate3(
                        .forCats,
                        imageId: imageId,
                        veterinarianId: veterinarianGig.currentId
                    )
                } catch VJotError.tooManyRequests429 {
                    print(VJotError.tooManyRequests429.localizedDescription)
                    
                    // ////////////////////////////////////////////////////////////////////////////
                    // UX IS AGUABLY BETTER IF USER IS NOT INFORMED OF THE RATELIMIT ERROR ////////
                    // ////////////////////////////////////////////////////////////////////////////
                    
//                    vjotError = VJotError.tooManyRequests429
//                    vjotErrorThrown.toggle()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
    
    func calculateRatio(width: Int?, height: Int?) -> CGFloat {
        switch verticalSizeClass {
        case .regular:
            guard let width = width, let height = height else { return ((1 + sqrt(5)) / 2) }
            return CGFloat(width) / CGFloat(height)
        case .compact:
            guard let width = width, let height = height else { return (1 + sqrt(5)) }
            return CGFloat(width) / CGFloat(height)
        case .none:
            return 1
        case .some(_):
            return 1
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatBreedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatBreedsView()
//    }
//}
