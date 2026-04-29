//
//  GeoapifyReverseGeocodingResponse.swift
//  Maply
//
//  Created by Wilder Moreno on 29/04/26.
//

import Foundation

struct GeoapifyReverseGeocodingResponse: Decodable {
    let results: [GeoapifyReverseGeocodingResult]
}

struct GeoapifyReverseGeocodingResult: Decodable {
    let name: String?
    let formatted: String?
    let addressLine1: String?
    let addressLine2: String?
    let street: String?
    let housenumber: String?
    let city: String?
    let postcode: String?
    let resultType: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case formatted
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case street
        case housenumber
        case city
        case postcode
        case resultType = "result_type"
    }
}
