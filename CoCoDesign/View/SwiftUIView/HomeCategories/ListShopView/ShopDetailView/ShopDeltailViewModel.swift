//
//  ShopDeltailViewModel.swift
//  CoCoDesign
//
//  Created by apple on 3/12/21.
//

import Combine
import SwiftUI

class ShopDetailViewModel: ObservableObject {
    @Published var state = State()
    @Published var action: Action = .become

    @Binding var shopMasterCategory: ShopMasterCategory

    init(_ shopMasterCategory: Binding<ShopMasterCategory>) {
        _shopMasterCategory = shopMasterCategory
    }

    struct State {
        var isShowFullSizeImage: Bool = false
        var urlSelected = ""
        var selectionTab = 0
    }

    enum Action {
        case become
        case selectec(Int)
    }
}

