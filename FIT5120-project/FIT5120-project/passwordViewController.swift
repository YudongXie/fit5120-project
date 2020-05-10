//
//  passwordViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 28/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class passwordViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    /*Click return to hide keyboard*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func button(_ sender: Any) {
        /*If correct then render to next controller, else enter again*/
        if(textField.text == "1122"){
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            UIApplication.shared.keyWindow?.rootViewController = viewController;
           
        }else{
            let title = "Password Incorrect"
                   let alert = UIAlertController(title: title, message: "", preferredStyle:
                       UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "Try Again", style:
                       UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
