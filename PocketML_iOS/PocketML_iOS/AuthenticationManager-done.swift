//
//  AuthenticationManager.swift
//  PocketML_iOS
//
//  Created by Ella Schneyer on 5/4/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user : User){
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager{
    static let shared = AuthenticationManager()
    private init () {}
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user : authDataResult.user)
    }
}
