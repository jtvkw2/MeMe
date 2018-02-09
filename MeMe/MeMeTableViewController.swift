//
//  SentMemesTableViewController.swift
//  MeMe
//
//  Created by Jacob on 2/2/18.
//  Copyright © 2018 Jacob Voyles. All rights reserved.
//

import UIKit

class MeMeTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = editButtonItem
        title = "Sent Memes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        for tabBarItem in tabBarController!.tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath as IndexPath)
        
        // Configure the cell...
        let meme = appDelegate.memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        // Grabbing the selected cell's meme
        let selectedMeme = appDelegate.memes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeDetailVC = storyboard.instantiateViewController(withIdentifier: "MeMeDetailViewController") as! MeMeDetailViewController
        memeDetailVC.selectedMeme = selectedMeme
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
