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

private struct Configuration {
    static let timeEnd = 0
    static let timeStart = 90
    static let second = 60
    static let minute = 60
    static let hour = 24
}

extension VerifiCodeViewModel: PhoneLoginService {}
extension VerifiCodeViewModel {
    struct State {
        // resendCode
        var isSuccesReceiveCode: Bool = false
        var isFail: Bool = false
        // requestLogin
        var isNewUser: Bool = false
        var isOldUser: Bool = false
        // update view
        var isShowIndicator: Bool = false
        var isCanAction: Bool = false
        var error: Error = APIError.unknown("")
        var isPushView: Bool = false
    }

    enum Action {
        case become
        case login(_ codeInput: String)
        case resendCode
        case startCountDown
    }
}

class VerifiCodeViewModel: ObservableObject {
    @Published var action: Action = .become
    @Published var state = State()

    var phoneNumber: String
    var apiSession: APIService = APISession()

    private var verificationID: String
    private var disposbag = Set<AnyCancellable>()
    
    init(_ phoneNumber: String, _ verificationID: String) {
        self.phoneNumber = phoneNumber
        self.verificationID = verificationID

        $action
            .sink { action in
                switch action {
                case .become:
                    break
                case let .login(code):
                    self.signIn(code)
                case .resendCode:
                    self.requestPhoneToFirebase()
                case .startCountDown:
                    break
                }
            }
            .store(in: &disposbag)
    }

    func timeFormater(seconds: Int) -> String {
        let sec = seconds % Configuration.second
        let minute = seconds / Configuration.minute
        return "\(minute): \(sec)"
    }

    func signIn(_ code: String) {
        state.isShowIndicator = true
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID,
                                                                 verificationCode: code)
        Auth.auth().signIn(with: credential) { _, error in
            self.state.isShowIndicator = false
            if let error = error {
                self.state.error = error
                self.state.isFail = true
            } else {
                self.request(self.phoneNumber)
            }
        }
    }

    func request(_ phoneNumber: String) {
        let phonedefault = phoneNumber.phoneDefaultNumber()
        state.isShowIndicator = true
        phoneInput(phonedefault)
            .receive(on: DispatchQueue.main)
            .sink { response in
                switch response {
                case let .failure(error):
                    self.state.error = error
                    self.state.isFail = true
                case .finished:
                    break
                }
                self.state.isShowIndicator = false
            } receiveValue: { response in
                guard let token = response.data else { return }
                SceneDelegate.shared.token = token
                switch token.accountStatus {
                case .new:
                    self.state.isNewUser = true
                case .old:
                    self.state.isOldUser = true
                }
            }
            .store(in: &disposbag)
    }

    func requestPhoneToFirebase() {
        state.isShowIndicator = true
        Future<String, Error> { promise in
            PhoneAuthProvider
                .provider()
                .verifyPhoneNumber(self.phoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    promise(.success(verificationID ?? ""))
                }
        }
        .sink { results in
            switch results {
            case let .failure(error):
                self.state.error = error
                self.state.isFail = true
            case .finished:
                break
            }
            self.state.isShowIndicator = false
        } receiveValue: { id in
            self.state.isSuccesReceiveCode = true
            self.verificationID = id
        }
        .store(in: &disposbag)
    }
}
