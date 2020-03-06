//
//  MealContents.swift
//  MealPreppr
//
//  Created by Jon Corn on 3/2/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import Foundation

class MealContents: Codable {
  var itemName: String
  var itemMeasurement: Double?
  var itemMeasurementType: String?
  
  init(itemName: String, itemMeasurement: Double?, itemMeasurementType: String?) {
    self.itemName = itemName
    self.itemMeasurement = itemMeasurement
    self.itemMeasurementType = itemMeasurementType
  }
}

extension MealContents: Equatable {
  static func == (lhs: MealContents, rhs: MealContents) -> Bool {
    return lhs.itemName == rhs.itemName && lhs.itemMeasurement == rhs.itemMeasurement && lhs.itemMeasurementType == rhs.itemMeasurementType
  }
}
