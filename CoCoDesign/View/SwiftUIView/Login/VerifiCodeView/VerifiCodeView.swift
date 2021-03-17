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

    @State private var inputCode = ""
    @State private var timeRemaining = 90
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ActivityIndicatorLoadingView(isShowing: $viewModel.state.isShowIndicator) {
            VStack {
                NavigationBarCustomeView(isLeftHidden: false, leftAction: {
                    presentationMode.wrappedValue.dismiss()
                }, barView: Text(""))
                    .frame(alignment: .top)
                Spacer()
                    .frame(height: 20.scaleH)

                inputView
                    .padding(EdgeInsets(top: 0,
                                        leading: 24,
                                        bottom: 0,
                                        trailing: 24))
                Spacer()
                    .frame(height: 16.scaleH)
                cowndownView
                Spacer()
                actionView
                    .padding(EdgeInsets(top: 0,
                                        leading: 24,
                                        bottom: 0,
                                        trailing: 24))
            }
            .padding(.bottom, 12.scaleH)
            .onDisappear {
                timer.upstream.connect().cancel()
            }
        }
        .navigationBarHidden(true)
    }

    var actionView: some View {
        return VStack {
            if viewModel.state.isOldUser || viewModel.state.isNewUser {
                NavigationLink(destination: RegisterProfileView(RegisterProfileViewModel(viewModel.phoneNumber)),
                               isActive: $viewModel.state.isNewUser) {
                    EmptyView()
                }
                .hidden()

                NavigationLink(destination: HomeCategoriesView(HomeCategoriesViewModel()),
                               isActive: $viewModel.state.isOldUser) {
                    EmptyView()
                }
                .hidden()
            }

            Button(action: {
                timer.upstream.connect().cancel()
                viewModel.action = .login(inputCode)
            }, label: {
                Text(Strings.Action.next)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 48.scaleH)
                    .foregroundColor(.white)
                    .background(inputCode.count == 6 ?
                        Color.AppColor.appColor : Color.AppColor.textPlaceHolder)
                    .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
            })
                .allowsHitTesting(inputCode.count == 6)
                .alert(isPresented: $viewModel.state.isFail, content: {
                    Alert(title: Text(Strings.Title.error),
                          message: Text(viewModel.state.error.localizedDescription),
                          dismissButton: .cancel({
                              viewModel.state.isFail = false
                              inputCode = ""
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

    var inputView: some View {
        return VStack(alignment: .leading, spacing: nil, content: {
            Text(Strings.VerificodeView.codeOPT)
                .font(.appFont(interFont: .bold, size: 18))
            Spacer()
                .frame(height: 10.scaleH)
            Text(Strings.VerificodeView.inputCodeOTP)
                .foregroundColor(Color.AppColor.grayTextColor)
                .font(.appFont(interFont: .semiBold, size: 12))
            Text(viewModel.phoneNumber.phoneFormat("+## ### ### #####"))
                .foregroundColor(Color.AppColor.blackColor)
                .font(.appFont(interFont: .semiBold, size: 12))
            Spacer()
                .frame(height: 25.scaleH)
            OTPView(verifiCode: $inputCode)
                .frame(height: 43.scaleH)
                .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 9))
        })
    }

    var cowndownView: some View {
        return HStack {
            Text(Strings.VerificodeView.timeOTP)
                .font(.appFont(interFont: .semiBold, size: 11))
                .foregroundColor(.black)
            Text(viewModel.timeFormater(seconds: timeRemaining))
                .foregroundColor(.red)
                .font(.appFont(interFont: .semiBold, size: 11))
                .onReceive(timer) { _ in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        self.viewModel.state.isCanAction = false
                        timer.upstream.connect().cancel()
                    }
                }
        }
    }
}
