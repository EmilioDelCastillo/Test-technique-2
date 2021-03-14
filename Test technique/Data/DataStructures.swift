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

struct Parameter: Codable {
    var id: Int?
    var name: String?
    var displayName: String?
    var description: String?
    var preferredUnit: String?
    var isCore: Bool?
    var maxColorValue: Double?
}

struct Parameters: Codable {
    var meta: Meta?
    var results: [Parameter]?
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

enum SensorType: String, CaseIterable {
    case all = "all"
    case reference = "reference grade"
    case lowCost = "low-cost sensor"
}

enum Entity: String, CaseIterable {
    case all
    case government
    case community
    case research
}

enum ResultError: Error {
    case negativeCount
    case noResult
    case unknownError
}
