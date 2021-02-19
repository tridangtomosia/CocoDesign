//
//  PurposeInput.swift
//  join_chat
//
//  Created by apple on 7/14/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct PurposeInput {
    final class GetPurpose: Input<[Purpose]> {
        override init() {
            super.init()
            url = APIPath.Purpose.purpose
        }
    }
}
