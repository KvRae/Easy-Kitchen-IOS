//
//  CartViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 5/4/2023.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var ingredients = [Ingredient]()
    var filteredData = [Ingredient]()
    var selectedIngredients = [Ingredient]()
    var removedIngredients = [Ingredient]()

    let floatingButton = UIButton(type: .system)

    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet var containerNavigationItem: UINavigationItem!
    

    @IBOutlet weak var selectedIngredientsButton: UIButton!
    
    @IBOutlet var ingredientTableView: UITableView!
    let badgeLabel = UILabel(frame: CGRect(x: 30, y: 20, width: 15, height: 15))

    
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
//        selectedIngredientsButton.setTitle("(\(selectedIngredients.count))", for: .normal)

            badgeLabel.text = "\(selectedIngredients.count)"
        if (selectedIngredients.count != 0){
            floatingButton.isEnabled = true
        }


    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = ingredients
        } else {
            filteredData = ingredients.filter { $0.strIngredient.lowercased().contains(searchText.lowercased()) }
        }
        ingredientTableView.reloadData()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(removedIngredients)
        for i in 0..<removedIngredients.count {
            ingredients.append(removedIngredients[i])
        }

        for i in 0..<removedIngredients.count {
            filteredData.append(removedIngredients[i])
        }
        ingredientTableView.reloadData()

        selectedIngredients = selectedIngredients.filter { !removedIngredients.contains($0) }
        badgeLabel.text = "\(selectedIngredients.count)"
        if (selectedIngredients.count == 0){
            floatingButton.isEnabled = false
        }
        print (selectedIngredients)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a label for the badge
        badgeLabel.layer.cornerRadius = 15/2
        badgeLabel.layer.masksToBounds = true
        badgeLabel.backgroundColor = UIColor(named: "orangeKitchen")
        badgeLabel.textColor = .white
        badgeLabel.textAlignment = .center
        badgeLabel.font = UIFont.systemFont(ofSize: 10)
        badgeLabel.text = "0"
        selectedIngredientsButton.addSubview(badgeLabel)

        
        if let navigationBar = self.navigationController?.navigationBar {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search"
            searchBar.sizeToFit()
            searchBar.delegate = self
            let leftBarButtonItemsWidth = containerNavigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let rightBarButtonItemsWidth = containerNavigationItem.rightBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let searchBarWidth = navigationBar.frame.width - leftBarButtonItemsWidth - rightBarButtonItemsWidth - 32
            searchBar.frame.size.width = searchBarWidth - 54
            searchBar.frame.size.height = 44
            
            let searchContainer = UIView(frame: searchBar.frame)
            searchContainer.addSubview(searchBar)
            containerNavigationItem.titleView = searchContainer
            

        }
        print("the height of tabbar is \(tabBarController!.tabBar.frame.height)")
        

        // Set the frame and position of the button
        floatingButton.frame = CGRect(x: view.bounds.width - 68, y: view.bounds.height   - tabBarController!.tabBar.frame.height - 60 , width: 48, height: 48)

        // Set the button's appearance
        floatingButton.backgroundColor = UIColor(named: "orangeKitchen")
        floatingButton.layer.cornerRadius = 24
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        floatingButton.layer.shadowOpacity = 0.5
        floatingButton.layer.shadowRadius = 2
        
        if (selectedIngredients.count == 0){
            floatingButton.isEnabled = false
        }
        // Set the button's image or title
        let image = UIImage(systemName: "magnifyingglass")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .regular))
            .withRenderingMode(.alwaysTemplate)
        floatingButton.setImage(image, for: .normal)
        floatingButton.tintColor = .white
        
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)

        // Add the button to the view hierarchy
        view.addSubview(floatingButton)

        
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

    @objc func didTapFloatingButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "matchingFoodsVC") as! MatchingFoodsViewController
        destinationVC.selectedIngredients=selectedIngredients
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // In the source view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedIngredientsSegue" {
            if let selectedIngredientsVC = segue.destination as? SelectedIngredientsViewController {
                // Set the property to true
                selectedIngredientsVC.hidesBottomBarWhenPushed = true

                
                selectedIngredientsVC.selectedIngredients = selectedIngredients
            }
        }
    }
}

