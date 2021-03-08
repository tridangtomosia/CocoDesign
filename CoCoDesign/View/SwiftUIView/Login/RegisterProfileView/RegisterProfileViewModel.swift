import Combine
import SwiftUI

class RegisterProfileViewModel: ObservableObject, APIUpdateUserProfileService {
    private var disposbag = Set<AnyCancellable>()
    @Published var state = State()
    @Published var action: Action = .become
    @Published var nameInput: String = ""

    var apiSession: APIService = APISession()
    var phoneNumber: String = ""

    init(_ phoneNumber: String = "") {
        self.phoneNumber = phoneNumber
        $action
            .sink(receiveValue: { action in
                switch action {
                case .become:
                    break
                case .register:
                    self.register()
                }
            })
            .store(in: &disposbag)
    }

    func register() {
        self.state.isShowIndicator = true
        updateProfile(nameInput)
            .receive(on: DispatchQueue.main)
            .sink { results in
                switch results {
                case let .failure(error):
                    self.state.error = error
                case .finished:
                    break
                }
                self.state.isShowIndicator = false
            } receiveValue: { _ in
                self.state.isCompletedUpdate = true
            }
            .store(in: &disposbag)
    }
}

extension RegisterProfileViewModel {
    struct State {
        var isShowIndicator: Bool = false
        var isCompletedUpdate: Bool = false
        var error: Error = APIError.unknown("")
    }

    enum Action {
        case become
        case register
    }
}
