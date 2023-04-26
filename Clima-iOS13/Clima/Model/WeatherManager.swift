//
//  WeatherManager.swift
//  Clima
//
//  Created by Guilherme Mello on 14/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ weatherManager: WeatherManager, error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9f0e78c6d9bc2de2e10c19e9ed120ba3&units=metric" //missing &q=cityName
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherData(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1- create a url
        if let url = URL(string: urlString) {
            //2- create a URLSession
            let session = URLSession(configuration: .default)
            //3- give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(self, error: error!)
                    return
                }
                if let safeData = data {
                    //transfor my Data object that comes from dataTask into JSON
                    if let weather = self.parseJSON(safeData) {
                        // I want to send this weather back to the WeatherViewController
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4- start the task
            task.resume()
        }
    } //end of performRequest method
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let description = decodedData.weather[0].description
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            // I need to return this object
            let weather = WeatherModel(cityName: name, weatherDescription: description, temperature: temp, weatherId: id)
            return weather
        } catch {
            self.delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
    
}
