//
//  CollectionViewController.swift
//  MeMe
//
//  Created by Jacob on 2/2/18.
//  Copyright © 2018 Jacob Voyles. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource {
    
    //User action buttons
    @IBOutlet weak var memeCollection: UICollectionView!
    @IBOutlet weak var addMeme: UIBarButtonItem!
    
    //'Edit' the meme
    @IBOutlet weak var memeEdit: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Are the memes emnpty? If so, pop up the editor. This should create the initial app functionality required by the spec.
        //This will only happen on the initial load, as monitored by a global var
        if (UIApplication.shared.delegate as! AppDelegate).memes.count == 0 {
            //Pop up the editor
            let controller =
                self.storyboard?.instantiateViewController(withIdentifier: "memeEditor") as! ViewController
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
        //println("Number of memes from ViewDidAppear: \((UIApplication.sharedApplication().delegate as AppDelegate).memes.count)")
        
        //Reload the data
        memeCollection.reloadData()
    }
    
    //Collection View methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath as IndexPath) as! MeMeCollectionViewCell
        cell.memedImage.image = meme.memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        //With the edit function enabled, we hijack the selection event to determine whether
        //to show the Detail View or offer to delete a meme
        //let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        //let meme = memes[indexPath.row]
        
        //We're not editing, so show the detail view
        if !self.isEditing{
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! ViewController
            //controller.meme = meme
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{//We're editing so show a confirmation dialog and delete this meme if confirmed
            //We need to do this because the CollectionView doesn't have a UI method to handle this like TableView does...
            
            //Create an alert
            let confirm = UIAlertController(title: "Delete Meme?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            //Cancel button just closes the dialog
            confirm.addAction(UIAlertAction(title: "Cancel",style: UIAlertActionStyle.cancel, handler: nil))
            //Delete button does the dirty work
            confirm.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler:
                { action in
                    //Delete the selected entry
                    (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
                    //and reload the data
                    self.memeCollection.reloadData()
            }))
            self.present(confirm, animated: true, completion: nil)
        }
    }
    
    //Add a new meme from the action button on the table or collection view
    @IBAction func newMeme(sender: UIBarButtonItem) {
        let controller =
            self.storyboard?.instantiateViewController(withIdentifier: "memeEditor") as! ViewController
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    //The monkey flips the switch, and we're doing this manually with collection views
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        //We're editing, so stop
        if self.isEditing{
            sender.style = UIBarButtonItemStyle.plain
            sender.title = "Edit"
            self.isEditing = false
        }
            //We're not, so start
        else{
            sender.title = "Done"
            sender.style = UIBarButtonItemStyle.done
            self.isEditing = true
        }
    }

}
