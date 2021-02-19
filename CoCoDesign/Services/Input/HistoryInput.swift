//
//  HistoryInput.swift
//  join_chat
//
//  Created by Phuong Vo on 9/30/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct HistoryInput {
    final class GetCallHistories: Input<[CallHistory]> {
        override init() {
            super.init()
            url = APIPath.User.callHistories
        }
    }

    final class DeleteCallHistory: Input<Bool> {
        init(id: Int) {
            super.init()
            url = APIPath.User.deleteCallHistory(id: id)
            method = .delete
        }
    }
    
    final class ReportUser: Input<Bool> {
        init(id: Int, reason: String, reasonDetail: String?) {
            super.init()
            url = APIPath.User.reportUser(id: id)
            parameter = ["reason" : reason]
            if let reasonDetail = reasonDetail {
                parameter?["reason_detail"] = reasonDetail
            }
            method = .post
        }
    }
}
