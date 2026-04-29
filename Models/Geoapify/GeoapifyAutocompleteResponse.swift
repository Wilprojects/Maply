//
//  GeoapifyAutocompleteResponse.swift
//  Maply
//
//  Created by Wilder Moreno on 29/04/26.
//

import Foundation

struct GeoapifyAutocompleteResponse: Decodable {
    let results: [GeoapifyAutocompleteResult]
}

struct GeoapifyAutocompleteResult: Decodable, Identifiable {
    let placeId: String?
    let formatted: String?
    let name: String?
    let addressLine1: String?
    let addressLine2: String?
    let lat: Double?
    let lon: Double?
    
    var id: String {
        placeId ?? UUID().uuidString
    }
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case formatted
        case name
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case lat
        case lon
    }
}
