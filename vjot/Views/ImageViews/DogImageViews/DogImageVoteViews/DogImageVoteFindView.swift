//
//  DogImageVoteFindView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct DogImageVoteFindView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var focused: Bool

    @EnvironmentObject var imageEngine: ImageEngine
    @EnvironmentObject var voteEngine: VoteEngine
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var noResult: Bool = false
    @State var image: DogAPIImage? = nil
    
    @State var voteId: String = String()
    @State var vote: DogAPIVote? = nil
    
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
                    Text("retrieve votes")
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
                    TextField("id", text: $voteId)
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
                            
                            if let voteId = Int(voteId) {
                                vote = try await voteEngine.fetchDog(voteId: voteId)
                            }
                            
                            // {-}{-}{-}{-}{-
                            // MARK }{-}{-}{-
                            // {-}{-}{-}{-}{-
                            
                            if vote == nil { noResult = true }
                            
                            // </></></></></
                            // IMAGE? /></></
                            // </></></></></
                            
                            if let vote {
                                image = try await imageEngine.fetchDog(
                                    imageId: vote.imageId,
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
                .disabled(voteId.isEmpty)
                .padding()

                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: DETAILS
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                
                if !noResult {
                    
                    // ::::::::::::::::
                    // IF OK RESULTS ::
                    // ::::::::::::::::
                    
                    if let vote { DogVoteDetailsView(vote: vote) }
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


        .onChange(of: voteId, perform: { newValue in
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

//struct DogImageVoteFindView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogImageVoteFindView()
//    }
//}
