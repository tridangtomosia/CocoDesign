//
//  HomeCategories.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import Combine
import SwiftUI

struct HomeCategoriesView: View {
    @ObservedObject var viewModel: HomeCategoriesViewModel
    init(_ viewModel: HomeCategoriesViewModel) {
        self.viewModel = viewModel
        self.viewModel.action = .request
    }

    var body: some View {
        VStack {
            NavigationLink(destination: ListShopView(viewModel: ListShopViewModel(viewModel.state.categoryId, 0)),
                           isActive: $viewModel.state.isPushListShop) {}
                .hidden()
            categoryCollectionView
                .background(Color.AppColor.backgroundColor)
                .navigationBarHidden(false)
                .navigationBarTitle(Text(Strings.BarTitle.categoryView), displayMode: .inline)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .alert(isPresented: $viewModel.state.isFail) {
                    Alert(title: Text(viewModel.state.error.localizedDescription))
                }
        }
//        .onAppear {
//            self.viewModel.action = .request
//        }
        .navigationBarBackButtonHidden(true)
    }

    var categoryCollectionView: some View {
        return ScrollView {
            if viewModel.categories.count != 0 {
                ForEach(0 ..< viewModel.categories.count / 4, id: \.self) { element in
                    HStack {
                        ForEach(0 ..< 4, id: \.self) { item in
                            ItemCategoryView(category: viewModel.categories[element * 4 + item])
                                .onTapGesture {
                                    viewModel.action = .pushView(viewModel.categories[element * 4 + item].id ?? 0)
                                }
                        }
                    }
                    .padding(.all, 10)
                }
            }
        }
    }
}

// struct HomeCategoriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeCategoriesView()
//    }
// }
