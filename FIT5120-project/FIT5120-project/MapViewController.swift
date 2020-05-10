//
//  MapViewController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 17/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate, UIScrollViewDelegate{

    @IBOutlet weak var mkMapView: MKMapView!
    @IBOutlet weak var userLocationImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    let regionInMeters: Double = 10000
    var locationManager = CLLocationManager()
    var currentlocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // scrollView.delegate = self
        mkMapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //Updating the location
        locationManager.startUpdatingLocation()
//        if(locationManager.startUpdatingLocation() == ()){
//            let title = "Fail to track user's location"
//            let message = "Open GPS -> Setting - privacy - location service"
//            let alert = UIAlertController(title: title, message: message, preferredStyle:
//                UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style:
//                UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
      //  scrollView.maximumZoomScale = 5
      //  scrollView.minimumZoomScale = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //view controller changed, enable map and hide image
     //   self.scrollView.isHidden = true
        self.mkMapView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let title = "Click User Marker to see graph information"
        let alert = UIAlertController(title: title, message: "", preferredStyle:
            UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return userLocationImage
//    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        // Only called when variable have location data
        authorizelocationstates()
    }
    
    func authorizelocationstates(){
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentlocation = locationManager.location
        }
       // print(currentlocation.coordinate.latitude)
       // print(currentlocation.coordinate.longitude)
        
        centerLocation()
    
    }
    
    func centerLocation(){
           //设置中心位置, zoom大小
           let location = CLLocationCoordinate2D(latitude: currentlocation.coordinate.latitude, longitude: currentlocation.coordinate.longitude)
           let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
           self.mkMapView.setRegion(region, animated: true)
       }
    
     
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

       
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
            if annotationView == nil{
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
            }
        
          //If the mark is not user location, set mark image
            if annotation is MKUserLocation{
                annotationView?.image=UIImage(named:"icons8-user-40")
                
                //set the popup
                annotationView?.canShowCallout = true
                let btn = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = btn
                btn.addTarget(self, action: #selector(showGraph), for:.touchUpInside)
                return annotationView
            }
            else{
                annotationView?.image=UIImage(named:"icons8-crashed-car-30")
                //set the popup
                annotationView?.canShowCallout = true
                let btn = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = btn
                btn.addTarget(self, action: #selector(showGraph), for:.touchUpInside)
    //            theName = annotation.title!!
    //            theDesc = annotation.subtitle!!
            }
            return annotationView
        }

    //When the mark is clicked
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let titleAnnotation = view.annotation
//
//        print("zzz")
    }
    
    @objc func showGraph(){
        let json: [String : Any] = ["lat":currentlocation.coordinate.latitude,"lon":currentlocation.coordinate.longitude]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json,options: [])
        
        let url = URL(string: "http://fit5120.herokuapp.com/crashes_tod_atm")!
        var request = URLRequest(url: url)
               
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            DispatchQueue.main.async {
                //self.scrollView.isHidden = false
              //  self.userLocationImage.isHidden = false
               // self.userLocationImage.image = UIImage(data: data)
               // self.userLocationImage.layer.zPosition = 1
                self.mkMapView.isUserInteractionEnabled=false
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
              //  self.userLocationImage.isUserInteractionEnabled = true
               // self.userLocationImage.addGestureRecognizer(tapGestureRecognizer)
                
              //  print(self.scrollView.zoomScale)
            }
            
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print("--- \(responseJSON)")
//            }
        }
        
        task.resume()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
      //  self.scrollView.isHidden = true
        self.mkMapView.isUserInteractionEnabled = true
    }
}
