//
//  URL.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import UIKit

extension URL {
    var request: URLRequest {
        return URLRequest(url: self)
    }
//
//    func open() {
//        if #available(iOS 10.0, *) {
//            kApplication.open(self, options: [:], completionHandler: nil)
//        } else {
//            kApplication.openURL(self)
//        }
//    }
//
//    func valueOf(_ queryParamaterName: String) -> String? {
//        guard let url = URLComponents(string: self.absoluteString) else { return nil }
//        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
//    }
}
