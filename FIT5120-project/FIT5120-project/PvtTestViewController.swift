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


class PvtTestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var Test: UIButton!
    @IBOutlet weak var displayedTime: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastTestLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var timeArray = [String]()
    var responseArray = [Double]()
    var randomTimeArray = [Int]()
    var second = 180
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
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "WechatIMG8981")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.contentView.insertSubview(backgroundImage, at: 0)
        
        backgroundImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        Test.layer.cornerRadius = 15
        Test.layer.borderWidth = 2
        
        Start.setTitleColor(UIColor.white, for: .normal)
        Start.setTitleColor(UIColor.gray, for: .disabled)
        Start.setImage(UIImage(named:"icons8-in-progress-48"), for: .disabled)
        Start.setTitle("Running", for: .disabled)
        //Start.alignVertical()
        let title = "Test Rule"
        let message = "1.Total Test Time : 3 mintues\n 2.Failed if click before color changed\n 3.Each click will be recorded\n 4.No click within 30s, test will be finished\n 5.Click 'Start' to start test"
        let alert = UIAlertController(title: title, message: message, preferredStyle:
            UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableView.delegate = self
        tableView.dataSource = self
        Test.isEnabled = false
        displayedTime.layer.zPosition = 1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // self.viewDidLoad()

        let title = "Test Rule"
        let message = "1.Total Test Time : 3 mintues\n 2.Failed if click before color changed\n 3.Each click will be recorded\n 4.No click within 30s, test will be finished\n 5.Click 'Start' to start test"
        let alert = UIAlertController(title: title, message: message, preferredStyle:
            UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableView.delegate = self
        tableView.dataSource = self

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
        if let tabBarController = self.view.window!.rootViewController as? UITabBarController {
            //Change the selected index to the one you want (starts from 0)
            tabBarController.selectedIndex = 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        cell.textLabel!.text = timeArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    
    @IBAction func startGame(_ sender: UIButton) {
        //        Start.pluse()
       // Start.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0);
        Start.imageEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0);
        Start.titleEdgeInsets = UIEdgeInsets(top: 45, left: -47, bottom: 0, right: 0);
        //Clear table view cell
        responseArray = []
        randomTimeArray = []
        timeArray = []
        tableView.reloadData()
        //Reset progress bar progress
        progressView.progress = 0
        //Reset display time text to "MS"
        displayedTime.text = "Waiting..."
        //Set progressbar updated every second
        self.progressBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
        Start.isEnabled = false
        //First game started
        randomNumber = Int.random(in: 5...10)
        print("random number \(randomNumber)")
        Test.backgroundColor = UIColor.red
        self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
        Test.isEnabled = true
        
    }
    
    @objc func displayMsecond(){
        displayedSecond = Date().timeIntervalSinceReferenceDate - startTime
        
        secondString = String(format: "%.2f", displayedSecond)
        
        self.displayedTime.text = "\(secondString) S"
        //    print(secondString)
        //        print(" - \(Double(secondString))")
        
        //Not click after 30s
        if(Double(secondString) == 30){
            timeLeft.text = "Test Finished due to 30s time out"
            displayedTime.text = ""
            Start.isEnabled = true
            Test.isEnabled = false
            progressBarTimer.invalidate()
            GameTimer.invalidate()
            displayTimer.invalidate()
            secondString = ""
            displayedSecond = 0.0
            second = 180
            earlyClick = 0
            count = 0
            Test.backgroundColor = UIColor.gray
            Start.imageEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0);
        }
    }
    
    @objc func startMSTimer(){
        
        //When MS time is displaying , enable to click
        Test.isEnabled = true
        //Show green when timing
        Test.backgroundColor = UIColor.green
        
        startTime = Date().timeIntervalSinceReferenceDate
        
        //Set displayed time timer
        self.displayTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.displayMsecond), userInfo: nil, repeats: true)
        
        print("random number is \(TimeInterval(randomNumber))");
    }
    
    
    @IBAction func oneClick(_ sender: Any) {
        count+=1
        
        //If it is early Click
        if(displayedSecond == 0.0){
            earlyClick += 1
            GameTimer.invalidate()
            displayedSecond = 0.0
            if(displayTimer != nil){
                displayTimer.invalidate()
            }
            
            randomNumber = Int.random(in: 5...10)
            
            print("Restarted \(randomNumber)")
            
            Test.backgroundColor = UIColor.red
            displayedTime.text = "Waiting..."
            self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
            lastTestLabel.isHidden = false
            lastTestLabel.text = "Early Touch, new test starting..."
        }else{
            //Append time to arrayList
            displayTimer.invalidate()
            
            let time = String(format: "%.2f", displayedSecond)
            
            
            switch count {
            case 1:
                timeArray.append("The \(count)st test: " + time + " S ")
                responseArray.append(Double(time)!)
            case 2:
                timeArray.append("The \(count)nd test: " + time + " S ")
                responseArray.append(Double(time)!)
            case 3:
                timeArray.append("The \(count)rd test: " + time + " S ")
                responseArray.append(Double(time)!)
                
            default:
                timeArray.append("The \(count)th test: " + time + " S ")
                responseArray.append(Double(time)!)
            }
            
            /*append random number to array ,
             make sure button is clicked and append
             */
            randomTimeArray.append(randomNumber)
            lastTestLabel.isHidden = false
            lastTestLabel.fadeTransition(0.5)
            lastTestLabel.text = "Last Response Time was \(time) S"
            
            //Refresh tableView Cell
            tableView.reloadData()
            
            //Set displayedSecond to 0
            displayedSecond = 0.0
            //Random second before display MS
            randomNumber = Int.random(in: 5...10)
            print("random number \(randomNumber)")
            Test.backgroundColor = UIColor.red
            displayedTime.text = "Waiting..."
            self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
        }
        
        
    }
    
    
    @objc func updateProgressView(){
        //Updating progress bar
        progressView.progress += 1/180;
        second = second - 1;
        timeLeft.fadeTransition(0.7)
        timeLeft.text = String(second);
        
        if(second == 0){
            timeLeft.text = "Test finished"
            print("early touch = \(earlyClick)")
            displayedSecond = 0.0
            displayedTime.text = ""
            Start.isEnabled = true
            Test.isEnabled = false
            progressBarTimer.invalidate()
            GameTimer.invalidate()
            //Check whether always early click
            if(displayTimer != nil){
                displayTimer.invalidate()
            }
            second = 180
            count = 0
            earlyClick = 0
            Test.backgroundColor = UIColor.gray
            if(responseArray.count != 0){
                postJson()
            }
            else{
                let title = "Warning"
                let message = "No any clicks, please re-start test"
                let alert = UIAlertController(title: title, message: message, preferredStyle:
                    UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style:
                    UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            Start.imageEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0);
            
            //            for index in responseArray{
            //                print(index)
            //            }
            //
            //            for index in timeArray{
            //                print(index)
            //            }
        }
        
        
    }
    
    //Get test rule
    @IBAction func questionMark(_ sender: Any) {
        //Reactions Test rule
        let title = "Test Rule"
        let message = "1.Total Test Time : 3 mintues\n 2.Failed if click before color changed\n 3.Each click will be recorded\n 4.No click within 30s, test will be finished\n 5.Click 'Start' to start test"
        let alert = UIAlertController(title: title, message: message, preferredStyle:
            UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func postJson(){
        // prepare json data
        
        let json: [String : Any] = ["reaction_times":responseArray,"test_times":randomTimeArray,"false_clicks":earlyClick]
        //let valid = JSONSerialization.isValidJSONObject(json)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json,options: [])
        
        let jsonData2 = try? JSONSerialization.data(withJSONObject: json,options: [])
        // create post request
        //        let url = URL(string: "http://fit5120.herokuapp.com/local_crashes_person")!
        let url = URL(string: "https://fit5120.herokuapp.com/pvt_data/summary")!
        let url2 = URL(string: "https://fit5120.herokuapp.com/pvt_data/chart")!

        var request = URLRequest(url: url)
        var request2 = URLRequest(url: url2)
        
        request.httpMethod = "POST"
        request2.httpMethod = "POST"
        
        /*send the jsonData using json type
         if there is not declare for "application/json"
         the server will not know what type i sent, it will be txt?(guess)
         */
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData
        request2.httpBody = jsonData2
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(response)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                // print("--- \(responseJSON)")
                //print(responseJSON["comment"])

                self.resultComments = responseJSON["comment"]! as! String
                self.resultRating = responseJSON["rating"]! as! Int
                self.resultLevel = responseJSON["fatigue_level"]! as! String

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
                        let title = "Reaction Test Report Generated!"
                        let message = "Click Go to see your test report"
                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
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
        let title = "Generating a report...👻"
        let message = "Please wait for few seconds...👻"
               let alert = UIAlertController(title: title, message: "", preferredStyle:
                   UIAlertController.Style.alert)
               self.present(alert, animated: true, completion: nil)
    }
    
    
    //Unwind segue pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         print(" --- \(resultImage)")
        if(segue.identifier == "ReactionResultSegue"){
            if let nextViewController = segue.destination as? ReactionResultViewController {
                nextViewController.comment = self.resultComments
                nextViewController.rating = Double(self.resultRating)
                nextViewController.fatigue_level = self.resultLevel
               
                nextViewController.imageResult = self.resultImage
            }
        }
        
        
    }
    
}


extension UIView{
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
