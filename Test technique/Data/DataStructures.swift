//
//  DataStructures.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 11/03/2021.
//

import Foundation

struct Meta: Codable {
    var name: String?
    var licence: String?
    var website: String?
    var page: Int?
    var limit: Int?
    var found: Int?
}

struct Country: Codable {
    var code: String?
    var name: String?
    var locations: Int?
    var firstUpdated: String?
    var lastUpdated: String?
    var parameters: [String]?
    var count: Int?
    var cities: Int?
    var sources: Int?
}

struct Location: Codable {
    var locationId: Int?
    var location: String?
    var parameter: String?
    var value: Double?
    var date: Date?
    var unit: String?
    var coordinates: Coordinates?
    var country: String?
    var city: String?
    var isMobile: Bool?
    var isAnalysis: Bool?
    var entity: String?
    var sensorType: String?
}

struct Countries: Codable {
    var meta: Meta?
    var results: [Country]?
}

struct Date: Codable {
    var utc: String?
    var local: String?
}

struct Coordinates : Codable {
    var latitude: Double
    var longitude: Double
}

struct Locations: Codable {
    var meta: Meta?
    var results: [Location]?
}
