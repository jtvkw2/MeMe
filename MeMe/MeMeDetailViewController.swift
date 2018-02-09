//
//  MemeDetailViewController.swift
//  MeMe
//
//  Created by Jacob on 2/9/18.
//  Copyright © 2018 Jacob Voyles. All rights reserved.
//

import UIKit

class MeMeDetailViewController: UIViewController {
    
    var selectedMeme: Meme!
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = selectedMeme.memedImage
        detailImageView.contentMode = .scaleAspectFit
        
        
    }
}


