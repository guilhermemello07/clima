//
//  WeatherModel.swift
//  Clima
//
//  Created by Guilherme Mello on 19/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let cityName: String
    let weatherDescription: String
    let temperature: Double
    let weatherId: Int
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var conditionName: String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snowflake"
        case 701...741:
            return "cloud.fog"
        case 751...781:
            return "tornado"
        case 800:
            return "sun.min"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
