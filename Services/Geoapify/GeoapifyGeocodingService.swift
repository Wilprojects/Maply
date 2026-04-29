//
//  GeoapifyGeocodingService.swift
//  Maply
//
//  Created by Wilder Moreno on 29/04/26.
//

import Foundation
import CoreLocation

enum GeoapifyServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noResults
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "No se pudo construir la URL de Geoapify."
        case .invalidResponse:
            return "La respuesta del servicio no fue válida."
        case .noResults:
            return "No se encontró una dirección para esta ubicación."
        }
    }
}

final class GeoapifyGeocodingService {
    static let shared = GeoapifyGeocodingService()
    
    private init() {}
    
    func reverseGeocode(latitude: Double, longitude: Double) async throws -> ReverseGeocodedPlace {
        var components = URLComponents(string: "https://api.geoapify.com/v1/geocode/reverse")
        
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "lang", value: "es"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "apiKey", value: APIKeys.geoapify)
        ]
        
        guard let url = components?.url else {
            throw GeoapifyServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw GeoapifyServiceError.invalidResponse
        }
        
        let decodedResponse = try JSONDecoder().decode(
            GeoapifyReverseGeocodingResponse.self,
            from: data
        )
        
        guard let firstResult = decodedResponse.results.first else {
            throw GeoapifyServiceError.noResults
        }
        
        let suggestedName = buildSuggestedName(from: firstResult)
        let suggestedAddress = buildSuggestedAddress(from: firstResult)
        
        return ReverseGeocodedPlace(
            suggestedName: suggestedName,
            suggestedAddress: suggestedAddress
        )
    }
    
    private func buildSuggestedName(from result: GeoapifyReverseGeocodingResult) -> String {
        if let name = result.name, !name.isEmpty {
            return name
        }
        
        if let street = result.street, !street.isEmpty {
            return street
        }
        
        return "Nueva ubicación"
    }
    
    private func buildSuggestedAddress(from result: GeoapifyReverseGeocodingResult) -> String {
        var firstLineParts: [String] = []
        
        if let street = result.street, !street.isEmpty {
            firstLineParts.append(street)
        }
        
        if let housenumber = result.housenumber, !housenumber.isEmpty {
            firstLineParts.append(housenumber)
        }
        
        let firstLine = firstLineParts.joined(separator: " ")
        
        var secondLineParts: [String] = []
        
        if let city = result.city, !city.isEmpty {
            secondLineParts.append(city)
        }
        
        if let postcode = result.postcode, !postcode.isEmpty {
            secondLineParts.append(postcode)
        }
        
        let secondLine = secondLineParts.joined(separator: ", ")
        
        let addressParts = [firstLine, secondLine].filter { !$0.isEmpty }
        
        if !addressParts.isEmpty {
            return addressParts.joined(separator: ", ")
        }
        
        if let addressLine2 = result.addressLine2, !addressLine2.isEmpty {
            return addressLine2
        }
        
        if let formatted = result.formatted, !formatted.isEmpty {
            return formatted
        }
        
        return "Dirección no disponible"
    }
}
