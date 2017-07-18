//
//  SetUserProfileViewController.swift
//  FitCal
//
//  Created by Natalia Consonni on 27/6/17.
//  Copyright © 2017 Bruno Lorenzo. All rights reserved.
//

import UIKit
import StepProgressBar
import ACProgressHUD_Swift
import Firebase

class SetUserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var progressStep: StepProgressBar!
    @IBOutlet weak var caloriesNumTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var finishSignUpButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var takeImageButton: UIButton!
    
    let picker = UIImagePickerController()
    let takeImagePicker = UIImagePickerController()
    
    var uid: String!
    var calories: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pictureImage = UIImage(named: "PictureIcon")
        self.selectImageButton.setImage(pictureImage, for: .normal)
        
        let cameraImage = UIImage(named: "CameraIcon")
        self.takeImageButton.setImage(cameraImage, for: .normal)
        
        self.finishSignUpButton.isHidden = true
        
        self.progressStep.stepsCount = 4
        self.progressStep.next()
        self.progressStep.next()
        self.progressStep.next()
        
        self.picker.delegate = self
        self.takeImagePicker.delegate = self
        
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        
        self.caloriesNumTextField.text = String(self.calories)
        
        Settings.instance.calories = self.calories

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func finishSignUp(_ sender: Any) {
        
        let progressHUD = self.initializeProgress(message: "Setting profile info..")
        
        // ++ Upload the profile image
        let profileImagePath = "Profile_" + self.uid + ".jpg"
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://fitnut-fa15d.appspot.com")
        let imgRef = storageRef.child("images").child(profileImagePath)
        if let imageData = UIImagePNGRepresentation(self.profileImage.image!) {
            imgRef.put(imageData, metadata: nil) {	metadata,error in
                if error != nil {
                    self.showError(message: (error?.localizedDescription)!)
                } else { 
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference()
                    let data: [String: Any] = ["Calories": self.calories]
                    ref.child("Users").child(self.uid).child("UserInfo").updateChildValues(data)
                    
                    User.instance.urlImage = metadata?.downloadURL()
                    
                    progressHUD.hideHUD()
                    self.performSegue(withIdentifier: "showDailyList", sender: self)
                }
            }
        }
        // --
    }
    
    @IBAction func takeImage(_ sender: Any) {
        self.takeImagePicker.sourceType = .camera
        self.takeImagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        present(takeImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        self.picker.allowsEditing = false
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        if(picker.sourceType == .camera) {
            UIImageWriteToSavedPhotosAlbum(chosenImage, self,#selector(image(_:didFinishSavingWithError:contextInfo:)),nil)
        } else {
        
        }
        
        self.profileImage.image = chosenImage
        
        self.finishSignUpButton.isHidden = false
        
        dismiss(animated:true, completion: nil)
    }
    
    func showError(message msg: String) {
        let errorAlterController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        errorAlterController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(errorAlterController, animated: true, completion: nil)
    }
    
    func initializeProgress(message msg: String) -> ACProgressHUD {
        let progressView = ACProgressHUD.shared
        progressView.progressText = msg
        progressView.showHUD()
        return progressView
    }
}
