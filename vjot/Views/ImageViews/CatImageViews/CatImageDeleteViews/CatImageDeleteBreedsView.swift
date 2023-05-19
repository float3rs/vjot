//
//  CatImageDeleteBreedsView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 21/4/23.
//

import SwiftUI

struct CatImageDeleteBreedsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        VStack {
            
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|> LIST SECTION
            // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><
            
            CatImageDeleteBreedsListView()
            
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

struct CatImageDeleteBreedsListView: View {
    
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
                Text("Search by Trait")
                    .tag(2)
            }
            List {
                
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                // <|><|><|><|><|><|><|><|><|><|><|><|><| MARK: SEARCH BY BREED
                // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>
                
                if searchState == 0 {
                    ForEach(breedEngine.searchCats()) { catBreed in
                        NavigationLink {
                            CatBreedView(catBreed: catBreed)
                        } label: {
                            CatImageDeleteBreedsListElementView(catBreed: catBreed)
                        }
                        
                        // (%)(%)(%)(%)(%)(%)
                        // SWIPE ACTIONS )(%)
                        // (%)(%)(%)(%)(%)(%)
                        
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.uploadedCatBreedIds.append(catBreed.id)
                            } label: {
                                Label("add", systemImage: "checkmark")
                            }
                            .tint(Color.accentColor)
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.uploadedCatBreedIds = imageEngine.uploadedCatBreedIds.filter { $0 != catBreed.id }
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
                    ForEach(breedEngine.searchCatTraits()) { catBreed in
                        NavigationLink {
                            CatBreedView(catBreed: catBreed)
                        } label: {
                            CatImageDeleteBreedsListElementView(catBreed: catBreed)
                        }
                        
                        // (%)(%)(%)(%)(%)(%)
                        // SWIPE ACTIONS )(%)
                        // (%)(%)(%)(%)(%)(%)
                        
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.uploadedCatBreedIds.append(catBreed.id)
                            } label: {
                                Label("add", systemImage: "checkmark")
                            }
                            .tint(Color.accentColor)
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button {
                                imageEngine.uploadedCatBreedIds = imageEngine.uploadedCatBreedIds.filter { $0 != catBreed.id }
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
            
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Label("back to cats", systemImage: "arrow.left")
                            Text("Include")
                        }
                    }
                }
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


struct CatImageDeleteBreedsListElementView: View {
    var catBreed: CatAPIBreed
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var imageEngine: ImageEngine
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        HStack {
            Spacer()
            Text(catBreed.name)
                .foregroundColor(imageEngine.uploadedCatBreedIds.contains(where: {$0 == catBreed.id}) ? Color.accentColor : Color.secondary)
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatImageDeleteBreedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageDeleteBreedsView()
//    }
//}
