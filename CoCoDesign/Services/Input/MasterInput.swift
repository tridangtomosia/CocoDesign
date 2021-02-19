//
//  MasterInput.swift
//  join_chat
//
//  Created by Phuong Vo on 8/31/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct MasterInput {
    final class GetEffects: Input<EffectData> {
        override init() {
            super.init()
            url = APIPath.Master.effects
        }
    }
}
