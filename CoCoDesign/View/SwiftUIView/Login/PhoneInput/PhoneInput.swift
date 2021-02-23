//
//  PhoneInput.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

private struct Configuration {
    static let linkPolicy = "Bằng việc chọn tiếp tục, bạn đã đồng ý với https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui của CoCo"
    static let linkNamePolicy = "Điều khoản & Điều kiện"
    static let placeHolderDefaultPhone = "000-000-0000"
    static let InputPhoneLabel = "Nhập số điện thoại"
}

struct PhoneInput: View {
    @ObservedObject private var phoneNumber = PhoneInputObserver()
    @State private var regionFlag: RegionFlag = RegionFlag(regionName: "Viet Nam", emoji: "🇻🇳", dialCode: "+84")
    @State private var searchRegion: String = ""
    @State private var isPresentPicker = false
    @State var isPushWebView: Bool = false

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15, content: {
                Text(Configuration.InputPhoneLabel)
                    .font(.appFont(interFont: .bold, size: 18))
                HStack {
                    Button(action: {
                        isPresentPicker.toggle()
                    }, label: {
                        HStack(alignment: .center, spacing: 0, content: {
                            Text(regionFlag.emoji)
                                .font(.system(size: 20))
                            Text(regionFlag.dialCode)
                                .padding(.all, 0)
                                .font(.appFont(interFont: .bold, size: 13))
                                .foregroundColor(Color.AppColor.blackColor)
                        })
                        .padding(.leading, -10)
                    })
                                        
                    Rectangle()
                        .frame(width: 1, height: 45.scaleH)
                        .foregroundColor(Color.AppColor.grayBorderColor)
                    
                    ZStack(alignment: .leading) {
                        if phoneNumber.phoneNumber.isEmpty {
                            Text(Configuration.placeHolderDefaultPhone)
                                .font(.appFont(interFont: .bold, size: 13))
                                .foregroundColor(Color.AppColor.textPlaceHolder)
                                .padding(.leading, 10)
                        }
                        TextField("", text: $phoneNumber.phoneNumber)
                            .padding(.leading, 10)
                            .foregroundColor(Color.AppColor.blackColor)
                    }
                }
                .padding(.leading, 24)
                .overlay(RoundedRectangle(cornerRadius: 45.scaleH)
                    .stroke(Color.AppColor.grayBorderColor, lineWidth: 1))
                Spacer()
            })
                .padding(.all, 24)

            VStack(alignment: .leading, spacing: 12.scaleH, content: {
                LinkedText(Configuration.linkPolicy, linkName: Configuration.linkNamePolicy, font: .appFont(interFont: .regular, size: 13))
                    .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
                NavigationLink(
                    destination: VerifiCode(phoneNumber: phoneNumber.phoneNumber),
                    label: {
                        Text(Strings.Action.next)
                            .font(.appFont(interFont: .semiBold, size: 15))
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 48.scaleH)
                            .background(phoneNumber.isReadyToPush ?
                                Color.AppColor.appColor : Color.AppColor.textPlaceHolder)
                            .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
                    }
                )
                .allowsHitTesting(phoneNumber.isReadyToPush)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
            })
        }
        .padding(.bottom, 12.scaleH)
        .sheet(isPresented: $isPresentPicker, content: {
            pickerPlaceView()
        })
    }

    func pickerPlaceView() -> some View {
        return VStack {
            HStack(alignment: .center, spacing: nil, content: {
                HStack {
                    Text(regionFlag.emoji)
                        .padding(.leading, 10)
                        .font(.system(size: 20))
                    Text(regionFlag.dialCode)
                        .font(.appFont(interFont: .bold, size: 13))
                        .foregroundColor(Color.AppColor.blackColor)
                }
                Spacer()
                TextField(Strings.Action.search, text: $searchRegion)
                    .frame(width: 150, alignment: .center)
                Spacer()
                Button(action: {
                    isPresentPicker.toggle()
                }, label: {
                    Text(Strings.Action.done)
                })
            })

            if searchRegion.isEmpty {
                Picker(selection: $regionFlag, label: Text(Strings.AppText.place), content: {
                    ForEach(areaCodes, id: \.self) { i in
                        Text(i.regionName + ": " + i.place)
                    }
                })
            } else {
                List {
                    let places = areaCodes.filter { (RegionFlag) -> Bool in
                        RegionFlag.regionName.contains(searchRegion)
                    }

                    ForEach(places, id: \.regionName) { i in
                        Button(action: {
                            searchRegion = ""
                            regionFlag = i
                        }, label: {
                            Text("\(i.regionName)")
                        })
                    }
                }
            }
        }
    }
}

struct PhoneInput_Previews: PreviewProvider {
    static var previews: some View {
        PhoneInput()
    }
}
