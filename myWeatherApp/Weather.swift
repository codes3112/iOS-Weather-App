//
//  Weather.swift
//  myWeatherApp
//
//  Created by sneha arora on 2018-08-30.
//  Copyright © 2018 sneha arora. All rights reserved.
//

import Foundation
import CoreLocation

//Data Model :Struct
struct Weather {
    let summary : String
    let icon : String
    let temperature : Double
    
//We are using "data" Array. We get data in dictionary form from the web API. So we Convert that to an object using init. This is called Serialization
    
    enum SerializationError:Error{
        case missing(String)
        case invalid(String,Any)
    }

    init(json:[String : Any]) throws {
        guard let summary = json["summary"] as?String else{
            throw SerializationError.missing("Summary Is Missing")
        }
        guard let icon = json["icon"] as?String else{
            throw SerializationError.missing("Icon Is Missing")
        }
        guard let temperature = json["temperatureMax"] as?Double else{
            throw SerializationError.missing("Temperature Is Missing ")
        }
        //initializing the properties
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        
    }

    static let basePath = "https://api.darksky.net/forecast/084e95aafc25c1da2609ea454662ee68/"
    
    static func forecast(withLocation location:CLLocationCoordinate2D, completion: @escaping([Weather]) ->()){
        //let url = basePath+location
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url : URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request){(data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather]=[]
            if let data = data{
                
                do{
                    //casting dictionary
                    
                    if let json=try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        
                        //if above works and we get data dictionary perform the following
                        
                        if let dailyForecasts = json["daily"] as?[String:Any]{
                            //casting dictionary again into array
                            if let dailyData = dailyForecasts["data"] as?[[String:Any]]{
                                
                                //now appending data to our Weather Object
                                
                                for dataPoint in dailyData{
                                    if let weatherObject = try? Weather(json: dataPoint){
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
            completion(forecastArray)
        }
        
        
      }
        task.resume()
    }
    
}
//struct ends







