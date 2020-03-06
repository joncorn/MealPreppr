//
//  DoubleExtension.swift
//  MealPreppr
//
//  Created by Jon Corn on 3/4/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import Foundation

extension Double {
  var clean: String {
    return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
  }
}
