//
//  CreateNewMealAlertViewController.swift
//  MealPreppr
//
//  Created by Jon Corn on 2/27/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import UIKit

class CreateNewMealAlertViewController: UIViewController, UITextFieldDelegate {
  
  // MARK: - Properties
  
  // MARK: - Outlets
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var createButton: UIButton!
  @IBOutlet weak var mealNameTextField: UITextField!
  
  // views
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var titleView: UIView!

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    createToolbar()
    setupAlertCorners()
    self.mealNameTextField.delegate = self
  }
  
  // MARK: - Actions
  // dismisses main alert view
  @IBAction func dismissAlert(_ sender: Any) {
    dismissView()
  }
  
  @IBAction func createButtonTapped(_ sender: Any) {
    guard let mealName = mealNameTextField.text, mealName != "" else {return}
    MealController.shared.createMeal(with: mealName)
    self.performSegue(withIdentifier: "unwindToMain", sender: self)
  }
  
  // MARK: - Methods
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.backgroundView.endEditing(true)
    return false
  }
  
  @objc func dismissView() {
    dismiss(animated: true, completion: nil)
  }
  
  func createToolbar() {
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
    toolBar.setItems([doneButton], animated: false)
    mealNameTextField.inputAccessoryView = toolBar
  }
  
//  func createToolbar() {
//    let toolBar = UIToolbar()
//    toolBar.sizeToFit()
//    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
//    let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(<#T##@objc method#>))
//  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  func setupAlertCorners() {
    cancelButton.layer.cornerRadius = 5
    createButton.layer.cornerRadius = 5
    mealNameTextField.layer.cornerRadius = 5
    backgroundView.layer.cornerRadius = 5
    titleView.layer.cornerRadius = 5
  }
}
