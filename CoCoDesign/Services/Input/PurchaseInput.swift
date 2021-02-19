//
//  PurChases.swift
//  join_chat
//
//  Created by apple on 9/4/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct PurchaseInput {
    final class GetPurchases: Input<[PointPurchase]> {
        override init() {
            super.init()
            url = APIPath.Purchase.purchases
        }
    }
}
