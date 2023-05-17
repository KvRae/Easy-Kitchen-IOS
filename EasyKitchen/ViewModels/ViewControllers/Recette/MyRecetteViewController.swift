//
//  RecetteViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 7/5/2023.
//

import UIKit
import SwiftUI
import JWTDecode
import Alamofire
import Toast

class MyRecetteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {

    
    var recettes:[Recette] = []
    var filteredData:[Recette] = []
    let searchController = UISearchController(searchResultsController: nil)
    var id :String = ""

    @IBOutlet weak var recetteNavigationItem: UINavigationItem!
    
    @IBOutlet weak var recetteCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"recetteCell",for:indexPath) as! RecetteCollectionViewCell
        
        let recette = filteredData[indexPath.row]

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        longPressGesture.accessibilityLabel = recette._id // set the accessibilityLabel to the recetteId

        cell.addGestureRecognizer(longPressGesture)
        

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
    
    @IBOutlet weak var emptyRecettes: UILabel!
    
    @IBOutlet weak var emptyRecettesIV: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.recettes.count < 1 || self.filteredData .count < 1){
            self.emptyRecettes.isHidden = false
            self.emptyRecettesIV.isHidden = false
        }else{
            self.emptyRecettes.isHidden = true
            self.emptyRecettesIV.isHidden = true
        }
        let defaults = UserDefaults.standard
        
        let token = defaults.object(forKey: "token") as? String
        
        let jwt = try? decode(jwt: token!)
        
        if let jwt = jwt {
            // access the claims in the token payload
            self.id = jwt.claim(name: "userId").string!
                
        } else {
            // handle decoding error
        }
        
        recetteCollectionView.showsVerticalScrollIndicator = false
        

        if let navigationBar = self.navigationController?.navigationBar {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search"
            searchBar.sizeToFit()
            searchBar.delegate = self
            let leftBarButtonItemsWidth = recetteNavigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let rightBarButtonItemsWidth = recetteNavigationItem.rightBarButtonItems?.reduce(0, { $0 + $1.width }) ?? 0
            let searchBarWidth = navigationBar.frame.width - leftBarButtonItemsWidth - rightBarButtonItemsWidth - 60
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
                
                let allRecettes = try decoder.decode([Recette].self, from: data)
                
                self.recettes = allRecettes.filter { recette in
                    return recette.userId == self.id
                }
                
                self.recettes.sort { (recette1, recette2) -> Bool in
                    let total1 = recette1.likes - recette1.dislikes
                    let total2 = recette2.likes - recette2.dislikes
                    return total1 > total2
                }
                
                print("foods array: \(self.recettes.count)")
                
                self.filteredData = allRecettes.filter { recette in
                    return recette.userId == self.id
                }
                    self.filteredData.sort { (recette1, recette2) -> Bool in
                    let total1 = recette1.likes - recette1.dislikes
                    let total2 = recette2.likes - recette2.dislikes
                    return total1 > total2
                }
                print("filteredData array: \(self.filteredData.count)")
                DispatchQueue.main.async {
                    self.recetteCollectionView.reloadData()
                    if (self.recettes.count < 1 || self.filteredData.count < 1){
                        self.emptyRecettes.isHidden = false
                        self.emptyRecettesIV.isHidden = false
                    }else{
                        self.emptyRecettes.isHidden = true
                        self.emptyRecettesIV.isHidden = true
                    }
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        taskFood.resume()
    }
    func setupBottomView() {


    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 200 - self.tabBarController!.tabBar.frame.size.height - 12, width: UIScreen.main.bounds.width, height: 200))
        self.view.addSubview(bottomView)
        
        var style = ToastStyle()
        
        style.backgroundColor = UIColor.systemFill
        style.messageColor = UIColor.label
        
        ToastManager.shared.style = style

        bottomView.makeToast("Hold on a recipe to delete it")


    }
    
    @objc func didTapFloatingButton() {
        let vc = UIHostingController(rootView: RecetteView())
        present(vc, animated: true)
    }

         @objc func dismissSwiftUIView() {
                 dismiss(animated: true, completion: nil)

             }

    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        guard let recetteId = sender.accessibilityLabel else { return } // get the recetteId from accessibilityLabel
        
        print(recetteId)
        let alert = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this item?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }

            /*
            guard let url = URL(string: "http://127.0.0.1:3000/api/recettes/\(recetteId)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error deleting recette: \(error)")
                    return
                }
                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                    print("Failed to delete recette")
                    return
                }
                DispatchQueue.main.async {
                    self.recettes = self.recettes.filter { $0._id != recetteId }
                    self.recetteCollectionView.reloadData()
                }
            }.resume()*/
            
            
            let url = "http://127.0.0.1:3000/api/recettes/\(recetteId)"
            AF.request(url, method: .delete).validate().responseData { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success:
                    self.recettes = self.recettes.filter { $0._id != recetteId }
                    self.filteredData = self.filteredData.filter { $0._id != recetteId }
                    if (self.recettes.count < 1 || self.filteredData .count < 1){
                        self.emptyRecettes.isHidden = false
                        self.emptyRecettesIV.isHidden = false
                    }else{
                        self.emptyRecettes.isHidden = true
                        self.emptyRecettesIV.isHidden = true
                    }

                    self.recetteCollectionView.reloadData()
                case .failure(let error):
                    print("Error deleting recette: \(error)")
                }
            }
        }
        alert.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    

}
