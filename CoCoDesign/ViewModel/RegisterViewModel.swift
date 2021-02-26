//
//  RegisterViewModel.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import Combine
import SwiftUI

struct RegisterViewModel: APIUpdateUserProfileService {
    @Binding var cancellables: Set<AnyCancellable>
    @Binding var isShowIndicator: Bool
    @Binding var isCompletedUpdate: Bool
    var apiSession: APIService = APISession()
    var fullName = ""

    func register() {
        isShowIndicator = true
        updateProfile(fullName)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("complete request")
            } receiveValue: { _ in
                isShowIndicator = false
            }
            .store(in: &cancellables)
    }
}
