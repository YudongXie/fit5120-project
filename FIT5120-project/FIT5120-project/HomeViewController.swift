//
//  HomeViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 14/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    //    @IBOutlet weak var tempMinLabel: UILabel!
    //    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    var datas : weatherApi?
    var stringIcon : String!
    var tipsTimer: Timer!
    var originX : CGFloat = 0.0
    var imageData : Data!
    var tipsArray = ["Get a good night's sleep before heading off on a long trip","don't travel for more than eight to ten hours a day","take regular breaks – at least every two hours","share the driving wherever possible","don't travel at times when you'd usually be sleeping","take a 15 minute powernap if you feel yourself becoming drowsy","don't drink alcohol before your trip."]
    
    //var originTransform = CGAffineTransform()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originX = weatherImg.frame.origin.x
       // originTransform = weatherImg.transform
        print(weatherImg.frame.origin.x)
//        print(weatherImg.alpha)
//        print(weatherImg.transform)
        
        //Set the background image and fit it to screen
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homeBg3")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.contentView.insertSubview(backgroundImage, at: 0)
        self.tipsTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.randomTips), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.weatherLabel.isHidden = true
        self.humidityLabel.isHidden = true
        self.currentTempLabel.isHidden = true
        callWeatherAPI()
        //print("-- \(originX)")
        //self.weatherImg.frame.origin.x = 0
        //self.weatherImg.alpha = 1
        //animationImage()
        randomTips()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.weatherImg.image = nil
    }
    
    @objc func randomTips(){
        
        let randomTipsString = tipsArray.randomElement()
        tipsLabel.fadeTransition(0.7)
        tipsLabel.text = "DO YOU KNOW how to beat driver fatigue? \n \(randomTipsString!)"
    }
    
    //Calling weather api to get today's weather information
    func callWeatherAPI() {
        //print("xx")
        let searchString =
        "https://api.openweathermap.org/data/2.5/weather?q=Melbourne,au&appid=7274f1851678751d9cb91a679f06ac4b"
        
        let jsonURL = URL(string:
            searchString.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            // If there is an error show the error message
            if let error = error {
                
                return
            }
            do {
                
                let decoder = JSONDecoder()
                self.datas = try decoder.decode(weatherApi.self, from: data!)
            } catch let err {
                
            }
            DispatchQueue.main.async {
                //Set label's text in main task
                self.weatherLabel.text = "Weather: \(self.datas?.currentWeather as! String)"
                self.currentTempLabel.text = "Now: \(String(Int(self.datas?.currentTemp as! Double)))°C"
                //                self.tempMinLabel.text = "MinTemp: \(String(Int(self.datas?.temp_min as! Double)))°C"
                //                self.tempMaxLabel.text = "MaxTemp: \(String(Int(self.datas?.temp_max as! Double)))°C"
                self.humidityLabel.text = "Humidity: \(String(Int(self.datas?.humidity as! Double)))%"
                self.stringIcon = self.datas?.currentIcon as! String
                //Set labels visible
                self.weatherLabel.isHidden = false
                self.humidityLabel.isHidden = false
                //                self.tempMinLabel.isHidden = false
                //                self.tempMaxLabel.isHidden = false
                self.currentTempLabel.isHidden = false
                
                let serviceURL = "http://openweathermap.org/img/wn/\(self.stringIcon!).png"
                
                let url = URL(string: serviceURL)
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                //self.weatherImg.transform = CGAffineTransform(scaleX:1.0, y:1.0)
                self.imageData = data!
                self.weatherImg.image = UIImage(data: data!)
                self.weatherImg.transform = CGAffineTransform(scaleX:1.0, y:1.0)
                self.animationImage()
            }
        }
        task.resume()
    }
    
    func animationImage(){
        UIView.animate(withDuration: 3.0, animations:{
          //  print(self.weatherImg.frame.origin.x)
            self.weatherImg.frame.origin.x = self.weatherImg.frame.origin.x + self.originX
           // print(self.weatherImg.frame.origin.x)
            self.weatherImg.alpha = 0
            self.weatherImg.transform = CGAffineTransform(scaleX:1.5, y:1.5)
        })
       
        //After animation, set alpha back to 1
        weatherImg.alpha = 1
        //After animation set position back to origin
        self.weatherImg.frame.origin.x = self.originX
    }
    
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
