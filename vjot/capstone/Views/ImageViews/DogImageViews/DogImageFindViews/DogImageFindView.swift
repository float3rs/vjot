//
//  DogImageFindView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 19/4/23.
//

import SwiftUI

struct DogImageFindView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var focused: Bool
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine
    @EnvironmentObject var imageEngine: ImageEngine
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var noResults: Bool = false
    @State var optionsGiven: Bool = false
    
    @State var sizesShown: Bool = false
    @State var size: APISize = .medium
    
    @State var imageId = String()
    @State var image: DogAPIImage? = nil
    
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
                        Text("find dog image")
                        if sizesShown {
                            HStack {
                                Spacer()
                                Spacer()
                                Spacer()
                                Text("...adjusted")
                                    .foregroundColor(Color.secondary)
                                    .padding(.trailing)
                                
                                Spacer()
                            }
                        }
                    }
                    .font(.title)
                    .padding()
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*]  MARK: SEARCH
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // <|><|><|><|><|><
                    // TEXTFIELD |><|><
                    // <|><|><|><|><|><
                    
                    HStack {
                        
                        // ~~~~~~~~~~~~
                        // SPACER ~~~~~
                        // ~~~~~~~~~~~~
                        
                        Spacer()
                        
                        // ~~~~~~~~~~~~
                        // FIELD ~~~~~`
                        // ~~~~~~~~~~~~
                        
                        TextField("id", text: $imageId)
                            .textFieldStyle(.roundedBorder)
                            .focused($focused)
                            .padding(.leading)
                        
                        // ~~~~~~~~~~~~
                        // SETTIGS ~~~~
                        // ~~~~~~~~~~~~
                        
                        NavigationLink {
                            DogFindOptionsView(
                                noResults: $noResults,
                                sizesShown: $sizesShown,
                                size: $size
                            )
                        } label: {
                            Image(systemName: "gear")
                                .foregroundColor(sizesShown ? Color.green : Color.primary)
                        }
                        .buttonStyle(.bordered)
                        .font(.body)
                        .padding(.trailing)

                        // ~~~~~~~~~~~~
                        // SPACER ~~~~~
                        // ~~~~~~~~~~~~
                        
                        Spacer()
                    }
                    .padding()
                    
                    // <|><|><|><|><|><
                    // BUTTON |><|><|><
                    // <|><|><|><|><|><
                    
                    Button {
                        Task {
                            do {
                                focused = false // RELEASE THE KEYBOARD
                                
                                // {-}{-}{-}{-}{-
                                // SEARCH -}{-}{-
                                // {-}{-}{-}{-}{-
                                
                                image = try await imageEngine.fetchDog(
                                    imageId: imageId,
                                    subId: veterinarianGig.currentId?.uuidString,
                                    size: size
                                )
                                
                                // {-}{-}{-}{-}{-
                                // MARK }{-}{-}{-
                                // {-}{-}{-}{-}{-
                                
                                if image == nil { noResults.toggle() }
                                
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
                        Image(systemName: "magnifyingglass")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(imageId.isEmpty)
                    .padding()
                    
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
                        
                        if let image {
                            
                            // \/\/\/\/\/\/\/\/\/
                            // SECTION \/\/\/\/\/
                            // \/\/\/\/\/\/\/\/\/
                            
                            DogSectionView(image: image, uploaded: false)
                                .padding()
                        }
                    }
                }   // INNER VSTACK
            } // SCROLLVIEW
            
            // ----------------------------------------------------------------
            // FOOTER /////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            Spacer()
            WarningVetFooterView()
            
        } // VStack
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: BACKGROUND
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .background {
            if let image {
                AsyncImage(url: image.url) { phase in
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
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)( MARK: ON CHANGE
        // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#
        // NEW SEARCH ~/~/~/~
        // RESET RESULTS /~/~
        // /~/~/~/~/~/~/~/~/~
        
        
        .onChange(of: imageId, perform: { newValue in
            noResults = false
        })
        
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
                    Label("BACK TO DOGS", systemImage: "photo.on.rectangle")
                }
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink {
//                    DogFindOptionsView(
//                        noResults: $noResults,
//                        sizesShown: $sizesShown,
//                        size: $size
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

struct DogFindOptionsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine
    @EnvironmentObject var imageEngine: ImageEngine
    
    @Binding var noResults: Bool
    @Binding var sizesShown: Bool
    @Binding var size: APISize
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: -10) {
                Text("Find".lowercased())
                Text("Options".lowercased())
            }
            .font(.title)
            .padding()
            
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][% MARK: INCLUDED SIZES
            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%
            
            VStack {
                
                // <|><|><|><|><|><
                // MESSAGE ><|><|><
                // <|><|><|><|><|><
                
                VStack(spacing: 0) {
                    Text("optionally, designate")
                    Text("specific size")
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
                // PICKER |><|><|><
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

//struct DogImageFindView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogImageFindView()
//    }
//}
