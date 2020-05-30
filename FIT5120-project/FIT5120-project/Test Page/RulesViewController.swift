//
//  RulesViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 6/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
    
    @IBOutlet var visualArray: [UIVisualEffectView] = []
    @IBOutlet weak var buttonVisual: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*For loop to set the radius for each subView*/
        for index in visualArray{
            index.layer.cornerRadius = 10
            index.clipsToBounds = true
        }
        
        buttonVisual.layer.cornerRadius = 15
        buttonVisual.clipsToBounds = true
    }
    
    @IBAction func backToPreviousPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       }
    

}
