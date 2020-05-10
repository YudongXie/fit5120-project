//
//  GeneralReportViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 7/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class GeneralReportViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,DatabaseListener{
    
    
    
    
    
    
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
    let dateFormatter = DateFormatter()
    var tableViewPositionY = 0.0
    
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
        
        /*Set confirmbutton radius and border*/
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.borderColor = UIColor.white.cgColor
        
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
            scrollView.contentOffset = CGPoint(x: 0, y: position)
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
        let secondViewHeight = tableView.contentSize.height + height + 300
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
