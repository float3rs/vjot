//
//  DogImageSearchBreedsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 17/4/23.
//

import SwiftUI

struct DogImageSearchBreedsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        VStack {
            
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|> LIST SECTION
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><
            
            DogImageSearchBreedsListView()
            
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>< FOOTER SECTION
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><
            
            Spacer()
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Swipe right to incude breed")
                    Image(systemName: "arrowtriangle.right")
                    Spacer()
                    Spacer()
                }
                .font(.subheadline)
                HStack {
                    Spacer()
                    Spacer()
                    Image(systemName: "arrowtriangle.left")
                    Text("Swipe left to exclude breed")
                    Spacer()
                }
                .font(.subheadline)
            }
            .foregroundColor(Color.secondary)
            .padding(5)
            .background(
                Color(UIColor.systemBackground)
                    .brightness((colorScheme == .light) ? -0.1 : +0.1)
            )
        }
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct DogImageSearchBreedsListView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var imageEngine: ImageEngine
    @EnvironmentObject var breedEngine: BreedEngine
    @State var searchState: Int = 0
    
    // searchState: 0 <- Search by Breed
    // searchState: 2 <- Search by Trait
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        VStack() {
            
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
                        NavigationLink {
                            DogBreedView(dogBreed: dogBreed)
                        } label: {
                            DogImageSearchBreedsListElementView(dogBreed: dogBreed)
                        }
                        
                        // (%)(%)(%)(%)(%)(%)
                        // SWIPE ACTIONS )(%)
                        // (%)(%)(%)(%)(%)(%)
                        
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.dogBreedIds.append(dogBreed.id)
                            } label: {
                                Label("add", systemImage: "checkmark")
                            }
                            .tint(Color.accentColor)
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.dogBreedIds = imageEngine.dogBreedIds.filter { $0 != dogBreed.id }
                            } label: {
                                Label("remove", systemImage: "x.circle")
                            }
                            .tint(Color.red)
                        })
                    }
                }
                
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                // <|><|><|><|><|><|><|><|><|><|><| MARK: SEARCH BY BREED GROUP
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                
                if searchState == 1 {
                    ForEach(breedEngine.searchDogGroups()) { dogBreed in
                        NavigationLink {
                            DogBreedView(dogBreed: dogBreed)
                        } label: {
                            DogImageSearchBreedsListElementView(dogBreed: dogBreed)
                        }
                        
                        // (%)(%)(%)(%)(%)(%)
                        // SWIPE ACTIONS )(%)
                        // (%)(%)(%)(%)(%)(%)
                        
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.dogBreedIds.append(dogBreed.id)
                            } label: {
                                Label("add", systemImage: "checkmark")
                            }
                            .tint(Color.accentColor)
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.dogBreedIds = imageEngine.dogBreedIds.filter { $0 != dogBreed.id }
                            } label: {
                                Label("remove", systemImage: "x.circle")
                            }
                            .tint(Color.red)
                        })
                    }
                }
                
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                // <|><|><|><|><|><|><|><|><|><|><|><|><| MARK: SEARCH BY TRAIT
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                
                if searchState == 2 {
                    ForEach(breedEngine.searchDogTraits()) { dogBreed in
                        NavigationLink {
                            DogBreedView(dogBreed: dogBreed)
                        } label: {
                            DogImageSearchBreedsListElementView(dogBreed: dogBreed)
                        }
                        
                        // (%)(%)(%)(%)(%)(%)
                        // SWIPE ACTIONS )(%)
                        // (%)(%)(%)(%)(%)(%)
                        
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.dogBreedIds.append(dogBreed.id)
                            } label: {
                                Label("add", systemImage: "checkmark")
                            }
                            .tint(Color.accentColor)
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.dogBreedIds = imageEngine.dogBreedIds.filter { $0 != dogBreed.id }
                            } label: {
                                Label("remove", systemImage: "x.circle")
                            }
                            .tint(Color.red)
                        })
                    }
                }
            }
            .listStyle(.inset)
            
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
            
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Label("back to dogs", systemImage: "arrow.left")
                            Text("Include")
                        }
                    }
                }
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
        default:
            return $breedEngine.dogTraitSearchTerm
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

struct DogImageSearchBreedsListElementView: View {
    var dogBreed: DogAPIBreed
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var imageEngine: ImageEngine
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        HStack {
            Spacer()
            Text(dogBreed.name)
                .foregroundColor(imageEngine.dogBreedIds.contains(where: {$0 == dogBreed.id}) ? Color.accentColor : Color.secondary)
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogImageBreedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogImageSearchBreedsView()
//    }
//}
