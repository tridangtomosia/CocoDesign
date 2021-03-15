//
//  ListDetailView.swift
//  CoCoDesign
//
//  Created by apple on 3/2/21.
//

import Combine
import SwiftUI

struct ShopDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: ShopDetailViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: nil, content: {
                    VStack(alignment: .center, spacing: nil, content: {
                        pageView
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height * 1 / 3.2,
                                   alignment: .topLeading)
                            .clipped()
                            .overlay(
                                backButton
                                    .frame(width: geometry.size.width,
                                           height: geometry.size.height * 1 / 3.2,
                                           alignment: .topLeading)
                            )
                            .overlay(
                                pageNumberView
                                    .frame(width: geometry.size.width,
                                           height: geometry.size.height * 1 / 3.2,
                                           alignment: .bottomTrailing)
                            )
                            .overlay(
                                avatarView
                                    .frame(width: geometry.size.width,
                                           height: geometry.size.height * 1 / 3.2 + 60,
                                           alignment: .bottom)
                            )
                        Spacer()
                            .frame(height: 50)
                        Text(viewModel.shopMasterCategory.name ?? "")
                            .font(.appFont(interFont: .bold, size: 16))
                            .foregroundColor(Color.AppColor.blackColor)
                        Rectangle()
                            .foregroundColor(Color.AppColor.grayBorderColor)
                            .frame(height: 1)
                    })
                    infomationView
                    Spacer()
                })
                    .fullScreenCover(isPresented: $viewModel.state.isShowFullSizeImage) {
                        pageView
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height,
                                   alignment: .center)
                            .overlay(
                                backButton
                                    .frame(width: geometry.size.width,
                                           height: geometry.size.height,
                                           alignment: .topLeading)
                            )
                    }
                    .overlay(
                        selectedShopButton
                            .frame(width: geometry.size.width - 48,
                                   height: geometry.size.height - 24,
                                   alignment: .bottomTrailing)
                    )
            }
        }
        .navigationBarHidden(true)
    }

    var selectedShopButton: some View {
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
                viewModel.shopMasterCategory.isSelected = true
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    var avatarView: some View {
        VStack {
            if let urlString = viewModel.shopMasterCategory.imgUrl {
                ImageView(withURL: urlString)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Text("No Image")
            }
        }
    }

    var pageNumberView: some View {
        VStack {
            Text(viewModel.shopMasterCategory.banners == nil ? "1/1" : "\(viewModel.state.selectionTab + 1)/\(viewModel.shopMasterCategory.banners?.count ?? 0)")
                .frame(width: 48, height: 20)
                .foregroundColor(Color.AppColor.blackColor)
                .font(.appFont(interFont: .semiBold, size: 11))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                )
                .padding(.trailing, 6)
        }
    }

    var backButton: some View {
        ZStack {
            Button {
                if viewModel.state.isShowFullSizeImage {
                    viewModel.state.isShowFullSizeImage.toggle()
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Image("ic_back_white")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 10, height: 18, alignment: .center)
                    .padding(.all, 10)
                    .shadow(color: .black, radius: 3, x: 1, y: 1)
            }
            .frame(width: 50, height: 50, alignment: .center)
        }
    }

    var infomationView: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(Strings.ShopDetailView.infomation)
                .font(.appFont(interFont: .bold, size: 16))
                .foregroundColor(Color.AppColor.blackColor)
                .padding(.leading, 16)

            HStack {
                Image("ic_place")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(viewModel.shopMasterCategory.address ?? "")
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.blackColor)
            }
            .padding(.leading, 16)

            HStack {
                Image("ic_clock")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(Strings.ShopDetailView.timeOpenShop)
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.appColor)
                Text(viewModel.shopMasterCategory.workingTime ?? "")
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.blackColor)
            }
            .padding(.leading, 16)

            HStack {
                Image("ic_note")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(viewModel.shopMasterCategory.descript ?? "")
                    .font(.appFont(interFont: .regular, size: 12))
                    .foregroundColor(Color.AppColor.blackColor)
            }
            .padding(.leading, 16)
        })
    }

    func itemPageView(_ urlString: String, _ isPresentFullScren: Bool = false) -> some View {
        return ImageView(withURL: urlString,
                         isPresentFullScreen: viewModel.state.isShowFullSizeImage)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .center)
            .padding(.all, 0)
    }

    var pageView: some View {
        return
            TabView(selection: $viewModel.state.selectionTab,
                    content: {
                        if let data = viewModel.shopMasterCategory.banners, data.count != 0 {
                            ForEach(data, id: \.imgUrl) { element in
                                itemPageView(element.imgUrl, viewModel.state.isShowFullSizeImage)
                                    .tabItem { EmptyView() }
                                    .tag(element)
                                    .onTapGesture {
                                        self.viewModel.state.isShowFullSizeImage = true
                                    }
                            }
                        } else {
                            if let url = viewModel.shopMasterCategory.imgUrl {
                                itemPageView(url, viewModel.state.isShowFullSizeImage)
                                    .onTapGesture {
                                        self.viewModel.state.isShowFullSizeImage = true
                                    }
                            }
                        }
            })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}
