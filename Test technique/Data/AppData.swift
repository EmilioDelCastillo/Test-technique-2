//
//  AppData.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 11/03/2021.
//

import Foundation

class AppData {
    static var shared = AppData()
    var countries: [Country]!
    var locations: [Location]!
    
    var isMobile = false
    var isAnalysis = false

    var sensorType: SensorType = .reference
    var entity: Entity = .government
    
    /**
     Stores the countries from the API in RAM
     - Parameter completion: The closure to be executed once the data arrives. If there's an error, it is given as the argument.
     */
    func loadCountries(completion: @escaping (Error?) -> Void) {
        let url = URL(string: "https://docs.openaq.org/v2/countries")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
    
                if let myData = data {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Countries.self, from: myData) {
                        
                        // TODO: Handle the possible error
                        self.countries = json.results!
                        completion(nil)
                        
                    } else {
                        completion(error)
                    }
                }
            } else {
                completion(error)
            }
        }.resume()
    }
    
    
    func getData(for countryCode: String, completion: @escaping (Error?) -> Void) {
        let limit = 5000
        
        // Create request
        var components = URLComponents(string: "https://docs.openaq.org/v2/measurements/")!
        components.queryItems = [
            URLQueryItem(name: "date_from",  value: "2021-03-01T00:00:00+00:00"),
            URLQueryItem(name: "date_to",    value: "2021-03-11T00:30:00+00:00"),
            URLQueryItem(name: "limit",      value: limit.description),
            URLQueryItem(name: "page",       value: "1"),
            URLQueryItem(name: "offset",     value: "0"),
            URLQueryItem(name: "sort",       value: "desc"),
            URLQueryItem(name: "has_geo",    value: "true"),
            URLQueryItem(name: "radius",     value: "100000"),
            URLQueryItem(name: "country_id", value: countryCode),
            URLQueryItem(name: "order_by",   value: "location"),
            URLQueryItem(name: "isMobile",   value: isMobile.description),
            URLQueryItem(name: "isAnalysis", value: isAnalysis.description),
        ]
        
        if entity != .all {
            components.queryItems?.append(URLQueryItem(name: "entity",     value: entity.rawValue))
        }
        
        if sensorType != .all {
            components.queryItems?.append(URLQueryItem(name: "sensorType", value: sensorType.rawValue))
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: ":", with: "%3A")
        
        
        let requestURL = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            if error == nil {
    
                if let myData = data {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Locations.self, from: myData) {
                        
                        // TODO: Handle the possible error
                        self.locations = json.results!
                        print("Found:", json.meta!.found!, "Limit", json.meta!.limit!)
                        
                        completion(nil)
                    
                    } else {
                        completion(error)
                    }
                }
            } else {
                completion(error)
            }
        }.resume()
        
    }
    
    /**
     Returns the code of the country
     - Parameter countryName: The name of the country
     - Returns: The code of the country or nil if no country with the given name was found
     */
    func getCountryCode(countryName: String) -> String? {
        if let countries = countries,
           let country = countries.first(where: { (country) -> Bool in
            country.name == countryName
           }) {
            return country.code
        } else {
            return nil
        }
    }
    
}
