//
//  DogBreedsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import SwiftUI

struct DogBreedsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        DogBreedsListView()
            .navigationBarTitleDisplayMode(.inline)
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct DogBreedsListView: View {
    
    @EnvironmentObject var breedEngine: BreedEngine
    @State var searchState: Int = 0
    
    // searchState: 0 <- Search by Breed
    // searchState: 1 <- Search by Breed Group
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
                Text("Search by Breed Group")
                    .tag(1)
                Text("Search by Trait")
                    .tag(2)
            }
            
            List {
                
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                // <|><|><|><|><|><|><|><|><|><|><|><|><| MARK: SEARCH BY BREED
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                
                if searchState == 0 {
                    ForEach(breedEngine.searchDogs()) { dogBreed in
                        NavigationLink(value: dogBreed) {
                            DogBreedsListElementView(dogBreed: dogBreed)
                        }
                    }
                }
                
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                // <|><|><|><|><|><|><|><|><|><|><| MARK: SEARCH BY BREED GROUP
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                
                if searchState == 1 {
                    ForEach(breedEngine.searchDogGroups()) { dogBreed in
                        NavigationLink(value: dogBreed) {
                            DogBreedsListElementView(dogBreed: dogBreed)
                        }
                    }
                }
                
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                // <|><|><|><|><|><|><|><|><|><|><|><|><| MARK: SEARCH BY TRAIT
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                
                if searchState == 2 {
                    ForEach(breedEngine.searchDogTraits()) { dogBreed in
                        NavigationLink(value: dogBreed) {
                            DogBreedsListElementView(dogBreed: dogBreed)
                        }
                    }
                }
            }
            .listStyle(.inset)
            .navigationDestination(for: DogAPIBreed.self) { dogBreed in
                DogBreedView(dogBreed: dogBreed)
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
                // BY BREED GROUP /\/\/
                // /\/\//\/\/\/\/\/\/\/
                
                if searchState == 1 {
                    if breedEngine.dogGroupSearchTerm.isEmpty {
                        ForEach(breedEngine.getDogGoups(), id: \.self) { suggestion in
                            Text(suggestion)
                                .searchCompletion(suggestion)
                        }
                    }
                }
                
                // /\/\//\/\/\/\/\/\/\/
                // BY TRAIT /\/\/\/\/\/
                // /\/\//\/\/\/\/\/\/\/
                
                if searchState == 2 {
                    if breedEngine.dogTraitSearchTerm.isEmpty {
                        ForEach(breedEngine.getDogTraits(), id: \.self) { suggestion in
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
                                try await breedEngine.refresh(.forDogs)
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
            return $breedEngine.dogSearchTerm
        case 1:
            return $breedEngine.dogGroupSearchTerm
        default:
            return $breedEngine.dogTraitSearchTerm
        }
    }
    
    func producePrompt() -> String {
        switch searchState {
        case 0:
            return "Search by Breed"
        case 1:
            return "Search by Breed Group"
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

struct DogBreedsListElementView: View {
    var dogBreed: DogAPIBreed
    
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
                
                // ----------
                // EMPTY ////
                // ----------
                
            case .empty:
                HStack {
                    Spacer()
                    Text(dogBreed.name)
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
            if let imageId = dogBreed.referenceImageId {
                do {
                    image = try await breedEngine.locate3(
                        .forDogs,
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

//struct DogBreedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogBreedsView()
//    }
//}
