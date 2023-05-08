//
//  FoodDetailViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 25/4/2023.
//

import UIKit

class FoodDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
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
    
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    var ingredients : [String] = []
    var measures:[String] = []
    
    var foodDetail: Food? = nil
    @IBOutlet weak var descriptionScrollView: UITextView!
    @IBOutlet weak var ingredientsMesuresTableView: UITableView!
    @IBOutlet weak var foodDetailIV: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsListLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingedientsFilter()
        mesuresFilter()
        print(ingredients.count)
        print(measures.count)
        
        
        foodDetailIV.kf.setImage(with: URL(string: foodDetail!.strMealThumb))
        ingredientsListLabel.text = foodDetail?.strMeal
        descriptionScrollView.text = foodDetail?.strInstructions
        areaLabel.text = foodDetail?.strArea
        
        qrCodeImageView.image = generateQRCode(from: foodDetail!.strYoutube)
        
    }
    
    func ingedientsFilter(){
        if let food = foodDetail {
            if let ingredient1 = food.strIngredient1, !ingredient1.isEmpty {
                ingredients.append(ingredient1)
            }
            if let ingredient2 = food.strIngredient2, !ingredient2.isEmpty {
                ingredients.append(ingredient2)
            }
            if let ingredient3 = food.strIngredient3, !ingredient3.isEmpty {
                ingredients.append(ingredient3)
            }
            if let ingredient4 = food.strIngredient4, !ingredient4.isEmpty {
                ingredients.append(ingredient4)
            }
            if let ingredient5 = food.strIngredient5, !ingredient5.isEmpty {
                ingredients.append(ingredient5)
            }
            if let ingredient6 = food.strIngredient6, !ingredient6.isEmpty {
                ingredients.append(ingredient6)
            }
            if let ingredient7 = food.strIngredient7, !ingredient7.isEmpty {
                ingredients.append(ingredient7)
            }
            if let ingredient8 = food.strIngredient8, !ingredient8.isEmpty {
                ingredients.append(ingredient8)
            }
            if let ingredient9 = food.strIngredient9, !ingredient9.isEmpty {
                ingredients.append(ingredient9)
            }
            if let ingredient10 = food.strIngredient10, !ingredient10.isEmpty {
                ingredients.append(ingredient10)
            }
            if let ingredient11 = food.strIngredient11, !ingredient11.isEmpty {
                ingredients.append(ingredient11)
            }
            if let ingredient12 = food.strIngredient12, !ingredient12.isEmpty {
                ingredients.append(ingredient12)
            }
            if let ingredient13 = food.strIngredient13, !ingredient13.isEmpty {
                ingredients.append(ingredient13)
            }
            if let ingredient14 = food.strIngredient14, !ingredient14.isEmpty {
                ingredients.append(ingredient14)
            }
            if let ingredient15 = food.strIngredient15, !ingredient15.isEmpty {
                ingredients.append(ingredient15)
            }
            if let ingredient16 = food.strIngredient16, !ingredient16.isEmpty {
                ingredients.append(ingredient16)
            }
            if let ingredient17 = food.strIngredient17, !ingredient17.isEmpty {
                ingredients.append(ingredient17)
            }
            if let ingredient18 = food.strIngredient18, !ingredient18.isEmpty {
                ingredients.append(ingredient18)
            }
            if let ingredient19 = food.strIngredient19, !ingredient19.isEmpty {
                ingredients.append(ingredient19)
            }
            if let ingredient20 = food.strIngredient20, !ingredient20.isEmpty {
                ingredients.append(ingredient20)
            }
        }
    }
    
    func mesuresFilter() {

        if let measure1 = foodDetail!.strMeasure1, !measure1.isEmpty {
            measures.append(measure1)
        }
        if let measure2 = foodDetail!.strMeasure2, !measure2.isEmpty {
            measures.append(measure2)
        }
        if let measure3 = foodDetail!.strMeasure3, !measure3.isEmpty {
            measures.append(measure3)
        }
        if let measure4 = foodDetail!.strMeasure4, !measure4.isEmpty {
            measures.append(measure4)
        }
        if let measure5 = foodDetail!.strMeasure5, !measure5.isEmpty {
            measures.append(measure5)
        }
        if let measure6 = foodDetail!.strMeasure6, !measure6.isEmpty {
            measures.append(measure6)
        }
        if let measure7 = foodDetail!.strMeasure7, !measure7.isEmpty {
            measures.append(measure7)
        }
        if let measure8 = foodDetail!.strMeasure8, !measure8.isEmpty {
            measures.append(measure8)
        }
        if let measure9 = foodDetail!.strMeasure9, !measure9.isEmpty {
            measures.append(measure9)
        }
        if let measure10 = foodDetail!.strMeasure10, !measure10.isEmpty {
            measures.append(measure10)
        }
        if let measure11 = foodDetail!.strMeasure11, !measure11.isEmpty {
            measures.append(measure11)
        }
        if let measure12 = foodDetail!.strMeasure12, !measure12.isEmpty {
            measures.append(measure12)
        }
        if let measure13 = foodDetail!.strMeasure13, !measure13.isEmpty {
            measures.append(measure13)
        }
        if let measure14 = foodDetail!.strMeasure14, !measure14.isEmpty {
            measures.append(measure14)
        }
        if let measure15 = foodDetail!.strMeasure15, !measure15.isEmpty {
            measures.append(measure15)
        }
        if let measure16 = foodDetail!.strMeasure16, !measure16.isEmpty {
            measures.append(measure16)
        }
        if let measure17 = foodDetail!.strMeasure17, !measure17.isEmpty {
            measures.append(measure17)
        }
        if let measure18 = foodDetail!.strMeasure18, !measure18.isEmpty {
            measures.append(measure18)
        }
        if let measure19 = foodDetail!.strMeasure19, !measure19.isEmpty {
            measures.append(measure19)
        }
        if let measure20 = foodDetail!.strMeasure20, !measure20.isEmpty {
            measures.append(measure20)
        }
    }
    func generateQRCode(from string: String) -> UIImage? {
        // Create a data object from the input string
        let data = string.data(using: String.Encoding.ascii)

        // Create a CIFilter instance for the CIQRCodeGenerator filter
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        // Set the input data for the filter
        filter.setValue(data, forKey: "inputMessage")

        // Get the output image from the filter
        guard let outputImage = filter.outputImage else { return nil }

        // Create a UIImage from the output image
        let context = CIContext()
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        let image = UIImage(cgImage: cgImage!)

        return image
    }
    
}
