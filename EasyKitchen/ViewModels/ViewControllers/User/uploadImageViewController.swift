//
//  uploadImageViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 6/5/2023.
//

import UIKit
import JWTDecode
import Kingfisher

class uploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let defaults = UserDefaults.standard


    
    
    @IBOutlet weak var profileImageView: UIImageView!


    var userId : String = ""
    var image : String = ""

    

    let imagePicker = UIImagePickerController()

    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var update: UIButton!
    
    var idStr: String?// The ID of the user whose profile picture is being updated


    var id: String?

    override func viewDidLoad() {

        super.viewDidLoad()
        let token = defaults.object(forKey: "token") as? String

        let jwt = try? decode(jwt: token!)

        if let jwt = jwt {
            // access the claims in the token payload
            DispatchQueue.main.async {
                self.userId = jwt.claim(name: "userId").string!
                print(jwt.claim(name: "userId").string!)

                self.image = jwt.claim(name: "image").string!
                
                self.profileImageView.kf.setImage(with: URL(string: self.image))
            }

            
            
            
        } else {
            // handle decoding error
        }

        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2

        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor.orange.cgColor



        userId = defaults.string(forKey: "id") ?? "N/A"

        imagePicker.delegate = self

        imagePicker.allowsEditing = true

        update.addTarget(self, action: #selector(uploadProfilePicture), for: .touchUpInside)

    }


 
/*
    @objc func uploadProfilePicture() {

        guard let userId = self.userId,
              
        
        let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5)

       

        else {

            print("Failed to get user ID or image data")

            return

        }

        self.showAlertNavigate(title: "success", message: "Great Pic")

           

           // rest of your code here

       
        print("the userID is" + self.userId)

        let url = URL(string: "http://localhost:3000/api/users/upload/\(self.userId)")!

        

        var request = URLRequest(url: url)

        request.httpMethod = "PUT"

        

        let boundary = UUID().uuidString

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        

        var body = Data()

        

        let fieldName = "file"

        let fileName = UUID().uuidString + ".jpg"

        let mimeType = "image/jpeg"

        

        body.append("--\(boundary)\r\n".data(using: .utf8)!)

        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)

        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)

        body.append(imageData)

        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        

        request.httpBody = body

        

        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {

                print(error.localizedDescription)

                return

            }

            

            guard let httpResponse = response as? HTTPURLResponse,

                  (200...299).contains(httpResponse.statusCode) else {

                print("Invalid response")

                return

            }

            

            guard let responseData = data else {

                print("No data received")

                return

            }

            

            do {

                let json = try JSONSerialization.jsonObject(with: responseData, options: [])

                print(json)

            } catch {

                print(error.localizedDescription)

            }

        }

        

        task.resume()

    }
*/
    
    @objc func uploadProfilePicture() {
        
        guard let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5) else {
            print("Failed to get image data")
            return
        }

        print("the userID is " + self.userId)
        let url = URL(string: "http://localhost:3000/api/users/upload/\(self.userId)")!

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        let fieldName = "file"
        let fileName = UUID().uuidString + ".jpg"
        let mimeType = "image/jpeg"

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }

            guard let responseData = data else {
                print("No data received")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                print(json)

                DispatchQueue.main.async {
                    if let jsonDict = json as? [String: Any],
                       let message = jsonDict["message"] as? String {
                        self.showAlert(title: "Success", message: message)
                        
                        UserDefaults.standard.removeObject(forKey: "token")
                        
                        self.defaults.set(jsonDict["token"], forKey: "token")                        
                    } else {
                        print("Error: Invalid JSON format")
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[.editedImage] as? UIImage {

            profileImageView.image = editedImage

        } else if let originalImage = info[.originalImage] as? UIImage {

            profileImageView.image = originalImage

        }

        dismiss(animated: true, completion: nil)

        

    }




    @IBAction func selectProfilePicture(_ sender: Any) {

        let alert = UIAlertController(title: "Choose Profile Picture", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in

            self.imagePicker.sourceType = .camera

            self.present(self.imagePicker, animated: true, completion: nil)

        }))

        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in

            self.imagePicker.sourceType = .photoLibrary

            self.present(self.imagePicker, animated: true, completion: nil)

        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)

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

    

    

    func showAlertNavigate(title: String, message: String, id: String? = nil, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        

        let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let destinationVC = storyboard.instantiateViewController(withIdentifier: "uploadImageVC") as! uploadImageViewController

            if let id = id {

                destinationVC.idStr = String(id)

            }

            self.navigationController?.pushViewController(destinationVC, animated: true)

        }

        

        alert.addAction(action)

        

        if let topViewController = UIApplication.shared.windows.first?.rootViewController {

            topViewController.present(alert, animated: true, completion: nil)

        }

    }



    

}

