//
//  SignInAuthCredential.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Firebase
import UIKit
import SwiftUI
import Combine

class StateLogin: ObservableObject {
    @Published var successLogin = false
    @Published var isLogin = false
    @Published var loginFail = APIError.unknown("")
}

class SignInAuthCredential {
    @ObservedObject var stateLogin = StateLogin()
    
    func signIn(_ verificationCode: String, verificationID: String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)

        Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
                self.stateLogin.loginFail = APIError.unknown(error.localizedDescription)
            } else {
                self.stateLogin.successLogin = true
            }
        }
    }
}
