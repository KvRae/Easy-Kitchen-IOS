//
//  FoodDetailViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 25/4/2023.
//

import UIKit
import JWTDecode

class RecetteDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientMeasureCell", for: indexPath) as! IngredientsMeasuresTableViewCell
           
        let data = ingredients[indexPath.row]
        let data1 = measures[indexPath.row]
        print(data1+" "+"Of" + " " + data)
           
        // Configure the cell with the extracted data
        cell.ingredientMeasureLabel.text = data1+" "+"of" + " " + data

        return cell
    }
    
    
    var ingredients : [String] = []
    var measures:[String] = []
    
    @IBOutlet weak var durationView: UIView!
    
    @IBOutlet weak var personView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    var recetteDetail: Recette? = nil
    @IBOutlet weak var descriptionScrollView: UITextView!
    @IBOutlet weak var ingredientsMesuresTableView: UITableView!
    
    @IBOutlet weak var foodDetailIV: UIImageView!
    
    @IBOutlet weak var difficultyView: UIView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsListLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingedientsFilter()
        mesuresFilter()
        print(ingredients.count)
        print(measures.count)
        
        // '2 kilos'+' '+ 'of' + 'meat'
        
        foodDetailIV.kf.setImage(with: URL(string: recetteDetail!.image))
        ingredientsListLabel.text = recetteDetail?.name
        descriptionScrollView.text = recetteDetail?.description
        userLabel.text = recetteDetail?.username
        let total = recetteDetail!.likes - recetteDetail!.dislikes
        likeCountLabel.text = "\(total)"
        durationView.layer.cornerRadius = 10.0
        
        // Set the shadow properties of the view's layer
        durationView.layer.shadowColor = UIColor.black.cgColor
        durationView.layer.shadowOpacity = 0.3
        durationView.layer.shadowOffset = CGSize(width: 0, height: 2)
        durationView.layer.shadowRadius = 2
        personView.layer.cornerRadius = 10.0
        // Set the shadow properties of the view's layer
        personView.layer.shadowColor = UIColor.black.cgColor
        personView.layer.shadowOpacity = 0.3
        personView.layer.shadowOffset = CGSize(width: 0, height: 2)
        personView.layer.shadowRadius = 2
        difficultyView.layer.cornerRadius = 10.0
        // Set the shadow properties of the view's layer
        difficultyView.layer.shadowColor = UIColor.black.cgColor
        difficultyView.layer.shadowOpacity = 0.3
        difficultyView.layer.shadowOffset = CGSize(width: 0, height: 2)
        difficultyView.layer.shadowRadius = 2
        
        let duration = recetteDetail!.duration
        if (duration<59){
            durationLabel.text = "\(duration) minutes"
        }else if(duration == 60){
            durationLabel.text = "\(duration) Hour"

        }else if ( duration > 60){
            let hours = duration / 60
            let minutes = duration % 60
            if hours == 1 {
                durationLabel.text = "\(hours) hour \(minutes) minutes"
            } else {
                durationLabel.text = "\(hours) hours \(minutes) minutes"
            }
        }
        personLabel.text = "\(recetteDetail!.person) persons"
        difficultyLabel.text = "\(recetteDetail!.difficulty)"
    }
    
    func ingedientsFilter(){
        if let recette = recetteDetail {
            if let ingredient1 = recette.strIngredient1, !ingredient1.isEmpty {
                ingredients.append(ingredient1)
            }
            if let ingredient2 = recette.strIngredient2, !ingredient2.isEmpty {
                ingredients.append(ingredient2)
            }
            if let ingredient3 = recette.strIngredient3, !ingredient3.isEmpty {
                ingredients.append(ingredient3)
            }
            if let ingredient4 = recette.strIngredient4, !ingredient4.isEmpty {
                ingredients.append(ingredient4)
            }
            if let ingredient5 = recette.strIngredient5, !ingredient5.isEmpty {
                ingredients.append(ingredient5)
            }
            if let ingredient6 = recette.strIngredient6, !ingredient6.isEmpty {
                ingredients.append(ingredient6)
            }
            if let ingredient7 = recette.strIngredient7, !ingredient7.isEmpty {
                ingredients.append(ingredient7)
            }
            if let ingredient8 = recette.strIngredient8, !ingredient8.isEmpty {
                ingredients.append(ingredient8)
            }
            if let ingredient9 = recette.strIngredient9, !ingredient9.isEmpty {
                ingredients.append(ingredient9)
            }
            if let ingredient10 = recette.strIngredient10, !ingredient10.isEmpty {
                ingredients.append(ingredient10)
            }
            if let ingredient11 = recette.strIngredient11, !ingredient11.isEmpty {
                ingredients.append(ingredient11)
            }
            if let ingredient12 = recette.strIngredient12, !ingredient12.isEmpty {
                ingredients.append(ingredient12)
            }
            if let ingredient13 = recette.strIngredient13, !ingredient13.isEmpty {
                ingredients.append(ingredient13)
            }
            if let ingredient14 = recette.strIngredient14, !ingredient14.isEmpty {
                ingredients.append(ingredient14)
            }
            if let ingredient15 = recette.strIngredient15, !ingredient15.isEmpty {
                ingredients.append(ingredient15)
            }
            if let ingredient16 = recette.strIngredient16, !ingredient16.isEmpty {
                ingredients.append(ingredient16)
            }
            if let ingredient17 = recette.strIngredient17, !ingredient17.isEmpty {
                ingredients.append(ingredient17)
            }
            if let ingredient18 = recette.strIngredient18, !ingredient18.isEmpty {
                ingredients.append(ingredient18)
            }
            if let ingredient19 = recette.strIngredient19, !ingredient19.isEmpty {
                ingredients.append(ingredient19)
            }
            if let ingredient20 = recette.strIngredient20, !ingredient20.isEmpty {
                ingredients.append(ingredient20)
            }
        }
    }
    
    func mesuresFilter() {

        if let measure1 = recetteDetail!.strMeasure1, !measure1.isEmpty {
            measures.append(measure1)
        }
        if let measure2 = recetteDetail!.strMeasure2, !measure2.isEmpty {
            measures.append(measure2)
        }
        if let measure3 = recetteDetail!.strMeasure3, !measure3.isEmpty {
            measures.append(measure3)
        }
        if let measure4 = recetteDetail!.strMeasure4, !measure4.isEmpty {
            measures.append(measure4)
        }
        if let measure5 = recetteDetail!.strMeasure5, !measure5.isEmpty {
            measures.append(measure5)
        }
        if let measure6 = recetteDetail!.strMeasure6, !measure6.isEmpty {
            measures.append(measure6)
        }
        if let measure7 = recetteDetail!.strMeasure7, !measure7.isEmpty {
            measures.append(measure7)
        }
        if let measure8 = recetteDetail!.strMeasure8, !measure8.isEmpty {
            measures.append(measure8)
        }
        if let measure9 = recetteDetail!.strMeasure9, !measure9.isEmpty {
            measures.append(measure9)
        }
        if let measure10 = recetteDetail!.strMeasure10, !measure10.isEmpty {
            measures.append(measure10)
        }
        if let measure11 = recetteDetail!.strMeasure11, !measure11.isEmpty {
            measures.append(measure11)
        }
        if let measure12 = recetteDetail!.strMeasure12, !measure12.isEmpty {
            measures.append(measure12)
        }
        if let measure13 = recetteDetail!.strMeasure13, !measure13.isEmpty {
            measures.append(measure13)
        }
        if let measure14 = recetteDetail!.strMeasure14, !measure14.isEmpty {
            measures.append(measure14)
        }
        if let measure15 = recetteDetail!.strMeasure15, !measure15.isEmpty {
            measures.append(measure15)
        }
        if let measure16 = recetteDetail!.strMeasure16, !measure16.isEmpty {
            measures.append(measure16)
        }
        if let measure17 = recetteDetail!.strMeasure17, !measure17.isEmpty {
            measures.append(measure17)
        }
        if let measure18 = recetteDetail!.strMeasure18, !measure18.isEmpty {
            measures.append(measure18)
        }
        if let measure19 = recetteDetail!.strMeasure19, !measure19.isEmpty {
            measures.append(measure19)
        }
        if let measure20 = recetteDetail!.strMeasure20, !measure20.isEmpty {
            measures.append(measure20)
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "token") as? String

        let jwt = try? decode(jwt: token!)
        
        if let jwt = jwt {
        guard let url = URL(string: "http://localhost:3000/api/recettes/\(recetteDetail!._id)/like") else {
            print("Invalid URL")
            return
        }

            // access the claims in the token payload
            let userId = jwt.claim(name: "userId").string!
            let body = ["id":userId ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                if let response = response as? HTTPURLResponse {
                    print("Status code: \(response.statusCode)")
                }

                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                        DispatchQueue.main.async {
                            self.showAlert(title: "Success", message: "The recipe has been liked!")
                        }
                    }
                }
            }

            task.resume()
        } else {
            // handle decoding error
        }



        
    }
    
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "token") as? String

        let jwt = try? decode(jwt: token!)
        
        if let jwt = jwt {
        guard let url = URL(string: "http://localhost:3000/api/recettes/\(recetteDetail!._id)/dislike") else {
            print("Invalid URL")
            return
        }

            // access the claims in the token payload
            let userId = jwt.claim(name: "userId").string!
            let body = ["id":userId ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                if let response = response as? HTTPURLResponse {
                    print("Status code: \(response.statusCode)")
                }

                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                        DispatchQueue.main.async {
                            self.showAlert(title: "Success", message: "The recipe has been liked!")
                        }
                    }
                }
            }

            task.resume()
        } else {
            // handle decoding error
        }
    }
    
 
    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        

        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in

            completion?()

        }

        

        alert.addAction(action)

        

        if let topViewController = UIApplication.shared.windows.first?.rootViewController {

            topViewController.present(alert, animated: true, completion: nil)

        }

    }
}
