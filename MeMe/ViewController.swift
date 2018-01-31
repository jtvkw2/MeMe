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
    @IBOutlet weak var CancalButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.delegate = self as? UITextFieldDelegate;
        bottomText.delegate = self as? UITextFieldDelegate;
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        let attributes : [String : Any] = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "ComicSansMS", size: 40) ?? UIFont.systemFont(ofSize: 30)
            ]
        
        topText.defaultTextAttributes = attributes
        topText.textAlignment = NSTextAlignment.center
        topText.text = "Top Text"
        
        bottomText.defaultTextAttributes = attributes
        bottomText.textAlignment = NSTextAlignment.center
        bottomText.text = "Bottom Text"
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func pickAnImageCamera(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        present(pickerController, animated:true, completion:nil)
    }
    
    @IBAction func pickAnImageAlbum(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(pickerController, animated:true, completion:nil)
    }
    
    @IBAction func takeAction(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        print("I have a meme!")
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage],applicationActivities: nil)
        
        present(activityViewController, animated: true)
        activityViewController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if (completed)
            {
                self.save(memedImage: memedImage)
            }
        }
    }
    
    @IBAction func Cancel(_ sender: Any) {
        ImagePickerView.image = nil
        topText.text = "Top Text"
        bottomText.text = "Bottom Text"
        dismiss(animated: true, completion: nil)
    }
    
    
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
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
        
        return memedImage
    }
   
    func save(memedImage:UIImage){
        let meme = Meme( topText:topText.text!, bottomText: bottomText.text!, image:
            ImagePickerView.image!, memedImage: memedImage)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
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
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomText.isFirstResponder)
        {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if (bottomText.isFirstResponder)
        {
            view.frame.origin.y += getKeyboardHeight(notification as Notification)
        }
    }
}
