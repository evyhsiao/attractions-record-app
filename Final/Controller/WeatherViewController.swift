//
//  WeatherViewController.swift
//  Final
//
//  Created by evyhsiao on 2022/1/1.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet var cityName: UILabel!
    
    @IBOutlet var temperature: UILabel!
    
    @IBOutlet var humidity: UILabel!
    
    @IBOutlet var weatherState: UILabel!
    
    @IBOutlet var weatherImage: UIImageView!
    
    var city: String = ""
    
    private let API_URL = "https://api.openweathermap.org/data/2.5/weather?"
    private let API_KEY = "b76f7eedf5708822e87b9cb4a99c8062"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getForecast(location: self.city)
    }
    
    func getForecast(location: String) {
        
        guard let accessURL = URL(string: API_URL + "q=\(location)&units=metric&lang=zh_tw&APPID=\(API_KEY)") else {
            return
        }
        
        let request = URLRequest(url: accessURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            //parse data
            if let data = data {
                let decoder = JSONDecoder()
                if let weatherData = try? decoder.decode(WeatherForecastData.self, from: data) {
                    print("============== Weather Full data ==============")
                    print(weatherData)
                    print("============== Weather Partial data ==============")
                    print("City: \(weatherData.name)")
                    print("Coordinate: (\(weatherData.coord.lon),\(weatherData.coord.lat))")
                    print("Temperature: \(weatherData.main.temp)°C")
                    print("Descrition: \(weatherData.weather[0].description)")
                    let iconcode = weatherData.weather[0].icon
                    print(iconcode)
                    
                    OperationQueue.main.addOperation {
                        self.cityName.text = weatherData.name
                        self.temperature.text = "Temperature: \(weatherData.main.temp)°C"
                        self.humidity.text = "Humidity: \(weatherData.main.humidity)%"
                        self.weatherState.text =  weatherData.weather[0].description
                        self.weatherImage.image = UIImage(named: iconcode)
                    }
                }
            }
        })
        
        task.resume()
    }
}
