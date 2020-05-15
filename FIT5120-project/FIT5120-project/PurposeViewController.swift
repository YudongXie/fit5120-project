//
//  PurposeViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 2/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class PurposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
               appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LexendGiga-Regular", size: 12)!,.foregroundColor:UIColor.white]
               appearance.backgroundColor = UIColor.init(red: 89/255, green: 128/255, blue: 169/255, alpha: 1.0)
               UINavigationBar.appearance().standardAppearance = appearance
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*Set nav bar color and font size*/
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LexendGiga-Regular", size: 12)!,.foregroundColor:UIColor.white]
        appearance.backgroundColor = UIColor(red: 52/255, green: 71/255, blue: 102/255, alpha: 1)
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
