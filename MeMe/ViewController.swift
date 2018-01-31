//
//  ViewController.swift
//  MeMe
//
//  Created by Jacob on 1/29/18.
//  Copyright © 2018 Jacob Voyles. All rights reserved.
//

import UIKit
import Foundation

struct Meme {
    var topText : String
    var bottomText : String
    var image : UIImage
    var memedImage : UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {


    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    
    @IBOutlet weak var bottomToolBar: UIToolbar!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.delegate = self as? UITextFieldDelegate;
        bottomText.delegate = self as? UITextFieldDelegate;
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        let memeTextAttributes : [String : Any] = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "Papya", size:40) ??  UIFont.systemFont(ofSize: 40)
            ]
        
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.center
        topText.text = "TOP"
        topText.isHidden = false;
        
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.center
        bottomText.text = "BOTTOM"
        bottomText.isHidden = false;
        // Do any additional setup after loading the view, typically from a nib.
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageCamera(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        present(pickerController, animated:true, completion:nil)
    }
    
    //execute this when user selects album icon
    @IBAction func pickAnImageAlbum(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(pickerController, animated:true, completion:nil)
    }
    
    //executed when user selects image from image picker
    func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePickerView.contentMode = UIViewContentMode.scaleAspectFit
            ImagePickerView.image = image
            dismiss(animated: true, completion: nil)
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        ImagePickerView.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        //we want to hide the toolbars, so that they are not
        //part of the meme
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        
        //create the image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //once the image is created, the toolbars can be redisplayed
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
        
        return memedImage
    }
   
    func save(memedImage:UIImage){
        let meme = Meme( topText:topText.text!, bottomText: bottomText.text!, image:
            ImagePickerView.image!, memedImage: memedImage)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    
    //this function is executed when the Action button is selected
    //the meme is generated and the Activity View Controller is displayed
    @IBAction func takeAction(sender: AnyObject) {
        
        //memed image, with image and text is generated
        let memedImage = generateMemedImage()
        print("I have a meme")
        //create the Activity View Controller
        let activityViewController = UIActivityViewController(activityItems: [memedImage],applicationActivities: nil)
        
        present(activityViewController, animated: true)
        
        //this sets up the save of the meme, which will be done when the Activity View Controller is completed
        activityViewController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if (completed)
            {
                self.save(memedImage: memedImage)
            }
        }
}
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if (bottomText.isFirstResponder)
        {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        print(bottomText.isFirstResponder)
        if (bottomText.isFirstResponder)
        {
            view.frame.origin.y += getKeyboardHeight(notification as Notification)
        }
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
