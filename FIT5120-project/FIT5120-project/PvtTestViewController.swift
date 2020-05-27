//
//  PvtTestViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 7/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

protocol getDataDelegate{
    func itemDownloaded(resultJson:[TestResultJson])
}


class PvtTestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,DatabaseListener{
    
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var Test: UIButton!
    @IBOutlet weak var displayedTime: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastTestLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tapMeLabel: UILabel!
    
    
    var listenerType = ListenerType.all
    var allVar = [CheckList]()
    weak var databaseController: DatabaseProtocol?
    var timeArray = [String]()
    var responseArray = [Double]()
    var randomTimeArray = [Int]()
    var second = 90
    var displayedSecond = 0.0
    var progressBarTimer: Timer!
    var GameTimer: Timer!
    var displayTimer : Timer!
    var count = 0
    var gameStarted = false
    var randomNumber = 0
    var secondString = ""
    var earlyClick = 0
    var startTime = 0.0
    var resultArray = [TestResultJson]()
    var resultComments = ""
    var resultRating = 0
    var resultLevel = ""
    var resultImage : Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        /*Set background image for nav bar*/
        let img = UIImage(named: "testBg4")
        navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        
        /*set background image for view*/
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "testBg4"))
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "testBg4")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        /*Fir image background for view*/
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        /*Set Test button radius and border width */
        Test.layer.cornerRadius = 15
        Test.layer.borderWidth = 2
        Test.layer.borderColor = UIColor.white.cgColor
        Test.layer.cornerRadius = 0.5 * Test.bounds.size.width
        Test.clipsToBounds = true
        /*Set Test button background color*/
        Test.backgroundColor = UIColor(red: 97/255, green: 204/255, blue: 200/255, alpha: 0.1)
        
        /*Set Start color for different states*/
        Start.setTitleColor(UIColor.white, for: .normal)
        Start.setTitleColor(UIColor.gray, for: .disabled)
        Start.setImage(UIImage(named:"icons8-in-progress-48"), for: .disabled)
        Start.setTitle("Running", for: .disabled)
        tableView.delegate = self
        tableView.dataSource = self
        Test.isEnabled = false
        displayedTime.layer.zPosition = 1
        tapMeLabel.layer.zPosition = 1
        tapMeLabel.isHidden = true

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*Add listener*/
        databaseController?.addListener(listener: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        /*Set enable for test button*/
        if(GameTimer == nil && displayTimer == nil && progressBarTimer == nil){
            Test.isEnabled = false
        }else{
            Test.isEnabled = true
        }
        displayedTime.layer.zPosition = 1
        Start.pluse()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var window : UIWindow
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        if let tabBarController = self.view.window!.rootViewController as? UITabBarController {
            /*Change the selected index to the one you want (starts from 0)*/
            tabBarController.selectedIndex = 0
        }
        
    }
    
    func onCheckListChange(change: DatabaseChange, checkList: [CheckList]) {
        /*Change date format*/
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: date)
        /*Append value from checkList to a new array*/
        allVar = []
        for index in checkList{
            if(index.time == currentDate){
                allVar.append(index)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*Set value for cells*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel!.text = timeArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
        return cell
    }
    
    
    @IBAction func startGame(_ sender: UIButton) {
        Start.imageEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0);
        Start.titleEdgeInsets = UIEdgeInsets(top: 45, left: -47, bottom: 0, right: 0);
        /*Clear table view cell*/
        responseArray = []
        randomTimeArray = []
        timeArray = []
        tableView.reloadData()
        /*Reset progress bar progress*/
        progressView.progress = 0
        /*Reset display time text to "waiting"*/
        displayedTime.text = "waiting."
        /*Set progressbar updated every second*/
        self.progressBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
        Start.isEnabled = false
        /*First game started*/
        randomNumber = Int.random(in: 4...6)
        self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
        Test.isEnabled = true

        
    }
    
    
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToPreviousPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func displayMsecond(){
        displayedSecond = Date().timeIntervalSinceReferenceDate - startTime
        
        secondString = String(format: "%.2f", displayedSecond)
        
        self.displayedTime.text = "\(secondString) S"
        tapMeLabel.isHidden = false
        
        /*Not click after 30s then reset*/
        if(Double(secondString) == 30){

            timeLeft.text = "Test finished due to 30s time out."
            displayedTime.text = ""
            tapMeLabel.isHidden = true
            Start.isEnabled = true
            Test.isEnabled = false
            progressBarTimer.invalidate()
            GameTimer.invalidate()
            displayTimer.invalidate()
            secondString = ""
            displayedSecond = 0.0
            second = 90
            earlyClick = 0
            count = 0
            Test.backgroundColor = UIColor(red: 97/255, green: 204/255, blue: 200/255, alpha: 0.1)
            Start.imageEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0);
        }
    }
    
    @objc func startMSTimer(){
        /*When MS time is displaying , enable to click*/
        Test.isEnabled = true
        startTime = Date().timeIntervalSinceReferenceDate
        /*Set displayed time timer*/
        self.displayTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.displayMsecond), userInfo: nil, repeats: true)
    }
    
    @objc func noBorder(){
        let opacity:CGFloat = 0
        let borderColor = UIColor.white
        Test.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
    }

    @objc func border(){
        let opacity:CGFloat = 1
        let borderColor = UIColor.white
        Test.layer.borderColor = borderColor.withAlphaComponent(opacity).cgColor
    }

    
    @IBAction func oneClick(_ sender: Any) {
        count+=1
        
        /*If it is early Click ,count number and reset timing*/
        if(displayedSecond == 0.0){
            earlyClick += 1
            GameTimer.invalidate()
            displayedSecond = 0.0
            if(displayTimer != nil){
                displayTimer.invalidate()
            }
            
            randomNumber = Int.random(in: 4...6)
            displayedTime.text = "waiting."
            tapMeLabel.isHidden = true
            
            self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
            lastTestLabel.isHidden = false
            lastTestLabel.text = "Early touch will restart the current test."
        }else{
            /*Append time to arrayList*/
            displayTimer.invalidate()
            let time = String(format: "%.2f", displayedSecond)
            
            /*Apeend string to table*/
            switch count {
            case 1:
                timeArray.append("The \(count)st test: " + time + " S .")
                responseArray.append(Double(time)!)
            case 2:
                timeArray.append("The \(count)nd test: " + time + " S .")
                responseArray.append(Double(time)!)
            case 3:
                timeArray.append("The \(count)rd test: " + time + " S .")
                responseArray.append(Double(time)!)
                
            default:
                timeArray.append("The \(count)th test: " + time + " S .")
                responseArray.append(Double(time)!)
            }
            
            /*append random number to array ,
             make sure button is clicked and append
             */
            randomTimeArray.append(randomNumber)
            lastTestLabel.isHidden = false
            lastTestLabel.fadeTransition(0.5)
            lastTestLabel.text = "Last Response Time was \(time) S."
            
            /*Refresh tableView Cell*/
            tableView.reloadData()
            
            /*Set displayedSecond to 0*/
            displayedSecond = 0.0
            /*Random second before display MS*/
            randomNumber = Int.random(in: 4...6)
            displayedTime.text = "waiting."
            tapMeLabel.isHidden = true
            self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
        }
        
        
    }
    
    
    @objc func updateProgressView(){
        /*Updating progress bar*/
        progressView.progress += 1/90;
        second = second - 1;
        timeLeft.fadeTransition(0.7)
        timeLeft.text = String(second);
        
        /*If second == 0 then test finished and reset all things*/
        if(second == 0){
            timeLeft.text = "Test finished."
            displayedSecond = 0.0
            displayedTime.text = ""
            tapMeLabel.isHidden = true
            Start.isEnabled = true
            Test.isEnabled = false
            progressBarTimer.invalidate()
            GameTimer.invalidate()
            //Check whether always early click
            if(displayTimer != nil){
                displayTimer.invalidate()
            }
            second = 90
            count = 0
            earlyClick = 0
            Test.backgroundColor = UIColor(red: 97/255, green: 204/255, blue: 200/255, alpha: 0.1)
            if(responseArray.count != 0){
                postJson()
            }
            else{
                /*No any clicks then restart test*/
                let title = "Warning"
                let message = "No any clicks, please re-start test."
                let alert = UIAlertController(title: title, message: message, preferredStyle:
                    UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style:
                    UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            Start.imageEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0);
        }
        
        
    }
    
    func postJson(){
        /* prepare json data*/
        let json: [String : Any] = ["reaction_times":responseArray,"test_times":randomTimeArray,"false_clicks":earlyClick]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json,options: [])
        
        let jsonData2 = try? JSONSerialization.data(withJSONObject: json,options: [])
        /* create post request*/
        let url = URL(string: "https://fit5120.herokuapp.com/pvt_data/summary")!
        let url2 = URL(string: "https://fit5120.herokuapp.com/pvt_data/chart")!

        var request = URLRequest(url: url)
        var request2 = URLRequest(url: url2)
        
        request.httpMethod = "POST"
        request2.httpMethod = "POST"
        
        /*send the jsonData using json type
         */
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
        /*insert json data to the request*/
        request.httpBody = jsonData
        request2.httpBody = jsonData2
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.resultComments = responseJSON["comment"]! as! String
                self.resultRating = responseJSON["rating"]! as! Int
                self.resultLevel = responseJSON["fatigue_level"]! as! String
                DispatchQueue.main.async{
                    for index in self.allVar{
                        self.databaseController?.updatePvtResultToCoredata(checkList: index, fatigueLevel: self.resultLevel, rating: self.resultRating)
                    }
                }

            }
        }
        
        task.resume()
        
        let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            self.resultImage = data
            DispatchQueue.main.async {
                    self.dismiss(animated: false) { () -> Void in
                        /*Report pop up window and able to render to another view*/
                        let title = "Reaction test teport generated!"
                        let message = ""
                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "Report", style: UIAlertAction.Style.default, handler: {
                            (_)in
                            self.performSegue(withIdentifier: "ReactionResultSegue", sender: self)
                        })
                        alert.addAction(OKAction)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
            }
        }
        task2.resume()
        /*Pop up window*/
        let title = "Generating a report..."
        let message = "Please wait for few seconds..."
        let alert = UIAlertController(title: title, message: "", preferredStyle:
            UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*Unwind segue pass data*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ReactionResultSegue"){
            if let nextViewController = segue.destination as? ReactionResultViewController {
                /*Pass value to next view*/
                nextViewController.comment = self.resultComments
                nextViewController.rating = Double(self.resultRating)
                nextViewController.fatigue_level = self.resultLevel
                nextViewController.imageResult = self.resultImage
            }
        }
        
        
    }
    
}


extension UIView{
    /*Pluse animation*/
    func pluse(){
        let pluse = CASpringAnimation(keyPath: "transform.scale")
        pluse.duration = 0.7
        pluse.fromValue = 0.85
        pluse.toValue = 1.0
        pluse.repeatCount = 100000
        pluse.autoreverses = true
        pluse.initialVelocity = 0.7
        pluse.damping = 1.0
        self.layer.add(pluse,forKey:nil)
    }
}
