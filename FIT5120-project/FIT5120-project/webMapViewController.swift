//
//  webMapViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 30/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit
import GooglePlaces
import WebKit
import CoreLocation

class webMapViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    var webData: String!
    @IBOutlet weak var oriTextField: UITextField!
    @IBOutlet weak var desTextField: UITextField!
    @IBOutlet weak var segementControl: UISegmentedControl!
    @IBOutlet weak var navigatieButton: UIButton!
    
    @IBOutlet weak var currentLocationButton: UIButton!
    
    var currentlocation:CLLocation!
    var originLat : NSNumber = 0
    var originLong : NSNumber = 0
    var desLat : NSNumber = 0
    var desLong : NSNumber = 0
    var currentTag = "safest"
    var currentTextField : UITextField!
    var currentLat : CLLocationDegrees = 0
    var currentLong : CLLocationDegrees = 0
    var noLocationTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oriTextField.delegate = self
        desTextField.delegate = self
        segementControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        segementControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        oriTextField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "new-icons8-circle-30")
        imageView.image = image
        oriTextField.leftView = imageView
        
        desTextField.leftViewMode = UITextField.ViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image2 = UIImage(named: "new-icons8-marker-30")
        imageView2.image = image2
        desTextField.leftView = imageView2
        
        navigatieButton.layer.cornerRadius = 5
        currentLocationButton.layer.cornerRadius = 5
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        /* Set default rotation*/
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .landscapeLeft
        userLocation()
    }
    
    func userLocation(){
        /*Get locationManager value from AppDelegate*/
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let locationManager = appDelegate.locationManager
        
        /*Check the currentlocation whether null or not*/
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            locationManager.startUpdatingLocation()
            currentlocation = locationManager.location
        }
        /*If not allowed locate GPS*/
        if(CLLocationManager.authorizationStatus() == .denied){
            currentlocation = nil
        }
        
        /*If GPS not turned on*/
        if(currentlocation == nil){
            currentLat = -37.817522
            currentLong = 144.967549
            let title = "We are unable to locate your location "
            let message = "Please make sure your GPS is turned on \n User current location will be system default location"
            let alert = UIAlertController(title: title, message: message, preferredStyle:
                UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
            self.noLocationTimer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
        }
        else{
            currentLat = currentlocation.coordinate.latitude
            currentLong = currentlocation.coordinate.longitude
        }
        
        /*Send location to backedn to get map html*/
        let nullValue : String?
        nullValue = nil
        let json: [String : Any] = [
            "origin":[
                "qry_type": "latLon",
                "query":[
                    "lat": currentLat,
                    "lon": currentLong,
                    "address":nullValue
                ]
            ],
            "dest":nullValue
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json,options: [])
        let url = URL(string: "https://fit5120.herokuapp.com/map")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        /*insert json data to the request*/
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let str = String(decoding: data, as: UTF8.self)
            self.webData = str
            DispatchQueue.main.async {
                /*Set rotation value*/
                let value = UIInterfaceOrientation.landscapeLeft.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                self.webView.loadHTMLString(self.webData, baseURL: nil)
            }
            
        }
        
        task.resume()
    }
    
    @IBAction func originTap(_ sender: Any) {
        autocompleteClicked(oriTextField)
    }
    
    @IBAction func destinationTap(_ sender: Any) {
        autocompleteClicked(desTextField)
    }
    
    @IBAction func locateCurrentLocation(_ sender: UIButton) {
        userLocation()
    }
    
    
    /*Value changed for different routes*/
    @IBAction func tagValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentTag = "safest"
            callMapHtml()
            break
        case 1:
            currentTag = "fastest"
            callMapHtml()
            break
        case 2:
            currentTag = "shortest"
            callMapHtml()
            break
        default:
            currentTag = "safest"
            break
        }
    }
    
    
    @objc func autocompleteClicked(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        /*Specify the place data types to return.*/
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        /*Specify a filter.*/
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter

        currentTextField = sender
        /* Display the autocomplete view controller.*/
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func routeButton(_ sender: Any) {
        callMapHtml()
    }
    
    func callMapHtml(){
        /*Set json data*/
        if(oriTextField.text !=  "" && desTextField.text != ""){
            let json: [String : Any] = [
                "origin":[
                    "qry_type": "latLon",
                    "query":[
                        "lat": originLat,
                        "lon": originLong,
                        "address": oriTextField.text!
                    ]
                ],
                "dest":[
                    "qry_type": "latLon",
                    "query":[
                        "lat": desLat,
                        "lon": desLong,
                        "address": desTextField.text!
                    ]
                ],
                "tags": currentTag
            ]
            
            /*Call URL*/
            let jsonData = try? JSONSerialization.data(withJSONObject: json,options: [])
            let url = URL(string: "https://fit5120.herokuapp.com/map")!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            /* insert json data to the request*/
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let str = String(decoding: data, as: UTF8.self)
                self.webData = str
                DispatchQueue.main.async {
                    /*Disclamier pop up window*/
                    if(self.currentTag == "safest"){
                        let title = ""
                        let message = "Safest: Based on total number of accidents on the route between 2011 and 2019. \n Source: VicRoads"
                        let alert = UIAlertController(title: title, message: message, preferredStyle:
                            UIAlertController.Style.alert)
                        self.present(alert, animated: true, completion: nil)
                    }else if(self.currentTag == "fastest"){
                        let title = ""
                        let message = "Fastest: Based on traffic conditions and distance. \n Source: Google transit APIs"
                        let alert = UIAlertController(title: title, message: message, preferredStyle:
                            UIAlertController.Style.alert)
                        self.present(alert, animated: true, completion: nil)
                    }
                        Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)

                    self.webView.loadHTMLString(self.webData, baseURL: nil)
                }
                
            }
            task.resume()
        }else{
            /*Pop up window for no inputs*/
            let title = "No location input!"
            let message = "Make sure you have entered location!"
            let alert = UIAlertController(title: title, message: message, preferredStyle:
                UIAlertController.Style.alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    /*dismiss pop up window*/
    @objc func dismissAlert(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swapLocation(_ sender: Any) {
        /*Click the button to swap the value of Des/Ori*/
        let swapValueOne = oriTextField.text
        let swapValueTwo = desTextField.text
        let swapValueOriLat = originLat
        let swapValueOriLong = originLong
        let swapValueDesLat = desLat
        let swapValueDesLong = desLong
        
        oriTextField.text = swapValueTwo
        desTextField.text = swapValueOne
        
        originLat = swapValueDesLat
        originLong = swapValueDesLong
        
        desLat = swapValueOriLat
        desLong = swapValueOriLong
    }
    
}

extension webMapViewController: GMSAutocompleteViewControllerDelegate {
    
    /* Handle the user's selection.*/
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        currentTextField.text = place.name
        
        let serviceURL = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(place.placeID!)&fields=geometry&key=AIzaSyBCI3i1usIcHgacrg0Hg6qmtycIPztheC0"
        print(serviceURL)
        let url = URL(string:serviceURL)
        guard url != nil else{
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data,response,error) in
            /*Getting the lat / lng from the Json*/
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            let result = json!["result"] as? [String : Any]
            let geometry = result!["geometry"] as? [String : Any]
            let location = geometry!["location"] as? [String : Any]
            let lat = location!["lat"] as! NSNumber
            let long = location!["lng"] as! NSNumber
            DispatchQueue.main.async {
                if(self.currentTextField == self.oriTextField){
                    self.originLat = lat
                    self.originLong = long
                }
                if(self.currentTextField == self.desTextField){
                    self.desLat = lat
                    self.desLong = long
                }
            }
        }
        dataTask.resume()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        /* TODO: handle the error.*/
        print("Error: ", error.localizedDescription)
    }
    
    /* User canceled the operation.*/
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    /* Turn the network activity indicator on and off again.*/
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
