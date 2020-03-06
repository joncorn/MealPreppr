//
//  MealDetailViewController.swift
//  MealPreppr
//
//  Created by Jon Corn on 2/28/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import UIKit

protocol MealDetailViewControllerDelegate: class {
  func multiplyIngredientQty(sender: MealDetailViewController)
}

class MealDetailViewController: UIViewController {
  
  // MARK: - Properties
  let alertService = AlertService()
  var mealLanding: Meal?
  weak var delegate: MealDetailViewControllerDelegate?
  
  // MARK: - Outlets
  // background views
  @IBOutlet weak var mealDetailView: UIView!
  @IBOutlet weak var groceryHeaderView: UIView!
  @IBOutlet weak var groceryListView: UIView!
  
  // Title and buttons
  @IBOutlet weak var multiplyerCountTextField: UITextField!
  
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var mealTitleTextField: UITextField!
  
  // Tableview
  @IBOutlet weak var GroceryListTableView: UITableView!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    GroceryListTableView.delegate = self
    GroceryListTableView.dataSource = self
    multiplyerCountTextField.delegate = self
    
    updateViews()
    setupViews()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    GroceryListTableView.reloadData()
  }
  
  // MARK: - Actions
  @IBAction func addButtonTapped(_ sender: Any) {
    print("tapped")
  }
  
  // MARK: - Methods
  
  func setupViews() {
    mealDetailView.layer.cornerRadius = 5
    groceryHeaderView.layer.cornerRadius = 5
    groceryListView.layer.cornerRadius = 5
    addButton.layer.cornerRadius = 5
  }
  
  func updateViews() {
    guard let meal = mealLanding else {return}
    mealTitleTextField.text = meal.mealName
    multiplyerCountTextField.text = "\(meal.mealCount)"
  }
  
  func doneButtonPressed() {
    guard let meal = mealLanding else {return}
    guard let multiplyerAsString = multiplyerCountTextField.text, !multiplyerAsString.isEmpty else {return}
    guard let multiplyerAsInt = Int(multiplyerAsString) else { return }
    
    meal.mealCount = multiplyerAsInt
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

}

// MARK: - UITableViewDelegate/DataSource ext.
extension MealDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mealLanding?.groceryList.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = GroceryListTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? GroceryListTableViewCell
      else {return UITableViewCell()}
    
    let meal = mealLanding
    let groceries = mealLanding?.groceryList[indexPath.row]
    cell.groceriesLanding = groceries
    cell.mealLanding = meal
    cell.updateViews()
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      guard let meal = mealLanding else {return}
      guard let mealContent = mealLanding?.groceryList[indexPath.row] else {return}
      MealController.shared.deleteMealContent(with: mealContent, fromMeal: meal)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }
}

// MARK: - MultiplyerTextFieldDelegate
extension MealDetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    multiplyerCountTextField.resignFirstResponder()
    doneButtonPressed()
    GroceryListTableView.reloadData()
    return true
  }
}

// MARK: - GroceryItemAlertDelegate ext.
extension MealDetailViewController: GroceryItemAlertDelegate {
  func sendMealToMealLanding(withMeal meal: Meal, sender: GroceryItemAlertViewController) {
    let landingVC = self
    landingVC.mealLanding = meal
  }
  
  func reloadTableViewData(_ sender: GroceryItemAlertViewController) {
    self.GroceryListTableView.reloadData()
  }
}

// MARK: - Prepare for segue
extension MealDetailViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toMealAlert" {
      let meal = mealLanding
      guard let alertVC = segue.destination as? GroceryItemAlertViewController else {return}
      alertVC.mealLanding = meal
      alertVC.delegate = self
    }
  }
}

