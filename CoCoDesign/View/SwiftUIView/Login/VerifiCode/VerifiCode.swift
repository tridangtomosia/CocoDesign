//
//  VerifiCode.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI
import Combine

struct VerifiCode: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var viewModel = ViewModel()
    @State private var cancellables = Set<AnyCancellable>()
    var dialCode = "+84"
    @ObservedObject var phone: PhoneVerifyObserver
    
    var body: some View {
        LoadingIndicatorView(isShowing: $viewModel.isShowProgress) {
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
                if viewModel.isFirstBecome {
                    VerificodeViewModel(verificationID: $viewModel.stateVerificode.id,
                                        timeRemaining: $viewModel.timeRemaining,
                                        phoneNumber: dialCode + phone.phoneRequest,
                                        isShowProgress: $viewModel.isShowProgress).sendPhone()
                    viewModel.isFirstBecome = false
                }
            }}
    }

    private func actionView() -> some View {
        return VStack {
            NavigationLink(destination: RegisterProfile(phone: phone),
                           isActive: $viewModel.stateLogin.sucessNewLogin) {
                EmptyView()
            }
            .hidden()
            
            NavigationLink(destination: Text("Old User"),
                           isActive: $viewModel.stateLogin.sucessOldLogin) {
                EmptyView()
            }
            .hidden()

            Button(Strings.Action.next) {
                SignInAuthCredentialViewModel(cancellables: $cancellables,
                                              stateLogin: $viewModel.stateLogin,
                                              isShowLoading: $viewModel.isShowProgress,
                                              stateVerificode: viewModel.stateVerificode,
                                              phoneNumber: phone.phoneRequest).signIn()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 48.scaleH)
            .foregroundColor(.white)
            .background(viewModel.stateVerificode.sucess ?
                Color.AppColor.appColor : Color.AppColor.textPlaceHolder)
            .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
            .allowsHitTesting(viewModel.stateVerificode.sucess)
            .alert(isPresented: $viewModel.stateLogin.failLogin, content: {
                Alert(title: Text("ERROR"), message: Text(viewModel.stateLogin.loginFail.localizedDescription), dismissButton: .cancel({
                    viewModel.stateLogin.failLogin = false
                }))
                    
            })
            Spacer()
                .frame(height: 14.scaleH)

            Button(action: {
                VerificodeViewModel(verificationID: $viewModel.stateVerificode.id,
                                    timeRemaining: $viewModel.timeRemaining,
                                    phoneNumber: dialCode + phone.phoneRequest,
                                    isShowProgress: $viewModel.isShowProgress).sendPhone()
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
            Text(Strings.AppText.VerificodeView.codeOPT)
                .font(.appFont(interFont: .bold, size: 18))
            Spacer()
                .frame(height: 10.scaleH)
            Text(Strings.AppText.VerificodeView.inputCodeOTP)
                .foregroundColor(Color.AppColor.grayTextColor)
                .font(.appFont(interFont: .semiBold, size: 12))
            Text(dialCode + " " + phone.phone)
                .foregroundColor(Color.AppColor.blackColor)
                .font(.appFont(interFont: .semiBold, size: 12))
            Spacer()
                .frame(height: 25.scaleH)
            OTPView(verifiCode: $viewModel.stateVerificode.code, isInputFull: $viewModel.stateVerificode.sucess)
                .frame(height: 43.scaleH)
                .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 9))
        })
    }

    private func cowndownView() -> some View {
        return HStack {
            Text(Strings.AppText.VerificodeView.timeOTP)
                .font(.appFont(interFont: .semiBold, size: 11))
                .foregroundColor(.black)
            Text(timeFormater(second: viewModel.timeRemaining))
                .foregroundColor(.red)
                .font(.appFont(interFont: .semiBold, size: 11))
                .onReceive(viewModel.timer) { _ in
                    if self.viewModel.timeRemaining > 0 {
                        self.viewModel.timeRemaining -= 1
                    }
                }
        }
    }

    private func timeFormater(second: Int) -> String {
        let sec = second % 60
        let minute = second / 60
        return "\(minute): \(sec)"
    }
    
    struct ViewModel {
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        var stateLogin = StateLogin()
        var stateVerificode = StateVerificode()
        var timeRemaining = 0
        var isShowProgress = false
        var isFirstBecome = true
        var token = Token(token: "", accountStatus: "")
    }
}

struct VerifiCode_Previews: PreviewProvider {
    static var previews: some View {
        VerifiCode( phone: PhoneVerifyObserver())
    }
}
