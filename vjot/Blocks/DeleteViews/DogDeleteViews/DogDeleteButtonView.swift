//
//  DogDeleteView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import SwiftUI

struct DogDeleteButtonView: View {
    var image: DogAPIImage
    
    @EnvironmentObject var imageEngine: ImageEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    @Binding var deleted: Bool
    @State var goDelete: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    var body: some View {
        VStack {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            switch deleted {
            case false:
                
                // {}{}{}{}{}{}{}{}{}{}{}{}
                // THE BUTTON }{}{}{}{}{}{}
                // {}{}{}{}{}{}{}{}{}{}{}{}
                
                Button {
                    goDelete = true
                } label: {
                    switch deleted {
                        
                        // %-%-%-%-%-%-%-%-%-%-%-
                        // UPDATE THE ICON %-%-%-
                        // DISABLE DELETE -%-%-%-
                        // %-%-%-%-%-%-%-%-%-%-%-
                        
                    case true:
                        Image(systemName: "delete.left")
                            .foregroundColor(Color.red)
                            .font(.title3)
                    case false:
                        Image(systemName: "delete.left")
                            .foregroundColor(Color.primary)
                            .font(.title3)
                    }
                }
                .buttonStyle(.bordered)
                .disabled(deleted)
                
            case true:
                
//                Text("deleted :(")
//                    .foregroundColor(Color.red)
//                    .font(.title)
//                    .padding(.bottom)
                
                HStack {
                    
                }
                .hidden()
            }
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|>< MARK: CONFIRMATION
        // <|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|><|
        
        .confirmationDialog("(◡︵◡)", isPresented: $goDelete, actions: {
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        try await delete(imageId: image.id)
                    } catch {
                        print(error.localizedDescription)
                        // VJotError ////////////////////
                        vjotError = VJotError.error(error)
                        vjotErrorThrown.toggle()
                    }
                }
            }
        }, message: {
            Text("The dog will no longer be available; any favs and/or votes associated with it will also be permanently removed; this action cannot be undone.")
//            HStack(spacing: 0) {
//                Image(systemName: "photo")
//                Image(systemName: "arrow.forward")
//                Image(systemName: "trash")
//                Image(systemName: "questionmark")
//            }
        })
        
        // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
        // [][][][][][][][][][][][][][][][][][][][][][][][][] MARK: ERROR ALERT
        // [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
        
        .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            // Text(error.recoverySuggestion ?? "Try again later.")
            if let failureReason = error.failureReason {
                Text(failureReason)
            }
        }
    }
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
    
    func delete(imageId: String) async throws {
        
        // <~><~><~><~><~><~><~><~><~><
        // WHEN IMAGE DELETED ~><~><~><
        // <~><~><~><~><~><~><~><~><~><
        // 1. DESATURATE IMAGE ><~><~><
        // 2. REMOVE  FAV IF FAVED <~><
        // 3. REMOVE VOTE IF VOTED <~><
        // 4. DISABLE  FAV ~><~><~><~><
        // 5. DISABLE VOTE ~><~><~><~><
        // 6. DISABLE SAVE ~><~><~><~><
        // <~><~><~><~><~><~><~><~><~><
        
        try await imageEngine.delete(.forDogs, imageId: imageId)
        try veterinarianGig.cleanDog(imageId: imageId)
        deleted = true
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogDeleteView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogDeleteView()
//    }
//}
