/**
 * Copyright (C) 2019 Extension All Rights Reserved.
 */

import UIKit

extension CGFloat {
    var scaleW: CGFloat {
        return CGFloat(self) * ConfigurationScale.scaleW
    }

    var scaleH: CGFloat {
        return CGFloat(self) * ConfigurationScale.scaleH
    }
}

extension FloatingPoint {
    var degreesToRadians: Self {
        return self * .pi / 180
    }

    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
}
