//
//  CatImageView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import SwiftUI

struct CatImageView: View {
    var image: CatAPIImage
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var breedEngine: BreedEngine
    @EnvironmentObject var categoryEngine: CategoryEngine

    @State var goAnalyze: Bool = false
    @Binding var deleted: Bool
    
    var body: some View {
        
        VStack(spacing: 2) {
            
            // <|><|><|><|><|><|><|
            // BREED/CATEGORY <|><|
            // <|><|><|><|><|><|><|
            // ////////////// BREED
            
            if let breeds = image.breeds {
                if !breeds.isEmpty {
                    HStack {
                        Text("breed:")
                            .foregroundColor(Color.secondary)
                        if let breedName = breedEngine.catCorrelate()[breeds[0].id] {
                            Text(breedName)
                        }
                    }
                    .font(.subheadline)
                }
            }
            
            // /////////// CATEGORY
            
            if let categories = image.categories {
                if !categories.isEmpty {
                    HStack {
                        Text("category:")
                            .foregroundColor(Color.secondary)
                        if let categoryName = categoryEngine.catCorrelate()[categories[0].id] {
                            Text(categoryName)
                        } else {
                            Text(categories[0].name)
                        }
                    }
                    .font(.subheadline)
                }
            }
            
            // <|><|><|><|><|><|><|
            // IMAGE <|><|><|><|><|
            // <|><|><|><|><|><|><|
            
            AsyncImage(url: image.url) { phase in
                switch phase {
                    
                    // ------------
                    // EMPTY //////
                    // ------------
                    
                case .empty:
                    ProgressView()
                    
                    // ------------
                    // SUCCESS ////
                    // ------------
                    
                case .success(let returnedImage):
                    Rectangle()
                        .cornerRadius(15)
                        .aspectRatio(
                            calculateRatio(width: image.width, height: image.height),
                            contentMode: .fit
                        )
                        .overlay {
                            switch deleted {
                            case true:
                                returnedImage
                                    .resizable()
                                    .scaledToFill()
                                    .saturation(0)
                                    .clipped()
                                    .brightness(colorScheme == .light ? 0.3 : -0.3)
                                    .cornerRadius(15)
                                    .overlay {
                                        Image("x0")
                                            .renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(colorScheme == .light ? Color.yellow : Color.red)
                                            .brightness(colorScheme == .light ? 0.5 : -0.5)
                                            .scaleEffect(3)
                                    }
                            case false:
                                returnedImage
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .cornerRadius(15)
                            }
                        }
                        .clipShape(Rectangle())
                        .padding(.horizontal, verticalSizeClass == .compact ? 100 : 0)
                    
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
                        .padding(.horizontal, verticalSizeClass == .compact ? 100 : 0)
                    
                    // ------------
                    // DEFAULT ////
                    // ------------
                    
                default:
                    fatalError()
                }
            }
            
            // <|><|><|><|><|><|><|
            // TAP |><|><|><|><|><|
            // <|><|><|><|><|><|><|
            
            .onTapGesture { goAnalyze.toggle() }
            
            // <|><|><|><|><|><|><|
            // CAPTION ><|><|><|><|
            // <|><|><|><|><|><|><|
            
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
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        
        .sheet(isPresented: $goAnalyze) {
            CatAnalysisSheetView(image: image, goAnalyze: $goAnalyze)
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

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// PREVIEW -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

//struct CatImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatImageView()
//    }
//}
