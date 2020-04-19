//
//  graphOneViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 20/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class graphOneViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
