//
//  AppData.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 11/03/2021.
//

import Foundation

class AppData {
    static var shared = AppData()
    private(set) var countries: [Country]!
    private(set) var locations: [Location]!
    private(set) var parameters: [Parameter]!
    
    var isMobile = false
    var isAnalysis = false

    var sensorType: SensorType = .reference
    var entity: Entity = .government
    var parameter: String = "pm10"
    
    var dateToday = Foundation.Date()
    private var dateTomorrow: Foundation.Date {
        Calendar.current.date(byAdding: .day, value: 1, to: dateToday)!
    }
    private var dateFormatter = DateFormatter()
    /**
     Stores the countries from the API in RAM
     - Parameter completion: The closure to be executed once the data arrives. If there's an error, it is given as the argument.
     */
    func loadCountries(completion: @escaping (Error?) -> Void) {
        let url = URL(string: "https://docs.openaq.org/v2/countries")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
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
        }
        
        // Prevent the UI from freezing
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
    }
    
    func loadParameters(completion: @escaping (Error?) -> Void) {
        let url = URL(string: "https://docs.openaq.org/v2/parameters")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
    
                if let myData = data {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Parameters.self, from: myData) {
                        
                        /* When handling non core parameters, some parameters' names are duplicates
                         and the /measures route can't handle parameter id so I'm contrained to filter
                         them out.
                         */
                        // TODO: Handle the possible error
                        self.parameters = json.results!.filter({ (element) -> Bool in
                            element.isCore!
                        })
                        completion(nil)
                        
                    } else {
                        completion(error)
                    }
                }
            } else {
                completion(error)
            }
        }
        
        // Prevent the UI from freezing
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
    }
    
    
    func getData(for countryCode: String, completion: @escaping (Error?) -> Void) {
        let limit = 100
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Create request
        var components = URLComponents(string: "https://docs.openaq.org/v2/measurements/")!
        components.queryItems = [
            URLQueryItem(name: "date_from",    value: dateFormatter.string(from: dateToday)),
            URLQueryItem(name: "date_to",      value: dateFormatter.string(from: dateTomorrow)),
            URLQueryItem(name: "limit",        value: limit.description),
            URLQueryItem(name: "page",         value: "1"),
            URLQueryItem(name: "sort",         value: "desc"),
            URLQueryItem(name: "has_geo",      value: "true"),
            URLQueryItem(name: "country_id",   value: countryCode),
            URLQueryItem(name: "sort",         value: "asc"),
            URLQueryItem(name: "order_by",     value: "datetime"),
            URLQueryItem(name: "isMobile",     value: isMobile.description),
            URLQueryItem(name: "isAnalysis",   value: isAnalysis.description),
            URLQueryItem(name: "parameter",    value: parameter)
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
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, sessionError) in
            
            if sessionError == nil {
    
                if let myData = data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let json = try decoder.decode(Locations.self, from: myData)
                        if let results = json.results {
                            self.locations = results
                            
                            if json.meta!.found! == 0 {
                                throw ResultError.noResult
                            }
                            if json.meta!.found! < 0 {
                                throw ResultError.negativeCount
                            }
                            print("Found:", json.meta!.found!, "Limit", json.meta!.limit!)
                            completion(nil)
                        
                        } else {
                            
                            completion(ResultError.unknownError)
                        }
                    } catch {
                        completion(error)
                    }
                }
            } else {
                completion(sessionError)
            }
        }
        
        // Prevent the UI from freezing
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
        
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
