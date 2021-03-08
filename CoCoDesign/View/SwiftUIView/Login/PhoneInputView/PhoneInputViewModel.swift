import Combine
import Firebase
import FirebaseAuth
import SwiftUI

class PhoneInputViewModel: ObservableObject {
    @Published var state = State()
    // action
    @Published var action: Action = .become
    @Published var phoneInputNumber: String = ""
    @Published var regionSearchName: String = ""
    
    
    var phoneRequest: String {
        var phoneRequest = phoneInputNumber
        if phoneRequest.count > 11 {
            phoneRequest.removeFirst()
        }
        return state.regionFlag.dialCode + phoneRequest
    }

    var originalPhoneNumber: String {
        let string = phoneInputNumber.phoneFormat("###-######")
        return "0" + string
    }

    private var disposbag = Set<AnyCancellable>()

    init() {
        $regionSearchName
            .map { name -> [RegionFlag] in
                areaCodes.filter { $0.regionName.contains(name) }
            }
            .eraseToAnyPublisher()
            .assign(to: \.state.places, on: self)
            .store(in: &disposbag)

        $phoneInputNumber
            .map { $0.count >= 9 }
            .eraseToAnyPublisher()
            .assign(to: \.state.canUsingPhoneNumber, on: self)
            .store(in: &disposbag)

        $action
            .sink { action in
                switch action {
                case .become:
                    break
                case .requestPhoneTofireBase:
                    self.requestPhoneToFirebase()
                case let .showPlace(isShow):
                    self.state.isShowPlace = isShow
                }
            }.store(in: &disposbag)
    }

    func requestPhoneToFirebase() {
        state.isShowIndicator = true
        Future<String, Error> { promise in
            PhoneAuthProvider
                .provider()
                .verifyPhoneNumber(self.phoneRequest, uiDelegate: nil) { verificationID, error in
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
            self.state.isSucces = true
            self.state.verificodeId = id
        }
        .store(in: &disposbag)
    }
}

extension PhoneInputViewModel {
    struct State {
        var verificodeId: String = ""
        var isSucces: Bool = false
        var isFail: Bool = false
        var isShowIndicator = false
        var error: Error = APIError.unknown("")
        var canUsingPhoneNumber: Bool = false
        var isShowPlace: Bool = false
        var places: [RegionFlag] = []
        var regionFlag: RegionFlag = RegionFlag(regionName: "Viet Nam", emoji: "🇻🇳", dialCode: "+84")
    }

    enum Action {
        case become
        case requestPhoneTofireBase
        case showPlace(Bool)
    }
}
