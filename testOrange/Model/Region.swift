//
//  Region.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import Foundation

struct Region: Codable {
    let name, country: String
    let lat, lon: Double
    let population: Int
    let timezone, status: String
}
