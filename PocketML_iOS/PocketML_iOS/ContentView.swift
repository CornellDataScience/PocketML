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
                    Image("TunerLogo")
                    .padding(.bottom, 100)
                    Text("Powered by \n Cornell Data Science")
                        .offset(y:225) // Adjust the offset as needed
                        .padding()
                        .foregroundStyle(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                        .monospaced()
                        .multilineTextAlignment(.center)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
                
            }.navigationBarBackButtonHidden(true)
        }
    }
}

    

#Preview {
    ContentView()
}
