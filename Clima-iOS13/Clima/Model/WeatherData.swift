//
//  WeatherData.swift
//  Clima
//
//  Created by Guilherme Mello on 17/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    
    var name: String
    var main: Main
    var weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Codable {
    let description: String
    let main: String
    let id: Int
}
