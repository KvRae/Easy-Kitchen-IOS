//
//  RecetteViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 7/5/2023.
//

import UIKit

class RecetteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {

    
    var recettes:[Recette] = []
    var filteredData:[Recette] = []
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var recetteNavigationItem: UINavigationItem!
    
    @IBOutlet weak var recetteCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"recetteCell",for:indexPath) as! RecetteCollectionViewCell
        

        let recette = filteredData[indexPath.row]

        cell.recetteImageView.kf.setImage(with: URL(string: recette.image))
            cell.recetteLabel.text = recette.name
            cell.recetteImageView.layer.cornerRadius = 20.0
            cell.recetteImageView.contentMode = .scaleAspectFill
            cell.recetteImageView.clipsToBounds = true
            cell.blackScreen.layer.cornerRadius = 20.0

        let total = recette.likes - recette.dislikes
        
        cell.recetteLikeButton.setTitle("\(total)",for: .normal)
        cell.recetteLikeButton.titleLabel?.font = UIFont.systemFont(ofSize: 1)

        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
            
            
            // Get the product that was selected
            let recetteDetail = self.filteredData[indexPath.item]
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let recetteDetailViewController = storyboard.instantiateViewController(withIdentifier: "recetteDetailVC") as! RecetteDetailViewController
        recetteDetailViewController.recetteDetail = recetteDetail
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(recetteDetailViewController, animated: true)
            
   
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = recettes
        } else {
            filteredData = recettes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        recetteCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recetteCollectionView.showsVerticalScrollIndicator = false
        

        if let navigationBar = self.navigationController?.navigationBar {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search"
            searchBar.sizeToFit()
            searchBar.delegate = self
            let leftBarButtonItemsWidth = recetteNavigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let rightBarButtonItemsWidth = recetteNavigationItem.rightBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let searchBarWidth = navigationBar.frame.width - leftBarButtonItemsWidth - rightBarButtonItemsWidth - 32
            searchBar.frame.size.width = searchBarWidth - 8
            searchBar.frame.size.height = 44
            
            let searchContainer = UIView(frame: searchBar.frame)
            searchContainer.addSubview(searchBar)
            recetteNavigationItem.titleView = searchContainer
            

        }
        guard let urlRecette = URL(string: "http://127.0.0.1:3000/api/recettes") else { return }
        let sessionFood = URLSession.shared
        let taskFood = sessionFood.dataTask(with: urlRecette) { (data, response, error) in
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
                
                self.recettes = try decoder.decode([Recette].self, from: data)
                print("foods array: \(self.recettes.count)")
                
                self.filteredData = try decoder.decode([Recette].self,from:data)
                print("filteredData array: \(self.filteredData.count)")
                DispatchQueue.main.async {
                    self.recetteCollectionView.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        taskFood.resume()
    }
    


}
