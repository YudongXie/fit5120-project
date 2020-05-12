//
//  QuestionViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 4/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,DatabaseListener {
    
    
    
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
    /*Set defaul questions*/
    let questionList = ["In last 24 hours, do you have at least 8 hours sleeping time?","Is your driving going to be less than 2 hours today?","You do not drink coffee before you start driving today?","Have you taken regular breaks at least every two hours today?","Is your journey less than 8 hours today?"]
    
    /*Set default question index*/
    var currentQuestionIndex = 0;
    
    var listenerType = ListenerType.all
    var allVar = [CheckList]()
    weak var databaseController: DatabaseProtocol?
    var tempValue = ""
    var answerVar = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        submitButton.layer.cornerRadius = 10
        submitButton.layer.borderWidth = 2
        submitButton.layer.borderColor = UIColor.white.cgColor
        /*Set the background image for table view*/
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "testBg4"))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        /*Set the nav color and font size*/
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LexendGiga-Regular", size: 12)!,.foregroundColor:UIColor.white]
        appearance.backgroundColor = UIColor.init(red: 89/255, green: 128/255, blue: 169/255, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    /*Next button action*/
    @IBAction func nextAction(_ sender: UIButton) {
        /* If the current question is the last one, then set the index to zero
         if the current question is the first one, then set the index to the last one
         */
        if(currentQuestionIndex == 4){
            currentQuestionIndex = 0
        }else{
            currentQuestionIndex += 1
        }
        questionLabel.text = questionList[currentQuestionIndex]
        
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
        
        /*Selected row is changed when the next button is clicked*/
        let indexPath = IndexPath(row: currentQuestionIndex, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        
        /* If the current question is the last one, then set the index to zero
         if the current question is the first one, then set the index to the last one
         */
        if(currentQuestionIndex == 0){
            currentQuestionIndex = 4
        }else{
            currentQuestionIndex -= 1
        }
        questionLabel.fadeTransition(0.9)
        questionLabel.text = questionList[currentQuestionIndex]
        
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
        
        /*Selected row is changed when the next button is clicked*/
        let indexPath = IndexPath(row: currentQuestionIndex, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
    }
    
    @IBAction func yesAction(_ sender: UIButton) {
        /*If the yes button is clicked, set yes button background image to checked and no button background image to unchecked*/
        noButton.setImage(UIImage(named:"red-icons8-unchecked-checkbox-50"), for: .normal)
        sender.setImage(UIImage(named:"green-icons8-checked-checkbox-50"), for: .normal)

        databaseController?.updateQuestion(checkList: allVar[0], questionChanged: true, order: currentQuestionIndex)

    }
    
    @IBAction func noAction(_ sender: UIButton) {
        /*If the no button is clicked, set no button background image to checked and yes button background image to unchecked*/
        yesButton.setImage(UIImage(named:"green-icons8-unchecked-checkbox-50"), for: .normal)
        sender.setImage(UIImage(named:"red-icons8-close-window-50"), for: .normal)
        
        databaseController?.updateQuestion(checkList: allVar[0], questionChanged: false, order: currentQuestionIndex)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        /*set all temp to the same when submit button is clicked*/
        databaseController?.update(checkList: allVar[0], questionOne: allVar[0].questionOne, questionTwo: allVar[0].questionTwo, questionThree: allVar[0].questionThree, questionFour: allVar[0].questionFour, questionFive: allVar[0].questionFive, fatigueLevel: allVar[0].fatigueLevel!, rating: Int(allVar[0].rating), weatherTemp: tempValue)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        /*Before the view appeared, set the default question index and text, also add the listenter for this view controller*/
        currentQuestionIndex = 0
        questionLabel.text = questionList[currentQuestionIndex]
        databaseController?.addListener(listener: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*If the view is appeared, set the default selected table cell*/
        let indexPath = IndexPath(row: currentQuestionIndex, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*Remove listener*/
        databaseController?.removeListener(listener: self)
        /*Set nav bar color and font size*/
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LexendGiga-Regular", size: 12)!,.foregroundColor:UIColor.white]
        appearance.backgroundColor = UIColor(red: 52/255, green: 71/255, blue: 102/255, alpha: 1)
        UINavigationBar.appearance().standardAppearance = appearance
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
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Get the current cell ID and set its text and color for each row*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        
        /*Cell text setting*/
        cell.textLabel!.text = questionList[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel!.font = UIFont(name:"LexendGiga-Regular", size:15)
        
        /*If the question answer is Yes, then set the checkmark for that speicial cell*/
        switch indexPath.row {
        case 0:
            if(allVar[0].questionOne == true){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            break;
        case 1:
            if(allVar[0].questionTwo == true){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            break;
        case 2:
            if(allVar[0].questionThree == true){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            break;
        case 3:
            if(allVar[0].questionFour == true){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            break;
        case 4:
            if(allVar[0].questionFive == true){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            break;
        default:
            break;
        }
        /*set text color for selected cell*/
        cell.textLabel?.highlightedTextColor = UIColor.black
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentQuestionIndex = indexPath.row
        
        /*Add the animation for question label*/
        questionLabel.fadeTransition(0.9)
        questionLabel.text = questionList[indexPath.row]
        
        switch indexPath.row {
            
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
    
    @IBAction func backToPreviousPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
