//
//  testMainScreenViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 20/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

/*This file is for tab bar - Test*/

import UIKit

class testMainScreenViewController: UIViewController {
    
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var reactionTestButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "testBg4")
        
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        
        /* resize the background image to fit in scroll view*/
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        /*Set raidus for buttons*/
        questionButton.layer.zPosition = 1
        reactionTestButton.layer.zPosition = 1
        
        questionButton.layer.cornerRadius = 5

        reactionTestButton.layer.cornerRadius = 5
        
        questionButton.layer.borderWidth = 2
        reactionTestButton.layer.borderWidth = 2
        
        questionButton.layer.borderColor = UIColor.white.cgColor
        reactionTestButton.layer.borderColor = UIColor.white.cgColor
    }
    
}
