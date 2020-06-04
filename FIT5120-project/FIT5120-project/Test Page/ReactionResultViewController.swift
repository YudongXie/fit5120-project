//
//  ReactionResultViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 20/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

/*This file is for reaction result
 func backHome(): redirect the page to home screen
 func backToPreviousPage(): redirect the page to previous one
 */
import UIKit

class ReactionResultViewController: UIViewController,UIScrollViewDelegate{

    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet var imageViewArray: [UIImageView]!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var firstScrollView: UIScrollView!
    
    
    var rating = 0.0
    var comment = ""
    var fatigue_level = ""
    var imageResult : Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Set the background image and fit it to screen*/
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "testBg4")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        /* Resize the background image to fit in scroll view*/
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    }

    override func viewWillAppear(_ animated: Bool) {
        /*Set value */
        commentLabel.text = comment
        levelLabel.text = fatigue_level
        imageView.image = UIImage(data:imageResult)
        /*Set star for rating*/
        if (rating - floor(rating) > 0.000001) {
            for index in 0..<imageViewArray.count{
                if(index <= Int(floor(rating)) - 1){
                    imageViewArray[index].image = UIImage(named:"star1")
                }
                else if(index == Int(floor(rating)) ){
                    imageViewArray[index].image = UIImage(named:"halfStar")
                }else{
                    print(index)
                    imageViewArray[index].image = UIImage(named:"emptyStar")
                }
            }
        }
        else{
                
            for index in 0..<imageViewArray.count{
                if(index < Int(rating)){
                    imageViewArray[index].image = UIImage(named:"star1")
                }else{
                    imageViewArray[index].image = UIImage(named:"emptyStar")
                }
            }
        
        }
    }
    
    
    @IBAction func backHome(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToPreviousPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
