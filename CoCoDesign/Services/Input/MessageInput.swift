//
//  MessageInput.swift
//  join_chat
//
//  Created by 79 on 7/30/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct MessageInput {
    final class UploadImageMessage: Input<UserImage> {
        init(roomID: String) {
            super.init()
            url = APIPath.User.uploadImageMessage
            method = .post
            parameter = ["room_id": roomID]
        }
    }
}
