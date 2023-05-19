//
//  AboutView.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 28/4/23.
//

import SwiftUI

struct AboutView: View {
    
    // colorSwitch toggles with View's every reappearance
    // and enables getColorizedVJot to produce an AttributedString
    // with random foreground colors each time (very ugly hack)
    
    @State var animationEnabled: Bool = false
    @State var colorSwitch: Bool = false
    @State var breath: Bool = false
    
    var body: some View {
        VStack {
            
            VStack(spacing: -5) {
                Text("KODECO ACCELERATOR ")
                Text("IOS BOOTCAMP")
            }
            .padding(.bottom)
            .foregroundColor(Color.secondary)
            .font(.footnote)
            
            Spacer()
            
            VStack(spacing: -7) {
                Text("a veterinarian's jotter")
                    .font(.title)
                    .kerning(-1)
                    .fontWeight(.light)
                Text("by Nikos Saridakis")
                    .foregroundColor(Color(red: 1, green: 0.35294, blue: 0.003921))
                    .font(.title3)
            }
            .padding()
            
            Group {

                Spacer()
                Spacer()
                Spacer()
                
                VStack {
                    Text(getColorizedVJot(colorSwitch: colorSwitch))
                        .padding()
                        .font(.largeTitle)
                        .fontWeight(.thin)
                        .background(getColorizedCircle(colorSwitch: colorSwitch))
                        .scaleEffect(breath ? 1.75 : 2.75)
                    //                .scaleEffect(breath ? 1 : 3)
                        .animation(.easeInOut(duration: 1), value: breath)
                    //                .animation(.spring(response: 2, dampingFraction: 0.5), value: breath)
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    guard !animationEnabled else { return }
                    animationEnabled.toggle()
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        breath.toggle()
                    }
                }
                
                Image("kodeco")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .frame(maxWidth: 80, maxHeight: 80)
                
                Spacer()
                Spacer()
                
            }
            
            VStack(spacing: -5) {
                Text("being honoured by mentors")
                    .foregroundColor(Color.secondary)
                HStack(spacing: 5) {
                    Text("Bob DeLaurentis")
                        .foregroundColor(Color.primary)
                    Text("&")
                        .foregroundColor(Color.secondary)
                    Text("Mina Gerges")
                        .foregroundColor(Color.primary)
                }
            }
            
//            VStack(spacing: -5) {
//                VStack(spacing: -5) {
//                    Text("proudly, for the")
//                        .kerning(-0.3)
//                }
//                .foregroundColor(Color.secondary)
//                .font(.subheadline)
//                VStack(spacing: -5) {
//                    Text("Kodeco Accelerator")
//                    Text("iOS Bootcamp")
//                }
//            }
//            .padding(.vertical)
            
            Spacer()
            
            Text("2023")
                .padding()
                .foregroundColor(Color.secondary)
                .font(.footnote)
        }
    }
    
    func getColorizedVJot(colorSwitch: Bool) -> AttributedString {
        var attrstr = AttributedString("vjot")
        
        let v = attrstr.range(of: "v")!
        let jot = attrstr.range(of: "jot")!
        
        attrstr[v].foregroundColor = colorSwitch ? Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        ) : Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
        
        attrstr[jot].foregroundColor = colorSwitch ? Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        ) : Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
        
        return attrstr
    }
    
    func getColorizedCircle(colorSwitch: Bool) -> some View {
        let color = colorSwitch ? Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        ) : Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
        
        return Circle()
            .fill(color)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
