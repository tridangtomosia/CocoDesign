//
//  AccountInput.swift
//  join_chat
//
//  Created by 79 on 7/20/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct AccountInput {
    final class SearchByAccount: Input<[UserInvite]> {
        init(account: String, page: Int) {
            super.init()
            url = APIPath.User.searchAccount
            method = .post
            parameter = ["account": account, "page": page]
        }
    }

    final class SendInvite: Input<Bool> {
        init(accountId: String, roomId: String) {
            super.init()
            url = APIPath.User.sendInvite(id: accountId)
            method = .post
            parameter = ["id": accountId,
                         "room_id": roomId]
        }
    }

    final class DeleteInvite: Input<Bool> {
        init(id: String) {
            super.init()
            url = APIPath.User.deleteInvite(id: id)
            method = .delete
        }
    }

    final class CheckStatusFriend: Input<FriendStatusModel> {
        init(id: String) {
            super.init()
            url = APIPath.User.checkStatusFriend(id: id)
        }
    }

    final class AnswerInviteFriend: Input<Bool> {
        init(id: String, action: String) {
            super.init()
            url = APIPath.User.answerInviteFriend(id: id, answer: action)
            method = .put
        }
    }
}
