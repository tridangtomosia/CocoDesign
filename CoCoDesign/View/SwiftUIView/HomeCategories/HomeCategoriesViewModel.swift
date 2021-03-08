//
//  CategoriesViewModel.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import Combine
import SwiftUI

class HomeCategoriesViewModel: ObservableObject {
    @Published var action: Action = .become
    @Published var categories: [Category] = []
    @Published var state = State()
    var apiSession: APIService = APISession()
    private var disposbag = Set<AnyCancellable>()

    init() {
        $action
            .sink { action in
                switch action {
                case .become:
                    break
                case .request:
                    self.request()
                case let .pushView(id):
                    self.state.categoryId = id
                    self.state.isPushListShop = true
                }
            }
            .store(in: &disposbag)
    }

    func request() {
        state.isShowIndicator = true
        getCategories()
            .receive(on: DispatchQueue.main)
            .sink { results in
                switch results {
                case let .failure(error):
                    self.state.error = error
                    self.state.isFail = true
                case .finished:
                    print("completed")
                }
                self.state.isShowIndicator = false
            } receiveValue: { response in
                self.state.isRequested = true
                guard let categories = response.data else { return }
                self.categories = categories
            }
            .store(in: &disposbag)
    }
}

extension HomeCategoriesViewModel: APIRequestCategoriesService {
    struct State {
        var isShowIndicator: Bool = false
        var error: Error = APIError.unknown("")
        var isRequested: Bool = false
        var isPushListShop = false
        var categoryId: Int = 0
        var isFail: Bool = false
        var isSucces: Bool = false
    }

    enum Action {
        case become
        case request
        case pushView(Int)
    }
}
