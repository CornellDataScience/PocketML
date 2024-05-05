//
//  UserLoginView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class SignInEmailViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct UserLoginView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @State private var loggedIn = false
    @State private var idToken : String?
    
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
                TextField("Username", text: $viewModel.email)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.background2)
                    )
                    .padding(.leading)
                    .padding(.trailing)
                // password text field
                SecureField("Password", text: $viewModel.password)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.background2)
                    )
                    .padding(.leading)
                    .padding(.trailing)
                // sign-in button
                
                /*NavigationLink {
                    TabNavigatorView()
                }*/
                Button{
                    Task{
                        do{
                            try await viewModel.signIn()
                            print("Signed in")
                            loggedIn = true
                            return
                        }
                        catch {
                            print(error)
                        }
                                
                    }
                }
                label:{
                    Text("Sign In")
                    .foregroundStyle(Color.background2)
                    .padding(EdgeInsets(top:10,leading:100, bottom:10, trailing: 100 ))
                    .background(Color.main)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.top, 10)
                }//.navigationBarBackButtonHidden(true)
                
                /*NavigationLink {
                    TabNavigatorView()
                } label:{
                    Text("Sign In")
                        .foregroundStyle(Color.background2)
                        .padding(EdgeInsets(top:10,leading:100, bottom:10, trailing: 100 ))
                        .background(Color.main)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(.top, 10)
                }.navigationBarBackButtonHidden(true)
                */
                
                /*
                HStack{
                    Text("Dont have an account?")
                        .foregroundStyle(Color.main)
                    Text("Sign Up")
                        .foregroundStyle(Color.main)
                        .bold()
                    
                }.padding(.top, 50)
                */
            }
            .modifier(MainVStackModifier())
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $loggedIn, content: {
            JobDashboardView()
        })
    }
   
    //For the future: this is how you fetch idTokens. Out of date metod
    
    /*func fetchIDToken() {
            // Retrieve the current user
            guard let currentUser = Auth.auth().currentUser else {
                print("No user signed in")
                return
            }
        
            // Retrieve the ID token for the current user
            currentUser.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("Error retrieving ID token: \(error.localizedDescription)")
                    return
                }
                
            // Store the ID token in the variable
            self.idToken = idToken
            }
        }
    */
}

#Preview {
    UserLoginView()
}
