//
//  GroceryListTableViewCell.swift
//  MealPreppr
//
//  Created by Jon Corn on 3/2/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import UIKit

class GroceryListTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  var mealLanding: Meal?
  var groceriesLanding: MealContents?
  
  // MARK: - Outlets
  @IBOutlet weak var itemNameLabel: UILabel!
  @IBOutlet weak var itemQtyLabel: UILabel!
  @IBOutlet weak var measurementTypeLabel: UILabel!
  
  // MARK: - Methods
  
  func updateViews() {
    guard let groceries = groceriesLanding, let meal = mealLanding else {return}
    let qty = groceries.itemMeasurement ?? 1
    itemNameLabel.text = groceries.itemName
    measurementTypeLabel.text = groceries.itemMeasurementType
    itemQtyLabel.text = "\(updateQty(qty: qty, mealCount: meal.mealCount).clean)"
  }
  
  func updateQty(qty: Double, mealCount: Int) -> Double {
    let mealCountAsDouble = Double(mealCount)
    let multipliedQty = qty * mealCountAsDouble
    return multipliedQty
  }
}
