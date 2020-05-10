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
        
        /*Set the nav bar color and font size*/
        let appearance = UINavigationBarAppearance()
               appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LexendGiga-Regular", size: 12)!,.foregroundColor:UIColor.white]
               appearance.backgroundColor = UIColor.init(red: 89/255, green: 128/255, blue: 169/255, alpha: 1.0)
               UINavigationBar.appearance().standardAppearance = appearance
        
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
    
    
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
         self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*Set nav bar color and font size*/
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LexendGiga-Regular", size: 12)!,.foregroundColor:UIColor.white]
        appearance.backgroundColor = UIColor(red: 52/255, green: 71/255, blue: 102/255, alpha: 1)
        UINavigationBar.appearance().standardAppearance = appearance
       }
    

}
