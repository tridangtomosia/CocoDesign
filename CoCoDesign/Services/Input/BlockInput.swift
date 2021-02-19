//
//  BlockInput.swift
//  join_chat
//
//  Created by Phuong Vo on 10/7/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct BlockInput {
    final class PostBlockFriend: Input<Bool> {
        init(id: Int) {
            super.init()
            url = APIPath.User.blockFriend(id: id)
            method = .post
        }
    }

    final class PostUnBlockFriend: Input<Bool> {
        init(id: Int) {
            super.init()
            url = APIPath.User.unblockFriend(id: id)
            method = .delete
        }
    }

    final class GetListBlockFriend: Input<[BlockFriend]> {
        init(page: Int) {
            super.init()
            url = APIPath.User.getBlockFriend
            parameter?["page"] = page
        }
    }

    final class CheckBlockFriend: Input<Bool> {
        init(id: Int) {
            super.init()
            url = APIPath.User.checkBlockFriend(id: id)
        }
    }
}
