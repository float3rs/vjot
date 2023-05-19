//
//  DogImageFavFindView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 20/4/23.
//

import SwiftUI

struct DogImageFavFindView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var focused: Bool
    
    @EnvironmentObject var imageEngine: ImageEngine
    @EnvironmentObject var favouriteEngine: FavouriteEngine
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var noResult: Bool = false
    @State var image: DogAPIImage? = nil
    
    @State var favouriteId: String = String()
    @State var favourite: DogAPIFavourite? = nil
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY

    var body: some View {
        VStack {

            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------

            ScrollView {

                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][ MARK: THE TITLE
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*

                VStack(spacing: -10) {
                    Text("retrieve favs")
                        HStack {
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Text("...of dogs")
                                .foregroundColor(Color.secondary)
                                .padding(.trailing)
                            Spacer()
                            Spacer()
                        }
                }
                .font(.title)
                .padding(.horizontal)
                .padding()

                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                // [*][*][*][*][*][*][*][*][*][*][*][*  MARK: SEARCH BUTTON
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                // <|><|><|><|><|><
                // TEXTFIELD |><|><
                // <|><|><|><|><|><

                HStack {
                    Spacer()
                    TextField("id", text: $favouriteId)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focused)
                        .padding(.horizontal)
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
                            // INT -}{-}{-}{-
                            // {-}{-}{-}{-}{-
                            
                            if let favouriteId = Int(favouriteId) {
                                favourite = try await favouriteEngine.fetchDog(favouriteId: favouriteId)
                            }
                            
                            // {-}{-}{-}{-}{-
                            // MARK }{-}{-}{-
                            // {-}{-}{-}{-}{-
                            
                            if favourite == nil { noResult = true }
                            
                            // </></></></></
                            // IMAGE? /></></
                            // </></></></></
                            
                            if let favourite {
                                image = try await imageEngine.fetchDog(
                                    imageId: favourite.imageId,
                                    subId: veterinarianGig.currentId?.uuidString,
                                    size: nil
                                )
                            }
                            
                            // </></></></></
                            // NO IMAGE? /></
                            // </></></></></
                            
                            if image == nil { noResult = true }
                            
                            // ~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|
                            // CASESTUDY: WHEN SERVER RESPONDS WITH NON-UUID SUBID ~|
                            // ~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|~|
                            
                        } catch VJotError.id {
                            print(VJotError.id.localizedDescription)
                            noResult.toggle()
                        } catch {
                            print(error.localizedDescription)
                            // VJotError ////////////////////////////
                            vjotError = VJotError.error(error)
                            vjotErrorThrown.toggle()
                        }
                    }

                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .buttonStyle(.borderedProminent)
                .disabled(favouriteId.isEmpty)
                .padding()

                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: DETAILS
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                
                if !noResult {
                    
                    // ::::::::::::::::
                    // IF OK RESULTS ::
                    // ::::::::::::::::
                    
                    if let favourite { DogFavDetailsView(favourite: favourite) }
                }
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                // [*][*][*][*][*][*][*][*][*][*][*][*] MARK: IMAGE RESULTS
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                
                if noResult {
                    
                    // ::::::::::::::::
                    // IF NO RESULTS ::
                    // ::::::::::::::::
                    
                    Image("glassX")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.red)
                        .frame(width: 300, height: 300)
                    
                } else {
                    
                    // ::::::::::::::::
                    // IF OK RESULTS ::
                    // ::::::::::::::::
                    
                    if let image {
                        
                        // \/\/\/\/\/\/\/\/\/
                        // SECTION \/\/\/\/\/
                        // \/\/\/\/\/\/\/\/\/
                        
                        DogSectionView(image: image, uploaded: false)
                    }
                }
            } // ScrollView

            // ----------------------------------------------------------------
            // FOOTER /////////////////////////////////////////////////////////
            // ----------------------------------------------------------------

            Spacer()
            WarningVetFooterView()
            
        } // VStack

        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)( MARK: TOOLBAR
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
        
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


        .onChange(of: favouriteId, perform: { newValue in
            noResult = false
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
    } // body
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogImageFavFindView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogImageFavFindView()
//    }
//}
