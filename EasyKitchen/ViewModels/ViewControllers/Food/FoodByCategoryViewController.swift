//
//  FoodByCategoryViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 2/5/2023.
//

import UIKit

class FoodByCategoryViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    
    var filteredData: [Food] = []
    var foods: [Food] = []
    var categoryDetail: Category? = nil
    var foodFilter: [Food] = []

    @IBOutlet weak var foodByCategoryNavigationItem: UINavigationItem!
    @IBOutlet weak var foodByCategoryCollectionView: UICollectionView!
    
    
    let searchController = UISearchController(searchResultsController: nil)

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionViewCell
//        foodFilter = foods.filter { $0.strCategory == categoryDetail?.strCategory }

        
            let food = filteredData[indexPath.row]
            
            cell.foodImage.kf.setImage(with: URL(string: food.strMealThumb))
            cell.foodTitle.text = food.strMeal
            cell.foodImage.layer.cornerRadius = 20.0
            cell.foodImage.contentMode = .scaleAspectFill
            cell.foodImage.clipsToBounds = true
            cell.blackScreen.layer.cornerRadius = 20.0
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
            
            
            // Get the product that was selected
            let foodDetail = self.filteredData[indexPath.item]
            print(type(of: foodDetail))
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let foodDetailViewController = storyboard.instantiateViewController(withIdentifier: "foodDetailVC") as! FoodDetailViewController
            foodDetailViewController.foodDetail = foodDetail
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(foodDetailViewController, animated: true)
            
        
   
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = foodFilter
        } else {
            filteredData = foodFilter.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
        }
        foodByCategoryCollectionView.reloadData()
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredData = foodFilter
        let backButton = UIBarButtonItem()
        backButton.title = categoryDetail?.strCategory
        
        foodByCategoryNavigationItem.backBarButtonItem = backButton

        if let navigationBar = self.navigationController?.navigationBar {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search"
            searchBar.sizeToFit()
            searchBar.delegate = self
            let leftBarButtonItemsWidth = foodByCategoryNavigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let rightBarButtonItemsWidth = foodByCategoryNavigationItem.rightBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let searchBarWidth = navigationBar.frame.width - leftBarButtonItemsWidth - rightBarButtonItemsWidth - 32
            searchBar.frame.size.width = searchBarWidth - 32
            searchBar.frame.size.height = 44
            
            let searchContainer = UIView(frame: searchBar.frame)
            searchContainer.addSubview(searchBar)
            foodByCategoryNavigationItem.titleView = searchContainer
            

        }
        
        /*
        guard let urlFood = URL(string: "http://127.0.0.1:3000/api/food") else { return }
        let sessionFood = URLSession.shared
        let taskFood = sessionFood.dataTask(with: urlFood) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: invalid response")
                return
            }

            guard let data = data else {
                print("Error: missing data")
                return
            }
            do {
                let decoder = JSONDecoder()
                
                self.foods = try decoder.decode([Food].self, from: data)
                print("foods array: \(self.foods.count)")
                self.filteredData = try decoder.decode([Food].self,from:data)
                print("filteredData array: \(self.filteredData.count)")
                DispatchQueue.main.async {
                    self.foodByCategoryCollectionView.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        taskFood.resume()

        */
        // Do any additional setup after loading the view.
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
