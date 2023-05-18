//
//  DogBreedView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import SwiftUI
import MapKit

struct DogBreedView: View {
    var dogBreed: DogAPIBreed
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var router: Router
    
    @State var image: DogAPIImage? = nil
    
    @State var invalidLocation: Bool = false
    @State var analyses: [APIAnalysis] = []
    @State var goAnalyse: Bool = false
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        
        // --------------------------------------------------------------------
        // CONTENT ////////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        ScrollView{
            VStack {
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: THE NAME
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                HStack(alignment: .center) {
                    Text(dogBreed.name)
                        .foregroundColor(Color.primary)
                        .font(.title)
                }
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: THE IMAGE
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                if let image {
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    
                    
                    VStack(alignment: .center, spacing: 2) {
                        AsyncImage(url: image.url) { phase in
                            switch phase {
                                
                                // ------------------
                                // EMPTY ////////////
                                // ------------------
                                
                            case .empty:
                                ProgressView()
                                
                                // ------------------
                                // SUCCESS //////////
                                // ------------------
                                
                            case .success(let returnedImage):
                                returnedImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                
                                // ------------------
                                // FAILURE //////////
                                // ------------------
                                
                            case .failure(_):
                                Image("sloth")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaledToFill()
                                    .clipped()
                                    .background()
                                
                                // ------------------
                                // DEFAULT //////////
                                // ------------------
                                
                            default:
                                fatalError()
                            }
                        }
                        
                        // <|><|><|><|><|><
                        // TAP |><|><|><|><
                        // <|><|><|><|><|><
                        
                        .onTapGesture { goAnalyse.toggle() }
                        
                        // <|><|><|><|><|><
                        // CAPTION ><|><|><
                        // <|><|><|><|><|><
                        
                        if let width = image.width {
                            if let height = image.height  {
                                HStack(spacing: 8) {
                                    HStack(spacing: 4) {
                                        Text("image id:")
                                            .foregroundColor(Color.secondary)
                                        Text(image.id)
                                            .foregroundColor(Color.primary)
                                    }
                                    .font(.caption)
                                    HStack(spacing: 4) {
                                        Text("resolution:")
                                            .foregroundColor(Color.secondary)
                                        HStack(spacing: 0) {
                                            Text("(")
                                                .foregroundColor(Color.secondary)
                                            Text(String(width))
                                                .foregroundColor(Color.primary)
                                            Text(" x ")
                                                .foregroundColor(Color.secondary)
                                            Text(String(height))
                                                .foregroundColor(Color.primary)
                                            Text(")")
                                                .foregroundColor(Color.secondary)
                                        }
                                    }
                                    .font(.caption)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                    // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                    // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                }
                
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*] MARK: THE DETAILS
                // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*]
                
                VStack(alignment: .center, spacing: 0) {
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: DESCRIPTION
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if let description = dogBreed.description {
                        VStack {
                            Text("description")
                                .foregroundColor(Color.secondary)
                                .font(.headline)
                            Text(description)
                                .foregroundColor(Color.primary)
                                .multilineTextAlignment(.leading)
                                .font(.body)
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: NAVIGATION
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    DogBreedNavLinkView(dogBreed: dogBreed)
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: BREED SECTION
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if dogBreed.bredFor != nil || dogBreed.breedGroup != nil {
                        VStack {
                            
                            // <|><|><|><|><|><|>
                            // BREED GROUP <|><|>
                            // <|><|><|><|><|><|>
                            
                            if let breedGroup = dogBreed.breedGroup {
                                HStack {
                                    Text("breed group:")
                                        .foregroundColor(Color.secondary)
                                    Text(breedGroup)
                                        .foregroundColor(Color.primary)
                                }
                                .padding(.bottom)
                            }
                            
                            // <|><|><|><|><|><|>
                            // BRED FOR <|><|><|>
                            // <|><|><|><|><|><|>
                            
                            if let bredFor = dogBreed.bredFor {
                                if bredFor[0] != "" {
                                    VStack {
                                        Text("bred for")
                                            .foregroundColor(Color.secondary)
                                        ForEach(bredFor, id: \.self) { reason in
                                            Text(reason)
                                                .foregroundColor(Color.primary)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .multilineTextAlignment(.leading)
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: HISTORY
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if let history = dogBreed.history {
                        if !history.isEmpty {
                            HStack(alignment: .center) {
                                Text("history:")
                                    .foregroundColor(Color.secondary)
                                Text(history)
                                    .foregroundColor(Color.primary)
                            }
                            .font(.body)
                            .padding(.horizontal)
                            .padding(.bottom)
                            Divider()
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: LIFESPAN
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if let lifespan = dogBreed.lifeSpan {
                        HStack {
                            Text("lifespan:")
                                .foregroundColor(Color.secondary)
                            Text(String(lifespan.lowerBound))
                            Text("-")
                                .foregroundColor(Color.secondary)
                            Text(String(lifespan.upperBound))
                            Text("(years)")
                                .font(.footnote)
                                .foregroundColor(Color.secondary)
                        }
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: TEMPERAMENT
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if let temperament = dogBreed.temperament {
                        VStack {
                            Text("temperament")
                                .font(.body)
                                .foregroundColor(Color.secondary)
                            ForEach(temperament, id: \.self) { trait in
                                Text(trait)
                                    .foregroundColor(Color.primary)
                            }
                        }
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(- MARK: LOCATION
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if dogBreed.origin != nil || dogBreed.countryCode != nil {
                        VStack (spacing: 0) {
                            
                            // <|><|><|><|><|><|>
                            // ORIGINS ><|><|><|>
                            // <|><|><|><|><|><|>
                            
                            if let origin = dogBreed.origin {
                                if !origin.isEmpty {
                                    
                                    // ::::::::::::::::
                                    // IF SOME ::::::::
                                    // ::::::::::::::::
                                    
                                    HStack {
                                        Text("origin:")
                                            .foregroundColor(Color.secondary)
                                        HStack(spacing: 2) {
                                            Text("[")
                                                .foregroundColor(Color.secondary)
                                            
                                            // //////////////////
                                            // FOR EACH /////////
                                            // //////////////////
                                            
                                            ForEach(origin, id: \.self) { code in
                                                Text(code)
                                                    .foregroundColor(Color.primary)
                                                if code != origin.last {
                                                    Text("|")
                                                        .foregroundColor(Color.secondary)
                                                } else {
                                                    Text("]")
                                                        .foregroundColor(Color.secondary)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // <|><|><|><|><|><|>
                            // COUNTRY CODE |><|>
                            // <|><|><|><|><|><|>
                            
                            if let countryCode = dogBreed.countryCode {
                                VStack {
                                    HStack {
                                        Text("country code:")
                                            .foregroundColor(Color.secondary)
                                        Text(countryCode)
                                            .foregroundColor(Color.primary)
                                    }
                                    
                                    // [][][][][][][][][][][][][][][][][][][][]
                                    // [][][][][][][][][][][][][][][] MARK: MAP
                                    // [][][][][][][][][][][][][][][][][][][][]
                                    
                                    if let chosenLocation = chooseLocation() {
                                        
                                        // ::::::::::::::::
                                        // IF LOCATION ::::
                                        // ::::::::::::::::
                                        
                                        Button {
                                            let geocoder = CLGeocoder()
                                            geocoder.geocodeAddressString(chosenLocation) { (placemarks, error) in
                                                
                                                // ------------------
                                                // ERROR ////////////
                                                // ------------------
                                                
                                                if let error {
                                                    print(error.localizedDescription)
                                                    invalidLocation.toggle()
                                                }
                                                
                                                // ------------------
                                                // FOUND ////////////
                                                // ------------------
                                                
                                                if let placemarks {
                                                    let distance: CLLocationDistance = 10240000
                                                    if let coordinate: CLLocationCoordinate2D = placemarks.first?.location?.coordinate {
                                                        
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        // REGION }{}{}{}{}{}{}
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        
                                                        let region = MKCoordinateRegion(
                                                            center: coordinate,
                                                            latitudinalMeters: distance,
                                                            longitudinalMeters: distance
                                                        )
                                                        
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        // OPTIONS }{}{}{}{}{}{
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        
                                                        let options = [
                                                            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                                                            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
                                                        ]
                                                        
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        // PLACEMARK {}{}{}{}{}
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        
                                                        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                                                        
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        // ITEM }{}{}{}{}{}{}{}
                                                        // {}{}{}{}{}{}{}{}{}{}
                                                        
                                                        let mapItem = MKMapItem(placemark: placemark)
                                                        
                                                        mapItem.name = chosenLocation
                                                        mapItem.openInMaps(launchOptions: options)
                                                    }
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "map")
                                                .font(.headline)
                                        }
                                        .foregroundColor(Color.primary)
                                        .buttonStyle(.bordered)
                                        .padding()
                                    }
                                }
                            }
                        }
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                    
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: BODY
                    // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                    
                    if (dogBreed.height != nil) || (dogBreed.weight != nil) {
                        VStack(alignment: .vjotBreedH) {
                            
                            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            // HEIGHT /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            
                            if let height = dogBreed.height {
                                HStack(alignment: .center) {
                                    
                                    // ||||||||||||||||||||
                                    // LABEL ||||||||||||||
                                    // ||||||||||||||||||||
                                    
                                    Text("height:")
                                        .foregroundColor(Color.secondary)
                                    
                                    // ||||||||||||||||||||
                                    // NUMBERS ||||||||||||
                                    // ||||||||||||||||||||
                                    
                                    VStack(alignment: .vjotBreedH) {
                                        
                                        // ~@~@~@~@~@~@
                                        // METRIC @~@~@
                                        // ~@~@~@~@~@~@
                                        
                                        if let metric = height.metric {
                                            HStack(alignment: .center) {
                                                Text(String(metric.lowerBound))
                                                Text("-")
                                                    .foregroundColor(Color.secondary)
                                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                                                Text(String(metric.upperBound))
                                                Text("(cm)")
                                                    .font(.footnote)
                                                    .foregroundColor(Color.secondary)
                                            }
                                        }
                                        
                                        // ~@~@~@~@~@~@
                                        // IMPERIAL @~@
                                        // ~@~@~@~@~@~@
                                        
                                        if let imperial = height.imperial {
                                            HStack(alignment: .center) {
                                                Text(String(imperial.lowerBound))
                                                Text("-")
                                                    .foregroundColor(Color.secondary)
                                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                                                Text(String(imperial.upperBound))
                                                Text("(in)")
                                                    .font(.footnote)
                                                    .foregroundColor(Color.secondary)
                                            }
                                        }
                                    }
                                    .foregroundColor(Color.primary)
                                }
                                .font(.body)
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                        
                            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            // WEIGHT /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                            
                            if let weight = dogBreed.weight {
                                HStack(alignment: .center) {
                                    
                                    // ||||||||||||||||||||
                                    // LABEL ||||||||||||||
                                    // ||||||||||||||||||||
                                    
                                    Text("weight:")
                                        .foregroundColor(Color.secondary)
                                    
                                    // ||||||||||||||||||||
                                    // NUMBERS ||||||||||||
                                    // ||||||||||||||||||||
                                    
                                    VStack(alignment: .vjotBreedH) {
                                        
                                        // ~@~@~@~@~@~@
                                        // METRIC @~@~@
                                        // ~@~@~@~@~@~@
                                        
                                        if let metric = weight.metric {
                                            HStack(alignment: .center) {
                                                Text(String(metric.lowerBound))
                                                Text("-")
                                                    .foregroundColor(Color.secondary)
                                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                                                Text(String(metric.upperBound))
                                                Text("(kg)")
                                                    .font(.footnote)
                                                    .foregroundColor(Color.secondary)
                                            }
                                        }
                                        
                                        // ~@~@~@~@~@~@
                                        // IMPERIAL @~@
                                        // ~@~@~@~@~@~@
                                        
                                        if let imperial = weight.imperial {
                                            HStack(alignment: .center) {
                                                Text(String(imperial.lowerBound))
                                                Text("-")
                                                    .foregroundColor(Color.secondary)
                                                    .alignmentGuide(.vjotBreedH) { $0[.leading] }
                                                Text(String(imperial.upperBound))
                                                Text("(lb)")
                                                    .font(.footnote)
                                                    .foregroundColor(Color.secondary)
                                            }
                                        }
                                    }
                                    .foregroundColor(Color.primary)
                                }
                                .font(.body)
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                        }
                    }
                    Divider()
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                    // <><><><><><><><><><><><><><><><><><><><>< MARK: FALLBACK
                    // <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                    
                    if (
                        dogBreed.weight == nil &&
                        dogBreed.height == nil &&
                        dogBreed.bredFor == nil &&
                        dogBreed.lifeSpan == nil &&
                        dogBreed.origin == nil &&
                        dogBreed.countryCode == nil &&
                        dogBreed.description == nil &&
                        dogBreed.history == nil
                    ) {
                        VStack{
                            Text("No details about this breed are available")
                            Text("Please consider carrying your own research")
                        }
                        .foregroundColor(Color.secondary)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                    }
                }
                .padding(.bottom)
            }
            
            Spacer()
            
            // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
            // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][* MARK: THE FOOTER
            // [*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][*][
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-) MARK: ID
            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-)
            
            HStack {
                Text("breed id:")
                    .foregroundColor(Color.secondary)
                Text(String(dogBreed.id))
                    .foregroundColor(Color.primary)
            }
            .font(.caption)
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // \!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!
        // \!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\! MARK: LOCATION ALERT
        // \!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!/\!
        
        .alert(Text("Invalid Location"), isPresented: $invalidLocation, actions: {
            
        }, message: {
            Text("\(dogBreed.countryCode ?? "ERROR") cannot be found on the map")
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
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: BACKGROUND
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .frame(maxWidth: .infinity)
        .background {
            
            if let image {
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                AsyncImage(url: image.url) { phase in
                    switch phase {
                        
                        // ------------------
                        // EMPTY ////////////
                        // ------------------
                        
                    case .empty:
                        EmptyView()
                        
                        // ------------------
                        // SUCCESS //////////
                        // ------------------
                        
                    case .success(let returnedImage):
                        returnedImage
                            .resizable()
                            .overlay(.thinMaterial)
                            .aspectRatio(contentMode: .fill)
                            .brightness(colorScheme == .light ? 0.1 : -0.1)
                        
                        // ------------------
                        // FAILURE //////////
                        // ------------------
                        
                    case .failure(_):
                        Color.clear
                        
                        // ------------------
                        // DEFAULT //////////
                        // ------------------
                        
                    default:
                        fatalError()
                    }
                }
            }
            
            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
            // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
            // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: TOOLBAR
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !router.pathBre.isEmpty {
                        router.pathBre.removeLast()
                    }
                } label: {
                    Label("BACK TO DOGS", systemImage: "books.vertical")
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+) MARK: PURE MAGIC
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .task {
            if let imageId = dogBreed.referenceImageId {
                do {
                    image = try await breedEngine.locateDog(
                        imageId: imageId,
                        veterinarianId: veterinarianGig.currentId
                    )
                } catch let error {
                    print(error.localizedDescription)
                    // VJotError ////////////////////////////
                    vjotError = VJotError.error(error)
                    vjotErrorThrown.toggle()
                }
            }
        }
        
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+ MARK: ANALYSIS SHEET
        // (+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+)(+
        
        .sheet(isPresented: $goAnalyse) {
            if let image {
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                
                DogAnalysisSheetView(image: image, goAnalyze: $goAnalyse)
                
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
                // \/\/\/ IMAGE OPTIONAL BINDING \/\/\/
                // \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
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
    
    // ------------------------------------------------------------------------
    
    func chooseLocation() -> String? {
        if let origin = dogBreed.origin {
            if !origin.isEmpty {
                return origin.first!
            }
        } else {
            if let countryCode = dogBreed.countryCode {
                return countryCode
            }
        }
        return nil
    }
}

// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: NAVIGATION LINK
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][
// [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][


struct DogBreedNavLinkView: View {
    var dogBreed: DogAPIBreed
    
    var body: some View {
        NavigationLink {
            DogBreedImagesView(dogBreed: dogBreed)
        } label: {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.title3)
                .foregroundColor(Color.primary)
        }
        .buttonStyle(.bordered)
        .padding()
        .padding(.horizontal)
        .padding(.bottom)
        Divider()
            .padding(.horizontal)
            .padding(.bottom)
    }
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct DogBreedView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogBreedView(dogBreed: DogAPIBreed(id: 1, name: "Affenpinscher", referenceImageId: "BJa4kxc4X"))
//    }
//}
