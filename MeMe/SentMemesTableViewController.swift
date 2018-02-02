//
//  SentMemesTableViewController.swift
//  MeMe
//
//  Created by Jacob on 2/2/18.
//  Copyright © 2018 Jacob Voyles. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addMeme: UIBarButtonItem!
    @IBOutlet weak var memeTable: UITableView!
    //'Edit' button...
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
        
        //Reload the meme data
        memeTable.reloadData()
    }
    
    //Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! MeMeTableViewCell
        //Grab the entry for each row
        let meme = memes[indexPath.row]
        
        // Configure the cell...
        cell.memeImage.image = meme.memedImage
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath){
        //Show the selected memem in a Detail View
        let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        let meme = memes[indexPath.row]
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as MemeDetailViewController
        controller.meme = meme
       self.navigationController?.pushViewController(controller, animated: true)
    }
 */
    //Bonus - delete a meme
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Delete the selected entry
        (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
        //and reload the data
        memeTable.reloadData()
    }
    
    
    //Add a Meme from the action button in collection/table view
    @IBAction func newMeme(sender: UIBarButtonItem) {
        let controller =
            self.storyboard?.instantiateViewController(withIdentifier: "memeEditor") as! ViewController
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        //We're editing, so stop
        if memeTable.isEditing{
            memeTable.setEditing(false, animated: true)
            sender.style = UIBarButtonItemStyle.plain
            sender.title = "Edit"
        }
            //We're not, so start
        else{
            memeTable.setEditing(true, animated: true)
            sender.title = "Done"
            sender.style = UIBarButtonItemStyle.done
        }
    }

}
