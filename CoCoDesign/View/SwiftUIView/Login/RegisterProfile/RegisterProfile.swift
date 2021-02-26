//
//  RegisterProfile.swift
//  CoCoDesign
//
//  Created by apple on 2/25/21.
//

import Combine
import SwiftUI

struct RegisterProfile: View {
    @ObservedObject var phone: PhoneVerifyObserver
    @State private var cancellables = Set<AnyCancellable>()
    @State var viewModel = ViewModel()

    var body: some View {
        VStack {
            LoadingIndicatorView(isShowing: $viewModel.isShowProgress) {
                NavigationView {
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
                        .navigationBarTitle(Text(Strings.BarTitle.registerView)
                            .font(.appFont(interFont: .bold, size: 16)),
                            displayMode: .inline)
                        .navigationBarItems(trailing:
                            NavigationLink(
                                destination: Text("Destination"),
                                label: {
                                    Text(Strings.Action.skip)
                                        .font(.appFont(interFont: .semiBold, size: 13))
                                        .foregroundColor(Color.AppColor.blackColor)
                            })
                        )
                }
            }
        }
        .navigationBarHidden(true)
    }

    func inputView() -> some View {
        return VStack(alignment: .leading, spacing: nil, content: {
            Text(Strings.AppText.RegisterProfileView.fullName)
                .font(.appFont(interFont: .bold, size: 13))
                .foregroundColor(Color.AppColor.blackColor)
            ZStack {
                var onchange = false
                TextField(Strings.AppText.RegisterProfileView.placeHolderInputName, text: $viewModel.fullName)
                    .font(.appFont(interFont: .bold, size: 13))
                    .padding(.leading, 20)
                    .foregroundColor(onchange ? Color.AppColor.textPlaceHolder : Color.AppColor.blackColor)
                    .onChange(of: "", perform: { _ in
                        onchange = true
                    })
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
            Text(Strings.AppText.RegisterProfileView.phoneNumber)
                .font(.appFont(interFont: .bold, size: 13))
                .foregroundColor(Color.AppColor.blackColor)
            ZStack {
                TextField("0\(phone.phoneNumber)", text: .constant(""))
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
            Button(action: {
                RegisterViewModel(cancellables: $cancellables,
                                  isShowIndicator: $viewModel.isShowProgress,
                                  isCompletedUpdate: $viewModel.isCompletedRegister,
                                  fullName: viewModel.fullName)
                    .register()
            }, label: {
                Text(Strings.Action.save)
                    .font(.appFont(interFont: .bold, size: 13))
                    .padding(.leading, 10)
                    .foregroundColor(Color.AppColor.blackColor)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 48)
                    .background(viewModel.fullName.isEmpty ?
                        Color.AppColor.textPlaceHolder : Color.AppColor.appColor)
                    .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
            })
        })
    }

    struct ViewModel {
        var isFirstBecome = true
        var fullName = ""
        var isShowProgress = false
        var isCompletedRegister = false
    }
}

struct RegisterProfile_Previews: PreviewProvider {
    static var previews: some View {
        RegisterProfile(phone: PhoneVerifyObserver())
    }
}
