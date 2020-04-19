//
//  ReactionResultViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 20/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class ReactionResultViewController: UIViewController {

    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet var imageViewArray: [UIImageView]!
    
    
    var rating = 0.0
    var comment = ""
    var fatigue_level = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the background image and fit it to screen
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homeBg3")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        commentLabel.text = comment
        levelLabel.text = fatigue_level
        rating = 4.5
        if (rating - floor(rating) > 0.000001) {
            print(rating)
            
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
            
            
//            switch rating {
//            case 1:
//                image1.image = UIImage(named:"star1")
//                image2.image = UIImage(named:"emptyStar")
//                image3.image = UIImage(named:"emptyStar")
//                image4.image = UIImage(named:"emptyStar")
//                image5.image = UIImage(named:"emptyStar")
//            case 2:
//                image1.image = UIImage(named:"star1")
//                image2.image = UIImage(named:"star1")
//                image3.image = UIImage(named:"emptyStar")
//                image4.image = UIImage(named:"emptyStar")
//                image5.image = UIImage(named:"emptyStar")
//            case 3:
//                image1.image = UIImage(named:"star1")
//                image2.image = UIImage(named:"star1")
//                image3.image = UIImage(named:"star1")
//                image4.image = UIImage(named:"emptyStar")
//                image5.image = UIImage(named:"emptyStar")
//            case 4:
//                image1.image = UIImage(named:"star1")
//                image2.image = UIImage(named:"star1")
//                image3.image = UIImage(named:"star1")
//                image4.image = UIImage(named:"star1")
//                image5.image = UIImage(named:"emptyStar")
//            case 5:
//                image1.image = UIImage(named:"star1")
//                image2.image = UIImage(named:"star1")
//                image3.image = UIImage(named:"star1")
//                image4.image = UIImage(named:"star1")
//                image5.image = UIImage(named:"star1")
//            default:
//                break;
//            }
        }
    }
    
    

}
