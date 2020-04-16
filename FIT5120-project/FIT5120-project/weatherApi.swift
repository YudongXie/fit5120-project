//
//  weatherApi.swift
//  FIT5120-project
//
//  Created by Simon Xie on 14/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit

class weatherApi: NSObject,Decodable{
       var currentWeather: String?
       var weatherDescription: String?
       var currentTemp : Double?
//       var temp_min: Double?
//       var temp_max: Double?
       var humidity: Double?
       var currentIcon: String?
    
    enum CodingKeys: String, CodingKey{
        case weathers = "weather"
        case tempData = "main"
    }
    
    enum TempKeys: String, CodingKey {
        case currentTemp = "temp"
//        case temp_min
//        case temp_max
        case humidity
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
           
           
           let tempContainer = try rootContainer.nestedContainer(keyedBy: TempKeys.self, forKey: .tempData)
           self.currentTemp = try tempContainer.decode(Double.self, forKey: .currentTemp) - 273.15
//           self.temp_min = try tempContainer.decode(Double.self, forKey: .temp_min) - 273.15
//           self.temp_max = try tempContainer.decode(Double.self, forKey: .temp_max) - 273.15
           self.humidity = try tempContainer.decode(Double.self, forKey: .humidity)
       }
}
