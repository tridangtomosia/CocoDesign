//
//  ShopDeltailViewModel.swift
//  CoCoDesign
//
//  Created by apple on 3/12/21.
//

import Combine
import SwiftUI

extension ShopDetailViewModel: APIRequestShopDetailService {}

class ShopDetailViewModel: ObservableObject {
    @Published var state = State()
    @Published var action: Action = .become
    @Binding var category: ShopMasterCategory
    var apiSession: APIService = APISession()
    private var disposbag = Set<AnyCancellable>()

    init(_ category: Binding<ShopMasterCategory>) {
        self._category = category
        
        $action
            .removeDuplicates()
            .sink { action in
                switch action {
                case .become:
                    break
                case .request:
                    if !self.state.isSucessGetDeail {
                        self.request()
                    }
                case .selected:
                    if self.category.isSelected == false {
                        self.category.isSelected = true
                    }
                }
            }
            .store(in: &disposbag)
    }

    func request() {
        state.isShowIndicator = true
        getShopDetail(category.id ?? 0)
            .receive(on: DispatchQueue.main)
            .sink { results in
                switch results {
                case let .failure(error):
                    self.state.error = error
                case .finished:
                    break
                }
                self.state.isShowIndicator = false
            } receiveValue: { results in
                guard let category = results.data else { return }
                self.state.category = category
                self.state.isSucessGetDeail = true
            }
            .store(in: &disposbag)
    }
}

extension ShopDetailViewModel {
    struct State {
        var isShowIndicator: Bool = false
        var selectedTab = 0
        var error = APIError.unknown("")
        var category = ShopMasterCategory()
        var isSucessGetDeail: Bool = false
    }

    enum Action {
        case become
        case selected
        case request
    }
}
