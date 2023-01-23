//
//  Place.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import Foundation

struct Place: Codable {
    let xid, name: String
    let dist: Double
    let rate: Int
    let osm: String?
    let wikidata, kinds: String
    let point: Point
}


typealias Places = [Place]
