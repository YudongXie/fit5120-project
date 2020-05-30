//
//  AboutUsViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 19/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the background image and fit it to screen
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "testBg4")
        
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        /* resize the background image to fit in scroll view*/
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func getVideo(){
         /*Call Video URlL and display*/
         let serviceURL = "https://www.youtube.com/embed/e4uU47k_UKw?playsinline=1"
         let url = URL(string:serviceURL)
         webView.load(URLRequest(url:url!))
     }
    
    override func viewWillAppear(_ animated: Bool) {
        getVideo()
    }
    
}
