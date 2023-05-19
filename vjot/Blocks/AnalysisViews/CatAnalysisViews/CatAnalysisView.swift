//
//  CatAnalysisView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import SwiftUI

struct CatAnalysisView: View {
    var image: CatAPIImage
    
    @EnvironmentObject var analysisEngine: AnalysisEngine
    @State var analyses: [APIAnalysis] = []
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
    
            if !analysisEngine.analyses.isEmpty {
                
                // ::::::::::::::::::::::::::::::
                // IF ANALYSES FETCHED ::::::::::
                // ::::::::::::::::::::::::::::::
                
                ScrollView {
                    Text("analysis")
                        .font(.title)
                        .padding()
                    
                    Image("analysis")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.secondary)
                        .frame(maxWidth: 50, maxHeight: 50)
                        .padding()
                        .padding(.bottom)
                    
                    // <><><><><><><><>
                    // LOOP ><><><><><>
                    // <><><><><><><><>
                    
                    ForEach(analysisEngine.analyses, id: \.createdAt) { analysis in
                        VStack {
                            
                            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                            // [%][%][%][%][%][%][%][%][%][%][%][ MARK: DETAILS
                            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                            
                            VStack(alignment: .vjotAnalysisH) {
                                
                                // \/\/\/\/\/\/\/
                                // IMAGE ID /\/\/
                                // \/\/\/\/\/\/\/
                                
                                if let imageId = analysis.imageId {
                                    HStack {
                                        Text("id:")
                                            .foregroundColor(Color.secondary)
                                        Text(imageId)
                                            .foregroundColor(Color.primary)
                                            .alignmentGuide(.vjotAnalysisH) { $0[.leading] }
                                    }
                                    .font(.subheadline)
                                }
                                
                                // \/\/\/\/\/\/\/
                                // VENDOR /\/\/\/
                                // \/\/\/\/\/\/\/
                                
                                if let vendor = analysis.vendor {
                                    HStack {
                                        Text("vendor:")
                                            .foregroundColor(Color.secondary)
                                        Text(vendor)
                                            .foregroundColor(Color.primary)
                                            .alignmentGuide(.vjotAnalysisH) { $0[.leading] }
                                    }
                                    .font(.subheadline)
                                }
                                
                                // \/\/\/\/\/\/\/
                                // CREATED AT /\/
                                // \/\/\/\/\/\/\/
                                
                                HStack {
                                    Text("created:")
                                        .foregroundColor(Color.secondary)
                                    Text(analysis.createdAt.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: ""))
                                        .foregroundColor(Color.primary)
                                        .alignmentGuide(.vjotAnalysisH) { $0[.leading] }
                                }
                                .font(.subheadline)
                                
                                // \/\/\/\/\/\/\/
                                // APPROVED /\/\/
                                // \/\/\/\/\/\/\/
                                
                                if let approved = analysis.approved {
                                    HStack {
                                        Text("Approved: ")
                                            .foregroundColor(Color.secondary)
                                        Text(approved ? Image(systemName: "checkmark") : Image(systemName: "xmark"))
                                            .foregroundColor(approved ? Color.green : Color.red)
                                            .alignmentGuide(.vjotAnalysisH) { $0[.leading] }
                                    }
                                    .font(.subheadline)
                                }
                                
                                // \/\/\/\/\/\/\/
                                // REJECTED /\/\/
                                // \/\/\/\/\/\/\/
                                
                                if let rejected = analysis.rejected {
                                    HStack {
                                        Text("Rejected: ")
                                            .foregroundColor(Color.secondary)
                                        Text(rejected ? Image(systemName: "checkmark") : Image(systemName: "xmark"))
                                            .foregroundColor(rejected ? Color.red : Color.green)
                                            .alignmentGuide(.vjotAnalysisH) { $0[.leading] }
                                    }
                                    .font(.subheadline)
                                }
                            }
                            
                            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                            // [%][%][%][%][%][%][%][%][%][%][%][% MARK: LABELS
                            // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(
                            // MODERATION LABELS (-)(-)(-)(
                            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(
                            
                            if !analysis.moderationLabels.isEmpty {
                                VStack {
                                    Text("moderation labels")
                                        .font(.headline)
                                        .foregroundColor(Color.secondary)
                                        .padding(.vertical)
                                    
                                    // <><><><><>
                                    // LOOP ><><>
                                    // <><><><><>
                                    
                                    ForEach(analysis.moderationLabels, id: \.name) { moderationLabel in
                                        AnalysisLabelView(label: moderationLabel)
                                        if moderationLabel.name != analysis.moderationLabels.last!.name {
                                            Divider()
                                                .padding()
                                        }
                                    }
                                }
                                .padding()
                            }
                            
                            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(
                            // LABELS -)(-)(-)(-)(-)(-)(-)(
                            // (-)(-)(-)(-)(-)(-)(-)(-)(-)(
                            
                            if !analysis.labels.isEmpty {
                                VStack {
                                    Text("labels")
                                        .font(.headline)
                                        .foregroundColor(Color.secondary)
                                        .padding(.vertical)
                                    
                                    // <><><><><>
                                    // LOOP ><><>
                                    // <><><><><>
                                    
                                    ForEach(analysis.labels, id: \.name) { label in
                                        AnalysisLabelView(label: label)
                                        if label.name != analysis.labels.last!.name {
                                            Divider()
                                                .padding()
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                
            } else {
                
                // ::::::::::::::::::::::::::::::
                // IF ANALYSES NOT FETCHED ::::::
                // ::::::::::::::::::::::::::::::
                
                VStack {
                    Spacer()
                    Image("imageMissing")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .scaleEffect(0.2)
                        .foregroundColor(Color.secondary)
                    Spacer()
                    Text("Image Analysis Unavailable".uppercased())
                        .foregroundColor(Color.secondary)
                        .padding()
                }
            }
        }
        
        // --------------------------------------------------------------------
        // MODIFIERS //////////////////////////////////////////////////////////
        // --------------------------------------------------------------------
        // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        // <><><><><><><><><><><><><><><><><><><><><><><><><><><><>< MARK: TASK
        // <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
        
        .task {
            do {
                try await analysisEngine.fetch(.forCats, imageId: image.id)
            } catch let error {
                print(error.localizedDescription)
                // VJotError ////////////////////////////////
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

//struct CatAnalysisView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatAnalysisView()
//    }
//}
