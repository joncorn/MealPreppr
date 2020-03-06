//
//  MealController.swift
//  MealPreppr
//
//  Created by Jon Corn on 2/26/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import Foundation

class MealController {
  
  // MARK:  Properties
  static let shared = MealController()
  var mealsArray: [Meal] = []
  init() {
    loadFromPersistentStore()
  }
  
  // MARK: - MOCK Array/CRUD Methods
  /*
   mock array and crud functions to simulate app experience with firestore
   'comment out when complete
   */
  
    // Mock Data
  //  var meals: [Meal] {
  //    let beansMeal = Meal(mealName: "Beans/Rice/Broc", mealCount: 6, groceryList: beansMealContents)
  //    return [beansMeal]
  //  }
    // Mock Data
  //  var beansMealContents: [MealContents] {
  //    let beans = MealContents(itemName: "Beans", itemMeasurement: 6, itemMeasurementType: "Cans")
  //    let rice = MealContents(itemName: "Rice", itemMeasurement: 3, itemMeasurementType: "Cups")
  //    let broccoli = MealContents(itemName: "Broccoli", itemMeasurement: 1, itemMeasurementType: "Bag")
  //    return [beans, rice, broccoli]
  //  }
  

  
  // MARK: - CRUD Methods
  // Update Meal Contents
  func createMealContent(with mealContents: MealContents, toMeal meal: Meal) {
    meal.groceryList.append(mealContents)
    saveToPersistentStore()
  }
  
  // Update Meal Contents
  func deleteMealContent(with mealContents: MealContents, fromMeal meal: Meal) {
    guard let index = meal.groceryList.firstIndex(of: mealContents) else {return}
    meal.groceryList.remove(at: index)
    saveToPersistentStore()
  }
  
  // Update Meal Contents
  func updateMealContent(with mealContents: MealContents, toMeal meal: Meal, itemName: String, itemMeasurement: Double?, itemMeasurementType: String?) {
    mealContents.itemName = itemName
    mealContents.itemMeasurement = itemMeasurement
    mealContents.itemMeasurementType = itemMeasurementType
    saveToPersistentStore()
  }
  
  // Create top level Meal
  func createMeal(with MealName: String) {
    let meal = Meal(mealName: MealName)
    mealsArray.append(meal)
    saveToPersistentStore()
  }
  
  // Delete top level Meal
  func deleteMeal(with meal: Meal) {
    if let index = mealsArray.firstIndex(of: meal) {
      mealsArray.remove(at: index)
      saveToPersistentStore()
    }
  }
  
  func updateMeal(with meal: Meal, mealName: String, mealCount: Int, groceryList: [MealContents]) {
      meal.mealName = mealName
      meal.mealCount = mealCount
      meal.groceryList = groceryList
  }
  
  //  MARK: - JSONPersistence
  func fileURL() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = paths[0]
    let filename = "mealSaved.json"
    let fullURL = documentDirectory.appendingPathComponent(filename)
    return fullURL
  }
  
  func saveToPersistentStore() {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(mealsArray)
      try data.write(to: fileURL())
    } catch let error {
      print(error)
    }
  }
  
  func loadFromPersistentStore() {
    let decoder = JSONDecoder()
    do {
      let data = try Data(contentsOf: fileURL())
      let mealsArray = try decoder.decode([Meal].self, from: data)
      self.mealsArray = mealsArray
    } catch let error {
      print(error)
    }
  }
}

