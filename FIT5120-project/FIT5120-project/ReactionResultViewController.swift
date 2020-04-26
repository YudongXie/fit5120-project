//
//  ReactionResultViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 20/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class ReactionResultViewController: UIViewController,UIScrollViewDelegate{

    
//    @IBOutlet weak var image1: UIImageView!
//    @IBOutlet weak var image2: UIImageView!
//    @IBOutlet weak var image3: UIImageView!
//    @IBOutlet weak var image4: UIImageView!
//    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet var imageViewArray: [UIImageView]!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var firstScrollView: UIScrollView!
    
    
    var rating = 0.0
    var comment = ""
    var fatigue_level = ""
    var imageResult : Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.delegate = self
        //Set the background image and fit it to screen
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homeBg3")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.contentView.insertSubview(backgroundImage, at: 0)
        
        /* resize the background image to fit in scroll view*/
        backgroundImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        imageScrollView.minimumZoomScale = 1
        imageScrollView.maximumZoomScale = 5

    }
    
    func viewForZooming(in imageScrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(imageResult)
        commentLabel.text = comment
        levelLabel.text = fatigue_level
        imageView.image = UIImage(data:imageResult)
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
        
//        image1.image = UIImage(named:"logo")
//        image4.image = UIImage(named:"logo1")
    }
    
    
    @IBAction func backHome(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    

}
