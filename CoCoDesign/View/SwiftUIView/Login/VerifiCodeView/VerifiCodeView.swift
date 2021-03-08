//
//  VerifiCode.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import Combine
import SwiftUI

struct VerifiCodeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: VerifiCodeViewModel

    var body: some View {
        LoadingIndicatorView(isShowing: $viewModel.state.isShowIndicator) {
            VStack {
                Spacer()
                    .frame(height: 20.scaleH)
                
                
                inputView()
                    .padding(EdgeInsets(top: 0,
                                        leading: 24,
                                        bottom: 0,
                                        trailing: 24))
                Spacer()
                    .frame(height: 16.scaleH)
                cowndownView()
                Spacer()
                actionView()
                    .padding(EdgeInsets(top: 0,
                                        leading: 24,
                                        bottom: 0,
                                        trailing: 24))
            }
            .padding(.bottom, 12.scaleH)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Image("ic_back")
                .resizable()
                .frame(width: 10, height: 18, alignment: .center)
                .padding(.all, 0)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                viewModel.isStartCowndown = true
            }
        }
    }

    private func actionView() -> some View {
        return VStack {
//            NavigationLink(destination: RegisterProfileView(RegisterProfileViewModel(viewModel.phoneNumber)),
//                           isActive: $viewModel.state.isNewUser) {
//                EmptyView()
//            }
//            .hidden()
//
//            NavigationLink(destination: RegisterProfileView(RegisterProfileViewModel(viewModel.phoneNumber)),
//                           isActive: $viewModel.state.isOldUser) {
//                EmptyView()
//            }
//            .hidden()

            if viewModel.state.isOldUser || viewModel.state.isNewUser {
                NavigationLink(destination: HomeCategoriesView(HomeCategoriesViewModel()),
                               isActive: $viewModel.state.isOldUser) {
                    EmptyView()
                }
                .hidden()

                NavigationLink(destination: HomeCategoriesView(HomeCategoriesViewModel()),
                               isActive: $viewModel.state.isNewUser) {
                    EmptyView()
                }
                .hidden()
            }
            
            Button(action: {
                viewModel.action = .login
            }, label: {
                Text(Strings.Action.next)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 48.scaleH)
                    .foregroundColor(.white)
                    .background(viewModel.state.isCanAction ?
                        Color.AppColor.appColor : Color.AppColor.textPlaceHolder)
                    .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
            })
                .allowsHitTesting(viewModel.state.isCanAction)
                .alert(isPresented: $viewModel.state.isFail, content: {
                    Alert(title: Text("ERROR"),
                          message: Text(viewModel.state.error.localizedDescription),
                          dismissButton: .cancel({
                              viewModel.state.isNewUser = true
                              viewModel.state.isFail = false
                    }))
                })

            Spacer()
                .frame(height: 14.scaleH)

            Button(action: {
                viewModel.action = .resendCode
            }, label: {
                Text(Strings.Action.ReSendOTP)
                    .foregroundColor(Color.AppColor.grayTextColor)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 48.scaleH)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 48.scaleH)
                            .stroke(Color.AppColor.appColor, lineWidth: 1)
                    )
            })
        }
    }

    private func inputView() -> some View {
        return VStack(alignment: .leading, spacing: nil, content: {
            Text(Strings.VerificodeView.codeOPT)
                .font(.appFont(interFont: .bold, size: 18))
            Spacer()
                .frame(height: 10.scaleH)
            Text(Strings.VerificodeView.inputCodeOTP)
                .foregroundColor(Color.AppColor.grayTextColor)
                .font(.appFont(interFont: .semiBold, size: 12))
            Text(viewModel.phoneNumber)
                .foregroundColor(Color.AppColor.blackColor)
                .font(.appFont(interFont: .semiBold, size: 12))
            Spacer()
                .frame(height: 25.scaleH)
            OTPView(verifiCode: $viewModel.inputCode,
                    isInputFull: $viewModel.state.isCanAction)
                .frame(height: 43.scaleH)
                .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 9))
        })
    }

    private func cowndownView() -> some View {
        return HStack {
            Text(Strings.VerificodeView.timeOTP)
                .font(.appFont(interFont: .semiBold, size: 11))
                .foregroundColor(.black)
            Text(viewModel.state.timeRemaining)
                .foregroundColor(.red)
                .font(.appFont(interFont: .semiBold, size: 11))
        }
    }
}
