//
//  GeneralReportViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 7/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class GeneralReportViewController: UIViewController,DatabaseListener{
    
    
    
    
    
    @IBOutlet weak var conclusionLabel: UILabel!
    @IBOutlet weak var viewConclusionButton: UIButton!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var fatigueLevelLabel: UILabel!
    @IBOutlet weak var Q1Label: UILabel!
    @IBOutlet weak var Q2Label: UILabel!
    @IBOutlet weak var Q3Label: UILabel!
    @IBOutlet weak var Q4Label: UILabel!
    @IBOutlet weak var Q5Label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var swipeView: UIView!
    
    
    
    var listenerType = ListenerType.all
    var allVar = [CheckList]()
    weak var databaseController: DatabaseProtocol?
    var sevenDays = [String]()
    var existDays = [String]()
    var noTodayArray = [CheckList]()
    var tableViewPositionY = 0.0
    var yesArray = [0,0,0,0,0]
    var noArray = [0,0,0,0,0]
    var secondViewHeight : CGFloat = 0.0
    var currentPage = 0
    
    let yesArrayStr = ["you have enough sleeping time almost every day","you always drive less than two hours last week, it is good for your health","you avoid drink coffee before driving","you taken regular breaks during driving, you are a healthy driver","you try to avoid longtime driving"]
    let noArrayStr = ["you should get plenty of sleep before your drive, which is incredibly important for your health","you may fatigue driving. Please remember to find a place and have a rest every two hours","coffee has badly affected driving. You will experience serious lapses in concentration and slower reaction times","Long-time driving will cause fatigue and increase your risk of traffic accident. You should plan your rest stop","you much more likely to be fat and inactive than other people in their age group"]

    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        datePicker.datePickerMode = .date
        
        /*Set default date format*/
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        /*Set the datepicker text color to white*/
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        
        /*Set confirmbutton and viewConclusionButton radius and border*/
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.borderColor = UIColor(red: 61/255, green: 133/255, blue: 227/255, alpha: 1).cgColor
        
        
        viewConclusionButton.layer.cornerRadius = 10
        viewConclusionButton.layer.borderWidth = 2
        viewConclusionButton.layer.borderColor = UIColor(red: 61/255, green: 133/255, blue: 227/255, alpha: 1).cgColor
        
        swipeView.layer.cornerRadius = 25.0
               swipeView.layer.shadowColor = UIColor.black.cgColor
               swipeView.layer.shadowOffset = CGSize(width: 0.0, height: 20)
               swipeView.layer.shadowRadius = 12.0
               swipeView.layer.shadowOpacity = 0.5

        
        /*View adds background image*/
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "testBg4")
        
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        /* resize the background image to fit in scroll view*/
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func onCheckListChange(change: DatabaseChange, checkList: [CheckList]) {
        getLast7Days()
        /*Check the date whether exsits in LastSevenDays Array*/
        
        allVar = []
        noTodayArray = []
        for index in checkList{
            if sevenDays.contains(index.time!){
                allVar.append(index)
            }
            if sevenDays.contains(index.time!) && (index.time != sevenDays[0]){
                noTodayArray.append(index)
            }
        }
        
        existDays = []
        for index in allVar{
            existDays.append(index.time!)
        }
        /*Set page control page number*/
        pageControl.numberOfPages = existDays.count
        
        let minDateStr = existDays[0]
        let maxDateStr = existDays[existDays.count-1]
        /*The date that in array is currently AEST timezone, therefore it is GMT+0:00*/
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let minDate = dateFormatter.date(from: minDateStr)!
        let maxDate = dateFormatter.date(from: maxDateStr)!
        
        /*Set the min/max date for datePicker*/
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        changeLabels(currentPage: currentPage)
        computeConclusion()
    }
    
    func computeConclusion(){
        /*For loop to count number of yes/no for each question in past 7 days*/
        yesArray = [0,0,0,0,0]
        noArray = [0,0,0,0,0]
        for index in noTodayArray{
            if(index.questionOne == true){
                yesArray[0]+=1
            }else{
                noArray[0]+=1
            }
            
            if(index.questionTwo == true){
                yesArray[1]+=1
            }else{
                noArray[1]+=1
            }
            
            if(index.questionThree == true){
                yesArray[2]+=1
            }else{
                noArray[2]+=1
            }
            
            if(index.questionFour == true){
                yesArray[3]+=1
            }else{
                noArray[3]+=1
            }
            
            if(index.questionFive == true){
                yesArray[4]+=1
            }else{
                noArray[4]+=1
            }
        }
        
        /*Init variable for yes*/
        var yesMoreThanFour = 0
        var filterYes = [QuestionObject]()
        if(yesArray[0] + noArray[0] == 7){
            /*Find the count is more than or equal to 4 and append to filterYes Array*/
            for i in 0..<yesArray.count{
                if(yesArray[i] >= 4){
                    yesMoreThanFour+=1
                    let object = QuestionObject()
                    object.count = yesArray[i]
                    object.index = i
                    filterYes.append(object)
                }
            }
            
            /*Init variable for no*/
            var noValueCount = 0
            var filterNo = [QuestionObject]()

            
            /*Count for no */
            for i in 0..<noArray.count{
                if(noArray[i] >= 1){
                    noValueCount+=1
                    let object = QuestionObject()
                    object.count = noArray[i]
                    object.index = i
                    filterNo.append(object)
                }
            }
            
            var yesStr_1 = ""
            var yesStr_2 = ""

            /*Find highest count number and set output string*/
            var checkObjectForYesOne = QuestionObject()
            var checkObjectForYesTwo = QuestionObject()
            if(yesMoreThanFour >= 2){
                var yesMax = 0
                for x in filterYes{
                    if(x.count > yesMax){
                        yesMax = x.count
                        yesStr_1 = yesArrayStr[x.index]
                        checkObjectForYesOne = x
                    }
                }
                
                yesMax = 0
                for y in filterYes{
                    if(checkObjectForYesOne != y){
                        if(y.count > yesMax){
                            yesMax = y.count
                            yesStr_2 = yesArrayStr[y.index]
                            checkObjectForYesTwo = y
                        }
                    }
                }
            }else if(yesMoreThanFour == 1){
                let arrayIndex = filterYes[0].index
                yesStr_1 = yesArrayStr[arrayIndex]
            }
            
            var noStr_1 = ""
            var noStr_2 = ""
            
            /*Find highest count number and set output string*/
            if(noValueCount >= 2){
                var noMax = 0
                var checkObjectForNo = QuestionObject()
                for x in filterNo{
                    if(x.count > noMax && x.index != checkObjectForYesOne.index && x.index != checkObjectForYesTwo.index){
                        noMax = x.count
                        noStr_1 = noArrayStr[x.index]
                        checkObjectForNo = x
                    }
                }
                
                noMax = 0
                for y in filterNo{
                    if(checkObjectForNo != y){
                        if(y.count > noMax && y.index != checkObjectForYesOne.index && y.index != checkObjectForYesTwo.index){
                            noMax = y.count
                            noStr_2 = noArrayStr[y.index]
                        }
                    }
                }
            }else if(noValueCount == 1){
                let arrayIndex = filterNo[0].index
                noStr_1 = noArrayStr[arrayIndex]
            }
            
            /*Set output string to label text*/
            if(yesMoreThanFour >= 2 && noValueCount >= 2){
                conclusionLabel.text = "In last seven days, \(yesStr_1) and \(yesStr_2).But \(noStr_1) and also we think \(noStr_2)."
            }else if(yesMoreThanFour >= 2 && noValueCount == 1){
                conclusionLabel.text = "In last seven days, you did a good job in reduce your driving fatigue, \(yesStr_1) and \(yesStr_2).But we found \(noStr_1)."
            }else if(yesMoreThanFour >= 2 && noValueCount == 0){
                conclusionLabel.text = "In last seven days, you met the requirement of healthy driving. Please keep doing."
            }else if(yesMoreThanFour == 1 && noValueCount >= 2){
                conclusionLabel.text = "In last seven days, we found \(yesStr_1). But \(noStr_1) and, we think \(noStr_2). You may have high risk of fatigue driving."
            }else if(yesMoreThanFour == 0 && noValueCount >= 1){
                conclusionLabel.text = "In last seven days,  you had high risk of fatigue driving. We suggest you pay more attention on your health."
            }
        }else{
            conclusionLabel.text = "We are unable to give you a report conclusion because it needs continuous 7 days records"
        }
        
    }
    
    /*Swipe right and change page control*/
    @IBAction func swipeActionRight(_ sender: UISwipeGestureRecognizer) {
        if(currentPage == existDays.count - 1){
            currentPage = 0
        }else{
            currentPage += 1
        }
        changeLabels(currentPage: currentPage)
        pageControl.currentPage = currentPage
    }
    
    /*Swipe left and change page control*/
    @IBAction func swipeActionLeft(_ sender: UISwipeGestureRecognizer) {
        if(currentPage == 0){
            currentPage = existDays.count-1
        }else{
            currentPage -= 1
        }
        changeLabels(currentPage: currentPage)
        pageControl.currentPage = currentPage
    }
    
    /*Page Control changed*/
    @IBAction func pageControl(_ sender: UIPageControl) {
        currentPage = sender.currentPage
        changeLabels(currentPage: currentPage)
    }
    
    /*Function for set text*/
    func changeLabels(currentPage: Int){
       
        /*Animation for labels*/
        dateLabel.fadeTransition(0.7)
        fatigueLevelLabel.fadeTransition(0.7)
        ratingLabel.fadeTransition(0.7)
        Q1Label.fadeTransition(0.7)
        Q2Label.fadeTransition(0.7)
        Q3Label.fadeTransition(0.7)
        Q4Label.fadeTransition(0.7)
        Q5Label.fadeTransition(0.7)
        
         /*Change format of date*/
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: allVar[currentPage].time!)
        dateFormatter.dateFormat = "MMM-dd-YYYY"
        let goodDate = dateFormatter.string(from: date!)
        
        dateLabel.text = goodDate
        ratingLabel.text = "Rating: \(String(allVar[currentPage].rating))/5"
        fatigueLevelLabel.text = "Fatigue Level:  \(allVar[currentPage].fatigueLevel!)"
        if(allVar[currentPage].questionOne){
            Q1Label.text = "Q1.Yes"
        }else{
            Q1Label.text = "Q1.No"
        }
        
        if(allVar[currentPage].questionTwo){
            Q2Label.text = "Q2.Yes"
        }else{
            Q2Label.text = "Q2.No"
        }
        
        if(allVar[currentPage].questionThree){
            Q3Label.text = "Q3.Yes"
        }else{
            Q3Label.text = "Q3.No"
        }
        
        if(allVar[currentPage].questionFour){
            Q4Label.text = "Q4.Yes"
        }else{
            Q4Label.text = "Q4.No"
        }
        
        if(allVar[currentPage].questionFive){
            Q5Label.text = "Q5.Yes"
        }else{
            Q5Label.text = "Q5.No"
        }
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        /*The datePicker date is "UTC", so set the time zone to AEST*/
        dateFormatter.timeZone = TimeZone(abbreviation: "AEST")
        
        let somedateString = dateFormatter.string(from: datePicker.date)
        
        let indexOfDate = existDays.firstIndex(of: somedateString)
        if(indexOfDate != nil){
            currentPage = indexOfDate!
            changeLabels(currentPage: currentPage)
            pageControl.currentPage = currentPage
        }else{
            /*Pop up window for no date found in table*/
            let title = "No this date found!"
            let message = ""
            let alert = UIAlertController(title: title, message: message, preferredStyle:
                UIAlertController.Style.alert)
            let OKAction = UIAlertAction(title: "Got It!", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func viewConclusion(_ sender: UIButton) {
        /*Scroll to bottom*/
        let bottomOffset = CGPoint(x: 0, y:scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        /* Set default height = 0 */
        var height:CGFloat = 0
        /*For loop all subview of secondView
         If the subview is tableView or ImageView,
         the highe will not be counted (tableView height is dynamical, imageView is fixed (equal to secondView original height 2200)
         */
        for view in self.secondView.subviews {
            if(type(of:view) != UIImageView.self){
                height = height + view.bounds.size.height
            }
        }
        
        /*Add new tableView height + all subView height + 200(white space)*/
        secondViewHeight = height + 300
        /* Dynamiclly set the height of secondView*/
        secondViewHeightConstraint.constant = secondViewHeight
        
    }
    
    
    func getLast7Days()
    {
        /*Set the format of dates*/
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())

        /*Append last 8 existDays to array list*/
        for i in 0 ... 7 {
            
            let newdate = cal.date(byAdding: .day, value: -i, to: date)!
            /*Keep the date format as AEST*/
            dateFormatter.timeZone = TimeZone(abbreviation: "AEST")
            let str = dateFormatter.string(from: newdate)
            sevenDays.append(str)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*Before the view appeared, set the default question index and text, also add the listenter for this view controller*/
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    
    }
    
    
    
}
