//
//  InviteInput.swift
//  join_chat
//
//  Created by 79 on 8/12/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct ChannelInput {
    final class SendInvite: Input<InviteResponse> {
        init(id: String) {
            super.init()
            method = .post
            url = APIPath.Channel.invite(id: id)
        }
    }

    final class UserEffect: Input<Bool> {
        init(channelId: String, effectIds: [Int]) {
            super.init()
            method = .put
            url = APIPath.Channel.effects
            parameter = ["channel_id": channelId,
                         "effect_id": effectIds]
        }
    }

    final class UpdateCallHistory: Input<Bool> {
        init(channelId: String) {
            super.init()
            method = .post
            url = APIPath.Channel.callHistory(channelId: channelId)
            parameter = ["device_id": Helper.getUDID()]
        }
    }

    final class StatusOwnerChannel: Input<ChannelStatusResponse> {
        init(ownerId: String) {
            super.init()
            method = .get
            url = APIPath.Channel.ownerStatus(ownerId: ownerId)
        }
    }

    final class AnswerInviteGroup: Input<Bool> {
        init(channelName: String, actionAnswer: Int) {
            super.init()
            method = .put
            url = APIPath.Channel.answerInviteGroup
            parameter = ["name": channelName,
                         "is_accepted": actionAnswer]
        }
    }
    
    final class TopMatchingCreateChannel: Input<InviteResponse> {
        override init() {
            super.init()
            method = .post
            url = APIPath.Channel.topMatchingCreateChannel
        }
    }
}
