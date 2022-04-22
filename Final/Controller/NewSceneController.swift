//
//  NewSceneController.swift
//  Final
//
//  Created by evyhsiao on 2021/12/31.
//

import UIKit

class NewSceneController: UITableViewController, UITextViewDelegate {
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var cityTextField: RoundedTextField! {
        didSet {
            cityTextField.tag = 2
            cityTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
            descriptionTextView.text = "Input some description..."
            descriptionTextView.textColor = UIColor.lightGray
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 10.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if descriptionTextView.text == "" {
            descriptionTextView.text = "Input some description..."
            descriptionTextView.textColor = UIColor.lightGray
        }
    }

    @IBOutlet var photoImageView1: UIImageView!
    
    @IBOutlet var photoImageView2: UIImageView!
    
    @IBOutlet var photoImageView3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var addImage: Int = 0
    var imageCount: Int = 0
    
    @IBAction func addImage1(_ sender: Any) {
        addImages()
        self.addImage = 1
    }
    
    @IBAction func addImage2(_ sender: Any) {
        addImages()
        self.addImage = 2
    }
    
    @IBAction func addImage3(_ sender: Any) {
        addImages()
        self.addImage = 3
    }
    
    @IBAction func deleteImage1(_ sender: Any) {
        photoImageView1.image = UIImage(systemName: "doc.fill")
    }
    
    @IBAction func deleteImage2(_ sender: Any) {
        photoImageView2.image = UIImage(systemName: "doc.fill")
    }
    
    @IBAction func deleteImage3(_ sender: Any) {
        photoImageView3.image = UIImage(systemName: "doc.fill")
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        //Check empty fields and trigger an alert message
        if nameTextField.text == "" || cityTextField.text == "" || addressTextField.text == "" || descriptionTextView.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //Create a managed object in the context
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let scene = Scene(context: appDelegate.persistentContainer.viewContext)
        
        // Set the property values from the edit text fields
        scene.name = nameTextField.text!
        scene.city = cityTextField.text!
        scene.address = addressTextField.text!
        scene.summary = descriptionTextView.text!
        
        if let imageData1 = photoImageView1.image?.pngData() {  //having a default image already
            if imageData1 != UIImage(systemName: "doc.fill")?.pngData() {
                scene.image1 = imageData1
                self.imageCount += 1
            }
        }
        if let imageData2 = photoImageView2.image?.pngData() {  //having a default image already
            if imageData2 != UIImage(systemName: "doc.fill")?.pngData() {
                if self.imageCount == 0 {
                    scene.image1 = imageData2
                    self.imageCount += 1
                }else if self.imageCount == 1 {
                    scene.image2 = imageData2
                    self.imageCount += 1
                }
            }
        }
        if let imageData3 = photoImageView3.image?.pngData() {  //having a default image already
            if imageData3 != UIImage(systemName: "doc.fill")?.pngData() {
                if self.imageCount == 0 {
                    scene.image1 = imageData3
                    self.imageCount += 1
                }else if self.imageCount == 1 {
                    scene.image2 = imageData3
                    self.imageCount += 1
                }else if self.imageCount == 2{
                    scene.image3 = imageData3
                    self.imageCount += 1
                }
            }
        }
        scene.photoCount = Int16(self.imageCount)
        
        // Save the data to the data store
        appDelegate.saveContext()
        
        // Dismiss the current view controller
        dismiss(animated: true, completion: nil)
    }
    
    func addImages() {
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate methods

extension NewSceneController: UITextFieldDelegate  {
    
    // auto return to the next input textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate methods

extension NewSceneController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Retrieve the image picked up by the usr
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if self.addImage == 1 {
                photoImageView1.image = selectedImage
                photoImageView1.contentMode = .scaleAspectFill
                photoImageView1.clipsToBounds = true
            }
            if self.addImage == 2 {
                photoImageView2.image = selectedImage
                photoImageView2.contentMode = .scaleAspectFill
                photoImageView2.clipsToBounds = true
            }
            if self.addImage == 3 {
                photoImageView3.image = selectedImage
                photoImageView3.contentMode = .scaleAspectFill
                photoImageView3.clipsToBounds = true
            }
            else {
                print("Didn't add any image.")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
