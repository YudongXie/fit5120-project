//
//  AppDelegate.swift
//  FIT5120-project
//
//  Created by Simon Xie on 7/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    var currentlocation:CLLocation!
    var databaseController: DatabaseProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Add google places SDK key
        GMSPlacesClient.provideAPIKey("AIzaSyBCI3i1usIcHgacrg0Hg6qmtycIPztheC0")
        
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 2.0)
        //Change bar title color
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .headline),.foregroundColor:UIColor.white]
         appearance.backgroundColor = UIColor.init(red: 89/255, green: 128/255, blue: 169/255, alpha: 1.0)
        UINavigationBar.appearance().standardAppearance = appearance

        //Set the tab bar color to white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        
        //Set the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //Ask for permission
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        databaseController = CoreDataController()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

