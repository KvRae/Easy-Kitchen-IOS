//
//  RecetteSwiftUIView.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 2/5/2023.
//

import SwiftUI
import Foundation
import PhotosUI

struct RecetteView: View {
    @State private var name = ""
    @State private var image = ""
    @State private var description = ""
    @State private var isBio = false
    @State private var duration = ""
    @State private var person = ""
    @State private var showAlert = false
    @State private var difficulty = ""
    @State private var ingredients = [Ing]()
    @State private var steps = [String]()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    let defaults = UserDefaults.standard
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if let selectedImageData,
                        let uiImage = UIImage(data: selectedImageData) {
                            
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                    } else {
                        
                        Image(systemName: "photo.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(.gray)
                        
                    }
                    PhotosPicker(

                                  selection: $selectedItem,

                                  matching: .images,

                                  photoLibrary: .shared()) {

                                      Text("Pick a photo")

                                  }

                                  .onChange(of: selectedItem) { newItem in

                                      Task {

                                          // Retrieve selected asset in the form of Data

                                          if let data = try? await newItem?.loadTransferable(type: Data.self) {

                                              selectedImageData = data

                                          }

                                      }

                                  }
                    Section(header: Text("Basic Information")) {
                        TextField("Name", text: $name)
                        
                        Toggle("Is it organic?", isOn: $isBio)
                        
                        TextField("Duration", text: $duration)
                            .keyboardType(.numberPad)
                        
                        TextField("Person", text: $person)
                            .keyboardType(.numberPad)
                        
                        TextField("Difficulty", text: $difficulty)
                        
                        TextField("Description", text: $description)
                            .frame(width: .infinity, height: 100)
                    }
                    Section(header: Text("Ingredients/Mesures")) {
                        ForEach(ingredients.indices, id: \.self) { index in
                            HStack {
                                TextField("Ingredient", text: $ingredients[index].ingredient)
                                TextField("Mesure", text: $ingredients[index].mesure)
                            }
                        }
                        
                        Button(action: {
                            ingredients.append(Ing(ingredient: "", mesure: ""))
                        }) {
                            Label("Add Ingredients/Mesures", systemImage: "plus")
                            
                        }
                    }
                }
                
                Button(action: {
                    createRecipe(name: name,description: description, image: image, isBio: isBio, duration: duration, person: person, difficulty: difficulty, ingredients: ingredients, showAlert: showAlert)
                    
                    let userId = defaults.string(forKey: "id") ?? "N/A"
                    
                    sendImageWithPutRequest(image: UIImage(data: selectedImageData!)!, id: userId)
                    
                    
                }) {
                    Image(systemName: "plus")
                    Text("Create Recipe")
                }
                .frame(maxWidth: .infinity, minHeight: 24)
                .background(Color("ButtonColor"))
                .foregroundColor(Color("orangeKitchen"))
                .cornerRadius(8)
                .padding(.vertical, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Recipe Added"), message: Text("Your recipe has been successfully added."), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Create Recipe")
        }
    }
}


    
    
     struct CreateRecipeView_Previews: PreviewProvider {
     static var previews: some View {
     RecetteView()
     }
     }
     
func createRecipe(name: String,description: String, image: String, isBio: Bool, duration: String, person: String, difficulty: String, ingredients: [Ing], showAlert : Bool) {

    // Create the request URL
    let urlString = "http://localhost:3000/api/recettes/"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    // Create the request body
    var requestBody: [String: Any] = [
        "name": name,
        "description": description,
        "image": "",
        "isBio": isBio,
        "duration": duration,
        "person": person,
        "difficulty": difficulty,
        "username":name,
        "userId":"6390d20d7f807d0e685ac291"
    ]

    // Add the ingredients to the request body
    for (index, ingredient) in ingredients.enumerated() {
        let ingredientKey = "strIngredient\(index + 1)"
        requestBody[ingredientKey] = ingredient.ingredient
    }

    // Add the measures to the request body
    for (index, measure) in ingredients.enumerated() {
        let measureKey = "strMeasure\(index + 1)"
        requestBody[measureKey] = measure.mesure
        
    }
    
    // Convert the request body to JSON data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
        print("Failed to convert request body to JSON data")
        return
    }
    
    // Create the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    // Send the request
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        guard let data = data else {
            print("No data received")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }
        print("Response status code: \(httpResponse.statusCode)")
        if(httpResponse.statusCode == 201){
            
            
        }
        
        // Handle the response data here
    }.resume()
}

func sendImageWithPutRequest(image: UIImage,id : String) {

        guard let url = URL(string: "http://localhost:3000/api/users/upload/\("6390d20d7f807d0e685ac291")") else {

            return

        }

        

        // Create the URLRequest with the PUT HTTP method

        var request = URLRequest(url: url)

        request.httpMethod = "PUT"

        

        // Generate a boundary string for the multipart form data

        let boundary = UUID().uuidString

        

        // Set the Content-Type header to multipart/form-data with the boundary

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        

        // Create the data representation of the image

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {

            return

        }

        

        // Create the multipart/form-data body

        var body = Data()

        

        // Append the image data to the body

        body.append("--\(boundary)\r\n".data(using: .utf8)!)

        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)

        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)

        body.append(imageData)

        body.append("\r\n".data(using: .utf8)!)

        

        // Append any additional fields to the body if needed

        // For example, to include a title field:

        // body.append("--\(boundary)\r\n".data(using: .utf8)!)

        // body.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: .utf8)!)

        // body.append("My Image Title\r\n".data(using: .utf8)!)

        

        // Append the closing boundary

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        

        // Set the body of the request

        request.httpBody = body

        

        // Create a URLSessionDataTask and send the request

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {

                print("Error: \(error)")

                return

            }

            

            // Handle the response data if needed

            if let data = data {

                let responseString = String(data: data, encoding: .utf8)

                print("Response: \(responseString ?? "")")

            }

        }

        task.resume()

    }


struct Ing {
    var ingredient : String
    var mesure : String
}



     




