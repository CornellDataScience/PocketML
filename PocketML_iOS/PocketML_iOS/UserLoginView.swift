//
//  UserLoginView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct UserLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Welcome Back")
                    .monospaced()
                    .font(.largeTitle)
                    .foregroundStyle(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                Divider()
                    .frame(width: 200, height: 1)
                    .background(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                    .padding(.bottom, 20)
                    .padding(.top, -5)
                
                // username text field
                TextField("Username", text: $username)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
                    )
                    .padding(.leading)
                    .padding(.trailing)
                // password text field
                TextField("Password", text: $password)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
                    )
                    .padding(.leading)
                    .padding(.trailing)
                // sign-in button
                NavigationLink {
                    TabNavigatorView()
                } label:{
                    Text("Sign In")
                        .foregroundStyle(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
                        .padding(EdgeInsets(top:10,leading:100, bottom:10, trailing: 100 ))
                        .background(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(.top, 10)
                }.navigationBarBackButtonHidden(true)
                HStack{
                    Text("Dont have an account?")
                        .foregroundStyle(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                    Text("Sign Up")
                        .foregroundStyle(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                        .bold()
                    
                }.padding(.top, 50)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
        }
        .navigationBarBackButtonHidden(true)
    }
   
// create variables for small views to clean up main code??
    
//    private var viewAlbumsButton: some View {
//        Text("My List")
//            .foregroundStyle(Color(red:0.84705882352, green: 0.74901960784, blue:0.84705882352))
//            .padding(EdgeInsets(top:10,leading:20, bottom:10, trailing: 20 ))
//            .background(Color(red: 0.09803921568, green: 0.09803921568, blue: 0.43921568627))
//            .clipShape(RoundedRectangle(cornerRadius: 15))
//    }
}

#Preview {
    UserLoginView()
}
