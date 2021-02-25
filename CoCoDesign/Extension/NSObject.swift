//
//  NSObject.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Foundation

extension NSObject {
  @nonobjc var className: String {
    return String(describing: type(of: self))
  }
  @nonobjc class var className: String {
    return String(describing: self)
  }
}
