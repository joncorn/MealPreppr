//
//  GroceryItemAlertViewController.swift
//  MealPreppr
//
//  Created by Jon Corn on 3/2/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import UIKit


// MARK: Protocol
protocol GroceryItemAlertDelegate: class {
  func reloadTableViewData(_ sender: GroceryItemAlertViewController)
  func sendMealToMealLanding(withMeal meal: Meal, sender: GroceryItemAlertViewController)
}

// MARK: Class Declaration
class GroceryItemAlertViewController: UIViewController, UITextFieldDelegate {
  
  // MARK: - Properties
  var mealLanding: Meal?
  weak var delegate: GroceryItemAlertDelegate?
  let measurementsArray = ["oz", "cup(s)", "tbsp", "tsp"]
  var pickerView = UIPickerView()
  
  // MARK: - Outlets
  // Views
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var titleView: UIView!
  // Buttons
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  // Text Fields
  @IBOutlet weak var itemNameTextField: UITextField!
  @IBOutlet weak var itemQtyTextField: UITextField!
  @IBOutlet weak var measurementTypeTextField: UITextField!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTextFields()
    createToolbar()
    setupViews()
    
    pickerView.delegate = self
    pickerView.dataSource = self
    
    measurementTypeTextField.inputView = pickerView
    measurementTypeTextField.textAlignment = .center
    measurementTypeTextField.placeholder = "cups"
  }
  
  // MARK: - Actions
  @IBAction func dismissViewTapped(_ sender: Any) {
    dismissView()
  }
  
  @IBAction func addButtonTapped(_ sender: Any) {
    guard let meal = mealLanding,
      let itemName = itemNameTextField.text?.capitalized, itemName != "",
      let qty = itemQtyTextField.text,
      let measurement = measurementTypeTextField.text
      else {return}
    let qtyAsDouble = Double(qty)
    let mealContent = MealContents(itemName: itemName, itemMeasurement: qtyAsDouble, itemMeasurementType: measurement)
    MealController.shared.createMealContent(with: mealContent, toMeal: meal)
    delegate?.sendMealToMealLanding(withMeal: meal, sender: self)
    delegate?.reloadTableViewData(self)
    dismissView()
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any) {
    dismissView()
  }
  
  // MARK: - Methods
  func createToolbar() {
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
    toolBar.setItems([doneButton], animated: false)
    itemNameTextField.inputAccessoryView = toolBar
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  @objc func moveToNextTextField() {
    
  }
  
  // Allows you to press return to get to next textfield
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    if textField == itemNameTextField {
//      textField.resignFirstResponder()
//      itemQtyTextField.becomeFirstResponder()
//    } else if textField == itemQtyTextField {
//      textField.resignFirstResponder()
//      itemMeasurementTextField.becomeFirstResponder()
//    } else if textField == itemMeasurementTextField {
//      textField.resignFirstResponder()
//    }
//    return true
//  }
  
  @objc func dismissView() {
    dismiss(animated: true, completion: nil)
  }
  
  func setupTextFields() {
    itemNameTextField.delegate = self
    itemNameTextField.tag = 0
    itemQtyTextField.delegate = self
    itemQtyTextField.tag = 1
    measurementTypeTextField.delegate = self
    measurementTypeTextField.tag = 2
  }
  
  func setupViews() {
    // Views
    backgroundView.layer.cornerRadius = 5
    titleView.layer.cornerRadius = 5
    
    // Buttons
    cancelButton.layer.cornerRadius = 5
    addButton.layer.cornerRadius = 5
  }
}

// MARK: - UIPickerViewDelegate/DataSource
extension GroceryItemAlertViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return measurementsArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return measurementsArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    measurementTypeTextField.text = measurementsArray[row]
    measurementTypeTextField.resignFirstResponder()
  }
}
