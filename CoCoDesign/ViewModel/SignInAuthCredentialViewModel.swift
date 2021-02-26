//
//  SignInAuthCredential.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Combine
import Firebase
import SwiftUI
import UIKit

struct SignInAuthCredentialViewModel: PhoneLoginService {
    @Binding var cancellables : Set<AnyCancellable>
    @Binding var stateLogin: StateLogin
    @Binding var isShowLoading: Bool
    var apiSession: APIService = APISession()
    let stateVerificode: StateVerificode
    let phoneNumber: String

    func signIn() {
        isShowLoading = true
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: stateVerificode.id, verificationCode: stateVerificode.code)
        Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
                self.stateLogin.loginFail = APIError.unknown(error.localizedDescription)
                self.stateLogin.failLogin = true
            } else {
                self.request("0" + phoneNumber)
            }
            isShowLoading = false
        }
    }

    func request(_ phoneNumber: String) {
        phoneInput(phoneNumber)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("completed request")
            } receiveValue: { response in
                guard let token = response.data else { return }
                if token.accountStatus == "NEW" {
                    stateLogin.sucessNewLogin = true
                } else {
                    stateLogin.sucessOldLogin = true
                }
            }
            .store(in: &cancellables)
    }
}
