//
//  CartViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 5/4/2023.
//

import UIKit
/*
class CartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate	 {
    

    
    @IBOutlet var searchBar: UISearchBar!
    var ingredients : [Ingredient] = []
    var filteredData: [Ingredient]?
    var selectedIngredients = [Ingredient]()

    @IBOutlet var selectedIngredientsButton: UIButton!
    @IBOutlet var ingredientTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData?.count ?? ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
           
           let data = filteredData?[indexPath.row] ?? ingredients[indexPath.row] // Use the filtered data if it's not nil, otherwise use the original data
           
           // Configure the cell with the extracted data
           cell.ingredientLabel.text = data.strIngredient
           
           return cell
    }
 /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected ingredient
           let selectedIngredient = ingredients[indexPath.row]
           
           // Add the selected ingredient to the selectedIngredients array
           selectedIngredients.append(selectedIngredient)

           // Remove the selected ingredient from the ingredients array
           ingredients.remove(at: indexPath.row)

           // Reload the table view to reflect the changes
            ingredientTableView.reloadData()
           
           // Update the title of the cart button
           selectedIngredientsButton.setTitle("(\(selectedIngredients.count))", for: .normal)
  
        
    }
   */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected ingredient
        let selectedIngredient: Ingredient
        if var filteredData = filteredData {
            selectedIngredient = filteredData[indexPath.row]
            // Remove the selected ingredient from the filtered data array
            filteredData.remove(at: indexPath.row)
        } else {
            selectedIngredient = ingredients[indexPath.row]
        }
        
        // Add the selected ingredient to the selectedIngredients array
        selectedIngredients.append(selectedIngredient)
        
        // Remove the selected ingredient from the ingredients array
        if let index = ingredients.firstIndex(where: { $0._id == selectedIngredient._id }) {
            ingredients.remove(at: index)
        }
        
        // Reload the table view to reflect the changes
        ingredientTableView.reloadData()
        
        // Update the title of the cart button
        selectedIngredientsButton.setTitle("(\(selectedIngredients.count))", for: .normal)
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {
                    filteredData = nil // Clear the filtered data if the search bar text is nil
                    ingredientTableView.reloadData()
                    return
                }
                if text.isEmpty {
                    filteredData = nil // Clear the filtered data if the search bar text is empty
                } else {
                filteredData = ingredients.filter { $0.strIngredient.lowercased().contains(text.lowercased()) }
                }
                ingredientTableView.reloadData() // Reload the table view with the updated data
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the GET API request
        guard let url = URL(string: "http://127.0.0.1:3000/api/ingredients") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            // Parse the response data and extract the relevant information
            let decoder = JSONDecoder()
            do {
                let apiData = try decoder.decode([Ingredient].self, from: data)
                
                // Store the extracted data in an array
                self.ingredients = apiData
                print (self.ingredients)
                // Reload the tableView data on the main thread
                DispatchQueue.main.async {
                    self.ingredientTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()

    }
    


}
*/

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    var ingredients = [Ingredient]()
    var filteredData = [Ingredient]()
    var selectedIngredients = [Ingredient]()
    
    @IBOutlet var selectedIngredientsButton: UIButton!
    @IBOutlet var ingredientTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
           
        let data = filteredData[indexPath.row]
           
        // Configure the cell with the extracted data
        cell.ingredientLabel.text = data.strIngredient
           
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected ingredient
        let selectedIngredient = filteredData[indexPath.row]
           
        // Add the selected ingredient to the selectedIngredients array
        selectedIngredients.append(selectedIngredient)

        // Remove the selected ingredient from the ingredients array
        if let index = ingredients.firstIndex(of: selectedIngredient) {
            ingredients.remove(at: index)
        }

        // Remove the selected ingredient from the filteredData array
        filteredData.remove(at: indexPath.row)

        // Reload the table view to reflect the changes
        ingredientTableView.reloadData()
           
        // Update the title of the cart button
        selectedIngredientsButton.setTitle("(\(selectedIngredients.count))", for: .normal)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = ingredients
        } else {
            filteredData = ingredients.filter { $0.strIngredient.lowercased().contains(searchText.lowercased()) }
        }
        ingredientTableView.reloadData()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the GET API request
        guard let url = URL(string: "http://127.0.0.1:3000/api/ingredients") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            // Parse the response data and extract the relevant information
            let decoder = JSONDecoder()
            do {
                let apiData = try decoder.decode([Ingredient].self, from: data)
                
                // Store the extracted data in an array
                self.ingredients = apiData
                self.filteredData = apiData

                // Reload the tableView data on the main thread
                DispatchQueue.main.async {
                    self.ingredientTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()

    }
}

