//
//  VerifiCode.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

private struct Configuration {
    static let codeOPTLabel = "Mã xác thực OTP"
    static let inputCodeOTPLabel = "Nhập mã OTP vừa được gửi đến số điện thoai:"
    static let timeInputOTP = "Thời hạn OTP: "
    static let timeLimit = 0
}

struct VerifiCode: View {
//    @ObservedObject var verificodeViewModel: VerificodeViewModel
    @ObservedObject var stateLogin = StateLogin()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var dialCode: String
    @State var verifiCode: String = ""
    @State var verifiCodeId: String = ""
    @State var timeRemaining = Configuration.timeLimit
    @State var sucsessVerificode = false
    var phone = PhoneInputObserver()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20.scaleH)
            inputView()
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
            Spacer()
                .frame(height: 16.scaleH)
            cowndownView()
            Spacer()
            actionView()
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
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
            VerificodeViewModel(verificationID: $verifiCodeId, timeRemaining: $timeRemaining).sendPhone(phoneNumber: dialCode + phone.phoneRequest)
        }
        
    }

    func actionView() -> some View {
        return VStack {
            NavigationLink(destination: Text(verifiCode), isActive: $stateLogin.successLogin) { EmptyView() }
            Button(Strings.Action.next) {
                SignInAuthCredential().signIn(verifiCode, verificationID: verifiCodeId)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 48.scaleH)
            .foregroundColor(.white)
            .background(sucsessVerificode ?
                Color.AppColor.appColor : Color.AppColor.textPlaceHolder)
            .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
            .allowsHitTesting(sucsessVerificode)
//            NavigationLink(
//                destination: Text(verifiCode),
//                label: {
//                    Text(Strings.Action.next)
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .frame(height: 48.scaleH)
//                        .foregroundColor(.white)
//                        .background(sucsessVerificode ?
//                            Color.AppColor.appColor : Color.AppColor.textPlaceHolder)
//                        .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
//            }).allowsHitTesting(sucsessVerificode)

            Spacer()
                .frame(height: 14.scaleH)

            Button(action: {
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

    func inputView() -> some View {
        return VStack(alignment: .leading, spacing: nil, content: {
            Text(Configuration.codeOPTLabel)
                .font(.appFont(interFont: .bold, size: 18))
            Spacer()
                .frame(height: 10.scaleH)
            Text(Configuration.inputCodeOTPLabel)
                .foregroundColor(Color.AppColor.grayTextColor)
                .font(.appFont(interFont: .semiBold, size: 12))
            Text(dialCode + " " + phone.phoneNumber)
                .foregroundColor(Color.AppColor.blackColor)
                .font(.appFont(interFont: .semiBold, size: 12))
            Spacer()
                .frame(height: 25.scaleH)
            OTPView(verifiCode: $verifiCode, isInputFull: $sucsessVerificode)
                .frame(height: 43.scaleH)
                .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 9))
        })
    }

    func cowndownView() -> some View {
        return HStack {
            Text(Configuration.timeInputOTP)
                .font(.appFont(interFont: .semiBold, size: 11))
                .foregroundColor(.black)
            Text(timeFormater(second: timeRemaining))
                .foregroundColor(.red)
                .font(.appFont(interFont: .semiBold, size: 11))
                .onReceive(timer) { _ in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    }
                }
        }
    }

    func timeFormater(second: Int) -> String {
        let sec = second % 60
        let minute = second / 60
        return "\(minute): \(sec)"
    }
}

//struct VerifiCode_Previews: PreviewProvider {
//    static var previews: some View {
//        VerifiCode(dialCode: "+84", phone: PhoneInputObserver())
//    }
//}
