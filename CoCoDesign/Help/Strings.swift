//
//  Strings.swift
//  CoCoDesign
//
//  Created by apple on 2/22/21.
//

import Foundation

struct Strings {
    struct BarTitle {
        static let registerView = "Tài khoản của tôi"
        static let categoryView = "Danh Mục"
    }

    struct Action {
        static let ok = "OK".localized()
        static let skip = "SKIP".localized()
        static let next = "NEXT".localized()
        static let signUp = "SIGN_UP".localized()
        static let done = "DONE".localized()
        static let selectPhotoLibrary = "SELECT_PHOTO_LIBRARY".localized()
        static let takeAPhoto = "TAKE_A_PHOTO".localized()
        static let cancel = "CANCEL".localized()
        static let goToSetting = "GO_TO_SETTING".localized()
        static let invite = "INVITE".localized()
        static let block = "BLOCK".localized()
        static let delete = "DELETE".localized()
        static let reject = "REJECT".localized()
        static let approval = "APPROVAL".localized()
        static let send = "SEND".localized()
        static let retrun = "RETURN".localized()
        static let agree = "AGREE".localized()
        static let search = "SEARCH".localized()
        static let ReSendOTP = "RESENDOTP".localized()
        static let save = "SAVE".localized()
    }

    struct PhoneInputView {
        static let place = "Place".localized()
        static let textPolicy = "Bằng việc chọn tiếp tục, bạn đã đồng ý với http://af5a62e94315.ngrok.io/privacy-policy của CoCo"
        static let linkOpenPolicy = "Điều khoản & Điều kiện"
        static let placeHolderPhone = "000-000-0000"
        static let inputPhoneNumber = "Nhập số điện thoại"
    }

    struct VerificodeView {
        static let codeOPT = "Mã xác thực OTP"
        static let inputCodeOTP = "Nhập mã OTP vừa được gửi đến số điện thoai:"
        static let timeOTP = "Thời hạn OTP: "
    }

    struct RegisterProfileView {
        static let fullName = "Họ và tên"
        static let placeHolderInputName = "Nhập họ và tên"
        static let phoneNumber = "Số điện thoại"
    }

    struct CategoryView {
    }
}
