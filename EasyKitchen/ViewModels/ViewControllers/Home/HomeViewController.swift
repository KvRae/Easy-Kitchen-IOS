//
//  HomeViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 22/3/2023.
//

import UIKit
import Kingfisher
import UserNotifications
import JWTDecode
import SwiftUI
import QuartzCore

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var foods: [Food] = []
    var foodFilter: [Food] = []
    var foodImages: [URL] = []
    var categories: [Category] = []
    var categoriesImages: [URL] = []
    var recettes: [Recette] = []
    
    @IBOutlet weak var expertLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var recetteLabel: UILabel!
    
    
    
    @IBOutlet var foodCollectionView: UICollectionView!
    
    @IBOutlet var categoryCollectionview: UICollectionView!
    //FOOD COLLECTION VIEW
    
    @IBOutlet weak var recetteCollectionView: UICollectionView!
    
    var drawerViewController: DrawerViewController?
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == foodCollectionView ){
            return min(5,foodFilter.count)
        } else if ( collectionView == categoryCollectionview) {
            
            return categories.count
            
        }else if (collectionView == recetteCollectionView){
            return recettes.count
        }
        return 0
    }
    
    @IBOutlet weak var bioButton: UIButton!
    @IBOutlet weak var avatarIV: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var chefHat: UIImageView!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var category = " "
        if (getMeal(for: Date()) == "Breakfast"){category = "Breakfast"}
        if (getMeal(for: Date()) == "Lunch"){category =  "Pasta"}
        if (getMeal(for: Date()) == "Dinner"){category = "Seafood"}
        
        if (collectionView == foodCollectionView ){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionViewCell
            
            foodFilter = foods.filter { $0.strCategory == category }
            
            if indexPath.row < foodFilter.count {
                let food = foodFilter[indexPath.row]
                
                cell.foodImage.kf.setImage(with: URL(string: food.strMealThumb))
                cell.foodTitle.text = food.strMeal
                cell.foodImage.layer.cornerRadius = 20.0
                cell.foodImage.contentMode = .scaleAspectFill
                cell.foodImage.clipsToBounds = true
                cell.blackScreen.layer.cornerRadius = 20.0
            }
            
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
            
        } else if ( collectionView == recetteCollectionView){
            
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"recetteCell",for:indexPath) as! RecetteCollectionViewCell
            
            
            let recette = self.recettes[indexPath.row]
            
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
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == foodCollectionView){
            
            
            // Get the product that was selected
            let foodDetail = self.foodFilter[indexPath.item]
            print(type(of: foodDetail))
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let foodDetailViewController = storyboard.instantiateViewController(withIdentifier: "foodDetailVC") as! FoodDetailViewController
            
            
            foodDetailViewController.foodDetail = foodDetail
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(foodDetailViewController, animated: true)
            
        } else if(collectionView == categoryCollectionview){
            
            
            // Get the product that was selected
            let categoryDetail = self.categories[indexPath.item]
            print(type(of: categoryDetail))
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let foodByCategoryViewController = storyboard.instantiateViewController(withIdentifier: "foodCatVC") as! FoodByCategoryViewController
            foodFilter = foods.filter { $0.strCategory == categoryDetail.strCategory }
            
            foodByCategoryViewController.categoryDetail = categoryDetail
            foodByCategoryViewController.foodFilter = foods.filter { $0.strCategory == categoryDetail.strCategory }
            
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(foodByCategoryViewController, animated: true)
            
        } else if (collectionView == recetteCollectionView){
            
            // Get the product that was selected
            let recetteDetail = self.recettes[indexPath.item]
            // Create a new view controller to display the product details
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let recetteDetailViewController = storyboard.instantiateViewController(withIdentifier: "recetteDetailVC") as! RecetteDetailViewController
            recetteDetailViewController.recetteDetail = recetteDetail
            
            // Push the detail view controller onto the navigation stack
            
            navigationController?.pushViewController(recetteDetailViewController, animated: true)
        }
        
    }
    
    let defaults = UserDefaults.standard
    
    
    @IBAction func healthyModeTapped(_ sender: Any) {
        
        UIView.transition(with: UIApplication.shared.windows.first!,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "homeHealthyVC") as! HomeHealthyViewController
            self.navigationController?.pushViewController(destinationVC, animated: true)
        },
                          completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bioButton.isSelected = false

        
        
        
        
        self.foodCollectionView.backgroundColor = UIColor.clear
        self.categoryCollectionview.backgroundColor = UIColor.clear
        self.recetteCollectionView.backgroundColor = UIColor.clear
        
        
        navigationItem.hidesBackButton = true
        
        let chefHatCheck = defaults.object(forKey: "chefHat") as? Bool
        if (chefHatCheck == true){
            chefHat.isHidden = false
            
        }else{
            chefHat.isHidden = true
            
        }
        scheduleNotification()
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
        
        // recettes
        
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
                self.recetteLabel.isHidden = false
                return
            }
            
            guard let data = data else {
                print("Error: missing data")
                return
            }
            do {
                let decoder = JSONDecoder()
                
                self.recettes = try decoder.decode([Recette].self, from: data)
                
                print (self.recettes.count)
                self.recettes.sort { (recette1, recette2) -> Bool in
                    let total1 = recette1.likes - recette1.dislikes
                    let total2 = recette2.likes - recette2.dislikes
                    return total1 > total2
                }
                
                print("foods array: \(self.recettes.count)")
                
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarIV.layer.cornerRadius = avatarIV.frame.size.width / 2
        avatarIV.clipsToBounds = true
        avatarIV.contentMode = .scaleAspectFill
        
        let time = getMeal(for: Date())
        if (time == "Breakfast"){expertLabel.text = "For Breakfest"}
        if (time == "Lunch"){expertLabel.text = "For Launch"}
        if (time == "Dinner"){expertLabel.text = "For Dinner"}
        
        let token = defaults.object(forKey: "token") as? String
        
        
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
                self.foodFilter = try decoder.decode([Food].self, from: data)
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
    
    
    
    
    func getMeal(for date: Date) -> String {
        let calendar = Calendar.current
        print("Calendar",calendar)
        let hour = calendar.component(.hour, from: date)
        print("hour",hour)
        
        switch hour {
        case 6..<12:
            return "Breakfast"
        case 12..<18:
            return "Lunch"
        default:
            return "Dinner"
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Request permission to display notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notifications permission granted.")
            } else {
                print("Notifications permission denied.")
            }
        }
        return true
    }
    
    
    func scheduleNotification() {
        // Create a UNMutableNotificationContent object
        let content = UNMutableNotificationContent()
        content.title = "Welcome"
        content.body = "To the summoner's rift"
        
        // Configure the trigger for the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        // Create a UNNotificationRequest object with the content and trigger
        let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
        
        // Get the notification center
        let center = UNUserNotificationCenter.current()
        
        // Request authorization to display notifications (if needed)
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if error != nil {
                // Handle error
            } else if granted {
                // Schedule the notification
                center.add(request) { (error) in
                    if error != nil {
                        print(error)
                    } else {
                        print("notification success")
                    }
                }
            } else {
                print ("authorization denied")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
}
