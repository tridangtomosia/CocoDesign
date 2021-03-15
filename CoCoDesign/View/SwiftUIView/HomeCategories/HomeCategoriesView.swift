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
            NavigationBarCustomeView(isLineBottomHidden: false,
                                     barView: Text(Strings.BarTitle.categoryView))
                .background(Color.white)

            Spacer()
                .frame(height: 20)

            categoryCollectionView
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .alert(isPresented: $viewModel.state.isFail) {
                    Alert(title: Text(viewModel.state.error.localizedDescription))
                }
            Spacer()
        }
        .background(Color.AppColor.backgroundColor)
        .navigationBarHidden(true)
    }

    var categoryCollectionView: some View {
        return ScrollView {
            if viewModel.state.isPushListShop {
                NavigationLink(destination: ListShopView(viewModel: ListShopViewModel(viewModel.state.categoryId, 0)),
                               isActive: $viewModel.state.isPushListShop) {}
                    .hidden()
                    .navigationBarHidden(true)
            }
            let categories = viewModel.state.categories
            if !categories.isEmpty {
                ForEach(0 ..< categories.count / 4, id: \.self) { element in
                    HStack {
                        ForEach(0 ..< 4, id: \.self) { item in
                            ItemCategoryView(category: categories[element * 4 + item])
                                .onTapGesture {
                                    viewModel.action = .pushView(categories[element * 4 + item].id ?? 0)
                                }
                        }
                    }
                    .padding(.all, 10)
                }
            }
        }
    }

    struct ItemCategoryView: View {
        var category: Category = Category()

        var body: some View {
            VStack(alignment: .center, spacing: 5, content: {
                ZStack {
                    if let url = category.imgUrl {
                        ImageView(withURL: url)
                            .padding(.all, 16)
                    } else {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.AppColor.shadowColor, radius: 10, x: 1, y: 3)
                )

                Text(category.name ?? "")
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.blackColor)
                    .background(Color.clear)
                    .lineLimit(1)
            })
        }
    }
}
