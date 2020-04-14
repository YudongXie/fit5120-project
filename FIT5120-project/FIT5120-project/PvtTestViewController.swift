//
//  PvtTestViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 7/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class PvtTestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var Test: UIButton!
    @IBOutlet weak var displayedTime: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastTestLabel: UILabel!
    
    var timeArray = [String]()
    var responseArray = [Int]()
    var randomTimeArray = [Int]()
    var second = 15
    var displayedSecond = 0
    var progressBarTimer: Timer!
    var GameTimer: Timer!
    var displayTimer : Timer!
    var count = 0
    var gameStarted = false
    var randomNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        Test.isEnabled = false
        displayedTime.layer.zPosition = 1
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
        
        return cell
    }
    
    
    @IBAction func startGame(_ sender: Any) {
        
        //Clear table view cell
        responseArray = []
        randomTimeArray = []
        timeArray = []
        tableView.reloadData()
        //Reset progress bar progress
        progressView.progress = 0
        //Reset display time text to "MS"
        displayedTime.text = "MS"
        //Set progressbar updated every second
        self.progressBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
        Start.isEnabled = false
        
        //First game started
        randomNumber = Int.random(in: 3...5)
        print(randomNumber)
        Test.backgroundColor = UIColor.red
        self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
        Test.isEnabled = true
    }
    
    @objc func displayMsecond(){
        displayedSecond += 1
        displayedTime.text = String(displayedSecond) + " MS"
        
    }
    
    @objc func startMSTimer(){
        //When MS time is displaying , enable to click
        Test.isEnabled = true
        //Set displayed time timer
        self.displayTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.displayMsecond), userInfo: nil, repeats: true)
        //Show green when timing
        Test.backgroundColor = UIColor.green
    
        print("random number is \(TimeInterval(randomNumber))");
        
    }
    
    @IBAction func oneClick(_ sender: Any) {
        count+=1
        print(displayedSecond)
        if(displayedSecond == 0){
            GameTimer.invalidate()
            
            displayedSecond = 0
            if(displayTimer != nil){
                displayTimer.invalidate()
            }
            
            randomNumber = Int.random(in: 3...5)
            print("重新开始 \(randomNumber)")
            Test.backgroundColor = UIColor.red
            self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
            lastTestLabel.isHidden = false
            lastTestLabel.text = "Early Touch, new test starting..."
        }else{
            //Append time to arrayList
            displayTimer.invalidate()
            switch count {
            case 1:
                timeArray.append("The \(count)st test: " + String(displayedSecond) + " MS ")
                responseArray.append(displayedSecond)
            case 2:
                timeArray.append("The \(count)nd test: " + String(displayedSecond) + " MS ")
                responseArray.append(displayedSecond)
            case 3:
                timeArray.append("The \(count)rd test: " + String(displayedSecond) + " MS ")
                responseArray.append(displayedSecond)
                
            default:
                timeArray.append("The \(count)th test: " + String(displayedSecond) + " MS ")
                responseArray.append(displayedSecond)
            }
            
            /*append random number to array ,
             make sure button is clicked and append
            */
            randomTimeArray.append(randomNumber)
            lastTestLabel.isHidden = false
            lastTestLabel.text = "Last Response Time was \(displayedSecond) MS"
            
            //Refresh tableView Cell
            tableView.reloadData()
//            //Set displayedSecond to 0
            displayedSecond = 0
            //Random second before display MS
            randomNumber = Int.random(in: 3...5)
            print(randomNumber)
            Test.backgroundColor = UIColor.red
            self.GameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumber), target: self, selector: #selector(self.startMSTimer), userInfo: nil, repeats: false)
        }
        
        
    }
    
    @objc func updateProgressView(){
        //Updating progress bar
        progressView.progress += 1/15;
        second = second - 1;
        timeLeft.text = String(second);
        
        if(second == 0){
            timeLeft.text = "Test finished"
            displayedTime.text = ""
            Start.isEnabled = true
            Test.isEnabled = false
            progressBarTimer.invalidate()
            GameTimer.invalidate()
            //Check whether always early click
            if(displayTimer != nil){
                displayTimer.invalidate()
            }
            second = 15
            count = 0
            Test.backgroundColor = UIColor.gray
            postJson()
//            print("-----")
//            for random in randomTimeArray{
//                print(random)
//            }
//
//            for index in responseArray{
//                print(index)
//            }
        }
    }
    
    //Get test rule
    @IBAction func questionMark(_ sender: Any) {
        //Reactions Test rule
        let title = "Test Rule"
        let message = "1.Total Test Time : 2 mintues\n 2.Failed if touch before color changed\n 3.Each touch will be recorded 4.Click 'Start' to start test"
        let alert = UIAlertController(title: title, message: message, preferredStyle:
            UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func postJson(){
       // prepare json data
 
//        let json: [String: Any] = ["lat":"-37.8767985",
//        "lon":"144.9882031"]
        let json: [String : Any] = ["reaction_times":responseArray,"test_times":randomTimeArray]
        //let valid = JSONSerialization.isValidJSONObject(json)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json,options: [])
        
        // create post request
//        let url = URL(string: "http://fit5120.herokuapp.com/local_crashes_person")!
         let url = URL(string: "http://fit5120.herokuapp.com/pvt_data")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        /*send the jsonData using json type
            if there is not declare for "application/json"
        the server will not know what type i sent, it will be txt?(guess)
        */
    
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(response)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("--- \(responseJSON)")
            }
        }

        task.resume()
    }
}
