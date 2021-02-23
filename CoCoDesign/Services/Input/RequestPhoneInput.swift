//
//  Phone.swift
//  CoCoDesign
//
//  Created by apple on 2/19/21.
//

import Foundation

final class RequestPhoneInput: Input<Token> {
    init(phone: Phone) {
        super.init()
        url = APIPath.Phone.phone
        method = .post
        parameter = phone.dictionary
    }
}
