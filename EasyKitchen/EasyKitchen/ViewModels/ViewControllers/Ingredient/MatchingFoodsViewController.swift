//
//  MatchingFoodsViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 14/4/2023.
//

import UIKit

class MatchingFoodsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    var selectedIngredients = [Ingredient]()
    var matchingFoods = [Food]() // This should be declared at the class level, so it can be accessed by other functions

    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchingFoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"foodCell",for:indexPath) as! FoodCollectionViewCell
        

            let food = matchingFoods[indexPath.row]
        cell.foodImage.kf.setImage(with: URL(string: food.strMealThumb))
            cell.foodTitle.text = food.strMeal
            cell.foodImage.layer.cornerRadius = 20.0
            cell.foodImage.contentMode = .scaleAspectFill
            cell.foodImage.clipsToBounds = true
            cell.blackScreen.layer.cornerRadius = 20.0
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
                
                self.matchingFoods = try decoder.decode([Food].self, from: data)
                // Inside your data task, after decoding the JSON data
                // Filter the matchingFoods array to include only the foods that have at least one matching ingredient
                let matchingIngredients = self.selectedIngredients.map { $0.strIngredient }
                self.matchingFoods = self.matchingFoods.filter { food in
                    let ingredients = [
                        food.strIngredient1,
                        food.strIngredient2,
                        food.strIngredient3,
                        food.strIngredient4,
                        food.strIngredient5,
                        food.strIngredient6,
                        food.strIngredient7,
                        food.strIngredient8,
                        food.strIngredient9,
                        food.strIngredient10,
                        food.strIngredient11,
                        food.strIngredient12,
                        food.strIngredient13,
                        food.strIngredient14,
                        food.strIngredient15,
                        food.strIngredient16,
                        food.strIngredient17,
                        food.strIngredient18,
                        food.strIngredient19,
                        food.strIngredient20
                    ].compactMap { $0 }
                    return ingredients.contains(where: matchingIngredients.contains)
                }

                // Sort the matchingFoods array based on the number of matching ingredients
                self.matchingFoods = self.matchingFoods.sorted { food1, food2 in
                    let count1 = [
                        food1.strIngredient1,
                        food1.strIngredient2,
                        food1.strIngredient3,
                        food1.strIngredient4,
                        food1.strIngredient5,
                        food1.strIngredient6,
                        food1.strIngredient7,
                        food1.strIngredient8,
                        food1.strIngredient9,
                        food1.strIngredient10,
                        food1.strIngredient11,
                        food1.strIngredient12,
                        food1.strIngredient13,
                        food1.strIngredient14,
                        food1.strIngredient15,
                        food1.strIngredient16,
                        food1.strIngredient17,
                        food1.strIngredient18,
                        food1.strIngredient19,
                        food1.strIngredient20
                    ].compactMap { $0 }.filter(matchingIngredients.contains).count
                    let count2 = [
                        food2.strIngredient1,
                        food2.strIngredient2,
                        food2.strIngredient3,
                        food2.strIngredient4,
                        food2.strIngredient5,
                        food2.strIngredient6,
                        food2.strIngredient7,
                        food2.strIngredient8,
                        food2.strIngredient9,
                        food2.strIngredient10,
                        food2.strIngredient11,
                        food2.strIngredient12,
                        food2.strIngredient13,
                        food2.strIngredient14,
                        food2.strIngredient15,
                        food2.strIngredient16,
                        food2.strIngredient17,
                        food2.strIngredient18,
                        food2.strIngredient19,
                        food2.strIngredient20
                    ].compactMap { $0 }.filter(matchingIngredients.contains).count
                    return count1 > count2
                }
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
