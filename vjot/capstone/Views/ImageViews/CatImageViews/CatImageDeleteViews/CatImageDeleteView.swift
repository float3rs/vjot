//
//  CatImageDeleteView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 20/4/23.
//

import SwiftUI

struct CatImageDeleteView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine
    @EnvironmentObject var imageEngine: ImageEngine
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var noResults: Bool = false
    @State var images: [CatAPIImage] = []
    @State var limit: Int = 1
    
    @State var optionsGiven: Bool = false
    @State var categoriesShown: Bool = false
    @State var originalFilename: String = String()
    @State var subId: String = String()
    
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
                        Text("search for uploaded")
                        Text("cats to delete")
                        if (
                            !imageEngine.uploadedCatBreedIds.isEmpty ||
                            !imageEngine.uploadedCatCategoryIds.isEmpty ||
                            !originalFilename.isEmpty ||
                            !subId.isEmpty
                        ) {
                            HStack {
                                Text("...adjusted")
                                    .foregroundColor(Color.secondary)
                                    .padding(.leading)
                                Spacer()
                            }
                        }
                    }
                    .font(.title)
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
                        
                        Stepper(value: $limit, in: 1...9) {
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
                                
                                CatImageDeleteOptionsView(
                                    noResults: $noResults,
                                    categoriesShown: $categoriesShown,
                                    subId: $subId,
                                    originalFilename: $originalFilename
                                )
                            } label: {
                                if (
                                    !imageEngine.uploadedCatBreedIds.isEmpty ||
                                    !imageEngine.uploadedCatCategoryIds.isEmpty ||
                                    !originalFilename.isEmpty ||
                                    !subId.isEmpty
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
                                
                                images = try await imageEngine.fetchUploadedCats(
                                    limit: limit,
                                    subId: subId,
                                    originalFilename: originalFilename
                                )
                                
                                // {-}{-}{-}{-}{-
                                // MARK }{-}{-}{-
                                // {-}{-}{-}{-}{-
                                
                                if images.isEmpty { noResults.toggle() }
                                
                                // ~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|
                                // CASESTUDY: WHEN SERVER RESPONDS WITH NON-UUID SUBID ~|
                                // ~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|
                                
                            } catch VJotError.id {
                                print(VJotError.id.localizedDescription)
                                noResults.toggle()
                            } catch {
                                print(error.localizedDescription)
                                // VJotError ////////////////////////
                                vjotError = VJotError.error(error)
                                vjotErrorThrown.toggle()
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text(String(limit))
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
                            
                            CatSectionView(image: image, uploaded: true)
                                .padding()
                            
                            // \/\/\/\/\/\/\/\/\/
                            // DIVIDER \/\/\/\/\/
                            // \/\/\/\/\/\/\/\/\/
                            
                            if let lastImage = images.last {
                                if image.id != lastImage.id {
                                    Divider()
                                }
                            }
                        }
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
//                    CatImageDeleteOptionsView(
//                        noResults: $noResults,
//                        categoriesShown: $categoriesShown,
//                        subId: $subId,
//                        originalFilename: $originalFilename
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

struct CatImageDeleteOptionsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var subIdFocused: Bool
    @FocusState private var originalFilenameFocused: Bool
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine
    @EnvironmentObject var imageEngine: ImageEngine
    
    @Binding var noResults: Bool
    
    @Binding var categoriesShown: Bool
    @Binding var subId: String
    @Binding var originalFilename: String
    
    @State var subIdTextFieldShown: Bool = false
    @State var originalFilenameTextFieldShown: Bool = false
    
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
                    
                    if imageEngine.uploadedCatBreedIds.isEmpty {
                        
                        // ::::::::::::
                        // IF NO BREED
                        // SELECTED :::
                        // ::::::::::::
                        
                        NavigationLink {
                            CatImageDeleteBreedsView()
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
                            CatImageDeleteBreedsView()
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
                    
                    if !imageEngine.uploadedCatBreedIds.isEmpty {
                        VStack(alignment: .vjotImageH) {
                            ForEach(Array(imageEngine.uploadedCatBreedIds.enumerated()), id: \.offset) { index, breedId in
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
                            imageEngine.uploadedCatCategoryIds = []
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
                                    if imageEngine.uploadedCatCategoryIds.contains(where: { $0 == category.id }) {
                                        
                                        // ::::::::::::::::
                                        // IF CATEGORY ::::
                                        // SELECTED :::::::
                                        // ::::::::::::::::
                                        
                                        Button {
                                            imageEngine.uploadedCatCategoryIds = imageEngine.uploadedCatCategoryIds.filter { $0 != category.id }
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
                                            imageEngine.uploadedCatCategoryIds.append(category.id)
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
            // (%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(% MARK: ORIGINAL FILENAME
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            
            VStack {
                
                // <|><|><|><|><|><
                // MESSAGE ><|><|><
                // <|><|><|><|><|><
                
                VStack(spacing: 0) {
                    Text("optionally, designate")
                    Text("the original filename")
                }
                .foregroundColor(Color.secondary)
                .font(.subheadline)
                .padding(.bottom)
                
                // <|><|><|><|><|><
                // BUTTON |><|><|><
                // <|><|><|><|><|><
                
                Button {
                    switch originalFilenameTextFieldShown {
                    case true:
                        originalFilenameTextFieldShown.toggle()
                    case false:
                        originalFilenameTextFieldShown.toggle()
                    }
                } label: {
                    switch originalFilenameTextFieldShown {
                    case true:
                        Image(systemName: "bookmark")
                            .foregroundColor(Color.green)
                    case false:
                        Image(systemName: "bookmark.slash")
                            .foregroundColor(Color.red)
                    }
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
                
                // <|><|><|><|><|><
                // TEXTFIELD |><|><
                // <|><|><|><|><|><
                
                if originalFilenameTextFieldShown {
                    HStack {
                        Spacer()
                        TextField("id", text: $originalFilename)
                            .textFieldStyle(.roundedBorder)
                            .focused($originalFilenameFocused)
                            .padding(.horizontal)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            Divider()
                .padding(.horizontal)
                .padding(.bottom)
            
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            // (%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%)(%) MARK: SPECIFIC USER ID
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            
            VStack {
                
                // <|><|><|><|><|><
                // MESSAGE ><|><|><
                // <|><|><|><|><|><
                
                VStack(spacing: 0) {
                    Text("optionally, search")
                    Text("for specific user id")
                }
                .foregroundColor(Color.secondary)
                .font(.subheadline)
                .padding(.bottom)
                
                // <|><|><|><|><|><
                // BUTTON |><|><|><
                // <|><|><|><|><|><
                
                Button {
                    switch subIdTextFieldShown {
                    case true:
                        subIdTextFieldShown.toggle()
                    case false:
                        subIdTextFieldShown.toggle()
                    }
                } label: {
                    switch subIdTextFieldShown {
                    case true:
                        Image(systemName: "person.2")
                            .foregroundColor(Color.green)
                    case false:
                        Image(systemName: "person.2.slash")
                            .foregroundColor(Color.red)
                    }
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
                
                // <|><|><|><|><|><
                // TEXTFIELD |><|><
                // <|><|><|><|><|><
                
                if subIdTextFieldShown {
                    HStack {
                        Spacer()
                        TextField("id", text: $subId)
                            .textFieldStyle(.roundedBorder)
                            .focused($subIdFocused)
                            .padding(.horizontal)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
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

//struct CatImageDeleteFindView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageDeleteView()
//    }
//}
