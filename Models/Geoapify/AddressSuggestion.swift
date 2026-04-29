//
//  AddressSuggestion.swift
//  Maply
//
//  Created by Wilder Moreno on 29/04/26.
//

import Foundation

struct AddressSuggestion: Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
    let latitude: Double?
    let longitude: Double?
}
