//
//  PhoneInput.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct PhoneInputView: View {
    @ObservedObject var viewModel: PhoneInputViewModel

    var body: some View {
        LoadingIndicatorView(isShowing: $viewModel.state.isShowIndicator) {
            VStack {
                inputView
                    .padding(.all, 24)
                actionView
            }
            .padding(.bottom, 12.scaleH)
            .sheet(isPresented: $viewModel.state.isShowPlace, content: {
                placeSheetView
            })
        }
    }

    var actionView: some View {
        return VStack(alignment: .leading, spacing: 12.scaleH, content: {
            if viewModel.state.isSucces {
                NavigationLink(destination: VerifiCodeView(viewModel: VerifiCodeViewModel(viewModel.phoneRequest, viewModel.state.verificodeId)),
                               isActive: $viewModel.state.isSucces) {
                    EmptyView()
                }
                .hidden()
                .alert(isPresented: $viewModel.state.isFail) {
                    Alert(title: Text(viewModel.state.error.localizedDescription))
                }
            }

            LinkedText(Strings.PhoneInputView.textPolicy,
                       linkName: Strings.PhoneInputView.linkOpenPolicy,
                       font: .appFont(interFont: .regular, size: 13))
                .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))

            Button(action: {
                viewModel.action = .requestPhoneTofireBase
            }, label: {
                Text(Strings.Action.next)
                    .font(.appFont(interFont: .semiBold, size: 15))
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 48.scaleH)
                    .background(viewModel.state.canUsingPhoneNumber ?
                        Color.AppColor.appColor : Color.AppColor.textPlaceHolder)
                    .clipShape(RoundedRectangle(cornerRadius: 48.scaleH))
            })
                .allowsHitTesting(viewModel.state.canUsingPhoneNumber)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
        })
    }

    var inputView: some View {
        return VStack(alignment: .leading, spacing: 15, content: {
            Text(Strings.PhoneInputView.inputPhoneNumber)
                .font(.appFont(interFont: .bold, size: 18))
            HStack {
                buttonShowPlaceView
                Rectangle()
                    .frame(width: 1, height: 45.scaleH)
                    .foregroundColor(Color.AppColor.grayBorderColor)
                phoneInputView
            }
            .padding(.leading, 24)
            .overlay(RoundedRectangle(cornerRadius: 45.scaleH)
                .stroke(Color.AppColor.grayBorderColor, lineWidth: 1))
            Spacer()
        })
    }

    var buttonShowPlaceView: some View {
        Button(action: {
            viewModel.action = .showPlace(true)
        }, label: {
            HStack(alignment: .center, spacing: 0, content: {
                Text(viewModel.state.regionFlag.emoji)
                    .font(.system(size: 20))
                Text(viewModel.state.regionFlag.dialCode)
                    .padding(.all, 0)
                    .font(.appFont(interFont: .bold, size: 13))
                    .foregroundColor(Color.AppColor.blackColor)
            })
                .padding(.leading, -10)
        })
    }

    var phoneInputView: some View {
        return ZStack(alignment: .leading) {
            FormattedTextField(Strings.PhoneInputView.placeHolderPhone,
                               value: $viewModel.phoneInputNumber,
                               formatter: CurrencyTextFieldFormatter(limit: 12))
                .font(.appFont(interFont: .bold, size: 13))
                .padding(.leading, 10)
                .foregroundColor(Color.AppColor.blackColor)
                .keyboardType(.phonePad)
        }
    }

    var placeSheetView: some View {
        return VStack {
            actionPlaceView
            if viewModel.regionSearchName.isEmpty {
                pickerPlaceView
            } else {
                sortListPlaceView
            }
        }
    }

    var pickerPlaceView: some View {
        return Picker(selection: $viewModel.state.regionFlag,
                      label: Text(verbatim: Strings.PhoneInputView.place),
                      content: {
                          ForEach(areaCodes, id: \.self) { i in
                              Text(i.regionName + ": " + i.place)
                          }
        })
    }

    var sortListPlaceView: some View {
        return List {
            ForEach(viewModel.state.places, id: \.regionName) { i in
                Button(action: {
                    viewModel.regionSearchName = ""
                    viewModel.state.regionFlag = i
                }, label: {
                    Text("\(i.regionName)")
                })
            }
        }
    }

    var actionPlaceView: some View {
        return HStack(alignment: .center, spacing: nil, content: {
            HStack {
                Text(viewModel.state.regionFlag.emoji)
                    .padding(.leading, 10)
                    .font(.system(size: 20))
                Text(viewModel.state.regionFlag.dialCode)
                    .font(.appFont(interFont: .bold, size: 13))
                    .foregroundColor(Color.AppColor.blackColor)
            }
            Spacer()
            TextField(Strings.Action.search, text: $viewModel.regionSearchName)
                .frame(width: 150, alignment: .center)
            Spacer()
            Button(action: {
                viewModel.action = .showPlace(false)
            }, label: {
                Text(Strings.Action.done)
            })
        })
    }
}

struct PhoneInputView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneInputView(viewModel: PhoneInputViewModel())
    }
}
