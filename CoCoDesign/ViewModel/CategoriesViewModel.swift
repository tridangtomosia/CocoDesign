//
//  CategoriesViewModel.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import Combine
import SwiftUI

struct CategoriesViewModel: APIRequestCategoriesService {
    var apiSession: APIService = APISession()
    @State var cancellable = Set<AnyCancellable>()
    @Binding var categories: [Categorie]
    @Binding var isShowIndicator: Bool
    
    func request() {
        isShowIndicator = true
        getCategories()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("completed")
            } receiveValue: { response in
                guard let categories = response.data else {return}
                self.categories = categories
            }
            .store(in: &cancellable)
    }
    
}
