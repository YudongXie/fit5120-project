//
//  seoncdLanuchViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 29/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class secondLanuchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            /*Sleep for 3 second then render to next controller */
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "passwordController") as! UIViewController
            UIApplication.shared.keyWindow?.rootViewController = viewController;
        })
    }

}
