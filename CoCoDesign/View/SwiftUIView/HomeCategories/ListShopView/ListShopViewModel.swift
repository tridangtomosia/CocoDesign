//
//  ShopViewModel.swift
//  CoCoDesign
//
//  Created by apple on 3/1/21.
//

import Combine
import SwiftUI

extension ListShopViewModel {
    struct State {
        var listShop: [ShopMasterCategory] = []
        var saveListShop: [ShopMasterCategory] = []
        var error: Error = APIError.unknown("")
        var isFail: Bool = false
        var isShowIndicator: Bool = false
        var isRequested: Bool = false
    }

    enum Action {
        case become
        case request(Bool)
    }
}

class ListShopViewModel: ObservableObject, APIRequestShopService {
    @Published var action: Action = .become
    @Published var searchShop = ""
    
    var apiSession: APIService = APISession()
    @Published var state = State()
    private var disposbag = Set<AnyCancellable>()
    
    private var id: Int
    private var page: Int
    
    init(_ id: Int, _ page: Int = 0) {
        self.id = id
        self.page = page
        
        $action
            .sink { action in
                switch action {
                case .become:
                    break
                case let .request(isRequested):
                    if !isRequested {
                        self.request(id, page)
                        self.state.isRequested = true
                    }
                    
                }
            }
            .store(in: &disposbag)
    }
    
    
    func request(_ id: Int, _ page: Int) {
        state.isShowIndicator = true
        getListShop(id, page)
            .receive(on: DispatchQueue.main)
            .sink { results in
                switch results {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("completed")
                }
                self.state.isShowIndicator = false
            } receiveValue: { response in
                guard let listShop = response.data else {return}
                self.state.listShop = listShop
                self.state.saveListShop = listShop
            }
            .store(in: &disposbag)
    }
    
}
