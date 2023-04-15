//
//  HomeViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 22/3/2023.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var foods: [Food] = []
    var foodImages: [URL] = []
    var categories: [Category] = []
    var categoriesImages: [URL] = []

    
    @IBOutlet var foodCollectionView: UICollectionView!
    
    @IBOutlet var categoryCollectionview: UICollectionView!
    //FOOD COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == foodCollectionView ){
             return min(5,foods.count)
        } else if ( collectionView == categoryCollectionview) {
             return categories.count

        }
        return 0
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        if (collectionView == foodCollectionView ){
            
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"foodCell",for:indexPath) as! FoodCollectionViewCell
            
                let food = foods[indexPath.row]
                cell.foodImage.kf.setImage(with: URL(string: food.strMealThumb))
                cell.foodTitle.text = food.strMeal
                cell.foodImage.layer.cornerRadius = 20.0
                cell.foodImage.contentMode = .scaleAspectFill
                cell.foodImage.clipsToBounds = true
                cell.blackScreen.layer.cornerRadius = 20.0
            
            return cell
            
        } else if ( collectionView == categoryCollectionview) {
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"categoryCell",for:indexPath) as! CategoryCollectionViewCell
            
                let category = categories[indexPath.row]
                cell.categoryImage.kf.setImage(with: URL(string: category.strCategoryThumb))

                cell.categoryLabel.text = category.strCategory
                cell.categoryImage.layer.cornerRadius = 20.0
                cell.categoryImage.contentMode = .scaleAspectFill
                cell.categoryImage.clipsToBounds = true
                cell.categoryBlackScreen.layer.cornerRadius = 20.0
                
            
            return cell

        }
        return UICollectionViewCell()

    }
    
    let defaults = UserDefaults.standard


    @IBOutlet weak var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        

        let token = defaults.object(forKey: "token") as? String
        
        testLabel.text = token
        
        // GET FOOD API
        
        // Do any additional setup after loading the view.
        
        
        guard let url = URL(string: "http://127.0.0.1:3000/api/food") else { return }
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
                self.foods = try decoder.decode([Food].self, from: data)
                self.foodImages = self.foods.map({ URL(string: $0.strMealThumb)! })
                DispatchQueue.main.async {
                    self.foodCollectionView.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        task.resume()
        
        // GET Category API
        
        // Do any additional setup after loading the view.
        
        
        guard let urlCat = URL(string: "http://127.0.0.1:3000/api/categories") else { return }
        let sessionCat = URLSession.shared
        let taskCat = sessionCat.dataTask(with: urlCat) { (data, response, error) in
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
                self.categories = try decoder.decode([Category].self, from: data)
                DispatchQueue.main.async {
                    self.categoryCollectionview.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

            // Process the data here

        }

        taskCat.resume()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the back button
        navigationItem.hidesBackButton = true
    }

    @IBAction func disconnectButtonTapped(_ sender: Any) {
        defaults.removeObject(forKey: "token")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.navigationController?.pushViewController(destinationVC, animated: true)
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



/*   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       if (collectionView == foodCollectionView ){
           
           let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"foodCell",for:indexPath) as! FoodCollectionViewCell
           
           if indexPath.row < 5 {
               cell.foodImage.kf.setImage(with: foodImages[indexPath.row])
               cell.foodImage.layer.cornerRadius = 50.0
               cell.foodImage.contentMode = .scaleAspectFill
               cell.foodImage.clipsToBounds = true
           }
           return cell
           
       } else if ( collectionView == categoryCollectionview) {
           let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"categoryCell",for:indexPath) as! CategoryCollectionViewCell
           
           if indexPath.row < 5 {
               cell.categoryImage.kf.setImage(with: categoriesImages[indexPath.row])
               cell.categoryImage.layer.cornerRadius = 20.0
               cell.categoryImage.contentMode = .scaleAspectFill
               cell.categoryImage.clipsToBounds = true
           }
           return cell

       }
       return UICollectionViewCell()

   }*/
