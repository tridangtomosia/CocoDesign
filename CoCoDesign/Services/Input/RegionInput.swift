//
//  RegionInput.swift
//  join_chat
//
//  Created by apple on 7/8/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct RegionInput {
    final class GetRegion: Input<[Region]> {
        override init() {
            super.init()
            url = APIPath.Region.region
        }
    }
}
