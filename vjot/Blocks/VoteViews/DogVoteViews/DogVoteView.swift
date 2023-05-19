//
//  DogVoteView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 22/4/23.
//

import SwiftUI

struct DogVoteView: View {
    var image: DogAPIImage
    
    @EnvironmentObject var veterinarianGig: VeterinarianGig
    @EnvironmentObject var voteEngine: VoteEngine
    
    @State var vote: DogAPIVote? = nil
    @State var value: Int8 = 0
    @Binding var voted: Bool
    @Binding var goVote: Bool
    
    @State var voteId: Int? = nil
    @State var voteValue: Int8? = nil
    @State var voteSubId: UUID? = nil
    @State var voteCreatedAt: Date? = nil
    @State var voteCountryCode: String? = nil
    
    @State var vjotError: VJotError? = nil
    @State var vjotErrorThrown: Bool = false
    
    // /////////////////////////////////////////////////////////////////// BODY
    
    var body: some View {
        ZStack {
            ScrollView {
                
                // ------------------------------------------------------------
                // CONTENT ////////////////////////////////////////////////////
                // ------------------------------------------------------------
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: TITLE
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                
                VStack(spacing: -12) {
                    Text("vote")
                        .foregroundColor(Color.primary)
                    Text("dog")
                        .foregroundColor(Color.secondary)
                    
                }
                .font(.title)
                .padding()
                
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: IMAGE
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                

                DogImageView(image: image, deleted: .constant(false))
                    .padding()
                
                
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][ MARK: STEPPER
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                
                
                HStack {
                    
                    // #^#^#^#^#^#^#^#^
                    // UP ^#^#^#^#^#^#^
                    // #^#^#^#^#^#^#^#^
                    
                    Button {
                        if value > Int8.min {
                            value -= 1
                        }
                    } label: {
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(value > Int8.min ? Color.red : Color.secondary)
                            .font(.headline)
                        
                    }
                    .buttonStyle(.bordered)
                    .disabled(value == Int.min)
                    
                    // #^#^#^#^#^#^#^#^
                    // VALUE #^#^#^#^#^
                    // #^#^#^#^#^#^#^#^
                    
                    Text(String(value))
                        .font(.title)
                        .padding()
                    
                    // #^#^#^#^#^#^#^#^
                    // DOWN #^#^#^#^#^
                    // #^#^#^#^#^#^#^#^
                    
                    Button {
                        if value < Int8.max {
                            value += 1
                        }
                    } label: {
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(value < Int8.max ? Color.green : Color.secondary)
                            .font(.headline)
                        
                    }
                    .buttonStyle(.bordered)
                    .disabled(value == Int.max)
                }
                .padding()
                
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%] MARK: POST BUTTON
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                
                Button {
                    Task {
                        do {
                      
                                if let currentId = veterinarianGig.currentId {
                                    if var currentVet = veterinarianGig.track(currentId: currentId) {
                                        
                                        // ::::::::::::::::::::::::::
                                        // CHECK IF SIGNED IN :::::::
                                        // PRESENT THE VOTE OPTION ::
                                        // ::::::::::::::::::::::::::
                                        
                                        
                                        let postStatus = try await voteEngine.postDog(
                                            imageId: image.id,
                                            subId: currentId,
                                            value: Int(value)
                                        )
                                        
                                        voted = true
                                        
                                        // [][][][[][][][][
                                        // UPDATE DETAILS |
                                        // [][][][][][][][]
                                        
                                        self.voteId = postStatus.id
                                        self.voteValue = Int8(postStatus.value ?? 0)
                                        self.voteCreatedAt = Date()
                                        
                                        // [][][][][][][][]
                                        // UPDATE USER [][]
                                        // [][][][][][][][]
                                        
                                        currentVet.dogVotes[image.id] = self.voteId
                                        try veterinarianGig.update(veterinarian: currentVet)
                                    }
                                }
                            
                        } catch {
                            print(error.localizedDescription)
                            // VJotError //////////////////////
                            vjotError = VJotError.error(error)
                            vjotErrorThrown.toggle()
                        }
                    }
                } label: {
                    Image(systemName: voted ? "envelope.fill" : "envelope.open.fill")
                        .foregroundColor(voted ? Color.yellow : Color.primary)
                        .font(.headline)
                }
                .buttonStyle(.bordered)
                .padding()
                
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][ MARK: DETAILS
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                
                if voted {
                    
                    // ::::::::::::::::::::::::::::::
                    // IF A PREVIOUS VOTE EXISTS ::::
                    // OR A NEW ONE IS CREATED ::::::
                    // ::::::::::::::::::::::::::::::
                    
                    
                    VStack(alignment: .vjotVoteH, spacing: -2) {
                        if let voteSubId {
                            HStack {
                                Text("user:")
                                    .foregroundColor(Color.secondary)
                                Text(voteSubId.uuidString)
                                    .alignmentGuide(.vjotVoteH) { $0[.leading] }
                            }
                        }
                        if let voteCreatedAt {
                            HStack {
                                Text("date:")
                                    .foregroundColor(Color.secondary)
                                Text(String(voteCreatedAt.ISO8601Format().replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")))
                                    .alignmentGuide(.vjotVoteH) { $0[.leading] }
                            }
                        }
                        if let voteId {
                            HStack {
                                Text("vote:")
                                    .foregroundColor(Color.secondary)
                                Text(String(voteId))
                                    .alignmentGuide(.vjotVoteH) { $0[.leading] }
                            }
                        }
                        if let voteValue {
                            HStack {
                                Text("value:")
                                    .foregroundColor(Color.secondary)
                                Text(String(voteValue))
                                    .alignmentGuide(.vjotVoteH) { $0[.leading] }
                            }
                        }
                        if let voteCountryCode {
                            HStack {
                                Text("country:")
                                    .foregroundColor(Color.secondary)
                                Text(voteCountryCode)
                                    .alignmentGuide(.vjotVoteH) { $0[.leading] }
                            }
                        }
                    }
                    .font(.footnote)
                    .padding()
                }
                
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][ MARK: DELETE BUTTON
                // [%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%][%]
                
                if voted {
                    
                    // ::::::::::::::::::::::::::::::::::::
                    // IF ALREADY VOTED SOMETIME ::::::::::
                    // PRESENT THE DELETE VOTE OPTION :::::
                    // ::::::::::::::::::::::::::::::::::::
                    
                    Button {
                        Task {
                            do {
                                if let vote {
                                    try await _ = voteEngine.deleteDog(voteId: vote.id)
                                    
                                    // [][][][][][][]
                                    // UPDATE USER []
                                    // [][][][][][][]
                                    
                                    
                                    if let currentId = veterinarianGig.currentId {
                                        if var currentVet = veterinarianGig.track(currentId: currentId) {
                                            currentVet.dogVotes[image.id] = nil
                                            try veterinarianGig.update(veterinarian: currentVet)
                                        }
                                    }
                                    
                                    
                                    // [][][][][][][]
                                    // DISCARD [][][]
                                    // [][][][][][][]
                                    
                                    voted = false
                                    goVote = false
                                }
                                
                            } catch {
                                print(error.localizedDescription)
                                // VJotError //////////////////////
                                vjotError = VJotError.error(error)
                                vjotErrorThrown.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "delete.left.fill")
                            .foregroundColor(Color.red)
                            .font(.headline)
                    }
                    .buttonStyle(.bordered)
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
            
                if let currentId = veterinarianGig.currentId {
                    if let currentVet = veterinarianGig.track(currentId: currentId) {
                        
                        // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                        // CURRENT USER OF COURSE )(-)(-)(-
                        // (-)(-)(-)(-)(-)(-)(-)(-)(-)(-)(-
                        
                        do {
                            if let voteId = currentVet.dogVotes[image.id] {
                                
                                // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                                // IF CURRENT USER HAS ALREADY VOTED FOR THIS IMAGEID :::::
                                // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                                
                                vote = try await voteEngine.fetchDog(voteId: voteId)
                                if let vote {
                                    self.voteId = vote.id
                                    self.voteValue = Int8(vote.value)
                                    if let subId = vote.subId { self.voteSubId = subId }
                                    if let createdAt = vote.createdAt { self.voteCreatedAt = createdAt }
                                    if let countryCode = vote.countryCode {self.voteCountryCode = countryCode }
                                    
                                    // ####################
                                    // PRESET VALUE #######
                                    // ####################
                                    
                                    self.value = Int8(vote.value)
                                }
                                
                            } else {
                                
                                // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                                // IF CURRENT USER HASN'T ALREADY VOTED FOR THIS IMAGEID ::
                                // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                                
                                vote = nil
                            }
                        } catch {
                            print(error.localizedDescription)
                            // VJotError //////////////////////
                            vjotError = VJotError.error(error)
                            vjotErrorThrown.toggle()
                        }
                    }
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


//struct DogVoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogVoteView()
//    }
//}
