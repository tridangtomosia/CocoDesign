import Combine
import SwiftUI

struct ListShopView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: ListShopViewModel

//    var searchTextView: some View {
//        HStack {
//            Image("ic_search")
//                .resizable()
//                .frame(width: 15, height: 15)
//                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
//            TextField("tim kiem ten cua hang", text: $viewModel.searchShop)
//                .onChange(of: viewModel.searchShop, perform: { _ in
//                    let list = viewModel.savedListShop.filter({ shop in
//                        shop.name?.contains(searchShop) == true
//                    })
//                    listShop = list
//                })
//        }
//        .frame(width: 313, height: 30)
//        .overlay(RoundedRectangle(cornerRadius: 30)
//            .stroke(Color.AppColor.grayBorderColor, lineWidth: 0.5))
//    }

    var body: some View {
        LoadingIndicatorView(isShowing: $viewModel.state.isShowIndicator) {
            VStack(alignment: .leading, spacing: nil, content: {
                listShopBodyView
                    .onAppear(perform: {
                        viewModel.action = .request(viewModel.state.isRequested)
                    })
            })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Image("ic_back")
                .resizable()
                .frame(width: 10, height: 18, alignment: .center)
                .padding(.all, 0)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        )
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("test")
        ////                HStack {
        ////                    Image("ic_search")
        ////                        .resizable()
        ////                        .frame(width: 15, height: 15)
        ////                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        ////                    TextField("tim kiem ten cua hang", text: $searchShop)
        ////                        .onChange(of: searchShop, perform: { _ in
        ////                            let list = viewModel.savedListShop.filter({ shop in
        ////                                shop.name?.contains(searchShop) == true
        ////                            })
        ////                            listShop = list
        ////                        })
        ////
        ////                }
        ////                .frame(width: 313, height: 30)
        ////                .overlay(RoundedRectangle(cornerRadius: 30)
        ////                    .stroke(Color.AppColor.grayBorderColor, lineWidth: 0.5))
//            }
//        }
    }

    var listShopBodyView: some View {
        return VStack {
            List(0 ..< viewModel.state.listShop.count, id: \.self) { element in
                ZStack {
                    HStack {
                        if let url = viewModel.state.listShop[element].imgUrl {
                            ImageView(withURL: APIPath.endpoint + url)
                                .frame(width: 50, height: 50)
                        } else {
                            Image(uiImage: UIImage())
                                .frame(width: 50, height: 50)
                        }
                        
//                        Spacer()
//                            .frame(width: 10)
//                        
//                        Text(viewModel.state.listShop[element].name ?? "")
//                        
//                        Spacer()
//                        
//                        Image(((viewModel.state.listShop[element].id ?? "") == viewModel.state.isRequested) ? "ic_selected" : "ic_unselected")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 20, height: 20)
                    }
                    
                }
            }
            .background(Color.AppColor.backgroundColor)
        }
    }
}

// struct ListShopView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListShopView(viewModel: ListShopViewModel(0, 0))
//    }
// }
