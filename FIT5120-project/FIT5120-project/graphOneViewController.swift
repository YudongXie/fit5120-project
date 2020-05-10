//
//  graphOneViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 20/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit
import CoreLocation

class graphOneViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var segementedControl: UISegmentedControl!
    
    var locationManager = CLLocationManager()
    var currentlocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        locationManager.delegate = self
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homeBg3")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        segementedControl.layer.zPosition = 1
        
        
    }
    
    
    
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //print(pageControl.currentPage)
        if(segementedControl.selectedSegmentIndex == 0){
            return imageView
        }else{
            return imageView2
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentlocation = locationManager.location
        }
        
        if(currentlocation != nil){
            let title = "Asking for graphs from server side...👻"
            let message = "Please wait for few seconds...👻"
            let alert = UIAlertController(title: title, message: "", preferredStyle:
                UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
            
            let json: [String : Any] = ["lat":currentlocation.coordinate.latitude,"lon":currentlocation.coordinate.longitude]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json,options: [])
            
            let url = URL(string: "http://fit5120.herokuapp.com/crashes_tod_atm")!
            let url2 = URL(string: "http://fit5120.herokuapp.com/local_crashes_person")!
            
            var request = URLRequest(url: url)
            var request2 = URLRequest(url: url2)
            
            request.httpMethod = "POST"
            request2.httpMethod = "POST"
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // insert json data to the request
            request.httpBody = jsonData
            request2.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data:data)
                    self.dismiss(animated: true, completion: nil)
                    self.segementedControl.isHidden = false
                }
            }
            
            let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageView2.image = UIImage(data:data)
                    
                }
            }
            
            task.resume()
            task2.resume()
            
            
        }else{
            let title = "We are unable to locate your location👻"
            let message = "Please go Setting - Privacy - Location to open the GPS"
            let alert = UIAlertController(title: title, message: "", preferredStyle:
                UIAlertController.Style.alert)
            let OKAction = UIAlertAction(title: "Return to Home Page", style: UIAlertAction.Style.default, handler: {
                (_)in
                self.tabBarController?.selectedIndex = 0
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func pageControl(_ sender: UISegmentedControl) {
        //let index = segementedControl.c
        let index = sender.selectedSegmentIndex
        if(index == 0){
            if(imageView.isHidden == true){
                //reset the zoom scale for images
                self.scrollView.setZoomScale(0.0, animated: true)
                imageView.transform = CGAffineTransform.identity
                imageView2.transform = CGAffineTransform.identity
                imageView.isHidden = false
                imageView2.isHidden = true
                
            }
        }else{
            if(imageView2.isHidden == true){
                //reset the zoom scale for images
                self.scrollView.setZoomScale(0.0, animated: true)
                imageView.transform = CGAffineTransform.identity
                imageView2.transform = CGAffineTransform.identity
                imageView2.isHidden = false
                imageView.isHidden = true
                
            }
        }
        print(index)
        //print(dataArray[0])
        //imageView.image = UIImage(data:dataArray[index])
    }
}
