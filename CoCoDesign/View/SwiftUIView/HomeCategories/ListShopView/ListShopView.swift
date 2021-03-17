import Combine
import SwiftUI

struct ListShopView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: ListShopViewModel

    var body: some View {
        ActivityIndicatorLoadingView(isShowing: $viewModel.state.isShowIndicator) {
            VStack(alignment: .leading, spacing: nil, content: {
                NavigationBarCustomeView(isLeftHidden: false,
                                         isLineBottomHidden: false,
                                         leftAction: {
                                             presentationMode.wrappedValue.dismiss()
                                         },
                                         barView: searchView)
                    .background(Color.white)
                listShopBodyView
                Spacer()
            })
                .background(Color.AppColor.backgroundColor)
                .onAppear(perform: {
                    viewModel.action = .request
                })
        }
        .navigationBarHidden(true)
    }

    struct ShopCell: View {
        var shop: ShopMasterCategory

        var body: some View {
            HStack {
                if let url = shop.imgUrl {
                    LoadImageView(withURL: url)
                        .frame(width: 50, height: 50)
                        .clipped()
                        .padding(.all, 8)
                } else {
                    Image(uiImage: UIImage())
                        .frame(width: 50, height: 50)
                        .clipped()
                        .padding(.all, 8)
                }
                Spacer()
                    .frame(width: 10)
                Text(shop.name ?? "")
                Spacer()
                Image(shop.isSelected == true ? "ic_selected" : "ic_unselected")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
            .frame(height: 56, alignment: .center)
        }
    }

    var listShopBodyView: some View {
        return ScrollView {
            if viewModel.state.listShop.count != 0 {
                ForEach(0 ..< viewModel.state.listShop.count, id: \.self) { element in
                    NavigationLink(destination: ShopDetailView(ShopDetailViewModel($viewModel.state.listShop[element]))) {
                        ShopCell(shop: viewModel.state.listShop[element])
                            .padding(.all, 8)
                    }
                    .foregroundColor(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color.AppColor.shadowColor, radius: 10, x: 1, y: 1)
                    )
                }
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16))
            }
        }
    }

    var searchView: some View {
        GeometryReader { geometry in
            HStack {
                Image("ic_search")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                SearchTextField(text: $viewModel.searchShopName,
                                placeHolder: Strings.ListShopView.placeHolderSearch) { text in
                    viewModel.searchShopName = text
                    hideKeyboard()
                }
            }
            .overlay(RoundedRectangle(cornerRadius: geometry.size.height)
                .stroke(Color.AppColor.grayBorderColor, lineWidth: 1))
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .center)
        }
    }
}
