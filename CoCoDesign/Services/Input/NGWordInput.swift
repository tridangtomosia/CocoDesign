//
//  MasterInput.swift
//  join_chat
//
//  Created by Phuong Vo on 7/30/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct NGWordInput {
    final class GetNGWord: Input<[String]> {
        override init() {
            super.init()
            url = APIPath.NGWord.ngWords
        }
    }
}
