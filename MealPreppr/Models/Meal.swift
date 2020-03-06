//
//  Meal.swift
//  MealPreppr
//
//  Created by Jon Corn on 2/26/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import Foundation
import UIKit.UIImage

class Meal: Codable {
  var mealName: String
  var mealCount: Int
  var groceryList: [MealContents]
  let uuid: UUID
  
  init(mealName: String, mealCount: Int = 1, groceryList: [MealContents] = [], uuid: UUID = UUID()) {
    self.mealName = mealName
    self.mealCount = mealCount
    self.groceryList = groceryList
    self.uuid = uuid
  }
}

// MARK: - Equatable ext.
extension Meal: Equatable {
  static func == (lhs: Meal, rhs: Meal) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}
