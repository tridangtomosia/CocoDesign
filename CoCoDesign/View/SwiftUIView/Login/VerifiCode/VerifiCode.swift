//
//  VerifiCode.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct VerifiCode: View {
    var phoneNumber: String
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: nil, content: {
                Text("Mã xác thực OTP").font(.system(size: 18)).bold()
                Text("Nhập mã OTP vừa được gửi đến số điện thoai:\n \(phoneNumber)")
                    .font(.system(size: 12))
                AreaInputCode(inputCode: CodeInputObserver())
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
                            .background(Color(hex: "#34ADB1"))
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
                                .stroke(Color(hex: "#34ADB1"), lineWidth: 1)
                        )
                })
                Spacer().frame(height: 40.scaleH)
            }
        }
    }
}

struct VerifiCode_Previews: PreviewProvider {
    static var previews: some View {
        VerifiCode(phoneNumber: "123456789")
    }
}
