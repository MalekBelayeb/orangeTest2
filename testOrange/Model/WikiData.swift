//
//  wikiData.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import Foundation

struct WikiData: Codable {
    let xid, name: String
    let address: Address
    let rate, wikidata, kinds: String
    let sources: Sources
    let otm, wikipedia: String
    let image: String
    let preview: Preview
    let wikipediaExtracts: WikipediaExtracts
    let point: Point

    enum CodingKeys: String, CodingKey {
        case xid, name, address, rate, wikidata, kinds, sources, otm, wikipedia, image, preview
        case wikipediaExtracts = "wikipedia_extracts"
        case point
    }
}

// MARK: - Address
struct Address: Codable {
    let city, state, county, suburb: String
    let country, postcode, countryCode, stateDistrict: String

    enum CodingKeys: String, CodingKey {
        case city, state, county, suburb, country, postcode
        case countryCode = "country_code"
        case stateDistrict = "state_district"
    }
}

// MARK: - Point
struct Point: Codable {
    let lon, lat: Double
}

// MARK: - Preview
struct Preview: Codable {
    let source: String
    let height, width: Int
}

// MARK: - Sources
struct Sources: Codable {
    let geometry: String
    let attributes: [String]
}

// MARK: - WikipediaExtracts
struct WikipediaExtracts: Codable {
    let title, text, html: String
}
