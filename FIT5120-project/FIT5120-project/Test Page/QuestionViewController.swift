//
//  QuestionViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 4/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

/*This file is for Questionanires page
 func changeQuestion(): change the displayed questions
 func viewWillLayoutSubviews(): resize the content view
 func swipeLeft(): swipe questions
 func swipeRight(): swipe questions
 func yesAction(): yes action for questions
 func noAction(): no action for questions
 func backToPrevious(): redirect page to previous one
 func pageControl(): function for pageControl
 func submitAction(): submit question
 */

import UIKit

class QuestionViewController: UIViewController,DatabaseListener {
    

    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    /*Set defaul questions*/
    let questionList = ["In last 24 hours, do you have at least 8 hours sleeping time?","Is your driving going to be less than 2 hours today?","You do not drink coffee before you start driving today?","Have you taken regular breaks at least every two hours today?","Is your journey less than 8 hours today?"]
    
    /*Set default question index*/
    var currentQuestionIndex = 0
    var listenerType = ListenerType.all
    var allVar = [CheckList]()
    weak var databaseController: DatabaseProtocol?
    var tempValue = ""
    var answerVar = [Bool]()
    var secondViewHeight : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        submitButton.layer.cornerRadius = 10
        submitButton.layer.borderWidth = 2
        submitButton.layer.borderColor = UIColor(red: 61/255, green: 133/255, blue: 227/255, alpha: 1).cgColor

        cardView.layer.cornerRadius = 25.0
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 20)
        cardView.layer.shadowRadius = 12.0
        cardView.layer.shadowOpacity = 0.5
        
        
        /*Set the background image and fit it to screen*/
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "testBg4")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        /* Resize the background image to fit in scroll view*/
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        var height:CGFloat = 0
        for view in self.secondView.subviews {
            if(type(of:view) != UIImageView.self && type(of:view) != UITableView.self){
                height = height + view.bounds.size.height
            }
        }
        
        secondViewHeight = height + 300
        /* Dynamiclly set the height of secondView*/
        secondViewHeightConstraint.constant = secondViewHeight
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if(currentQuestionIndex == 0){
            currentQuestionIndex = 4
        }else{
            currentQuestionIndex -= 1
        }
        changeQuestion(currentIndex: currentQuestionIndex)
    }
    
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if(currentQuestionIndex == 4){
            currentQuestionIndex = 0
        }else{
            currentQuestionIndex += 1
        }
        changeQuestion(currentIndex: currentQuestionIndex)
    }
    
    
    @IBAction func yesAction(_ sender: UIButton) {
        /*If the yes button is clicked, set yes button background image to checked and no button background image to unchecked*/
        noButton.setImage(UIImage(named:"red-icons8-unchecked-checkbox-50"), for: .normal)
        sender.setImage(UIImage(named:"green-icons8-checked-checkbox-50"), for: .normal)
        
        databaseController?.updateQuestion(checkList: allVar[0], questionChanged: true, order: currentQuestionIndex)
        
        if(currentQuestionIndex < 4){
            currentQuestionIndex += 1
        }else if(currentQuestionIndex == 4){
            /*Scroll to bottom*/
            let bottomOffset = CGPoint(x: 0, y:scrollView.contentSize.height - scrollView.bounds.size.height)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
        
        questionLabel.fadeTransition(0.9)
        changeQuestion(currentIndex: currentQuestionIndex)
    }
    
    @IBAction func backToPrevious(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pageControl(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        changeQuestion(currentIndex: currentPage)
    }
    
    
    @IBAction func noAction(_ sender: UIButton) {
        /*If the no button is clicked, set no button background image to checked and yes button background image to unchecked*/
        yesButton.setImage(UIImage(named:"green-icons8-unchecked-checkbox-50"), for: .normal)
        sender.setImage(UIImage(named:"red-icons8-close-window-50"), for: .normal)
        
        databaseController?.updateQuestion(checkList: allVar[0], questionChanged: false, order: currentQuestionIndex)
        
        if(currentQuestionIndex < 4){
            currentQuestionIndex += 1
        }else if(currentQuestionIndex == 4){
            /*Scroll to bottom*/
            let bottomOffset = CGPoint(x: 0, y:scrollView.contentSize.height - scrollView.bounds.size.height)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
        
        questionLabel.fadeTransition(0.9)
        changeQuestion(currentIndex: currentQuestionIndex)
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        /*set all temp to the same when submit button is clicked*/
        databaseController?.update(checkList: allVar[0], questionOne: allVar[0].questionOne, questionTwo: allVar[0].questionTwo, questionThree: allVar[0].questionThree, questionFour: allVar[0].questionFour, questionFive: allVar[0].questionFive, fatigueLevel: allVar[0].fatigueLevel!, rating: Int(allVar[0].rating), weatherTemp: tempValue)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeQuestion(currentIndex: Int){
        /*set page index*/
        pageControl.currentPage = currentQuestionIndex
        questionLabel.text = "Question \(currentQuestionIndex+1): \n \(questionList[currentQuestionIndex])"
        /*getting the BOOL value from coredata, and set it to check or uncheck image for buttons*/
        switch currentQuestionIndex {
        case 0:
            if(allVar[0].questionOne == true){
                noButton.setImage(UIImage(named:"red-icons8-unchecked-checkbox-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-checked-checkbox-50"), for: .normal)
            }else{
                noButton.setImage(UIImage(named:"red-icons8-close-window-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-unchecked-checkbox-50"), for: .normal)
            }
            break;
        case 1:
            if(allVar[0].questionTwo == true){
                noButton.setImage(UIImage(named:"red-icons8-unchecked-checkbox-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-checked-checkbox-50"), for: .normal)
            }else{
                noButton.setImage(UIImage(named:"red-icons8-close-window-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-unchecked-checkbox-50"), for: .normal)
            }
            break;
        case 2:
            if(allVar[0].questionThree == true){
                noButton.setImage(UIImage(named:"red-icons8-unchecked-checkbox-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-checked-checkbox-50"), for: .normal)
            }else{
                noButton.setImage(UIImage(named:"red-icons8-close-window-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-unchecked-checkbox-50"), for: .normal)
            }
            break;
        case 3:
            if(allVar[0].questionFour == true){
                noButton.setImage(UIImage(named:"red-icons8-unchecked-checkbox-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-checked-checkbox-50"), for: .normal)
            }else{
                noButton.setImage(UIImage(named:"red-icons8-close-window-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-unchecked-checkbox-50"), for: .normal)
            }
            break;
        case 4:
            if(allVar[0].questionFive == true){
                noButton.setImage(UIImage(named:"red-icons8-unchecked-checkbox-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-checked-checkbox-50"), for: .normal)
            }else{
                noButton.setImage(UIImage(named:"red-icons8-close-window-50"), for: .normal)
                yesButton.setImage(UIImage(named:"green-icons8-unchecked-checkbox-50"), for: .normal)
            }
            break;
        default:
            break;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /* add the listenter for this view controller*/
        currentQuestionIndex = 0
        databaseController?.addListener(listener: self)
        changeQuestion(currentIndex: currentQuestionIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*Remove listener*/
        databaseController?.removeListener(listener: self)
    }
    
    func onCheckListChange(change: DatabaseChange, checkList: [CheckList]) {
        /*Get the array from coredata and pass it to current view array, format date*/
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: date)
        allVar = []
        for index in checkList{
            if(index.time == currentDate){
                allVar.append(index)
            }
        }
    }
    
    
    
    
}
