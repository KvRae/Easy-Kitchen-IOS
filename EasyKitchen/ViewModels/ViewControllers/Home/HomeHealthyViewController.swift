//
//  FoodViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 5/4/2023.
//

import UIKit
import JWTDecode

class HomeHealthyViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate  {

    var areas: [Area] = []
    var foods: [Food] = []
    var filteredData: [Food] = []
    var foodFilter: [Food] = []


    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var foodNavigationItem: UINavigationItem!
    
    @IBOutlet var foodCollectionView: UICollectionView!
    let defaults = UserDefaults.standard

    @IBOutlet weak var nameLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
  
             return foods.count


    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"foodCell",for:indexPath) as! FoodCollectionViewCell
            
                let food = foods[indexPath.row]
  

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
            let foodDetail = self.foods[indexPath.item]
            print(type(of: foodDetail))
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let foodDetailViewController = storyboard.instantiateViewController(withIdentifier: "foodDetailVC") as! FoodDetailViewController
            foodDetailViewController.foodDetail = foodDetail
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(foodDetailViewController, animated: true)
            
        
      
   
    }

    @IBOutlet weak var avatarIV: UIImageView!
    
    @IBOutlet weak var healthyModeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarIV.layer.cornerRadius = avatarIV.frame.size.width / 2
        avatarIV.clipsToBounds = true
        avatarIV.contentMode = .scaleAspectFill
        let token = defaults.object(forKey: "token") as? String
        let jwt = try? decode(jwt: token!)
        
        if let jwt = jwt {
            // access the claims in the token payload
            nameLabel.text = jwt.claim(name: "username").string!
            let image = jwt.claim(name: "image").string!
            
            avatarIV.kf.setImage(with: URL(string: image))
            
            
            
        } else {
            // handle decoding error
        }
        
        
        navigationItem.hidesBackButton = true
        healthyModeButton.isSelected = true
        
        self.foodCollectionView.backgroundColor = UIColor.clear

        foodCollectionView.showsVerticalScrollIndicator = false

        
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
                let newFoods = try decoder.decode([Food].self, from: data)

                DispatchQueue.main.async {
                    self.stopLoading()

                    self.foods = newFoods.filter { food in
                        return food.strCategory == "Vegan" || food.strCategory == "Vegetarian"
                    }
                    self.foodCollectionView.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        taskFood.resume()

    }
    
    @IBOutlet weak var chefHat: UIImageView!
    
    @IBAction func healthyMode(_ sender: Any) {
        
        UIView.transition(with: UIApplication.shared.windows.first!,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: {
            self.navigationController?.popViewController(animated: true)

        },
                          completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        let chefHatCheck = defaults.object(forKey: "chefHat") as? Bool
        if (chefHatCheck == true){
            chefHat.isHidden = false
            
        }else{
            chefHat.isHidden = true
            
        }
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading(){
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }

}

