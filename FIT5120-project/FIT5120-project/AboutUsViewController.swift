//
//  AboutUsViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 19/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Set the background image and fit it to screen
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homeBg3")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    

}
