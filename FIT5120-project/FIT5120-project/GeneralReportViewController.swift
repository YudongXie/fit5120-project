//
//  GeneralReportViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 7/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class GeneralReportViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,DatabaseListener{
    
    
    
    
    
    @IBOutlet weak var conclusionLabel: UILabel!
    @IBOutlet weak var viewConclusionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    
    
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
    let yesArrayStr = ["you have enough sleeping time almost every day","you always drive less than two hours last week, It is good for your health","you avoid drink coffee before driving","you taken regular breaks during driving, you are a healthy driver","you try to avoid longtime driving"]
    let noArrayStr = ["you should get plenty of sleep before your drive, which is incredibly important for your health","you may fatigue driving. Please remember to find a place and have a rest every two hours","coffee has badly affected driving. You will experience serious lapses in concentration and slower reaction times","Long-time driving will cause fatigue and increase your risk of traffic accident. You should plan your rest stop","you much more likely to be fat and inactive than other people in their age group"]
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        
        datePicker.datePickerMode = .date
        
        /*Set table view delegate*/
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        /*Table View adds background image*/
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "testBg4"))
        
        /*View adds background image*/
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "testBg4")
        
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.secondView.insertSubview(backgroundImage, at: 0)
        
        /* resize the background image to fit in scroll view*/
        backgroundImage.anchor(top: secondView.topAnchor, left: secondView.leftAnchor, bottom: secondView.bottomAnchor, right: secondView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        /*Set the color and font of Nav bar*/
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LexendGiga-Regular", size: 12)!,.foregroundColor:UIColor.white]
        appearance.backgroundColor = UIColor.init(red: 89/255, green: 128/255, blue: 169/255, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance
        
    }
    
    func onCheckListChange(change: DatabaseChange, checkList: [CheckList]) {
        getLast7Days()
        /*Check the date whether exsits in LastSevenDays Array*/
        
        for index in checkList{
            if sevenDays.contains(index.time!){
                allVar.append(index)
            }
            if sevenDays.contains(index.time!) && (index.time != sevenDays[0]){
                noTodayArray.append(index)
            }
        }
        
        for index in allVar{
            existDays.append(index.time!)
        }
        
        let minDateStr = existDays[0]
        let maxDateStr = existDays[existDays.count-1]
        /*The date that in array is currently AEST timezone, therefore it is GMT+0:00*/
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let minDate = dateFormatter.date(from: minDateStr)!
        let maxDate = dateFormatter.date(from: maxDateStr)!
        
        /*Set the min/max date for datePicker*/
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        computeConclusion()
    }
    
    func computeConclusion(){
        /*For loop to count number of yes/no for each question in past 7 days*/
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
//        yesArray = [4,4,3,3,3]
//        noArray = [3,3,4,4,4]
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
            if(yesMoreThanFour >= 2){
                var yesMax = 0
                var checkObjectForYes = QuestionObject()
                for x in filterYes{
                    if(x.count > yesMax){
                        yesMax = x.count
                        yesStr_1 = yesArrayStr[x.index]
                        checkObjectForYes = x
                    }
                }
                
                for y in filterYes{
                    if(checkObjectForYes != y){
                        yesMax = y.count
                        yesStr_2 = yesArrayStr[y.index]
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
                    if(x.count > noMax){
                        noMax = x.count
                        noStr_1 = noArrayStr[x.index]
                        checkObjectForNo = x
                    }
                }
                
                for y in filterNo{
                    if(checkObjectForNo != y){
                        noMax = y.count
                        noStr_2 = noArrayStr[y.index]
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
    
    @IBAction func confirmButton(_ sender: UIButton) {
        /*The datePicker date is "UTC", so set the time zone to AEST*/
        dateFormatter.timeZone = TimeZone(abbreviation: "AEST")
        
        let somedateString = dateFormatter.string(from: datePicker.date)
        
        let indexOfDate = existDays.firstIndex(of: somedateString)
        if(indexOfDate != nil){
            let indexPath = IndexPath(row: indexOfDate!, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            
            let position = 205 * indexPath.row
           // scrollView.contentOffset = CGPoint(x: 0, y: position)
            scrollView.setContentOffset(CGPoint(x: 0, y: position), animated: true)
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
        
        /*Resize the table view height according to the content*/
        tableViewHeightConstarint.constant = tableView.contentSize.height
        
        /* Set default height = 0 */
        var height:CGFloat = 0
        /*For loop all subview of secondView
         If the subview is tableView or ImageView,
         the highe will not be counted (tableView height is dynamical, imageView is fixed (equal to secondView original height 2200)
         */
        for view in self.secondView.subviews {
            if(type(of:view) != UIImageView.self && type(of:view) != UITableView.self){
                height = height + view.bounds.size.height
            }
        }
        
        /*Add new tableView height + all subView height + 200(white space)*/
        secondViewHeight = tableView.contentSize.height + height + 300
        /* Dynamiclly set the height of secondView*/
        secondViewHeightConstraint.constant = secondViewHeight
        /*Get the table view current Y position*/
        tableViewPositionY = Double(tableView.frame.origin.y)
        
    }
    
    
    func getLast7Days()
    {
        /*Set the format of dates*/
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        
        /*Append last 8 existDays to array list*/
        for i in 0 ... 7 {
            let newdate = cal.date(byAdding: .day, value: -i, to: date)!
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
        /*Set nav bar color and font size*/
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LexendGiga-Regular", size: 12)!,.foregroundColor:UIColor.white]
        appearance.backgroundColor = UIColor(red: 52/255, green: 71/255, blue: 102/255, alpha: 1)
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVar.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*Get cell ID*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportViewCell", for: indexPath) as! ReportTableViewCell
        cell.dateLabel.text = allVar[indexPath.row].time
        
        /*Set the cell value*/
        if(allVar[indexPath.row].questionOne){
            cell.questionOneLabel.text = "Q1.Yes"
        }else{
            cell.questionOneLabel.text = "Q1.No"
        }
        
        if(allVar[indexPath.row].questionTwo){
            cell.questionTwoLabel.text = "Q2.Yes"
        }else{
            cell.questionTwoLabel.text = "Q2.No"
        }
        
        if(allVar[indexPath.row].questionThree){
            cell.questionThreeLabel.text = "Q3.Yes"
        }else{
            cell.questionThreeLabel.text = "Q3.No"
        }
        
        if(allVar[indexPath.row].questionFour){
            cell.questionFourLabel.text = "Q4.Yes"
        }else{
            cell.questionFourLabel.text = "Q4.No"
        }
        
        if(allVar[indexPath.row].questionFive){
            cell.questionFiveLabel.text = "Q5.Yes"
        }else{
            cell.questionFiveLabel.text = "Q5.No"
        }
        
        cell.levelLabel.text = "Fatigue Level: \(allVar[indexPath.row].fatigueLevel!)"
        cell.ratingLabel.text = "Rating: \(String(allVar[indexPath.row].rating)) ⭐"
        cell.tempLabel.text = "Temp: \(allVar[indexPath.row].weatherTemp!)"
        return cell
    }
    
    /*Set cell height*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
    
    
}
