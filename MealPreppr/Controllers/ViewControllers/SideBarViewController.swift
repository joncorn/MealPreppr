//
//  SideBarViewController.swift
//  MealPreppr
//
//  Created by Jon Corn on 2/27/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController {
  
  // MARK: - Properties
  var menuOut = false
  let alertService = AlertService()
  
  // MARK: - Outlets
  // Sidebar buttons
  @IBOutlet weak var foodSearchButton: UIButton!
  @IBOutlet weak var settingsButton: UIButton!
  @IBOutlet weak var converterButton: UIButton!
  
  // MealList view constraints
  @IBOutlet weak var mealListViewLeading: NSLayoutConstraint!
  @IBOutlet weak var mealListViewTrailing: NSLayoutConstraint!
  
  // MealList tableview
  @IBOutlet weak var mealListTableView: UITableView!
  
  // nav bar
  @IBOutlet weak var hamburgerBarButton: UIBarButtonItem!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    mealListTableView.dataSource = self
    mealListTableView.delegate = self
    setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    mealListTableView.reloadData()
  }
  
  // MARK: - Actions
  @IBAction func mealListViewSwipedClosed(_ sender: UISwipeGestureRecognizer) {
    if menuOut == true {
      closeMenu()
    }
    animateSidebar()
  }
  
  @IBAction func mealListViewSwipedOpen(_ sender: Any) {
    if menuOut == false {
      openMenu()
    }
    animateSidebar()
  }
  
  @IBAction func menuButtonTapped(_ sender: Any) {
    if menuOut == false {
      openMenu()
    } else {
      closeMenu()
    }
    animateSidebar()
  }
  
  @IBAction func addMealButtonTapped(_ sender: Any) {
    let alertVC = alertService.CreateNewMealAlert()
    present(alertVC, animated: true)
  }
  
  @IBAction func unwindToSideBarViewController(segue: UIStoryboardSegue) {
    DispatchQueue.global(qos: .userInitiated).async {
      DispatchQueue.main.async {
        self.mealListTableView.reloadData()
      }
    }
  }
  
  // MARK: - Methods
  func animateSidebar() {
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
      self.view.layoutIfNeeded()
    }) { (animationComplete) in
      print("The animation is complete!")
    }
  }
  
  func openMenu() {
    mealListViewLeading.constant = 210
    mealListViewTrailing.constant = -210
    hamburgerBarButton.image = #imageLiteral(resourceName: "baseline_clear_white_36pt_3x")
    menuOut = true
    setTableViewInteractionState()
  }
  
  func closeMenu() {
    mealListViewLeading.constant = 0
    mealListViewTrailing.constant = 0
    hamburgerBarButton.image = #imageLiteral(resourceName: "ic_menu_white_3x")
    menuOut = false
    setTableViewInteractionState()
  }
  
  func setupViews() {
    // buttons
    foodSearchButton.layer.cornerRadius = 5
    settingsButton.layer.cornerRadius = 5
    converterButton.layer.cornerRadius = 5
    // tableview
    mealListTableView.layer.cornerRadius = 5
  }
  
  func setTableViewInteractionState() {
    if menuOut == true {
      mealListTableView.isUserInteractionEnabled = false
    } else {
      mealListTableView.isUserInteractionEnabled = true
    }
  }
  
  func isMealCountOneOrMore() {
    
  }
  
} // Class end

// MARK: - TableViewDelegate/DataSource ext.
extension SideBarViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MealController.shared.mealsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as? MealListTableViewCell
      else {return UITableViewCell()}
    let meal = MealController.shared.mealsArray[indexPath.row]
    
    // Mock data
    cell.mealIconImage.image = #imageLiteral(resourceName: "mockMeal2")
    cell.mealTitle.text = meal.mealName
    if meal.mealCount == 1 {
      cell.mealQty.text = "\(meal.mealCount) meal"
    } else {
      cell.mealQty.text = "\(meal.mealCount) meals"
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let meal = MealController.shared.mealsArray[indexPath.row]
      MealController.shared.deleteMeal(with: meal)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = .white
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let meal = MealController.shared.mealsArray[sourceIndexPath.row]
    MealController.shared.mealsArray.remove(at: sourceIndexPath.row)
    MealController.shared.mealsArray.insert(meal, at: destinationIndexPath.row)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toMealDetailVC" {
      guard let indexPath = mealListTableView.indexPathForSelectedRow,
        let destinationVC = segue.destination as? MealDetailViewController else {return}
      let meal = MealController.shared.mealsArray[indexPath.row]
      destinationVC.mealLanding = meal
    }
  }
}

