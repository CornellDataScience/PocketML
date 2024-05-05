//
//  ContentView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/22/24.
//


// this should be the main home page that connects to all other pages
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink{
                UserLoginView()
            }label:{
                
                VStack {
                    Image("PocketLogo")
                    .padding(.bottom, 100)
                    Text("Powered by \n Cornell Data Science")
                        .offset(y:225) // Adjust the offset as needed
                        .padding()
                        .padding(.bottom, 100)
                        .foregroundStyle(Color.main)
                        .monospaced()
                        .multilineTextAlignment(.center)
                    
                }
                .modifier(MainVStackModifier())
                
            }.navigationBarBackButtonHidden(true)
        }
    }
}

    

#Preview {
    ContentView()
}
