//
//  CollectionViewController.swift
//  MeMe
//
//  Created by Jacob on 2/2/18.
//  Copyright © 2018 Jacob Voyles. All rights reserved.
//

import UIKit

class MeMeCollectionViewController: UICollectionViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        for tabBarItem in tabBarController!.tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sent Memes"
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeme = appDelegate.memes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeDetailVC = storyboard.instantiateViewController(withIdentifier: "MeMeDetailViewController") as! MeMeDetailViewController
        memeDetailVC.selectedMeme = selectedMeme
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath as IndexPath) as! MeMeCollectionViewCell
        
        // Configure the cell
        let meme = appDelegate.memes[indexPath.row]
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }
}

