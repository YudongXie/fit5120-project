//
//  AboutUsViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 19/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the background image and fit it to screen
        
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
          backgroundImage.image = UIImage(named: "newHomeBg")
          
          backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
          self.contentView.insertSubview(backgroundImage, at: 0)
        
        
          /* resize the background image to fit in scroll view*/
          backgroundImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
