//
//  PlaceServices.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import Foundation

class APIService :  NSObject {
    
    private let sourcesURL =  "https://api.opentripmap.com/0.1/en/places/"
    
    func getPlacesByCoordinates(reseau :String ,completion : @escaping (Places) -> ()){
        //"radius?apikey=5ae2e3f221c38a28845f05b6e1e72f6e6fae9bc6a9473af209e333f9&radius=5000&lon=10.63699&lat=35.82539&rate=3&format=json"
        let urlComps = URLComponents(string: sourcesURL + "radius?apikey=5ae2e3f221c38a28845f05b6e1e72f6e6fae9bc6a9473af209e333f9&radius=5000&lon=10.63699&lat=35.82539&rate=3&format=json")
        let request = URLRequest(url: (urlComps?.url)!)
        URLSession.shared.dataTask(with: request ) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(Places.self, from: data)
                    completion(empData)
            }
        }.resume()
    }
    

}
