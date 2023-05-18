//
//  CatSaveView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import SwiftUI

struct CatSaveView: View {
    var image: CatAPIImage
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    
    @State var imageSaved: Bool = false
    @State var imageSavedOnce: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    var body: some View {
        
        // ------------------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////////////
        // ------------------------------------------------------------------------
        
        ZStack {
            
            // <~><~><~><~><~
            // SAVE BUTTON <~
            // <~><~><~><~><~
            
            Button {
                Task {
                    do {
                        if let imageURL = image.url {
                            let url = imageURL
                            let urlRequest = URLRequest(url: url)
                            
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            // THE SIMPLEST HTTP REQUEST }{
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            
                            let (data, _ ) = try await URLSession.shared.data(for: urlRequest)
                            
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            // CONVERT TO DATA FOR SAVING }
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            
                            let uiImage = UIImage(data: data)!
                            
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            // STRAIGHTFORWARD APPLE API }}
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            
                            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                            
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            // SHOW THE WITTY ALERT {/}{/}{
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            
                            imageSaved.toggle()
                            
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            // UPDATE THE ICON /}{/}{/}{/}{
                            // AND DISABLE IT {/}{/}{/}{/}{
                            // {/}{/}{/}{/}{/}{/}{/}{/}{/}{
                            
                            imageSavedOnce = true
                        }
                    } catch {
                        print(error.localizedDescription)
                        // VJotError ////////////////////////////
                        vjotError = VJotError.error(error)
                        vjotErrorThrown.toggle()
                    }
                }
            } label: {
                Image(systemName: imageSavedOnce ? "square.and.arrow.down.fill" : "square.and.arrow.down")
                    .font(.title3)
                    .foregroundColor(imageSavedOnce ? Color(UIColor.magenta) : Color.primary)
            }
            .disabled(imageSavedOnce)
            .buttonStyle(.bordered)
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: IMAGE SAVED ALERT
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)
        
        .alert("Saved to Photos", isPresented: $imageSaved, actions: {
            Button("SIGHS", action: {imageSaved.toggle()})
        }, message: {
            if let currentId = veterinarianGig.currentId {
                if let currentVet = veterinarianGig.track(currentId: currentId) {
                    Text("Congratulations \(currentVet.name)! Yet another Cat lies now upon your Library.")
                } else {
                    Text("Yet another Cat lies now upon your Photos Library.")
                }
            }
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
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatSaveView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatSaveView()
//    }
//}
