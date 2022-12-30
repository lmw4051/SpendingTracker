//
//  UIColorExtension.swift
//  SpendingTracker
//
//  Created by David Lee on 12/30/22.
//

import SwiftUI

extension UIColor {
  class func color(data: Data) -> UIColor? {
    return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
  }
  func encode() -> Data? {
    return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
  }
}
