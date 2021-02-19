//
//  IAPInput.swift
//  join_chat
//
//  Created by 79 on 8/10/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct IAPInput {
    final class UploadReceipt: Input<Bool> {
        init(iapInformation: IAPInformation) {
            super.init()
            method = .post
            parameter = iapInformation.dictionary
            url = APIPath.User.uploadReceipt
        }
    }
}
