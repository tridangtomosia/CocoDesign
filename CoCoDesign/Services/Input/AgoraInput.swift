//
//  AgoraInput.swift
//  join_chat
//
//  Created by 79 on 12/15/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct AgoraInput {
    final class GetChannelInformation: Input<AgoraChannelData> {
        init(channelName: String) {
            super.init()
            url = APIPath.AgoraChannelProfile.getAgoraChannelProfile(appId: KeyCenter.agoraAppID, channelName: channelName)
            let loginString = "\(KeyCenter.agoraUserName):\(KeyCenter.agoraPassword)"
             guard let loginData = loginString.data(using: String.Encoding.utf8) else { return }
             let base64LoginString = loginData.base64EncodedString()
            header?["Authorization"] = "Basic " + base64LoginString
        }
    }
}
