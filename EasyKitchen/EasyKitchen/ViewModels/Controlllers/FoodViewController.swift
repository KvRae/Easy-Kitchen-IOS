//
//  FoodViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 5/4/2023.
//

import UIKit

class FoodViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var areas: [Area] = []
    var foods: [Food] = []

    @IBOutlet var areaCollectionView: UICollectionView!
    
    @IBOutlet var foodCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if (collectionView == areaCollectionView ){
             return areas.count
        } else if ( collectionView == foodCollectionView) {
             return foods.count

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
            // Add a drop shadow
            cell.areaBackground.layer.shadowColor = UIColor.white.cgColor
            cell.areaBackground.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.areaBackground.layer.shadowOpacity = 0.5
            cell.areaBackground.layer.shadowRadius = 3.0
            return cell
        } else if (collectionView == foodCollectionView){
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
        return UICollectionViewCell()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                self.foods = try decoder.decode([Food].self, from: data)
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
    

}
