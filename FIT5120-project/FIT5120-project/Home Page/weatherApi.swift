//
//  weatherApi.swift
//  FIT5120-project
//
//  Created by Simon Xie on 14/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

/*This file is for decoding json*/

import UIKit

class weatherApi: NSObject,Decodable{
    var currentWeather: String?
    var weatherDescription: String?
    var currentTemp : Double?
    var humidity: Double?
    var currentIcon: String?
    var sunset : Int?
    var sunrise : Int?
    
    enum CodingKeys: String, CodingKey{
        case weathers = "weather"
        case tempData = "main"
        case sysData = "sys"
    }
    
    enum TempKeys: String, CodingKey {
        case currentTemp = "temp"
        case humidity
    }
    
    enum SysData: String, CodingKey {
        case sunset
        case sunrise
    }
    
    struct WeatherData: Decodable {
        var main: String
        var description: String
        var icon : String
    }
    
    
    required init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let weatherContainer = try? rootContainer.decode([WeatherData].self, forKey: .weathers)
        self.currentWeather = weatherContainer![0].main
        self.weatherDescription = weatherContainer![0].description
        self.currentIcon = weatherContainer![0].icon
        
        //Decode temp from "main" Array in APIS
        let tempContainer = try rootContainer.nestedContainer(keyedBy: TempKeys.self, forKey: .tempData)
        self.currentTemp = try tempContainer.decode(Double.self, forKey: .currentTemp) - 273.15
        self.humidity = try tempContainer.decode(Double.self, forKey: .humidity)
        
        //Decode sunrise + sunset
        let sysContainer = try rootContainer.nestedContainer(keyedBy: SysData.self, forKey: .sysData)
        self.sunrise = try sysContainer.decode(Int.self, forKey: .sunrise)
        self.sunset = try sysContainer.decode(Int.self, forKey: .sunset)
    }
}
