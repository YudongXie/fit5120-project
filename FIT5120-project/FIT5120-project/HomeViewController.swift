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
    
    var datas : weatherApi?
    var stringIcon : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the background image and fit it to screen
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homeBg3")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
//        let appearance = UINavigationBarAppearance()
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.weatherLabel.isHidden = true
        self.humidityLabel.isHidden = true
        self.currentTempLabel.isHidden = true
        callWeatherAPI()
    }
    
    //Calling weather api to get today's weather information
    func callWeatherAPI() {
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
                self.weatherImg.image = UIImage(data: data!)
            }
            
        }
        task.resume()
    }
  

}
