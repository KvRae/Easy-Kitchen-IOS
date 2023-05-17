//
//  FoodViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 5/4/2023.
//

import UIKit

class FoodViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate  {

    var areas: [Area] = []
    var foods: [Food] = []
    var filteredData: [Food] = []
    var foodFilter: [Food] = []


    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var foodNavigationItem: UINavigationItem!
    @IBOutlet var areaCollectionView: UICollectionView!
    
    @IBOutlet var foodCollectionView: UICollectionView!

    let searchController = UISearchController(searchResultsController: nil)

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if (collectionView == areaCollectionView ){
             return areas.count
        } else if ( collectionView == foodCollectionView) {
             return filteredData.count

        }
        return areas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == areaCollectionView ){
            
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"areaCell",for:indexPath) as! AreaCollectionViewCell
            
            
            let area = areas[indexPath.row]
            
            cell.areaLabel.text = area.strArea
            cell.areaBackground.layer.cornerRadius = 20.0
            cell.contentView.sizeToFit()
            return cell
        } else if (collectionView == foodCollectionView){
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"foodCell",for:indexPath) as! FoodCollectionViewCell
            

//                let food = foods[indexPath.row]
  
            let food = filteredData[indexPath.row]

            cell.foodImage.kf.setImage(with: URL(string: food.strMealThumb))
                cell.foodTitle.text = food.strMeal
                cell.foodImage.layer.cornerRadius = 20.0
                cell.foodImage.contentMode = .scaleAspectFill
                cell.foodImage.clipsToBounds = true
                cell.blackScreen.layer.cornerRadius = 20.0
            
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if(collectionView == foodCollectionView){
            
            
            // Get the product that was selected
            let foodDetail = self.filteredData[indexPath.item]
            print(type(of: foodDetail))
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let foodDetailViewController = storyboard.instantiateViewController(withIdentifier: "foodDetailVC") as! FoodDetailViewController
            foodDetailViewController.foodDetail = foodDetail
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(foodDetailViewController, animated: true)
            
        }else if (collectionView == areaCollectionView){
            // Get the product that was selected
            let areaDetail = self.areas[indexPath.item]
            print(type(of: areaDetail))
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let foodByCategoryViewController = storyboard.instantiateViewController(withIdentifier: "foodCatVC") as! FoodByCategoryViewController
            foodFilter = foods.filter { $0.strArea == areaDetail.strArea }
            
            //foodByCategoryViewController.categoryDetail = categoryDetail
            foodByCategoryViewController.foodFilter = foods.filter { $0.strArea == areaDetail.strArea }

            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(foodByCategoryViewController, animated: true)
        }
   
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = foods
        } else {
            filteredData = foods.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
        }
        foodCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        foodCollectionView.showsVerticalScrollIndicator = false
        areaCollectionView.showsHorizontalScrollIndicator = false
        
        if let navigationBar = self.navigationController?.navigationBar {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search"
            searchBar.sizeToFit()
            searchBar.delegate = self
            let leftBarButtonItemsWidth = foodNavigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let rightBarButtonItemsWidth = foodNavigationItem.rightBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let searchBarWidth = navigationBar.frame.width - leftBarButtonItemsWidth - rightBarButtonItemsWidth - 32
            searchBar.frame.size.width = searchBarWidth - 8
            searchBar.frame.size.height = 44
            
            let searchContainer = UIView(frame: searchBar.frame)
            searchContainer.addSubview(searchBar)
            foodNavigationItem.titleView = searchContainer
            

        }
        print(self.filteredData)
        guard let url = URL(string: "http://127.0.0.1:3000/api/areas") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
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
                self.areas = try decoder.decode([Area].self, from: data)
                DispatchQueue.main.async {
                    self.areaCollectionView.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        task.resume()
        
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
                self.stopLoading()
                self.foods = try decoder.decode([Food].self, from: data)
                print("foods array: \(self.foods.count)")
                self.filteredData = try decoder.decode([Food].self,from:data)
                print("filteredData array: \(self.filteredData.count)")
                DispatchQueue.main.async {
                    self.foodCollectionView.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        taskFood.resume()

    }
    override func viewWillAppear(_ animated: Bool) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading(){
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }

}

