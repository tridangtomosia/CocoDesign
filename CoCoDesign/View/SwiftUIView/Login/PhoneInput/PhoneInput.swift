//
//  PhoneInput.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct PhoneInput: View {
    @State private var viewModel = ViewModel()
    @ObservedObject private var phoneVerifyObserver = PhoneVerifyObserver()
    
    var body: some View {
        VStack {
            inputView()
                .padding(.all, 24)
            actionView()
        }
        .padding(.bottom, 12.scaleH)
        .sheet(isPresented: $viewModel.isPresentPicker, content: {
            pickerPlaceView()
        })
        .onAppear(perform: {
        })
    }
    
    private func actionView() -> some View {
        return VStack(alignment: .leading, spacing: 12.scaleH, content: {
            LinkedText(Strings.AppText.PhoneInputView.textPolicy,
                       linkName: Strings.AppText.PhoneInputView.linkOpenPolicy,
                       font: .appFont(interFont: .regular, size: 13))
                .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
            
            NavigationLink(
                destination: VerifiCode(dialCode: viewModel.regionFlag.dialCode, phone: phoneVerifyObserver),
                label: {
                    Text(Strings.Action.next)
                        .font(.appFont(interFont: .semiBold, size: 15))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 48.scaleH)
                        .background(phoneVerifyObserver.isCompleted ?
                            Color.AppColor.appColor : Color.AppColor.textPlaceHolder)
                        .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
                }
            )
            .allowsHitTesting(phoneVerifyObserver.isCompleted)
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
        })
    }
    
    private func inputView() -> some View {
        return VStack(alignment: .leading, spacing: 15, content: {
            Text(Strings.AppText.PhoneInputView.inputPhoneNumber)
                .font(.appFont(interFont: .bold, size: 18))
            HStack {
                showPlaceView()
                Rectangle()
                    .frame(width: 1, height: 45.scaleH)
                    .foregroundColor(Color.AppColor.grayBorderColor)
                inputPhoneView()
            }
            .padding(.leading, 24)
            .overlay(RoundedRectangle(cornerRadius: 45.scaleH)
                .stroke(Color.AppColor.grayBorderColor, lineWidth: 1))
            Spacer()
        })
    }
    
    private func showPlaceView() -> some View {
        Button(action: {
            viewModel.isPresentPicker.toggle()
        }, label: {
            HStack(alignment: .center, spacing: 0, content: {
                Text(viewModel.regionFlag.emoji)
                    .font(.system(size: 20))
                Text(viewModel.regionFlag.dialCode)
                    .padding(.all, 0)
                    .font(.appFont(interFont: .bold, size: 13))
                    .foregroundColor(Color.AppColor.blackColor)
            })
                .padding(.leading, -10)
        })
    }

    private func inputPhoneView() -> some View {
        return ZStack(alignment: .leading) {
            if phoneVerifyObserver.phoneNumber.isEmpty {
                Text(Strings.AppText.PhoneInputView.placeHolderPhone)
                    .font(.appFont(interFont: .bold, size: 13))
                    .foregroundColor(Color.AppColor.textPlaceHolder)
                    .padding(.leading, 10)
            }
            TextField("", text: $phoneVerifyObserver.phoneNumber)
                .font(.appFont(interFont: .bold, size: 13))
                .padding(.leading, 10)
                .foregroundColor(Color.AppColor.blackColor)
        }
    }

    private func pickerPlaceView() -> some View {
        return VStack {
            HStack(alignment: .center, spacing: nil, content: {
                HStack {
                    Text(viewModel.regionFlag.emoji)
                        .padding(.leading, 10)
                        .font(.system(size: 20))
                    Text(viewModel.regionFlag.dialCode)
                        .font(.appFont(interFont: .bold, size: 13))
                        .foregroundColor(Color.AppColor.blackColor)
                }
                Spacer()
                TextField(Strings.Action.search, text: $viewModel.searchRegion)
                    .frame(width: 150, alignment: .center)
                Spacer()
                Button(action: {
                    viewModel.isPresentPicker.toggle()
                }, label: {
                    Text(Strings.Action.done)
                })
            })

            if viewModel.searchRegion.isEmpty {
                Picker(selection: $viewModel.regionFlag, label: Text(verbatim: Strings.AppText.PhoneInputView.place), content: {
                    ForEach(areaCodes, id: \.self) { i in
                        Text(i.regionName + ": " + i.place)
                    }
                })
            } else {
                List {
                    let places = areaCodes.filter { (RegionFlag) -> Bool in
                        RegionFlag.regionName.contains(viewModel.searchRegion)
                    }
                    ForEach(places, id: \.regionName) { i in
                        Button(action: {
                            viewModel.searchRegion = ""
                            viewModel.regionFlag = i
                        }, label: {
                            Text("\(i.regionName)")
                        })
                    }
                }
            }
        }
    }
    
    struct ViewModel {
        var regionFlag: RegionFlag = RegionFlag(regionName: "Viet Nam", emoji: "🇻🇳", dialCode: "+84")
        var searchRegion: String = ""
        var isPresentPicker = false
        var isPushWebView: Bool = false
    }
}

struct PhoneInput_Previews: PreviewProvider {
    static var previews: some View {
        PhoneInput()
    }
}
