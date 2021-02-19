//
//  LineInput.swift
//  join_chat
//
//  Created by 79 on 10/21/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct LineInput {
    final class GetProfile: Input<LineProfile> {
        init(accessToken: String) {
            super.init()
            url = APIPath.LineProfile.profile
            header?["Authorization"] = "Bearer " + accessToken
        }
    }
}
