//
//  HomeViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 14/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController,DatabaseListener{
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var webView: WKWebView!
    
    var listenerType = ListenerType.all
    weak var databaseController: DatabaseProtocol?
    var datas : weatherApi?
    var sunrise : Int!
    var sunset : Int!
    var stringIcon : String!
    var tipsTimer: Timer!
    var originX : CGFloat = 0.0
    var imageData : Data!
    var temp = ""
    var tipsArray = ["Get a good night's sleep before heading off on a long trip","don't travel for more than eight to ten hours a day","take regular breaks – at least every two hours","share the driving wherever possible","don't travel at times when you'd usually be sleeping","take a 15 minute powernap if you feel yourself becoming drowsy","don't drink alcohol before your trip."]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        /*Get the original position of weatherImage*/
        originX = weatherImg.frame.origin.x
        /*Set the background image and fit it to screen*/
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "newHomeBg")
        
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.contentView.insertSubview(backgroundImage, at: 0)
      
        /* resize the background image to fit in scroll view*/
        backgroundImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
                
                
        self.tipsTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.randomTips), userInfo: nil, repeats: true)
        /*Put tips label on the top*/
        tipsLabel.layer.zPosition = 1
    }
    
    /*Passing values to next controller*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "homeToQuestionSegue"){
            if let nextViewController = segue.destination as? QuestionViewController {
                /*Pass tempature to next controller*/
                nextViewController.tempValue = temp
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*Before view appear, set hidden and call the api and set the video URL*/
        self.weatherLabel.isHidden = true
        self.humidityLabel.isHidden = true
        self.currentTempLabel.isHidden = true
        callWeatherAPI()
        getVideo()
        randomTips()
        
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*Remove listener*/
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.weatherImg.image = nil
    }
    
    func onCheckListChange(change: DatabaseChange, checkList: [CheckList]) {
           /*Get the array from coredata and pass it to current view array
            Also set the date formate
            */
           let date = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           let currentDate = formatter.string(from: date)
           var recordChecker = 0
        
           for index in checkList{
               if(index.time == currentDate){
                   recordChecker += 1
               }
           }
        /*If today has no record for test and questions, then create a new record*/
           if(recordChecker == 0){
               let _ = databaseController?.addCheckList(questionOne: false, questionTwo: false, questionThree: false, questionFour: false, questionFive: false, time: currentDate, fatigueLevel: "Reaction Test Not done", rating: 0, weatherTemp: "no record")
           }

       }
    
    @objc func randomTips(){
        /*Random tips and set the changing animation*/
        let randomTipsString = tipsArray.randomElement()
        tipsLabel.fadeTransition(0.7)
        tipsLabel.text = "DO YOU KNOW how to beat driver fatigue? \n \(randomTipsString!)"
    }
    
    func getVideo(){
        /*Call Video URlL and display*/
        let serviceURL = "https://www.youtube.com/embed/e4uU47k_UKw?playsinline=1"
        let url = URL(string:serviceURL)
        webView.load(URLRequest(url:url!))
    }
    
    /*Call weather api to get today's weather information*/
    func callWeatherAPI() {
        let searchString =
        "https://api.openweathermap.org/data/2.5/weather?q=Melbourne,au&appid=7274f1851678751d9cb91a679f06ac4b"
        
        let jsonURL = URL(string:
            searchString.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            /* If there is an error show the error message*/
            if let error = error {
                
                return
            }
            do {
                
                let decoder = JSONDecoder()
                self.datas = try decoder.decode(weatherApi.self, from: data!)
            } catch let err {
                
            }
            DispatchQueue.main.async {
                /*Set label's text in main task*/
                self.weatherLabel.text = "Weather: \(self.datas?.currentWeather as! String)"
                self.temp = "\(String(Int(self.datas?.currentTemp as! Double)))°C"
                self.currentTempLabel.text = "Now: \(String(Int(self.datas?.currentTemp as! Double)))°C"
                self.humidityLabel.text = "Humidity: \(String(Int(self.datas?.humidity as! Double)))%"
                self.stringIcon = self.datas?.currentIcon as! String
                /*Set labels visible*/
                self.weatherLabel.isHidden = false
                self.humidityLabel.isHidden = false
                self.currentTempLabel.isHidden = false
                
                /*Set the URL for weather image and download it from the URL*/
                let serviceURL = "http://openweathermap.org/img/wn/\(self.stringIcon!).png"
                
                let url = URL(string: serviceURL)
                let data = try? Data(contentsOf: url!)
                /* Set value according to response*/
                self.imageData = data!
                self.weatherImg.image = UIImage(data: data!)
                self.weatherImg.transform = CGAffineTransform(scaleX:1.0, y:1.0)
                self.weatherImg.trailingAnchor.constraint(equalTo: self.view.superview!.trailingAnchor, constant: 10).isActive = true
                self.animationImage()
            }
        }
        task.resume()
    }
    
    func animationImage(){
        /*Move the image from left to right*/
        UIView.animate(withDuration: 3.0, animations:{
            self.weatherImg.frame.origin.x = self.weatherImg.frame.origin.x + self.originX
            self.weatherImg.alpha = 0
            self.weatherImg.transform = CGAffineTransform(scaleX:1.5, y:1.5)
        })
       
        /*After animation, set alpha back to 1*/
        weatherImg.alpha = 1
        /*After animation set position back to origin*/
        self.weatherImg.frame.origin.x = self.originX
    }
    
}

extension UIView {
    /*Animation for changing*/
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    /*Background Image fit function*/
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }

    func center(x: NSLayoutXAxisAnchor?, y: NSLayoutYAxisAnchor? ) {

        translatesAutoresizingMaskIntoConstraints = false

        if let x = x {
            centerXAnchor.constraint(equalTo: x).isActive = true
        }

        if let y = y {
            centerYAnchor.constraint(equalTo: y).isActive = true
        }
    }
    }
}
