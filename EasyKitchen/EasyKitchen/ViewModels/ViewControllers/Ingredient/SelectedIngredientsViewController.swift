//
//  SelectedIngredientsViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 12/4/2023.
//

import UIKit

class SelectedIngredientsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var selectedIngredients : [Ingredient] = []
    var removedIngredients : [Ingredient] = []

    @IBOutlet weak var selectedItemsNavigationItem: UINavigationItem!
    @IBOutlet var ingredientsTableView: UITableView!
    let ingredientsCount = UILabel()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
           
        let data = selectedIngredients[indexPath.row]
           
        cell.ingredientLabel.text = data.strIngredient
           
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected ingredient
        let selectedIngredient = selectedIngredients[indexPath.row]
        
        // Remove the selected ingredient from the selectedIngredients array
        selectedIngredients.remove(at: indexPath.row)

        removedIngredients.append(selectedIngredient)
        
        // Reload the table view to reflect the changes
        ingredientsTableView.reloadData()
           
        ingredientsCount.text = "\(selectedIngredients.count) Ingrédients sélectionnés"


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Get a reference to the previous view controller on the navigation stack
        guard let previousViewController = navigationController?.viewControllers.last as? CartViewController else {
            return
        }
        
        // Pass the data to the previous view controller
        previousViewController.removedIngredients = removedIngredients
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        // Create a label
        ingredientsCount.font = UIFont.systemFont(ofSize: 15)
        ingredientsCount.text = "\(selectedIngredients.count) Ingrédients sélectionnés"
        ingredientsCount.textColor = UIColor.darkGray

        // Create a bar button item with the label as its custom view
        let rightBarButtonItem = UIBarButtonItem(customView: ingredientsCount)

        // Assign the bar button item to the navigation item's rightBarButtonItem property
        selectedItemsNavigationItem.rightBarButtonItem = rightBarButtonItem

        print(selectedIngredients.count)

    }
    @IBAction func clearAllButtonTapped(_ sender: Any) {
        
        removedIngredients.append(contentsOf: selectedIngredients)

        selectedIngredients.removeAll()

        ingredientsTableView.reloadData()
        ingredientsCount.text = "\(selectedIngredients.count) Ingrédients sélectionnés"
    

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIngredientsViewController = segue.source as? SelectedIngredientsViewController {
            removedIngredients = selectedIngredientsViewController.removedIngredients
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
