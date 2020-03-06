//
//  AlertService.swift
//  MealPreppr
//
//  Created by Jon Corn on 2/27/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import UIKit

class AlertService {
  func CreateNewMealAlert() -> CreateNewMealAlertViewController {
    let storyboard = UIStoryboard(name: "CreateNewMealAlert", bundle: .main)
    let alertVC = storyboard.instantiateViewController(identifier: "CreateNewMealAlertVC") as! CreateNewMealAlertViewController
    return alertVC
  }
  
  func CreateNewGroceryItemAlert() -> GroceryItemAlertViewController {
    let storyboard = UIStoryboard(name: "GroceryItemAlert", bundle: .main)
    let alertVC = storyboard.instantiateViewController(identifier: "CreateNewGroceryItemVC") as! GroceryItemAlertViewController
    return alertVC
  }
}
