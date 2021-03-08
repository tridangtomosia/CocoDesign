//
//  RegisterProfile.swift
//  CoCoDesign
//
//  Created by apple on 2/25/21.
//

import Combine
import SwiftUI

struct RegisterProfileView: View {
    @ObservedObject var viewModel: RegisterProfileViewModel
    
    init(_ viewModel: RegisterProfileViewModel) {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.appFont(interFont: .bold, size: 16)]
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            LoadingIndicatorView(isShowing: $viewModel.state.isShowIndicator) {
                VStack(alignment: .leading, spacing: 10, content: {
                    Spacer()
                        .frame(height: 65)
                    inputView()

                    Spacer()
                        .frame(height: 6)
                    phoneView()

                    Spacer()
                        .frame(height: 48)

                    actionView()

                    Spacer()

                })
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
            }
            .navigationBarTitle(Strings.BarTitle.registerView,
                                displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(
                    destination: HomeCategoriesView(HomeCategoriesViewModel()),
                    label: {
                        Text(Strings.Action.skip)
                            .font(.appFont(interFont: .semiBold, size: 13))
                            .foregroundColor(Color.AppColor.blackColor)
                })
            )
        }
    }

    func inputView() -> some View {
        return VStack(alignment: .leading, spacing: nil, content: {
            Text(Strings.RegisterProfileView.fullName)
                .font(.appFont(interFont: .bold, size: 13))
                .foregroundColor(Color.AppColor.blackColor)
            ZStack {
                TextField(Strings.RegisterProfileView.placeHolderInputName, text: $viewModel.nameInput)
                    .font(.appFont(interFont: .bold, size: 13))
                    .padding(.leading, 20)
                    .foregroundColor(Color.AppColor.blackColor)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 48)
            .overlay(
                RoundedRectangle(cornerRadius: 48.scaleH)
                    .stroke(Color.AppColor.appColor, lineWidth: 1)
            )
        })
    }

    func phoneView() -> some View {
        return VStack(alignment: .leading, spacing: nil, content: {
            Text(Strings.RegisterProfileView.phoneNumber)
                .font(.appFont(interFont: .bold, size: 13))
                .foregroundColor(Color.AppColor.blackColor)
            ZStack {
                TextField(viewModel.phoneNumber.phoneDefaultNumber().phoneFormat("### ### ####"),
                          text: .constant(""))
                    .font(.appFont(interFont: .bold, size: 13))
                    .padding(.leading, 20)
                    .foregroundColor(Color.AppColor.blackColor)
                    .disabled(true)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.AppColor.grayBorderColor)
            .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
            .overlay(
                RoundedRectangle(cornerRadius: 48.scaleH)
                    .stroke(Color.AppColor.grayBoldColor, lineWidth: 1)
            )
        })
    }

    func actionView() -> some View {
        return VStack(alignment: .leading, spacing: nil, content: {
            NavigationLink(destination: HomeCategoriesView(HomeCategoriesViewModel()),
                           isActive: $viewModel.state.isCompletedUpdate) {
                EmptyView()
            }
            .hidden()
            Button(action: {
                viewModel.action = .register
            }, label: {
                Text(Strings.Action.save)
                    .font(.appFont(interFont: .bold, size: 13))
                    .padding(.leading, 10)
                    .foregroundColor(Color.AppColor.blackColor)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 48)
                    .background(viewModel.nameInput.isEmpty ?
                        Color.AppColor.textPlaceHolder : Color.AppColor.appColor)
                    .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
            })
        })
    }
}

//struct RegisterProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterProfileView(viewModel: RegisterProfileViewModel(""))
//    }
//}
