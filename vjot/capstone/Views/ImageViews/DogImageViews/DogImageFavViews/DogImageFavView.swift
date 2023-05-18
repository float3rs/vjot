//
//  DogImageFavView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 20/4/23.
//

import SwiftUI

struct DogImageFavView: View {
    var body: some View {
        DogImageFavListView()
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct DogImageFavListView: View {
    
    @State var favourites: [DogAPIFavourite] = []
    @State var dict: [UUID: [DogAPIFavourite]] = [:]
    
    @State var noFavs: Bool = false
    @State var loaded: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var favouriteEngine: FavouriteEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        
        // --------------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        ZStack {
            
            // -?-?-?-?-?-?-?-?-?-?-?-?
            // LOADING TAKES A WHILE -?
            // -?-?-?-?-?-?-?-?-?-?-?-?
            
            if !loaded {
                Image("dogFunny")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.secondary)
                    .frame(maxWidth: 200, maxHeight: 200)
                
            } else {
                
                if noFavs {
                    
                    // ::::::::::::::::::::::::::
                    // NO FAVS IN SANDBOX :::::::
                    // ::::::::::::::::::::::::::
                    
                    FavFallbackView(forSpecies: .forDogs, forCurrent: false)
                    
                } else {
                    
                    // ::::::::::::::::::::::::::
                    // OK FAVS IN SANDBOX :::::::
                    // ::::::::::::::::::::::::::
                    
                    if let currentId = veterinarianGig.currentId {
                        
                        // {}{}{}{}{}{}{}{}{}{}
                        // IF SIGNED IN }{}{}{}
                        // {}{}{}{}{}{}{}{}{}{}
                        
                        
                        if let favs = dict[currentId] {
                            
                            // ^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§
                            // CHECK IF CURRENT USER HAS FAVS §^§^§^§
                            // ^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§
                            
                            List {
                                
                                // -><--><--><-
                                // LOOP ><--><-
                                // -><--><--><-
                                
                                ForEach(favs, id: \.id) { fav in
                                    
                                    // */*/*/*/*/*/*/*/*/*/*/*/*/
                                    // BEWARE OF CASE 73051 /*/*/
                                    // */*/*/*/*/*/*/*/*/*/*/*/*/
                                    
                                    NavigationLink {
                                        DogImageFavListElementContentView(favourite: fav, veterinarianId: currentId)
                                    } label: {
                                        DogImageFavListElementView(favourite: fav)
                                    }
                                }
                            }
                            
                        } else {
                            
                            // ^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§
                            // IF CURRENT USER HAS NO FAVS ^§^§^§^§^§
                            // ^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§
                            
                            FavFallbackView(forSpecies: .forDogs, forCurrent: true)
                        }
                        
                    } else {
                        
                        // {}{}{}{}{}{}{}{}{}{}
                        // IF SIGNED OUT {}{}{}
                        // {}{}{}{}{}{}{}{}{}{}
                        
                        FavCalloutView()
                    }
                }
            }
        }
        
        
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
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: FETCH FAVOURITES
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .task {
            do {
                favourites = try await favouriteEngine.fetchDogs(imageId: nil, subId: nil)
                dict = favouriteEngine.dictDogs(favourites: favourites)
                loaded = true
            } catch {
                print(error.localizedDescription)
                // VJotError ////////////////////
                vjotError = VJotError.error(error)
                vjotErrorThrown.toggle()
            }
        }
        
    }
    
    // ------------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////////
    // ------------------------------------------------------------------------
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST ELEMENT
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct DogImageFavListElementView: View {
    var favourite: DogAPIFavourite
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // ----------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: IMAGE SECTION
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
            
            
            if let image = favourite.image {
                
                // ::::::::::::::::::::::::::::::
                // IF IMAGE (AMBIGUOUS SPEC) ::::
                // ::::::::::::::::::::::::::::::
                
                AsyncImage(url: image.url) { phase in
                    switch phase {
                        
                        // ------------
                        // EMPTY //////
                        // ------------
                        
                    case .empty:
                        ProgressView()
                            .padding(.horizontal)
                        
                        // ------------
                        // SUCCESS ////
                        // ------------
                        
                    case .success(let returnedImage):
                        Rectangle()
                            .foregroundColor(Color(uiColor: UIColor.systemBackground))
                            .cornerRadius(15)
                            .aspectRatio(
                                calculateRatio(width: image.width, height: image.height),
                                contentMode: .fit
                            )
                            .overlay {
                                returnedImage
                                    .resizable()
                                    .scaledToFill()
                                    .overlay(.ultraThinMaterial)
                                    .brightness(colorScheme == .light ? 0.1 : -0.1)
                                    .clipped()
                                    .cornerRadius(15)
                            }
                            .clipShape(Rectangle())
                        
                        // ------------
                        // FAILURE ////
                        // ------------
                        
                    case .failure(_):
                        Rectangle()
                            .aspectRatio(
                                1,
                                contentMode: .fit
                            )
                            .overlay {
                                Image("sloth")
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .background()
                            }
                            .clipShape(Rectangle())
                        
                        // ------------
                        // DEFAULT ////
                        // ------------
                        
                    default:
                        fatalError()
                    }
                }
                
            } else {
                
                // ::::::::::::::::::::::::::::::
                // IF NO IMAGE (CASE 73051) :::::
                // ::::::::::::::::::::::::::::::
                
                Rectangle()
                    .aspectRatio(
                        1,
                        contentMode: .fit
                    )
                    .overlay {
                        Image("sloth")
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .background()
                    }
                    .clipShape(Rectangle())
            }
            
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: OVERLAY SECTION
            // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
            
            HStack(alignment: .bottom) {
                
                // %|%|%|%|%|%|%|%|%|%|
                // PUSH TO BOTTOM |%|%|
                // %|%|%|%|%|%|%|%|%|%|
                
                Spacer()
                VStack(alignment: .trailing) {
                    
                    // %|%|%|%|%|%|%|%|%|%|%|%|%|
                    // PUSH TO TRAILING |%|%|%|%|
                    // %|%|%|%|%|%|%|%|%|%|%|%|%|
                    
                    Spacer()
                    VStack(alignment: .vjotFavH) {
                        HStack {
                            Text("id:")
                                .foregroundColor(Color.secondary)
                            Text(String(favourite.id))
                                .foregroundColor(Color.secondary)
                                .alignmentGuide(.vjotFavH) { $0[.leading] }
                        }
                        HStack {
                            Text("date:")
                                .foregroundColor(Color.secondary)
                            Text(favourite.createdAt.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                .foregroundColor(Color.secondary)
                                .alignmentGuide(.vjotFavH) { $0[.leading] }
                        }
                    }
                    .padding(5)
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
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][ MARK: LIST ELEMENT CONTENT
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][

struct DogImageFavListElementContentView: View {
    var favourite: DogAPIFavourite
    var veterinarianId: UUID
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine
    @EnvironmentObject var imageEngine: ImageEngine
    @EnvironmentObject var favouriteEngine: FavouriteEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var image: DogAPIImage = DogAPIImage(id: UUID().uuidString)
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ScrollView {
            
            // --------------------------------------------------------------------
            // CONTENT ////////////////////////////////////////////////////////////
            // --------------------------------------------------------------------
            
            VStack {
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: TITLE
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                
                VStack(spacing: -10) {
                    Text("a dog faved")
                    
                    if veterinarianId == veterinarianGig.currentId {
                        
                        // ::::::::::::::::::::::::::::
                        // IF CURRENT USER ::::::::::::
                        // ::::::::::::::::::::::::::::
                        
                        HStack {
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Text("...by you!")
                                .foregroundColor(Color.secondary)
                                .padding(.trailing)
                            Spacer()
                            Spacer()
                        }
                        
                    } else {
                        
                        // ::::::::::::::::::::::::::::
                        // IF NOT CURRENT USER ::::::::
                        // ::::::::::::::::::::::::::::
                        
                        if let veterinarian = veterinarianGig.track(currentId: veterinarianId) {
                            
                            // :-:-:-:-:-:-:-:-:-:-:-:-
                            // IF STORED USER -:-:-:-:-
                            // :-:-:-:-:-:-:-:-:-:-:-:-
                            
                            HStack {
                                Spacer()
                                Spacer()
                                Spacer()
                                Text("...by \(veterinarian.name)")
                                    .foregroundColor(Color.secondary)
                                    .padding(.trailing)
                                Spacer()
                            }
                            
                        } else {
                            
                            // :-:-:-:-:-:-:-:-:-:-:-:-
                            // IF UNKNOWN USER :-:-:-:-
                            // :-:-:-:-:-:-:-:-:-:-:-:-
                            
                            HStack {
                                Spacer()
                                Spacer()
                                Spacer()
                                Text("...by someone unknown")
                                    .foregroundColor(Color.secondary)
                                    .padding(.trailing)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    // [/][/][/][/][/][
                    // THE INTERVAL /][
                    // [/][/][/][/][/][
                    
                    VStack(spacing: -8) {
                        Text("approximately")
                        Text("\(interval(date: favourite.createdAt)) ago")
                    }
                    .foregroundColor(Color.primary)
                    .font(.title3)
                    .padding(5)
                    
                }
                .font(.title)
                .padding()
                
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: SECTION
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                
                DogSectionView(image: image, uploaded: false)
                
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)( MARK: FAV DETAILS
                // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                
                DogFavDetailsView(favourite: favourite)
            }
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: FETCH IMAGE
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .task {
            do {
                image = try await imageEngine.fetchDog(
                    imageId: favourite.imageId,
                    subId: veterinarianGig.currentId?.uuidString,
                    size: nil
                )
            } catch {
                print(error.localizedDescription)
                // VJotError ////////////////////
                vjotError = VJotError.error(error)
                vjotErrorThrown.toggle()
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: TOOLBAR
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
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
        
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@ MARK: BACKGROUND
        // <@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><@><
        
        .background {
            AsyncImage(url: image.url) { phase in
                switch phase {
                    
                    // ------------
                    // EMPTY //////
                    // ------------
                    
                case .empty:
                    EmptyView()
                    
                    // ------------
                    // SUCCESS ////
                    // ------------
                    
                case .success(let returnedImage):
                    returnedImage
                        .resizable()
                        .overlay(.thinMaterial)
                        .aspectRatio(contentMode: .fill)
                        .brightness(colorScheme == .light ? 0.1 : -0.1)
                    
                    // ------------
                    // FAILURE ////
                    // ------------
                    
                case .failure:
                    Color.clear
                    
                    // ------------
                    // DEFAULT ////
                    // ------------
                    
                default:
                    fatalError()
                }
            }
        }
        
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
    }
    
    // --------------------------------------------------------------------
    // FUNCTIONS //////////////////////////////////////////////////////////
    // --------------------------------------------------------------------
    
    func interval(date: Date) -> String {
        
        let formatter = DateComponentsFormatter()
        
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .spellOut
        formatter.zeroFormattingBehavior = .dropAll
        
        let elapsed = Date().timeIntervalSince(date)
        guard let interval = formatter.string(from: elapsed) else { return "" }
        return interval
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogImageFavView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogImageFavView()
//    }
//}
