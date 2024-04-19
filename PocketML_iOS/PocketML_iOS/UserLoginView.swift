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
                    .modifier(BigTitleModifier())
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
                            .fill(Color.background2)
                    )
                    .padding(.leading)
                    .padding(.trailing)
                // password text field
                TextField("Password", text: $password)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.background2)
                    )
                    .padding(.leading)
                    .padding(.trailing)
                // sign-in button
                NavigationLink {
                    TabNavigatorView()
                } label:{
                    Text("Sign In")
                        .foregroundStyle(Color.background2)
                        .padding(EdgeInsets(top:10,leading:100, bottom:10, trailing: 100 ))
                        .background(Color.main)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(.top, 10)
                }.navigationBarBackButtonHidden(true)
                HStack{
                    Text("Dont have an account?")
                        .foregroundStyle(Color.main)
                    Text("Sign Up")
                        .foregroundStyle(Color.main)
                        .bold()
                    
                }.padding(.top, 50)
                
            }
            .modifier(MainVStackModifier())
        }
        .navigationBarBackButtonHidden(true)
    }
   
}

#Preview {
    UserLoginView()
}
