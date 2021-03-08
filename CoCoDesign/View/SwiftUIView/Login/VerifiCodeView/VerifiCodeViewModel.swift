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
        var timeRemaining: String = ""
        var error: Error = APIError.unknown("")
    }

    enum Action {
        case become
        case login
        case resendCode
    }
}

class VerifiCodeViewModel: ObservableObject {
    // action
    @Published var isStartCowndown: Bool = false
    @Published var action: Action = .become
    @Published var inputCode: String = ""

    @Published var state = State()

    var phoneNumber: String
    var apiSession: APIService = APISession()
    private var timeState: Int = 0
    private var verificationID: String
    private var disposbag = Set<AnyCancellable>()
    private var timer: Timer?

    init(_ phoneNumber: String, _ verificationID: String) {
        self.phoneNumber = phoneNumber
        self.verificationID = verificationID

        $isStartCowndown
            .map { $0 == true }
            .eraseToAnyPublisher()
            .sink { isSucces in
                if isSucces {
                    self.timeState = 90
                    self.cowndownStart()
                    self.isStartCowndown = false
                }
            }
            .store(in: &disposbag)

        $action
            .sink { action in
                switch action {
                case .become:
                    break
                case .login:
                    self.signIn()
                case .resendCode:
                    self.requestPhoneToFirebase()
                }
            }
            .store(in: &disposbag)

        $inputCode
            .dropFirst()
            .sink { code in
                // setting here if want auto login before succes input code
            }
            .store(in: &disposbag)
    }

    func cowndownStart() {
        state.timeRemaining = timeFormater(seconds: timeState)
        if timeState > 0 {
            timer = Timer.schedule(delay: 1) { _ in
                self.timeState -= 1
                self.cowndownStart()
            }
        }
    }

    func timeFormater(seconds: Int) -> String {
        let sec = seconds % Configuration.second
        let minute = seconds / Configuration.minute
        return "\(minute): \(sec)"
    }

    func signIn() {
        state.isShowIndicator = true
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID,
                                                                 verificationCode: inputCode)
        Auth.auth().signIn(with: credential) { _, error in
            self.state.isShowIndicator = false
            if let error = error {
                self.state.error = error
                self.state.isFail = true
            } else {
                self.stopTimer()
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
            self.isStartCowndown = true
        }
        .store(in: &disposbag)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
