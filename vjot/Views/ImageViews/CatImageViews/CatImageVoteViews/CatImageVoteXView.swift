//
//  CatImageVoteXView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 23/4/23.
//

import SwiftUI

struct CatImageVoteXView: View {
    var body: some View {
        CatImageVoteXListView()
    }
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct CatImageVoteXListView: View {
    
    @State var votes: [CatAPIVote] = []
    @State var dict: [UUID: [CatAPIVote]] = [:]
    
    @State var noFavs: Bool = false
    @State var loaded: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var voteEngine: VoteEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        
        // ----------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////
        // ----------------------------------------------------------------
        
        ZStack {
            
            // -?-?-?-?-?-?-?-?-?-?-?-?
            // LOADING TAKES A WHILE -?
            // -?-?-?-?-?-?-?-?-?-?-?-?
            
            if !loaded {
                Image("catFunny")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.secondary)
                    .frame(maxWidth: 200, maxHeight: 200)
                
            } else {
                
                if noFavs {
                    
                    // ::::::::::::::::::::::::::
                    // NO FAVS IN SANDBOX :::::::
                    // ::::::::::::::::::::::::::
                    
                    VoteFallbackView(forSpecies: .forCats, forCurrent: false)

                } else {
                    
                    // ::::::::::::::::::::::::::
                    // OK FAVS IN SANDBOX :::::::
                    // ::::::::::::::::::::::::::
                    
                    
                    List {
                        
                        // -><--><--><-
                        // LOOP ><--><-
                        // -><--><--><-
                        
                        ForEach(Array(dict.keys), id: \.self) { uuid in
                            
                            // {}{}{}{}{}{}{}{}{}{}
                            // FIND WHO FAVED }{}{}
                            // UUID IF UNKNOWN {}{}
                            // {}{}{}{}{}{}{}{}{}{}
                            
                            Section(header: Text(veterinarianGig.track(currentId: uuid)?.name ?? "unknown")) {
                                
                                // ^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§
                                // EVERY USER HAS ITS OWN HEADER, RETRIEVE FAVS
                                // ^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§^§
                                
                                if let votes = dict[uuid] {
                                    
                                    // -><--><--><-
                                    // LOOP ><--><-
                                    // -><--><--><-
                                    
                                    ForEach(votes, id: \.id) { vote in
                                        
                                        // */*/*/*/*/*/*/*/*/*/*/*/*/
                                        // BEWARE OF CASE 73051 /*/*/
                                        // */*/*/*/*/*/*/*/*/*/*/*/*/
                                        
                                        NavigationLink {
                                            CatImageVoteXListElementContentView(
                                                vote: vote,
                                                veterinarianId: uuid
                                            )
                                        } label: {
                                            CatImageVoteXListElementView(vote: vote)
                                        }
                                    }
                                }
                            }
                        }
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
                    Label("BACK TO CATS", systemImage: "photo.on.rectangle")
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: FETCH FAVOURITES
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .task {
            do {
                votes = try await voteEngine.fetchCats(subId: nil)
                
                // ::::::::::
                // NO FAVS ::
                // ::::::::::
                
                if votes.isEmpty { noFavs.toggle() }
                
                // ::::::::::
                // FAVS :::::
                // ::::::::::
                
                dict = voteEngine.dictCats(votes: votes)
                
                // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
                // LOADING TAKES A WHILE {}{}{}{}
                // {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
                
                loaded = true
            } catch {
                print(error.localizedDescription)
                // VJotError ////////////////////
                vjotError = VJotError.error(error)
                vjotErrorThrown.toggle()
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
}

// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{ MARK: LIST ELEMENT
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}
// {}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}

struct CatImageVoteXListElementView: View {
    var vote: CatAPIVote
    
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
            
            if let image = vote.image {
                
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
                            Text(String(vote.id))
                                .foregroundColor(Color.secondary)
                                .alignmentGuide(.vjotFavH) { $0[.leading] }
                        }
                        if let createdAt = vote.createdAt {
                            HStack {
                                Text("date:")
                                    .foregroundColor(Color.secondary)
                                
                                // [][][][][][][][][][][][][][]
                                // ISO FORMAT BECAUSE COOL [][]
                                // [][][][][][][][][][][][][][]
                                
                                
                                Text(createdAt.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                    .foregroundColor(Color.secondary)
                                    .alignmentGuide(.vjotFavH) { $0[.leading] }
                            }
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

struct CatImageVoteXListElementContentView: View {
    var vote: CatAPIVote
    var veterinarianId: UUID
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var imageEngine: ImageEngine
    @EnvironmentObject var voteEngine: VoteEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var image: CatAPIImage = CatAPIImage(id: UUID().uuidString)
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        VStack {
            ScrollView {
                
                // --------------------------------------------------------------------
                // CONTENT ////////////////////////////////////////////////////////////
                // --------------------------------------------------------------------
                
                VStack {
                    
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: TITLE
                    // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*
                    
                    VStack(spacing: -10) {
                        Text("a cat voted")
                        
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
                        
                        if let createdAt = vote.createdAt {
                            VStack(spacing: -8) {
                                Text("approximately")
                                Text("\(interval(date: createdAt)) ago")
                            }
                            .foregroundColor(Color.primary)
                            .font(.title3)
                            .padding(5)
                        }
                        
                    }
                    .font(.title)
                    .padding()
                    
                    // ----------------------------------------------------------------
                    // DEVELOPMENT MODE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                    // ----------------------------------------------------------------
                    
                    Group {
                        if veterinarianGig.track(currentId: veterinarianId) == nil {
                            Button {
                                Task {
                                    do {
                                        let _ = try await voteEngine.deleteCat(
                                            voteId: vote.id
                                        )
                                        dismiss()
                                    } catch let error {
                                        print(error.localizedDescription)
                                        // VJotError ////////////////////
                                        vjotError = VJotError.error(error)
                                        vjotErrorThrown.toggle()
                                    }
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.red)
                                    .font(.title3)
                            }
                            .buttonStyle(.bordered)
                            .padding(.bottom)
                        }
                    }
                    
                    // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                    // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: SECTION
                    // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                    
                    CatSectionView(image: image, uploaded: false)
                    
                    // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                    // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)( MARK: FAV DETAILS
                    // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(
                    
                    CatVoteDetailsView(vote: vote)
                }
            }
            
            // ----------------------------------------------------------------
            // FOOTER /////////////////////////////////////////////////////////
            // ----------------------------------------------------------------
            
            Spacer()
            WarningVetFooterView()
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: FETCH IMAGE
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .task {
            do {
                image = try await imageEngine.fetchCat(
                    imageId: vote.imageId,
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

//struct CatImageVoteXView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageVoteXView()
//    }
//}
