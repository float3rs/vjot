//
//  CatImageUploadView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 19/4/23.
//

import SwiftUI
import PhotosUI

struct CatImageUploadView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var imageEngine: ImageEngine
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var photosPickerItem: PhotosPickerItem? = nil
    @State var file: UIImage? = nil
    @State var image: Image? = nil
    
    @State var status: APIImageUploadStatus? = nil
    @State var uploading: Bool = false
    @State var uploaded: Bool = false
    
    @State var rotating: Bool = false
    @State var scaling: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ZStack {
            VStack {
                
                // ------------------------------------------------------------
                // CONTENT ////////////////////////////////////////////////////
                // ------------------------------------------------------------
                
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        // [*][*][*][*][*][*][*][*][*][*][*][*] MARK: THE TITLE
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        
                        VStack(spacing: -10) {
                            Text("upload")
                            Text("cat image")
                        }
                        .font(.title)
                        .padding()
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        // [*][*][*][*][*][*][*][*][*][ MARK: LOAD IMAGE BUTTON
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        
                        PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                            Image(systemName: "photo")
                                .symbolRenderingMode(.multicolor)
                                .font(.title3)
                                .foregroundColor(Color.primary)
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        // [*][*][*][*][*][*][*][*][*][*] MARK: IMAGE TO UPLOAD
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        
                        if let image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .padding(.horizontal, verticalSizeClass == .compact ? 100 : 0)
                                .brightness(uploading ? (colorScheme == .light ? 0.5 : -0.5) : 0)
                                .padding()
                        }
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        // [*][*][*][*][*][*][*][*][*][*][* MARK: UPLOAD BUTTON
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
                        
                        if let file {
                            Button {
                                Task {
                                    do {
                                        
                                        // \/\/\/\/\/\/\/\/\/\/\/\/\/
                                        // ATTEMP TO UPLOAD /\/\/\/\/
                                        // \/\/\/\/\/\/\/\/\/\/\/\/\/
                                        
                                        uploading = true
                                        status = try await imageEngine.upload(
                                            .forCats,
                                            file: file,
                                            subId: veterinarianGig.currentId
                                        )
                                        
                                        // \/\/\/\/\/\/\/\/\/\/\/\/\/
                                        // UPDATE/SAVE USER /\/\/\/\/
                                        // \/\/\/\/\/\/\/\/\/\/\/\/\/
                                        
                                        if status != nil {
                                            uploaded = true
                                        }
                                        uploading = false
                                    } catch {
                                        print(error.localizedDescription)
                                        // VJotError ////////////////////////////
                                        vjotError = VJotError.error(error)
                                        vjotErrorThrown.toggle()
                                    }
                                }
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding()
                        }
                    }
                }
            }
            
            // ----------------------------------------------------------------
            // MODIFIERS //////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: BACKGROUND
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            
            .background {
                if let image {
                    image
                        .resizable()
                        .overlay(.thinMaterial)
                        .aspectRatio(contentMode: .fill)
                        .brightness(colorScheme == .light ? 0.1 : -0.1)
                }
            }
            
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
                        Label("BACK TO CATS", systemImage: "photo.on.rectangle")
                    }
                }
            }
            
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@> MARK: ON CHANGE
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            
            .onChange(of: photosPickerItem) { newValue in
                Task {
                    let data: Data? = try? await photosPickerItem?.loadTransferable(type: Data.self)
                    if let data = data {
                        if let uiImage = UIImage(data: data) {
                            file = uiImage
                            image = Image(uiImage: uiImage)
                            return
                        }
                    }
                }
            }
            
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@> MARK: STATUS SHEET
            // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
            
            .sheet(isPresented: $uploaded, onDismiss: {
                uploaded = false
            }, content: {
                if let image {
                    if let status {
                        CatImageUploadStatusView(image: image, status: status, uploaded: $uploaded)
                    } else {
                        Text("UPLOADED")
                    }
                }
            })
            
            // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#
            // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(# MARK: ERROR ALERT
            // (#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#)(#
            
            .alert(isPresented: $vjotErrorThrown, error: vjotError) { _ in
                Button("OK", role: .cancel) {}
            } message: { error in
                // Text(error.recoverySuggestion ?? "Try again later.")
                if let failureReason = error.failureReason {
                    Text(failureReason)
                }
            }
            
            // /////////////////////////////////////////////////////////////////////
            // ///////////////////////////////////////////////// MARK: PROGRESS VIEW
            // /////////////////////////////////////////////////////////////////////
            
            if uploading {
//                Circle()
                Rectangle()
                    .padding()
//                    .foregroundColor(Color(uiColor: UIColor.systemBackground).opacity(0))
//                    .frame(maxWidth: 200, maxHeight: 200)
                    .foregroundColor(Color.clear)
                    .overlay {
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(Color.primary, lineWidth: 5)
                            .frame(width: 100, height: 100)
                            .rotationEffect(Angle(degrees: rotating ? 360 : 0 ))
                            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: rotating)
                            .scaleEffect(scaling ? 0.5 : 1.2)
                            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: scaling)
                            .onAppear {
                                rotating = true
                                scaling = true
                            }
                            .onDisappear {
                                rotating = false
                                scaling = false
                            }
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

// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][% MARK: SEARCH OPTIONS VIEW
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][

struct CatImageUploadStatusView: View {
    var image: Image
    var status: APIImageUploadStatus
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var uploaded: Bool
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ZStack(alignment: .center) {
            
            // ----------------------------------------------------------------
            // FOREGROUND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // ----------------------------------------------------------------
            
            ScrollView {
                
                // ------------------------------------------------------------
                // CONTENT ////////////////////////////////////////////////////
                // ------------------------------------------------------------
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: TITLE
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                VStack(spacing: -10) {
                    Text("upload")
                    Text("status")
                }
                .font(.title)
                .padding()
                
                VStack(alignment: .center) {
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: ID
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    
                    VStack(spacing: 2) {
                        
                        // <|><|><|><|>
                        // URL |><|><|>
                        // <|><|><|><|>
                        
                        HStack(spacing: 5) {
                            Text("url:")
                                .foregroundColor(Color.secondary)
                                .font(.caption)
                            Text(status.url.absoluteString)
                                .foregroundColor(Color.primary)
                                .font(.caption)
                        }
                        
                        // <|><|><|><|>
                        // SUBID <|><|>
                        // <|><|><|><|>
                        
                        if let subId = status.subId {
                            HStack(spacing: 5) {
                                Text("user:")
                                    .foregroundColor(Color.secondary)
                                    .font(.caption)
                                Text(subId.uuidString)
                                    .foregroundColor(Color.primary)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding()
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: IMAGE
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                    
                    Image("staircase")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.primary)
                        .frame(maxWidth: 80, maxHeight: 80)
                        .padding()
                    
                    VStack(alignment: .vjotBreedH) {
                        
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][ MARK: STATUS
                        // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                        // (§)(§)(§)(§)(§)(§)($)(
                        // ID ($)(§)(§)(§)($)($)(
                        // (§)(§)(§)(§)(§)(§)($)(
                        
                        HStack {
                            Text("id:")
                                .foregroundColor(Color.secondary)
                            Text(status.id)
                                .foregroundColor(Color.primary)
                                .alignmentGuide(.vjotBreedH) { $0[.leading] }
                        }
                        
                        // (§)(§)(§)(§)(§)(§)($)(
                        // WIDTH ($)(§)(§)(§)($)(
                        // (§)(§)(§)(§)(§)(§)($)(
                        
                        if let width = status.width {
                            HStack {
                                Text("width:")
                                    .foregroundColor(Color.secondary)
                                Text(String(width))
                                    .foregroundColor(Color.primary)
                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                                Text("pixels")
                                    .foregroundColor(Color.secondary)
                            }
                        }
                        
                        // (§)(§)(§)(§)(§)(§)($)(
                        // HEIGHT $)(§)(§)(§)($)(
                        // (§)(§)(§)(§)(§)(§)($)(
                        
                        if let height = status.height {
                            HStack {
                                Text("height:")
                                    .foregroundColor(Color.secondary)
                                Text(String(height))
                                    .foregroundColor(Color.primary)
                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                                Text("pixels")
                                    .foregroundColor(Color.secondary)
                            }
                        }
                        
                        // (§)(§)(§)(§)(§)(§)($)(
                        // FILENAME ($)(§)(§)($)(
                        // (§)(§)(§)(§)(§)(§)($)(
                        
                        if let filename = status.originalFilename {
                            HStack {
                                Text("filename:")
                                    .foregroundColor(Color.secondary)
                                Text(filename)
                                    .foregroundColor(Color.primary)
                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                            }
                        }
                        
                        // (§)(§)(§)(§)(§)(§)($)(
                        // PENDING )($)(§)(§)($)(
                        // (§)(§)(§)(§)(§)(§)($)(
                        
                        HStack {
                            Text("pending:")
                                .foregroundColor(Color.secondary)
                            if status.pending {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.green)
                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                            } else {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.red)
                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                            }
                        }
                        
                        // (§)(§)(§)(§)(§)(§)($)(
                        // APPROVED ($)(§)(§)($)(
                        // (§)(§)(§)(§)(§)(§)($)(
                        
                        HStack {
                            Text("approved:")
                                .foregroundColor(Color.secondary)
                            if status.approved {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.green)
                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                            } else {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.red)
                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // --------------------------------------------------------------------
            // MODIFIERS //////////////////////////////////////////////////////////
            // --------------------------------------------------------------------
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: BACKGROUND
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
            
            .background {
                image
                    .resizable()
                    .overlay(.thinMaterial)
                    .aspectRatio(contentMode: .fill)
                    .brightness(colorScheme == .light ? 0.1 : -0.1)
            }
            
            // ----------------------------------------------------------------
            // MARK: BACKGROUND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // ----------------------------------------------------------------
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        uploaded = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .padding()
                    }
                }
                
                // //////////
                // SPACER ///
                // //////////
                
                Spacer()
            }
        }
    }
}


// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatImageUploadView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageUploadView()
//    }
//}
