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
    @State private var description = ""
    @State private var image = ""
    @State private var isBio = false
    @State private var duration = ""
    @State private var person = ""
    @State private var difficulty = ""
    @State private var ingredients = [Ingredient]()
    @State private var steps = [String]()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
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

                                      Text("Select a photo")

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
                    }
                    
                    Section(header: Text("Ingredients")) {
                        ForEach(ingredients.indices, id: \.self) { index in
                            HStack {
                                TextField("Ingredient", text: $ingredients[index]._id)
                                
                                TextField("Quantity", text: $ingredients[index].strIngredient)
                            }
                        }
                        
                        Button(action: {
                            ingredients.append(Ingredient( id: UUID(), _id: "String", strIngredient: "", strDescription: ""))
                        }) {
                            Label("Add Ingredient", systemImage: "plus")
                        }
                    }
                    
                    Section(header: Text("Steps")) {
                        ForEach(steps.indices, id: \.self) { index in
                            TextField("Step \(index + 1)", text: $steps[index])
                        }
                        
                        Button(action: {
                            steps.append("")
                        }) {
                            Label("Add Step", systemImage: "plus")
                        }
                    }
                }
                
                Button(action: {
                    createRecipe()
                })
                {
                    Text("Create Recipe")
                        .foregroundColor(Color("orangeKitchen"))
                        Image(systemName: "")
                
                }
                .frame(maxWidth: .infinity, minHeight: 24)
                .background(Color("ButtonColor"))
                .cornerRadius(8)
                .padding(.vertical, 20)
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
     
     func createRecipe() {
     }
     

