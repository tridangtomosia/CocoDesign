//
//  PointInput.swift
//  join_chat
//
//  Created by Phuong Vo on 9/16/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct PointInput {
    final class GetAcquisition: Input<[PointHistory]> {
        init(date: String, page: Int) {
            super.init()
            url = APIPath.User.acquisitions
            parameter?["page"] = page
            parameter?["date"] = date
        }
    }

    final class PointConsumptions: Input<Bool> {
        init(type: PointConsumptionsType, channelId: String) {
            super.init()
            url = APIPath.Point.pointConsumption
            method = .post
            parameter?["type"] = type.rawValue
            parameter?["channel_id"] = channelId
        }
    }

    final class GetPointSetting: Input<[PointSetting]> {
        override init() {
            super.init()
            url = APIPath.Point.pointSetting
        }
    }
}
