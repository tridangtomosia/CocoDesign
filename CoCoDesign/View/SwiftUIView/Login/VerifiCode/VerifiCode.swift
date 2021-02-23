//
//  VerifiCode.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct VerifiCode: View {
    @EnvironmentObject var phoneViewModel: PhoneViewModel
    @State var phoneNumber: String
    var body: some View {
        if #available(iOS 14.0, *) {
            VStack {
                VStack(alignment: .leading, spacing: nil, content: {
                    Text("Mã xác thực OTP").font(.system(size: 18)).bold()
                    Text("Nhập mã OTP vừa được gửi đến số điện thoai:\n \(phoneNumber)")
                        .font(.system(size: 12))
                    OTP2UIView(text: $phoneNumber)
                        .frame(height: 50)
                })
                Spacer()
                VStack {
                    NavigationLink(
                        destination: Text("Hello"),
                        label: {
                            Text("Tiep Tuc")
                                .frame(width: 250.scaleW, height: 25.scaleH, alignment: .center)
                                .foregroundColor(.white)
                                .padding(.all, 10)
                                .background(Color.AppColor.appColor)
                                .clipShape(RoundedRectangle(cornerRadius: 25.scaleH))
                        })
                    
                    Button(action: {
                    }, label: {
                        Text("Gửi lại mã OTP")
                            .foregroundColor(Color(hex: "#9FA5C0"))
                            .frame(width: 250.scaleW, height: 25.scaleH, alignment: .center)
                            .padding(.all, 10)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25.scaleH)
                                    .stroke(Color.AppColor.appColor, lineWidth: 1)
                            )
                    })
                    Spacer().frame(height: 40.scaleH)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text(Image("ic_back")))
            .onAppear(perform: {
                //            phoneViewModel.postRequest(phone: "0123123321") { (token, error) in
                //                print(token)
                //            }
                phoneViewModel.login(Phone(phone: "0123123123"))
            })
        } else {
            // Fallback on earlier versions
        }
    }
}

struct VerifiCode_Previews: PreviewProvider {
    static var previews: some View {
        VerifiCode(phoneNumber: "123456789")
    }
}
