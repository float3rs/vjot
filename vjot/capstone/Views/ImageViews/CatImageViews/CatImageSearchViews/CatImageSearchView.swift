//
//  CatImageSearchView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 17/4/23.
//

import SwiftUI

struct CatImageSearchView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine
    @EnvironmentObject var imageEngine: ImageEngine
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var noResults: Bool = false
    @State var optionsGiven: Bool = false
    @State var count: Int = 1
    
    @State var categoriesShown: Bool = false
    @State var mixedExcluded: Bool = false
    @State var sizesShown: Bool = false
    @State var typesShown: Bool = false
    
    @State var size: APISize = .medium
    @State var type: APIMimeType = .jpg
    
    @State var images: [CatAPIImage] = []
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        VStack {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][ MARK: THE TITLE
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    
                    VStack(spacing: -10) {
                        Text("search cat images")
                        if (
                            !imageEngine.catBreedIds.isEmpty ||
                            !imageEngine.catCategoryIds.isEmpty ||
                            typesShown ||
                            sizesShown ||
                            mixedExcluded
                        ) {
                            HStack {
                                Spacer()
                                Text("...adjusted")
                                    .foregroundColor(Color.secondary)
                                    .padding(.leading)
                                Spacer()
                                Spacer()
                            }
                        }
                    }
                    .font(.title)
                    .padding(.horizontal)
                    .padding()
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*  MARK: SEARCH BUTTON
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // <|><|><|><|><|><
                    // COUNTER/GEAR |><
                    // <|><|><|><|><|><
                    
                    VStack {
                        
                        // ~~~~~~~
                        // STEPPER
                        // ~~~~~~~
                        
                        Stepper(value: $count, in: 1...9) {
                            Text("")
                        }
                        
                        // ~~~~~~~
                        // SETTIGS
                        // ~~~~~~~
                        
                        HStack {
                            Spacer()
                            NavigationLink {
                                
                                // \/\/\/\/\/\/\/\/\/
                                // OPTIONS \/\/\/\/\/
                                // \/\/\/\/\/\/\/\/\/
                                
                                CatImageSearchOptionsView(
                                    
                                    noResults: $noResults,
                                    
                                    categoriesShown: $categoriesShown,
                                    mixedExcluded: $mixedExcluded,
                                    sizesShown: $sizesShown,
                                    typesShown: $typesShown,
                                    
                                    size: $size,
                                    type: $type
                                )
                            } label: {
                                if (
                                    !imageEngine.catBreedIds.isEmpty ||
                                    !imageEngine.catCategoryIds.isEmpty ||
                                    typesShown ||
                                    sizesShown ||
                                    mixedExcluded
                                ) {
                                    Image(systemName: "gear")
                                        .foregroundColor(Color.green)
                                } else {
                                    Image(systemName: "gear")
                                        .foregroundColor(Color.primary)
                                }
                            }
                            .buttonStyle(.bordered)
                            .font(.body)
                            .padding(.trailing)
                        }
                    }
                    .padding()
                    
                    // <|><|><|><|><|><
                    // BUTTON |><|><|><
                    // <|><|><|><|><|><
                    
                    Button {
                        Task {
                            do {
                                
                                // {-}{-}{-}{-}{-
                                // SEARCH -}{-}{-
                                // {-}{-}{-}{-}{-
                                
                                images = try await imageEngine.fetchCats(
                                    typesShown: typesShown,
                                    type: type,
                                    size: size,
                                    count: count,
                                    mixedExcluded: mixedExcluded
                                )
                                
                                // {-}{-}{-}{-}{-
                                // MARK }{-}{-}{-
                                // {-}{-}{-}{-}{-
                                
                                if images.isEmpty { noResults.toggle() }
                                
                            } catch {
                                print(error.localizedDescription)
                                // VJotError ////////////////////////////
                                vjotError = VJotError.error(error)
                                vjotErrorThrown.toggle()
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text(String(count))
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*] MARK: IMAGE RESULTS
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    
                    if noResults {
                        
                        // ::::::::::::::::::::::
                        // IF NO RESULTS ::::::::
                        // ::::::::::::::::::::::
                        
                        Image("glassX")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.red)
                            .frame(width: 300, height: 300)
                        
                    } else {
                        
                        // ::::::::::::::::::::::
                        // IF OK RESULTS ::::::::
                        // ::::::::::::::::::::::
                        
                        ForEach(images, id: \.id) { image in
                            
                            // \/\/\/\/\/\/\/\/\/
                            // SECTION \/\/\/\/\/
                            // \/\/\/\/\/\/\/\/\/
                            
                            CatSectionView(image: image, uploaded: false)
                            
                            // \/\/\/\/\/\/\/\/\/
                            // DIVIDER \/\/\/\/\/
                            // \/\/\/\/\/\/\/\/\/
                            
                            if let lastImage = images.last {
                                if image.id != lastImage.id {
                                    Divider()
                                }
                            }
                        }
                        .padding()
                    }
                } // INNER VSTACK
            } // SCROLLVIEW
            
            // ----------------------------------------------------------------
            // FOOTER /////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            Spacer()
            WarningVetFooterView()
            
        } // OUTER VSTACK
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: BACKGROUND
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .background {
            if !images.isEmpty {
                AsyncImage(url: images[0].url) { phase in
                    switch phase {
                        
                        // ----------------
                        // EMPTY //////////
                        // ----------------
                        
                    case .empty:
                        EmptyView()
                        
                        // ----------------
                        // SUCCESS ////////
                        // ----------------
                        
                    case .success(let returnedImage):
                        returnedImage
                            .resizable()
                            .overlay(.thinMaterial)
                            .aspectRatio(contentMode: .fill)
                            .brightness(colorScheme == .light ? 0.1 : -0.1)
                        
                        // ----------------
                        // FAILURE ////////
                        // ----------------
                        
                    case .failure(_):
                        EmptyView()
                        
                        // ----------------
                        // DEFAULT ////////
                        // ----------------
                        
                    default:
                        fatalError()
                    }
                }
            }
        }
        
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#) MARK: TOOLBAR
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !router.pathIma.isEmpty {

                        // <+><+><+><+><+><+><+><+><+
                        // PATH FOR IMAGES TAB ><+><+
                        // <+><+><+><+><+><+><+><+><+

                        router.pathIma.removeLast()
                    }
                } label: {
                    Label("BACK TO CATS", systemImage: "photo.on.rectangle")
                }
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink {
//                    
//                    // \/\/\/\/\/\/\/\/\/
//                    // OPTIONS \/\/\/\/\/
//                    // \/\/\/\/\/\/\/\/\/
//                    
//                    CatImageSearchOptionsView(
//                        
//                        noResults: $noResults,
//                        
//                        categoriesShown: $categoriesShown,
//                        mixedExcluded: $mixedExcluded,
//                        sizesShown: $sizesShown,
//                        typesShown: $typesShown,
//                        
//                        size: $size,
//                        type: $type
//                    )
//                } label: {
//                    Image(systemName: "gear")
//                }
//            }
//        }
        
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
    } // BODY
}

// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][% MARK: SEARCH OPTIONS VIEW
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][

struct CatImageSearchOptionsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine
    @EnvironmentObject var imageEngine: ImageEngine
    
    @Binding var noResults: Bool
    
    @Binding var categoriesShown: Bool
    @Binding var mixedExcluded: Bool
    @Binding var sizesShown: Bool
    @Binding var typesShown: Bool
    
    @Binding var size: APISize
    @Binding var type: APIMimeType
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: -10) {
                Text("Search".lowercased())
                Text("Options".lowercased())
            }
            .font(.title)
            .padding()
            
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: INCLUDED BREEDS
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
            
            if !breedEngine.catBreeds.isEmpty {
                VStack {
                    
                    // <|><|><|><|><|><
                    // MESSAGE ><|><|><
                    // <|><|><|><|><|><
                    
                    VStack(spacing: 0) {
                        Text("optionally, search")
                        Text("for specific breeds")
                    }
                    .foregroundColor(Color.secondary)
                    .font(.subheadline)
                    .padding(.bottom)
                    
                    // <|><|><|><|><|><
                    // LINK ><|><|><|><
                    // <|><|><|><|><|><
                    
                    if imageEngine.catBreedIds.isEmpty {
                        
                        // ::::::::::::
                        // IF NO BREED
                        // SELECTED :::
                        // ::::::::::::
                        
                        NavigationLink {
                            CatImageSearchBreedsView()
                        } label: {
                            Image(systemName: "flag.slash")
                                .foregroundColor(Color.red)
                        }
                        .foregroundColor(Color.primary)
                        .buttonStyle(.bordered)
                        .padding(.bottom)
                        
                    } else {
                        
                        // ::::::::::::
                        // IF ANY BREED
                        // SELECTED :::
                        // ::::::::::::
                        
                        NavigationLink {
                            CatImageSearchBreedsView()
                        } label: {
                            Image(systemName: "flag")
                                .foregroundColor(Color.green)
                        }
                        .foregroundColor(Color.primary)
                        .buttonStyle(.bordered)
                        .padding(.bottom)
                    }
                    
                    // <|><|><|><|><|><
                    // DISPLAY ><|><|><
                    // <|><|><|><|><|><
                    
                    if !imageEngine.catBreedIds.isEmpty {
                        VStack(alignment: .vjotImageH) {
                            ForEach(Array(imageEngine.catBreedIds.enumerated()), id: \.offset) { index, breedId in
                                if let breedName = breedEngine.catCorrelate()[breedId] {
                                    HStack {
                                        Text("\(index + 1).")
                                            .foregroundColor(Color.secondary)
                                            .font(.subheadline)
                                            .alignmentGuide(.vjotImageH) { $0[.leading] }
                                        Text(breedName)
                                            .foregroundColor(Color.primary)
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: INCLUDED CATEGORIES
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            
            if !categoryEngine.catCategories.isEmpty {
                VStack {
                    
                    // <|><|><|><|><|><
                    // MESSAGE ><|><|><
                    // <|><|><|><|><|><
                    
                    VStack(spacing: 0) {
                        Text("optionally, search")
                        Text("for specific categories")
                    }
                    .foregroundColor(Color.secondary)
                    .font(.subheadline)
                    .padding(.bottom)
                    
                    // <|><|><|><|><|><
                    // BUTTON |><|><|><
                    // <|><|><|><|><|><
                    
                    Button {
                        switch categoriesShown {
                        case true:
                            categoriesShown.toggle()
                            imageEngine.catCategoryIds = []
                        case false:
                            categoriesShown.toggle()
                        }
                    } label: {
                        switch categoriesShown {
                        case true:
                            Image(systemName: "tag")
                                .foregroundColor(Color.green)
                        case false:
                            Image(systemName: "tag.slash")
                                .foregroundColor(Color.red)
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding(.bottom)
                    
                    // <|><|><|><|><|><
                    // DISPLAY ><|><|><
                    // <|><|><|><|><|><
                    
                    if categoriesShown {
                        VStack(alignment: .vjotImageH) {
                            ForEach(categoryEngine.catCategories) { category in
                                HStack {
                                    Text(category.name)
                                    if imageEngine.catCategoryIds.contains(where: { $0 == category.id }) {
                                        
                                        // ::::::::::::::::
                                        // IF CATEGORY ::::
                                        // SELECTED :::::::
                                        // ::::::::::::::::
                                        
                                        Button {
                                            imageEngine.catCategoryIds = imageEngine.catCategoryIds.filter { $0 != category.id }
                                        } label: {
                                            Image(systemName: "checkmark.square")
                                                .foregroundColor(Color.secondary)
                                        }
                                        .alignmentGuide(.vjotImageH) { $0[.trailing] }
                                        
                                    } else {
                                        
                                        // ::::::::::::::::
                                        // IF CATEGORY ::::
                                        // NOT SELECTED :::
                                        // ::::::::::::::::
                                        
                                        Button {
                                            imageEngine.catCategoryIds.append(category.id)
                                        } label: {
                                            Image(systemName: "square")
                                                .foregroundColor(Color.secondary)
                                        }
                                        .alignmentGuide(.vjotImageH) { $0[.trailing] }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][% MARK: INCLUDED TYPES
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            
            VStack {
                
                // <|><|><|><|><|><
                // MESSAGE ><|><|><
                // <|><|><|><|><|><
                
                VStack(spacing: 0) {
                    Text("optionally, search")
                    Text("for specific type")
                }
                .foregroundColor(Color.secondary)
                .font(.subheadline)
                .padding(.bottom)
                
                // <|><|><|><|><|><
                // BUTTON |><|><|><
                // <|><|><|><|><|><
                
                Button {
                    switch typesShown {
                    case true:
                        typesShown.toggle()
                    case false:
                        typesShown.toggle()
                    }
                } label: {
                    switch typesShown {
                    case true:
                        Image(systemName: "tag")
                            .foregroundColor(Color.green)
                    case false:
                        Image(systemName: "tag.slash")
                            .foregroundColor(Color.red)
                    }
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
                
                // <|><|><|><|><|><
                // PICKER |><|><|<>
                // <|><|><|><|><|><
                
                if typesShown {
                    Picker(selection: $type) {
                        Text(".jpg").tag(APIMimeType.jpg)
                            .font(.body)
                        Text(".png").tag(APIMimeType.png)
                            .font(.body)
                    } label: {
                        
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            Divider()
                .padding(.horizontal)
                .padding(.bottom)
            
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][% MARK: INCLUDED SIZES
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            
            VStack {
                
                // <|><|><|><|><|><
                // MESSAGE ><|><|><
                // <|><|><|><|><|><
                
                VStack(spacing: 0) {
                    Text("optionally, search")
                    Text("for specific size")
                }
                .foregroundColor(Color.secondary)
                .font(.subheadline)
                .padding(.bottom)
                
                // <|><|><|><|><|><
                // BUTTON |><|><|><
                // <|><|><|><|><|><
                
                Button {
                    switch sizesShown {
                    case true:
                        sizesShown.toggle()
                        size = .medium
                    case false:
                        sizesShown.toggle()
                    }
                } label: {
                    switch sizesShown {
                    case true:
                        Image(systemName: "tag")
                            .foregroundColor(Color.green)
                    case false:
                        Image(systemName: "tag.slash")
                            .foregroundColor(Color.red)
                    }
                }
                .buttonStyle(.bordered)
                
                // <|><|><|><|><|><
                // PICKER |><|><|<>
                // <|><|><|><|><|><
                
                if sizesShown {
                    Picker(selection: $size) {
                        Text("thumbnail").tag(APISize.thumbnail)
                            .font(.body)
                        Text("small").tag(APISize.small)
                            .font(.body)
                        Text("medium").tag(APISize.medium)
                            .font(.body)
                        Text("full").tag(APISize.full)
                            .font(.body)
                    } label: {
                        
                    }
                    .pickerStyle(.wheel)
                }
                
            }
            .padding(.horizontal)
            .padding(.bottom)
            if sizesShown {
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom)
            } else {
                Divider()
                    .padding(.horizontal)
                    .padding()
            }
            
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][% MARK: EXCLUDE MIXED BREEDS
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            
            VStack {
                
                // <|><|><|><|><|><
                // MESSAGE ><|><|><
                // <|><|><|><|><|><
                
                VStack(spacing: 0) {
                    Text("optionally, exclude")
                    Text("cats of mixed breed")
                }
                .foregroundColor(Color.secondary)
                .font(.subheadline)
                .padding(.bottom)
                
                // <|><|><|><|><|><
                // BUTTON |><|><|><
                // <|><|><|><|><|><
                
                Button {
                    switch mixedExcluded {
                    case true:
                        mixedExcluded.toggle()
                    case false:
                        mixedExcluded.toggle()
                    }
                } label: {
                    switch mixedExcluded {
                    case true:
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.red)
                    case false:
                        Image(systemName: "xmark")
                            .foregroundColor(Color.green)
                    }
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
        }
        
        // ------------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////////
        // ------------------------------------------------------------------------
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)( MARK: TOOLBAR
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Label("BACK TO SEARCH", systemImage: "arrow.left")
                        Text("Adjust")
                    }
                }
            }
        }
        
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(# MARK: ON DISAPPEAR
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)
        // NEW SETTINGS /~/~/
        // RESET RESULTS ~/~/
        // ~/~/~/~/~/~/~/~/~/
        
        .onDisappear {
            noResults = false
        }
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatImageSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            CatImageSearchView(
//                
//            )
//            .environmentObject(BreedEngine())
//            .environmentObject(CategoryEngine())
//            .environmentObject(ImageEngine())
//        }
//    }
//}
