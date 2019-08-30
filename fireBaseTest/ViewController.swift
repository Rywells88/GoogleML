//
//  ViewController.swift
//  fireBaseTest
//
//  Created by Ryley Wells (LCL) on 5/24/19.
//  Copyright © 2019 Ryley Wells (LCL). All rights reserved.
//

import UIKit
import CameraKit_iOS
import GoogleSignIn
import Firebase
import FirebaseMLCommon
import FirebaseMLVision
import FirebaseMLVisionAutoML


class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

let session = CKFPhotoSession()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // camera functionality
        let previewView = CKFPreviewView(frame: self.view.bounds)
        previewView.session = session
        
        // google sign in 
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        signInButton.setTitle("Sign in with Google", for: .normal)
        //takePic.setTitle("", for: .normal)
        guard let manifestPath = Bundle.main.path(forResource: "manifest",ofType: "json",inDirectory: "bundled-2019-06-04_17-00-17-857_tflite") else { return }
        let localModel = LocalModel(name: "myNewModel", path: manifestPath)
        if ( ModelManager.modelManager().register(localModel) == true){
            print ("the model has been registered")
        }else {
            print("the model has not been registered")
        }

        signInButton.addTarget(self, action: #selector(signInUserUsingGoogle(_sender:)), for: .touchUpInside)
        displayPic.layer.shadowColor = UIColor.black.cgColor
        //displayPic.layer.shadowOpacity = 0.2
        displayPic.clipsToBounds = false
        //displayPic.layer.shadowRadius = 1
        displayPic.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOpacity = 0.6
        bar.clipsToBounds = false
        bar.layer.shadowRadius = 5
        
        
        
}
    let brocolli = RestApiManager()
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var isSignedIn: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var displayPic: UIImageView!
    @IBOutlet weak var firstConfidenceLabel: UILabel!
    @IBOutlet weak var secondConfidenceLabel: UILabel!
    @IBOutlet var bar: UIView!
    
    
    @IBAction func takePic(_ sender: Any) {
       // session.capture({ (image, settings) in
        //let worked = self.brocolli.useModel(examp:#imageLiteral(resourceName: "Chinese_brocolli"))
       // if(worked == true){
            self.updateLabel()
           // self.updateImageView(brocolliPic: image)
      //  }
//    }) { (error) in
//             //TODO: Handle error
//        }
    }
    @objc func signInUserUsingGoogle(_sender: UIButton){
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = .camera
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            
        }
        
    }
    
    
    @IBAction func importPic(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            
        }
        
        
    }
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            brocolli.useModel(examp: image)
            displayPic.image = image
            
        }
        else{
            // error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("we have an error == \(error.localizedDescription)")
        }else {
            if let gmailUser = user {
                isSignedIn.text = "you are signed in using id \(gmailUser.profile.email)"
                
                signInButton.setValue("Sign out", forKey: "hi")
            }
        }
    }
    
    public func updateLabel(){
       
        var num1:Float = Float(brocolli.getFirstConfidenceLabel())
        var num2:Float = Float(brocolli.getSecondConfidenceLabel())
        firstConfidenceLabel.text = "\(num1*100.0)" + "%"
        secondConfidenceLabel.text = "\(num2*100.0)" + "%"
        
        
        
    }
    public func updateImageView(brocolliPic: UIImage)
    {
        displayPic.image = brocolliPic
    }
    
    
    
}
