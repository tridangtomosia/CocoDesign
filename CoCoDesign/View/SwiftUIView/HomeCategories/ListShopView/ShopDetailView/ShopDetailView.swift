//
//  ListDetailView.swift
//  CoCoDesign
//
//  Created by apple on 3/2/21.
//

import Combine
import SwiftUI

struct ShopDetailView: View {
    @Binding var shopDetail: ShopMasterCategory
    @State var selectionTab = 0
    @Binding var selectedShopId: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: nil, content: {
                VStack(alignment: .center, spacing: nil, content: {
                    pageImageView()
                        .frame(width: geometry.size.width, height: geometry.size.height * 1 / 3.2, alignment: .topLeading)
                        .overlay(
                            ZStack {
                                VStack {
                                    Text(shopDetail.banners?.isEmpty == true ? "1/1" : "\(selectionTab + 1)/\(shopDetail.banners?.count ?? 0)")
                                        .frame(width: 48, height: 20)
                                        .foregroundColor(Color.AppColor.blackColor)
                                        .font(.appFont(interFont: .semiBold, size: 11))
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.white)
                                        )
                                        .padding(.trailing, 6)
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height * 1 / 3.2, alignment: .bottomTrailing)
                            }
                        )
                        .overlay(
                            VStack {
                                if let urlString = shopDetail.imgUrl {
                                    ImageView(withURL: urlString)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } else {
                                    Text("Nothing")
                                }
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height * 1 / 3.2 + 90, alignment: .bottom)
                        )
                    Spacer()
                        .frame(height: 50)
                    Text("The coffeHouse")
                        .font(.appFont(interFont: .bold, size: 16))
                        .foregroundColor(Color.AppColor.blackColor)
                    Rectangle()
                        .foregroundColor(Color.AppColor.grayBorderColor)
                        .frame(height: 1)
                })
                infomationView()
                Spacer()
            })
                .overlay(
                    VStack {
                        VStack {
                            Image("ic_checked")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color.white)
                                .shadow(color: Color.AppColor.shadowColor, radius: 10, x: 1, y: 1)
                        )
                        .onTapGesture {
                            if let id = shopDetail.id {
                                selectedShopId = id
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .frame(width: geometry.size.width - 24,
                           height: geometry.size.height - 24,
                           alignment: .bottomTrailing)
                )
        }
        .navigationBarHidden(true)
    }

    func infomationView() -> some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text("Thong tin")
                .font(.appFont(interFont: .bold, size: 16))
                .foregroundColor(Color.AppColor.blackColor)
                .padding(.leading, 16)

            HStack {
                Image("ic_place")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(shopDetail.address ?? "")
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.blackColor)
            }
            .padding(.leading, 16)

            HStack {
                Image("ic_clock")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Gio mo cua: ")
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.appColor)
                Text(shopDetail.workingTime ?? "")
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.blackColor)
            }
            .padding(.leading, 16)

            HStack {
                Image("ic_note")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(shopDetail.descript ?? "")
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.blackColor)
            }
            .padding(.leading, 16)
        })
    }

    func pageView(_ urlString: String) -> some View {
        return VStack {
            ImageView(withURL: urlString)
                .padding(.all, 0)
        }
    }

    func pageImageView() -> some View {
        let data = shopDetail.banners ?? []
        return ZStack {
            TabView(selection: $selectionTab,
                    content: {
                        Group {
                            if data.count != 0 {
                                ForEach(data, id: \.imgUrl) { element in
                                    pageView(element.imgUrl)
                                        .tabItem { EmptyView() }
                                }
                            } else {
                                pageView(APIPath.endpoint + (shopDetail.imgUrl ?? ""))
                            }
                        }
                        .overlay(
                            VStack {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image("ic_back_white")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 10, height: 18, alignment: .center)
                                }
                                .frame(width: 50, height: 50)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading))
            })
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

// struct ShopDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopDetailView(, shopDetail: <#ShopMasterCategory#>)
//    }
// }
